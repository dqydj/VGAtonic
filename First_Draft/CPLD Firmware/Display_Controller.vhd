library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Display_Controller is

	Port (
				-- User logic clock
				CLK 							: in STD_LOGIC; -- 50 (and change) Mhz Clock
				
				-- Display Outputs:
				
				PIXEL 						: inout STD_LOGIC_VECTOR(7 downto 0) := "11100110";
				HSYNC 						: inout STD_LOGIC := '0';
				VSYNC 						: inout STD_LOGIC := '0';
				
				-- Memory Interface:
				ADDR							: out STD_LOGIC_VECTOR(18 downto 0) := (others => '0');
				DATA							: inout STD_LOGIC_VECTOR(7 downto 0);
				OE_LOW						: out STD_LOGIC := '1';
				WE_LOW						: out STD_LOGIC := '1';
				CE_LOW						: out STD_LOGIC := '1';
				
				-- Temp - put the clock out on one of the pins so we can check it with the scope
				--CPLD_GPIO					: out STD_LOGIC_VECTOR(16 downto 16) := "0";
				
				----------------------------------------------------------------------------------
				--                          VGAtonic Internal                                   --
				----------------------------------------------------------------------------------
				
				-- Inputs from SPI
				SPI_DATA_CACHE          : in STD_LOGIC_VECTOR(7 downto 0);
				SPI_CACHE_FULL_FLAG 		: in STD_LOGIC; 
				SPI_CMD_RESET_FLAG 		: in STD_LOGIC;
				
				-- Acknowledges to SPI
				ACK_USER_RESET          : inout STD_LOGIC := '0';
				ACK_SPI_BYTE            : out STD_LOGIC := '0'
	
	);
	
end Display_Controller;

architecture Behavioral of Display_Controller is
	
	-- Next Write
	signal WRITE_DATA       			: STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
	
	-- READ for our constant refresh out the VGA port - 800x525@ 60 FPS
	signal VGA_ROW_COUNT             : STD_LOGIC_VECTOR(9 downto 0) := (others => '0');
	signal VGA_PIXEL_COUNT           : STD_LOGIC_VECTOR(9 downto 0) := (others => '0');
	
	-- WRITE for our constant refresh out the VGA port (input from SPI) - 800x525@ 60 FPS
	signal WRITE_ROW              	: STD_LOGIC_VECTOR(9 downto 0) := (others => '1');
	signal WRITE_COLUMN           	: STD_LOGIC_VECTOR(9 downto 0) := (others => '1');
	
	
	-- Bring Async signals into our clock domain
	signal CACHE_FULL_FLAG    			: STD_LOGIC_VECTOR(1 downto 0) := "00";
	signal CACHE_RESET_FLAG   			: STD_LOGIC_VECTOR(1 downto 0) := "00";
	
	-- Write or Read cycle?
	signal CYCLE							: STD_LOGIC := '0';
	
	-- Do we need to write?  Should we reset write address?
	signal WRITE_READY					: STD_LOGIC := '0';
	signal RESET_NEXT						: STD_LOGIC := '0';
	
	-- What resolution are we in?
	-- 00 - 640x480
	-- 01 - 320x240
	-- 10 - 160x120
	-- 11 - 80 x60 
	signal USER_RES         			: STD_LOGIC_VECTOR(1 downto 0) := "00";

	-- What color depth are we in?
	-- 00 - 8bpp, 256 color
	-- 01 - 4 bpp, 16 color
	-- 10 - 2 bpp, 4 "color" - greys
	-- 11 - 1 bpp, B&W
	signal USER_BPP         			: STD_LOGIC_VECTOR(1 downto 0) := "00";
	signal ADDR_SHIFT         			: STD_LOGIC_VECTOR(5 downto 0) := "000000";
	
	-- Blanking periods, to avoid a ton of pterms
	signal VBLANK 							: STD_LOGIC := '0';
	signal HBLANK 							: STD_LOGIC := '0';
	
	Function DecodeAddress
	(
		USER_RES        : STD_LOGIC_VECTOR(1 downto 0);
		VGA_ROW_COUNT   : STD_LOGIC_VECTOR(9 downto 0);
		ADDR_SHIFT      : STD_LOGIC_VECTOR(5 downto 0);
		VGA_PIXEL_COUNT : STD_LOGIC_VECTOR(9 downto 0)
	) return STD_LOGIC_VECTOR IS
		variable tempAddress : STD_LOGIC_VECTOR(18 downto 0);
	begin
			tempAddress(18 downto 13) := VGA_ROW_COUNT(8 downto 3);
			-- Handle multiple resolutions by changing it per user mode.
			-- 640x480
			case USER_RES is
				WHEN "00"   => tempAddress(12 downto 10) := VGA_ROW_COUNT(2 downto 0);
				WHEN "01"   => tempAddress(12 downto 10) := VGA_ROW_COUNT(2 downto 1) & '0';
				WHEN "10"   => tempAddress(12 downto 10) := VGA_ROW_COUNT(2) & "00";
				WHEN others => tempAddress(12 downto 10) := "000";
			end case;
				
				tempAddress(9 downto 0) := 
								-- This section controls which pixel we are looking at.  
								-- Conveniently, it also works in the second half of our memory's address.
							VGA_PIXEL_COUNT(9 downto 6)      & 
							
								-- Example: 160x120 is 10, 2Bpp is 10 = Shift 2 = 111100
								-- Flip the bits and not them, you get 110000
								-- That's what we want - offsets of 16
								-- Then, just 'and' it with what is alread there.  0s make sure
								-- we stay on the pixel for a while.
								
								(not ADDR_SHIFT(0) and VGA_PIXEL_COUNT(5))              &
								(not ADDR_SHIFT(1) and VGA_PIXEL_COUNT(4))              &
								(not ADDR_SHIFT(2) and VGA_PIXEL_COUNT(3))              &
								(not ADDR_SHIFT(3) and VGA_PIXEL_COUNT(2))              &
								(not ADDR_SHIFT(4) and VGA_PIXEL_COUNT(1))              &
								(not ADDR_SHIFT(5) and VGA_PIXEL_COUNT(0)) ; --(VGA_PIXEL_COUNT(5 downto 0) and ADDR_SHIFT(0 to 5) );
			
		return tempAddress;
	end FUNCTION DecodeAddress;

	
