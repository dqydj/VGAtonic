library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Display_Controller is

	Port (
				-- User logic clock
				CLK 						: in STD_LOGIC; -- 50 (and change) Mhz Clock
				
				-- Display Outputs:
				
				PIXEL 						: inout STD_LOGIC_VECTOR(8 downto 0) := "111100110";
				HSYNC 						: inout STD_LOGIC := '0';
				VSYNC 						: inout STD_LOGIC := '0';
				
				-- Memory Interface:
				ADDR						: out STD_LOGIC_VECTOR(18 downto 0) := (others => '0');
				DATA						: inout STD_LOGIC_VECTOR(7 downto 0);
				OE_LOW						: out STD_LOGIC := '1';
				WE_LOW						: out STD_LOGIC := '1';
				CE_LOW						: out STD_LOGIC := '1';
				
				
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
	signal VGA_ROW_COUNT             	: STD_LOGIC_VECTOR(9 downto 0) := (others => '0');
	signal VGA_PIXEL_COUNT           	: STD_LOGIC_VECTOR(9 downto 0) := (others => '0');
	
	-- WRITE for our constant refresh out the VGA port (input from SPI) - 800x525@ 60 FPS
	signal WRITE_ROW              		: STD_LOGIC_VECTOR(9 downto 0) := (others => '1');
	signal WRITE_COLUMN           		: STD_LOGIC_VECTOR(9 downto 0) := (others => '1');
	
	
	-- Bring Async signals into our clock domain
	signal CACHE_FULL_FLAG    			: STD_LOGIC := '0';
	signal CACHE_RESET_FLAG   			: STD_LOGIC := '0';
	
	-- Write or Read cycle?
	signal CYCLE						: STD_LOGIC := '0';
	
	-- Do we need to write?  Should we reset write address?
	signal WRITE_READY					: STD_LOGIC := '0';
	signal RESET_NEXT					: STD_LOGIC := '0';
	
	-- What resolution are we in?
	-- 00 - 640x480
	-- 01 - 320x240
	-- 10 - 160x120
	-- 11 - 80 x60 
	signal USER_RES         			: STD_LOGIC_VECTOR(1 downto 0) := "00";

	-- What bit depth are we in?
	-- 00 - 8 bpp (256 Colors)
	-- 01 - 4 bpp (16 Colors)
	-- 10 - 2 bpp (4 Colors (B,W,GL,GH))
	-- 11 - 1 bpp (2 Colors (B,W))
	signal USER_BPP         			: STD_LOGIC_VECTOR(1 downto 0) := "00";

	-- We treat masked off addresses as don't cares - unless we are muxing multiple 
	-- pixels from the same data
	signal ADDR_MASK         			: STD_LOGIC_VECTOR(5 downto 0) := "000000";
	
	-- Blanking periods, to avoid a ton of pterms
	signal VBLANK 							: STD_LOGIC := '0';
	signal HBLANK 							: STD_LOGIC := '0';
	
	Function DecodeAddress
	(
		USER_RES        : STD_LOGIC_VECTOR(1 downto 0);
		VGA_ROW_COUNT   : STD_LOGIC_VECTOR(9 downto 0);
		ADDR_MASK      : STD_LOGIC_VECTOR(5 downto 0);
		VGA_PIXEL_COUNT : STD_LOGIC_VECTOR(9 downto 0)
	) return STD_LOGIC_VECTOR IS
		variable tempAddress : STD_LOGIC_VECTOR(18 downto 0);
	begin
			tempAddress(18 downto 13) := VGA_ROW_COUNT(8 downto 3);
			-- Handle multiple resolutions by changing it per user mode.
			-- 640x480
--			case USER_RES is
--				WHEN "00"   => tempAddress(12 downto 10) := VGA_ROW_COUNT(2 downto 0);
--				WHEN "01"   => tempAddress(12 downto 10) := VGA_ROW_COUNT(2 downto 1) & '0';
--				WHEN "10"   => tempAddress(12 downto 10) := VGA_ROW_COUNT(2) & "00";
--				WHEN others => tempAddress(12 downto 10) := "000";
--			end case;
				tempAddress(12) 			:=  (USER_RES(1) nand USER_RES(0)) and VGA_ROW_COUNT(2);
				tempAddress(11) 			:=  (not USER_RES(1)) and VGA_ROW_COUNT(1);
				tempAddress(10) 			:=  (USER_RES(1) nor  USER_RES(0)) and VGA_ROW_COUNT(0);
				tempAddress(9 downto 6) := VGA_PIXEL_COUNT(9 downto 6);
				tempAddress(5 downto 0) := VGA_PIXEL_COUNT(5 downto 0) and ADDR_MASK;
			
		return tempAddress;
	end FUNCTION DecodeAddress;

	
begin

	-- Our Write/Read Logic
	-- Be very careful here since this controls writing/reading from the memory!
	CE_LOW <= '0';
	OE_LOW <= (not CYCLE);
	WE_LOW <= CYCLE or CLK or (not WRITE_READY);
	
	
	-- Should *only* output on the data bus if we're doing a write.
	Write_Data_On_Bus: process (CLK, CYCLE, WRITE_READY, WRITE_DATA, WRITE_ROW)
	begin
		if ( (CYCLE or CLK) = '1' or WRITE_READY = '0') then
			-- Normally be in High-Z mode, since the memory will be controlling the bus at this stage
			DATA <= "ZZZZZZZZ";
		else
			-- Only when in the right clock cycle and we have a write ready
			DATA <= WRITE_DATA;
		end if;
		
		-- As for address - we flip it every cycle (2 master clocks)
		if (CYCLE = '0' and  WRITE_READY = '1') then 
			-- We're about to write
			ADDR  <= WRITE_ROW(8 downto 0) & WRITE_COLUMN;
		else
			-- We're doing normal bus reads
			ADDR  <= DecodeAddress(USER_RES, VGA_ROW_COUNT, ADDR_MASK, VGA_PIXEL_COUNT);
			
		end if;
		
		-- And our lowest blue lonely pixel - have it follow the middle blue bit so we can get true grays.
		-- This tradeoff is better than yellow and pink grays.
		PIXEL(0) <= PIXEL(1);
		
		
	end process;

	-- Code for Display Logic - Store the mask which we will use to decide our MSB while writing.
	-- This is what gives us, effectively, hardware acceleration for lower BPP and resolution.
	Display_Logic: process (CLK, ACK_USER_RESET)
		
		
		Function GetAddressMask
		(
			DATA : STD_LOGIC_VECTOR(7 downto 0)
		) return STD_LOGIC_VECTOR IS
			variable tempAddress : STD_LOGIC_VECTOR(5 downto 0);
		begin
			case DATA(3 downto 0) is
				when "0000"         							=> tempAddress := "111111";
				when "0100" | "0001" 							=> tempAddress := "111110";
				when "1000" | "0010" | "0101" 					=> tempAddress := "111100";
				when "1010" | "1101" | "0111" 					=> tempAddress := "110000";
				when "1110" | "1011" 							=> tempAddress := "100000";
				when "1111"										=> tempAddress := "000000";
				when  others 									=> tempAddress := "111000"; -- "1001" | "0110" | "1100" | "0011"
			end case;

			return tempAddress;
		end FUNCTION GetAddressMask;
		
		-- How much to 'increase' the line.  For 640x480x8bpp, this is 1, all the way to
		-- 80x60x1bpp, which will be increased by 64.  That is also the effective speedup.
		function getAdditionFactor 
			(
				ADDR_MASK : in STD_LOGIC_VECTOR(5 downto 0)
			) return integer is
				variable OUTPUT: integer;
				begin


-- 				Not enough pterms to do it will addition; use a LUT
--				OUTPUT := to_integer(unsigned(not ADDR_MASK)) + 1;


					case ADDR_MASK is
						when "000000" => OUTPUT := 64;
						when "100000" => OUTPUT := 32;
						when "110000" => OUTPUT := 16;
						when "111000" => OUTPUT := 8;
						when "111100" => OUTPUT := 4;
						when "111110" => OUTPUT := 2;
						when others   => OUTPUT := 1;
					end case;
					
				return OUTPUT;
			end getAdditionFactor;
		
	begin
		
		if (rising_edge(CLK)) then -- 50 and change MHz
		-- This is our user logic clock now, not SPI anymore
			
			-- Cyle back and forth between read/write, forever
			CYCLE <= not CYCLE;
			 
			-------------------------------------------------------------------------------------
			--            Framebuffer Write/Memory Management Code                             --
			-------------------------------------------------------------------------------------
			
			-- If the cache is full, we need to read it into our working register
			if (CACHE_FULL_FLAG = '1' and SPI_CACHE_FULL_FLAG = '1') then
				
				CACHE_FULL_FLAG <= '0';
				
					WRITE_DATA    <= SPI_DATA_CACHE;
					
					
					-- The first digits will 'look like' 639, and the end will equal our shift.
					if ( 		WRITE_COLUMN = "1001"   &   ADDR_MASK										
							or WRITE_COLUMN = "1111111111"  
					) then -- 640 pixels
						if (WRITE_ROW(9) = '1') then WRITE_ROW <= "0000000000"; -- End of the line
						else

-- 							Again, not enough pterms to do math, so instead use a LUT
--							WRITE_ROW <= STD_LOGIC_VECTOR(unsigned(WRITE_ROW) + unsigned'("0001") sll to_integer(unsigned(USER_RES)));


							case USER_RES is
								when "00" 	=> WRITE_ROW <= STD_LOGIC_VECTOR(unsigned(WRITE_ROW) + 1);
								when "01" 	=> WRITE_ROW <= STD_LOGIC_VECTOR(unsigned(WRITE_ROW) + 2);
								when "10" 	=> WRITE_ROW <= STD_LOGIC_VECTOR(unsigned(WRITE_ROW) + 4);
								when others => WRITE_ROW <= STD_LOGIC_VECTOR(unsigned(WRITE_ROW) + 8);
							end case;
						end if;
						WRITE_COLUMN <= "0000000000";
						
					else
					
						WRITE_COLUMN <= STD_LOGIC_VECTOR(unsigned(WRITE_COLUMN) + getAdditionFactor(ADDR_MASK));

					end if;

				
				-- ACK back to the SPI logic so it can reset the flag
				ACK_SPI_BYTE 	<= '1';
				WRITE_READY		<= '1';
			
			else
			
				-- If the cache isn't full, keep checking the flag - but don't change
				-- our currently active data
				CACHE_FULL_FLAG    	<= SPI_CACHE_FULL_FLAG;
				PIXEL(8 downto 1)    <= PIXEL(8 downto 1); -- This doesn't change
				ACK_SPI_BYTE    		<= '0';
				
			end if; -- End Cache Full
			
			
			if ( CACHE_RESET_FLAG = '1' and SPI_CMD_RESET_FLAG = '1') then
				-- If the mode reset flag is full, we need to set the mode back to
				-- whatever the initial state is
				RESET_NEXT <= '1'; -- Reset next time you get a chance
				CACHE_RESET_FLAG 	<= '0';
				ACK_USER_RESET   	<= '1';
				--WRITE_ROW     		<= (others => '1');
				--WRITE_COLUMN     	<= (others => '1');	
			
			else
				-- No reset flag up, so do whatever you want with the mode in your code
				--if (SPI_CMD_RESET_FLAG = '1') then
					CACHE_RESET_FLAG <= SPI_CMD_RESET_FLAG;
				--end if;
				
				
			end if; -- End Cache Full
			
			-- Following this line is code which executes every other clock.
			
			-------------------------------------------------------------------------------------
			--            Framebuffer Pixel Code                                               --
			-------------------------------------------------------------------------------------			
			if (CYCLE = '1') then -- First clock, do display things
				
				-- It helps to write this out on paper.  This section took probably 15 hours to perfect.
				
				if (VBLANK = '0' and HBLANK = '0') then -- then
					--PIXEL <= DATA;
					if (USER_BPP = "00") then
						PIXEL(8 downto 1) <= DATA;
					elsif (USER_BPP = "01") then
							PIXEL(8 downto 1) <= (	DATA(  to_integer(unsigned'(not VGA_PIXEL_COUNT(to_integer(unsigned(USER_RES))) & "11"))  ), 
															DATA(  to_integer(unsigned'(not VGA_PIXEL_COUNT(to_integer(unsigned(USER_RES))) & "00"))  ), 
															DATA(  to_integer(unsigned'(not VGA_PIXEL_COUNT(to_integer(unsigned(USER_RES))) & "00"))  ), 
															DATA(  to_integer(unsigned'(not VGA_PIXEL_COUNT(to_integer(unsigned(USER_RES))) & "10"))  ), 
															DATA(  to_integer(unsigned'(not VGA_PIXEL_COUNT(to_integer(unsigned(USER_RES))) & "00"))  ), 
															DATA(  to_integer(unsigned'(not VGA_PIXEL_COUNT(to_integer(unsigned(USER_RES))) & "00"))  ), 
															DATA(  to_integer(unsigned'(not VGA_PIXEL_COUNT(to_integer(unsigned(USER_RES))) & "01"))  ), 
															DATA(  to_integer(unsigned'(not VGA_PIXEL_COUNT(to_integer(unsigned(USER_RES))) & "00"))  )		
														);							

					elsif (USER_BPP = "10") then
								PIXEL(8 downto 1) <= (	8 | 5 | 2 => DATA( to_integer(not unsigned(VGA_PIXEL_COUNT(to_integer(unsigned(USER_RES))+1 downto to_integer(unsigned(USER_RES))) & '1'))),
																	others    => DATA( to_integer(not unsigned(VGA_PIXEL_COUNT(to_integer(unsigned(USER_RES))+1 downto to_integer(unsigned(USER_RES))) & '0')))
															) ;

					else 
						PIXEL(8 downto 1) <= (others => DATA(to_integer( unsigned(not VGA_PIXEL_COUNT(to_integer(unsigned(USER_RES))+2 downto to_integer(unsigned(USER_RES))))) ));
						
						--PIXEL(8 downto 1) <= (others => DATA(  to_integer(unsigned(    not VGA_PIXEL_COUNT(2 downto 0)    )  )) );
					end if;

				else
					PIXEL(8 downto 1) <= "00000000";
				end if;


			-------------------------------------------------------------------------------------
			--            Normal VGA Control Code - Syncs, Blanking Periods              	   --
			-------------------------------------------------------------------------------------
				
				-- VBLANK
				
				if (unsigned(VGA_ROW_COUNT) = 479) then
					VBLANK <= '1';
				elsif (unsigned(VGA_ROW_COUNT) = 0) then
					VBLANK <= '0';
				end if;
				
				-- HBLANK
				
				if (unsigned(VGA_PIXEL_COUNT) = 639) then
					HBLANK <= '1';
				elsif (unsigned(VGA_PIXEL_COUNT) = 0) then
					HBLANK <= '0';
				end if;
				
				-- Carefully timed HSync
				
				if (unsigned(VGA_PIXEL_COUNT) = 655) then
					HSYNC <= '0';
				elsif (unsigned(VGA_PIXEL_COUNT) = 751) then
					HSYNC <= '1';
				end if;
				
				-- Carefully timed VSync
				
				if (unsigned(VGA_ROW_COUNT) = 490 or unsigned(VGA_ROW_COUNT) = 491 or unsigned(VGA_ROW_COUNT) = 489) then
					VSYNC <= '0';
				else
					VSYNC <= '1';
				end if;

				-- Code for the end of a column and/or the end of a row.
				
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




			-- Now the second part of our cycle.  Since we are off the bus now, any writes that are queued up will happen here.
			else -- CYCLE = '0'
				if (ACK_USER_RESET  = '1') then
					-- Let's reset next time
					RESET_NEXT <= '1';
				end if;
				
				if (RESET_NEXT = '1') then
					-- Our resetting code - basically, set counters to all 1s (so +1 would be at 0,0)
					RESET_NEXT 		<= '0';
					WRITE_ROW 		<= (others => '1');
					WRITE_COLUMN 	<= (others => '1');
					ACK_USER_RESET 	<= '0';
					

					-------------------------------------------------------------------------------------
					--            VGATonic Control Code - Mode changes, HW Acceleration                --
					-------------------------------------------------------------------------------------
					-- If we *only* wrote 1 pixel, that's a mode change or a 'move'
					-- Easy to check - We would be at address '0' since we were reset here from all 1s.

					if(  ("0000000000" = WRITE_COLUMN and "0000000000" = WRITE_ROW) ) then
						
							if (WRITE_DATA(7) = '1') then

								-- Hardware acceleration!  Just put 6 downto 0 bits into our write address.  
								-- Seriously, that's all we need.

								WRITE_ROW <=   '0' 					& -- 9
								WRITE_DATA(6 downto 0)  			& -- 8, 7, 6, 5, 4, 3, 2
								"00";                				  -- 1, 0

								-- Only do one at a time - you can do one after another though, as long as you do
								-- mode setting first.								
							else 

								-- Our 'Mode Change' Packets:
								-- 6-4: Reserved (good luck fitting something!)
								-- 3-2: User bitdepth (8, 4, 2, 1)
								-- 1-0: User Resolution (640x480, 320x240, 160x120, 80x60)
								USER_BPP 	<= WRITE_DATA(3 downto 2);
								USER_RES 	<= WRITE_DATA(1 downto 0);
								ADDR_MASK 	<= GetAddressMask(WRITE_DATA);
							end if;
		
					end if;
				end if;
				
				if (WRITE_READY = '1') then
					-- Reset our write so we don't write every cycle.
					WRITE_READY <= '0';
				end if;
				
				
				-- Pixel, VSYNC, and HSYNC shouldn't change just because we're in the
				-- writing portion - keep them constant.
				PIXEL(8 downto 1) <= PIXEL(8 downto 1);
				HSYNC <= HSYNC;
				VSYNC <= VSYNC;
							
				
			end if;
		
		end if; -- End rising edge user logicclock
		
		
		
	end process;
	
	-- Framebuffer Core
end Behavioral;