begin

	-- Our Write/Read Logic
	--CPLD_GPIO(16) <= CYCLE;
	CE_LOW <= '0';
	OE_LOW <= (not CYCLE);
	WE_LOW <= CYCLE or CLK or (not WRITE_READY);
	
	-- Should *only* output on the data bus if we're doing a write.
	Write_Data_On_Bus: process (CLK, CYCLE, WRITE_READY, WRITE_DATA, WRITE_ROW, WRITE_COLUMN, USER_RES, VGA_ROW_COUNT, ADDR_SHIFT, VGA_PIXEL_COUNT)
	begin
		if ( (CYCLE or CLK) = '1' or WRITE_READY = '0') then
			-- Normally be in High-Z mode
			DATA <= "ZZZZZZZZ";
		else
			-- Only when in the right clock cycle and we have a write ready
			DATA <= WRITE_DATA;
		end if;
		
		-- As for address - we flip it every cycle (2 master clocks)
		if ( CYCLE = '0' and  WRITE_READY = '1') then 
			ADDR  <= WRITE_ROW(8 downto 0) & WRITE_COLUMN;
		else
			ADDR  <= DecodeAddress(USER_RES, VGA_ROW_COUNT, ADDR_SHIFT, VGA_PIXEL_COUNT);
			
		end if;
	end process;

	-- Code for Display Logic - Store the amount to shift so we know when it is the end of the row
	-- And also how much to add while doing video.
	Display_Logic: process (CLK, ACK_USER_RESET)
		
		
		-- Store a 'shifted address end'.  We use all sorts of bit tricks based on this number, but
		-- it lets us avoid a ton of pterms by 'wasting' a few macrocell.
		Function GetAddressShift
		(
			DATA : STD_LOGIC_VECTOR(7 downto 0)
		) return STD_LOGIC_VECTOR IS
			variable shiftAddress: STD_LOGIC_VECTOR(5 downto 0) := "000000";
			variable tempAddress : UNSIGNED(5 downto 0) := "111111";
		begin
			shiftAddress := std_logic_vector(
			
				tempAddress sll 
				to_integer(not unsigned(DATA(3 downto 2))) +
				to_integer(not unsigned(DATA(1 downto 0)))
						
			
			);

			return shiftAddress;
		end FUNCTION GetAddressShift;
		
		-- How much to 'increase' the line
		function getAdditionFactor 
			(
				ADDR_SHIFT : in STD_LOGIC_VECTOR(5 downto 0)
			) return integer is
				variable OUTPUT: integer;
				begin
					
					case ADDR_SHIFT is
						when "000000" => OUTPUT := 1;
						when "100000" => OUTPUT := 2;
						when "110000" => OUTPUT := 4;
						when "111000" => OUTPUT := 8;
						when "111100" => OUTPUT := 16;
						when "111110" => OUTPUT := 32;
						when others   => OUTPUT := 64;
					end case;
						
					
				return OUTPUT;
			end getAdditionFactor;
		
		-- Here is your color lookup table.  Use it in good health!
		Function GetPixel
		(
			USER_BITDEPTH	 	: STD_LOGIC_VECTOR(1 downto 0);
			VGA_PIXEL_COUNT   : STD_LOGIC_VECTOR(9 downto 0);
			DATA  				: STD_LOGIC_VECTOR(7 downto 0)
		) return STD_LOGIC_VECTOR IS
		variable PIXEL: std_logic_vector(8 downto 0);
		begin
			case USER_BITDEPTH is 
				when "00" 	=>   -- 8 bpp, 256 Color
					PIXEL := DATA & '0';
				when "01" 	=>   -- 4 bpp, RGBI
					if (VGA_PIXEL_COUNT(0) = '0') then -- Cycle(1) bit is low, so read the first half of the pixel
						PIXEL(8) := DATA(7); -- R High
						PIXEL(5) := DATA(6); -- G High
						PIXEL(2) := DATA(5); -- B High
						-- Intensity bit
						PIXEL(7) := DATA(4); -- R Intensity
						PIXEL(6) := DATA(4); -- R Intensity
						PIXEL(4) := DATA(4); -- G Intensity
						PIXEL(3) := DATA(4); -- G Intensity
						PIXEL(1) := DATA(4); -- B Intensity
						PIXEL(0) := DATA(4); -- B Intensity
					else -- Cycle(1) bit is high, so read the second half of the pixel
						PIXEL(8) := DATA(3); -- R High
						PIXEL(5) := DATA(2); -- G High
						PIXEL(2) := DATA(1); -- B High
						-- Intensity bit
						PIXEL(7) := DATA(0); -- R Intensity
						PIXEL(6) := DATA(0); -- R Intensity
						PIXEL(4) := DATA(0); -- G Intensity
						PIXEL(3) := DATA(0); -- G Intensity
						PIXEL(1) := DATA(0); -- B Intensity
						PIXEL(0) := DATA(0); -- B Intensity
					end if;
				when "10" 	=>   -- 2 bpp, Greyscale
						--PIXEL := "111111111";
					if (VGA_PIXEL_COUNT(1 downto 0) = "00") then
						PIXEL(8) := DATA(7); -- R High
						PIXEL(5) := DATA(7); -- G High
						PIXEL(2) := DATA(7); -- B High
						PIXEL(7) := DATA(6); -- R Intensity
						PIXEL(6) := DATA(6); -- R Intensity
						PIXEL(4) := DATA(6); -- G Intensity
						PIXEL(3) := DATA(6); -- G Intensity
						PIXEL(1) := DATA(6); -- B Intensity
						PIXEL(0) := DATA(6); -- B Intensity
					elsif (VGA_PIXEL_COUNT(1 downto 0) = "01") then
						PIXEL(8) := DATA(5); -- R High
						PIXEL(5) := DATA(5); -- G High
						PIXEL(2) := DATA(5); -- B High
						PIXEL(7) := DATA(4); -- R Intensity
						PIXEL(6) := DATA(4); -- R Intensity
						PIXEL(4) := DATA(4); -- G Intensity
						PIXEL(3) := DATA(4); -- G Intensity
						PIXEL(1) := DATA(4); -- B Intensity
						PIXEL(0) := DATA(4); -- B Intensity
					elsif (VGA_PIXEL_COUNT(1 downto 0) = "10") then
						PIXEL(8) := DATA(3); -- R High
						PIXEL(5) := DATA(3); -- G High
						PIXEL(2) := DATA(3); -- B High
						PIXEL(7) := DATA(2); -- R Intensity
						PIXEL(6) := DATA(2); -- R Intensity
						PIXEL(4) := DATA(2); -- G Intensity
						PIXEL(3) := DATA(2); -- G Intensity
						PIXEL(1) := DATA(2); -- B Intensity
						PIXEL(0) := DATA(2); -- B Intensity
					else 
						PIXEL(8) := DATA(1); -- R High
						PIXEL(5) := DATA(1); -- G High
						PIXEL(2) := DATA(1); -- B High
						PIXEL(7) := DATA(0); -- R Intensity
						PIXEL(6) := DATA(0); -- R Intensity
						PIXEL(4) := DATA(0); -- G Intensity
						PIXEL(3) := DATA(0); -- G Intensity
						PIXEL(1) := DATA(0); -- B Intensity
						PIXEL(0) := DATA(0); -- B Intensity
					end if;
				when others =>   -- Black & White
						PIXEL(8 downto 0) := ( others => DATA( to_integer(not(unsigned(VGA_PIXEL_COUNT(2 downto 0)))) ) );
			end case;
			return PIXEL;
		end GetPixel;
		
	begin
		
		if (rising_edge(CLK)) then -- 50 and change MHz
		-- This is our user logic clock now, not SPI anymore
			
			 -- Cyle back and forth between read/write, forever!!1!
			 CYCLE <= not CYCLE;
			 
			-------------------------------------------------------------------------------------
			--            Framebuffer Write/Memory Management Code                             --
			-------------------------------------------------------------------------------------
			
			-- If the cache is full, we need to read it into our working register
			if (CACHE_FULL_FLAG(1) = '1') then
				
				CACHE_FULL_FLAG <= "00";
				
					WRITE_DATA    <= SPI_DATA_CACHE;
					
					
					-- The first digits will 'look like' 639, and the end will equal our shift.
					if ( 		WRITE_COLUMN = "1001"   & 
										not ADDR_SHIFT(0) &
										not ADDR_SHIFT(1) &
										not ADDR_SHIFT(2) &
										not ADDR_SHIFT(3) &
										not ADDR_SHIFT(4) &
										not ADDR_SHIFT(5) 										
							or WRITE_COLUMN = "1111111111"  
					) then -- 640 pixels
						if ( 		(WRITE_ROW = "0111011111" and USER_RES = "00")
								or (WRITE_ROW = "0111011110" and USER_RES = "01")
								or	(WRITE_ROW = "0111011100" and USER_RES = "10")
								or	(WRITE_ROW = "0111011000" and USER_RES = "11")
								or  WRITE_ROW = "1111111111"
						) then -- 480 rows
							WRITE_ROW <= (others => '0');
						else
							if (USER_RES = "00") then
								WRITE_ROW <= STD_LOGIC_VECTOR(unsigned(WRITE_ROW) + 1);
							elsif (USER_RES = "01") then
								WRITE_ROW <= STD_LOGIC_VECTOR(unsigned(WRITE_ROW) + 2);
							elsif (USER_RES = "10") then
								WRITE_ROW <= STD_LOGIC_VECTOR(unsigned(WRITE_ROW) + 4);
							else
								WRITE_ROW <= STD_LOGIC_VECTOR(unsigned(WRITE_ROW) + 8);
							end if;
							
						end if;
						WRITE_COLUMN <= "0000000000";
						
					else
					
						WRITE_COLUMN <= STD_LOGIC_VECTOR(unsigned(WRITE_COLUMN) + getAdditionFactor(ADDR_SHIFT));

					end if;

				
				-- ACK back to the SPI logic so it can reset the flag
				ACK_SPI_BYTE 	 <= '1';
				WRITE_READY		 <= '1';
			
			else
			
				-- If the cache isn't full, keep checking the flag - but don't change
				-- our currently active data
				CACHE_FULL_FLAG    	<= CACHE_FULL_FLAG(0) & SPI_CACHE_FULL_FLAG;
				PIXEL       			<= PIXEL; -- This doesn't change
				ACK_SPI_BYTE    	 	<= '0';
				
			end if; -- End Cache Full
			
			
			if ( CACHE_RESET_FLAG = "11" ) then
				-- If the mode reset flag is full, we need to set the mode back to
				-- whatever the initial state is
				RESET_NEXT <= '1'; -- Reset next time you get a chance
				CACHE_RESET_FLAG 	<= "00";
				ACK_USER_RESET   	<= '1';
				--WRITE_ROW     		<= (others => '1');
				--WRITE_COLUMN     	<= (others => '1');	
			
			else
				-- No reset flag up, so do whatever you want with the mode in your code
				if (SPI_CMD_RESET_FLAG = '1') then
					CACHE_RESET_FLAG <= STD_LOGIC_VECTOR( unsigned(CACHE_RESET_FLAG) + 1);
				end if;
				
				
			end if; -- End Cache Full
			
			-- Following this line is code which executes every other clock.
			
			-------------------------------------------------------------------------------------
			--            Framebuffer Read Display Driver Code                                 --
			-------------------------------------------------------------------------------------			
			if (CYCLE = '1') then -- First clock, do display things
				
				-- Kick out a pixel, unless in the blanking period.
				
				if (VBLANK = '0' and HBLANK = '0') then -- then
					--PIXEL <= DATA;
					if (USER_BPP = "00") then
						PIXEL <= DATA;
					elsif (USER_BPP = "01") then
						if (VGA_PIXEL_COUNT(0) = '0') then
							PIXEL <= (DATA(7), DATA(4), DATA(4), DATA(6), DATA(4), DATA(4), DATA(5), DATA(4));
						else
							PIXEL <= (DATA(3), DATA(0), DATA(0), DATA(2), DATA(0), DATA(0), DATA(1), DATA(0));
						end if;
					elsif (USER_BPP = "10") then
						PIXEL <= (	DATA(  to_integer(unsigned(VGA_PIXEL_COUNT(1 downto 0)) + unsigned(VGA_PIXEL_COUNT(1 downto 0)) + 1)  ), 
										DATA(  to_integer(unsigned(VGA_PIXEL_COUNT(1 downto 0)) + unsigned(VGA_PIXEL_COUNT(1 downto 0)))      ), 
										DATA(  to_integer(unsigned(VGA_PIXEL_COUNT(1 downto 0)) + unsigned(VGA_PIXEL_COUNT(1 downto 0)))      ), 
										DATA(  to_integer(unsigned(VGA_PIXEL_COUNT(1 downto 0)) + unsigned(VGA_PIXEL_COUNT(1 downto 0)) + 1)  ), 
										DATA(  to_integer(unsigned(VGA_PIXEL_COUNT(1 downto 0)) + unsigned(VGA_PIXEL_COUNT(1 downto 0)))      ), 
										DATA(  to_integer(unsigned(VGA_PIXEL_COUNT(1 downto 0)) + unsigned(VGA_PIXEL_COUNT(1 downto 0)))      ), 
										DATA(  to_integer(unsigned(VGA_PIXEL_COUNT(1 downto 0)) + unsigned(VGA_PIXEL_COUNT(1 downto 0)) + 1)  ), 
										DATA(  to_integer(unsigned(VGA_PIXEL_COUNT(1 downto 0)) + unsigned(VGA_PIXEL_COUNT(1 downto 0)))      )		
									);
					else 
						PIXEL <= (others => DATA(  to_integer(unsigned(    not VGA_PIXEL_COUNT(2 downto 0)    )  )) );
					end if;

--					elsif (USER_BPP = "11") then
--						PIXEL <= (others => DATA(  to_integer(unsigned(    not VGA_PIXEL_COUNT(2 downto 0)    )  )) );
--					else 
--						PIXEL <= (others => DATA(  to_integer(unsigned(    not VGA_PIXEL_COUNT(2 downto 0)    )  )) );
--					end if;
				else
					PIXEL <= "00000000";
				end if;
				
				-- VBLANK
				
				if (unsigned(VGA_ROW_COUNT) = 480) then
					VBLANK <= '1';
				elsif (unsigned(VGA_ROW_COUNT) = 0) then
					VBLANK <= '0';
				else
					VBLANK <= VBLANK;
				end if;
				
				-- HBLANK
				
				if (unsigned(VGA_PIXEL_COUNT) = 640) then
					HBLANK <= '1';
				elsif (unsigned(VGA_PIXEL_COUNT) = 0) then
					HBLANK <= '0';
				else
					HBLANK <= HBLANK;
				end if;
				
				-- Carefully timed HSync
				
				if (unsigned(VGA_PIXEL_COUNT) = 656) then
					HSYNC <= '0';
				elsif (unsigned(VGA_PIXEL_COUNT) = 752) then
					HSYNC <= '1';
				else
					HSYNC <= HSYNC;
				end if;
				
				-- Carefully timed VSync
				
				if (unsigned(VGA_ROW_COUNT) = 490 or unsigned(VGA_ROW_COUNT) = 491 or unsigned(VGA_ROW_COUNT) = 492) then
					VSYNC <= '0';
				else
					VSYNC <= '1';
				end if;
				
				
			else -- Cycle = '0', second clock, do memory write things
				if (ACK_USER_RESET  = '1') then
					-- Let's reset next time
					RESET_NEXT <= '1';
				end if;
				
				if (RESET_NEXT = '1') then
					-- Our resetting code - basically, set counters to all 1s (so +1 would be at 0,0)
					RESET_NEXT <= '0';
					WRITE_ROW <= (others => '1');
					WRITE_COLUMN <= (others => '1');
					ACK_USER_RESET <= '0';
					
					-- If we only wrote 1 pixel, that's a mode change
					-- Easy to check - We would be at address '0' since we were reset here from all 1s.
					if(  	("0000000000" = WRITE_COLUMN and "0000000000" = WRITE_ROW) or
							("1111111111" = WRITE_COLUMN and "1111111111" = WRITE_ROW) or
							(getAdditionFactor(ADDR_SHIFT) = unsigned(WRITE_COLUMN) and "0000000000" = WRITE_ROW)
						) then
							USER_BPP 	<= WRITE_DATA(3 downto 2);
							USER_RES 	<= WRITE_DATA(1 downto 0);
							ADDR_SHIFT 	<= GetAddressShift(WRITE_DATA);
					end if;
				end if;
				
				if (WRITE_READY = '1') then
					-- Well, we won't let you write 2 cycles in a row, sorry.
					WRITE_READY <= '0';
				end if;
				
				
				-- Pixel, VSYNC, and HSYNC shouldn't change just because we're in the
				-- writing portion - keep them constant.
				PIXEL <= PIXEL;
				HSYNC <= HSYNC;
				VSYNC <= VSYNC;
				
	
				if (VGA_PIXEL_COUNT = "1100011111") then -- 799
					-- Column 800 - increase row
					VGA_PIXEL_COUNT  <= "0000000000";
					if (VGA_ROW_COUNT = "1000001100") then -- 524
						-- Row 525, reset to 0,0
						VGA_ROW_COUNT <= "0000000000";
					else
						VGA_ROW_COUNT <= STD_LOGIC_VECTOR(UNSIGNED(VGA_ROW_COUNT) + 1);
					end if;	
				else 
					VGA_PIXEL_COUNT <= STD_LOGIC_VECTOR(UNSIGNED(VGA_PIXEL_COUNT) + 1);
				end if;
							
				
			end if;
		
		end if; -- End rising edge user logicclock
		
		
		
	end process;
	
	-- Framebuffer Core
end Behavioral;
