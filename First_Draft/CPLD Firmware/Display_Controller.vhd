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
				CPLD_GPIO					: out STD_LOGIC_VECTOR(16 downto 16) := "0";
				
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
	signal WRITE_DATA       			: STD_LOGIC_VECTOR(7 downto 0) := "11100000";
	
	-- READ for our constant refresh out the VGA port - 800x525@ 60 FPS
	signal VGA_ROW_COUNT             : STD_LOGIC_VECTOR(9 downto 0) := (others => '0');
	signal VGA_PIXEL_COUNT           : STD_LOGIC_VECTOR(9 downto 0) := (others => '0');
	
	-- WRITE for our constant refresh out the VGA port (input from SPI) - 800x525@ 60 FPS
	signal WRITE_ROW              	: STD_LOGIC_VECTOR(9 downto 0) := (others => '0');
	signal WRITE_COLUMN           	: STD_LOGIC_VECTOR(9 downto 0) := (others => '0');
	
	
	-- Bring Async signals into our clock domain
	signal CACHE_FULL_FLAG    			: STD_LOGIC_VECTOR(1 downto 0) := "00";
	signal CACHE_RESET_FLAG   			: STD_LOGIC_VECTOR(1 downto 0) := "00";
	
	-- What graphics mode are we in? (In the demo this does nothing)
	signal USER_MODE         			: STD_LOGIC := '0';
	
	-- Write or Read cycle?
	signal CYCLE							: STD_LOGIC := '0';
	
	-- Do we need to write?  Should we reset write address?
	signal WRITE_READY					: STD_LOGIC := '0';
	signal RESET_NEXT						: STD_LOGIC := '0';
	
begin

	-- Our Write/Read Logic
	CPLD_GPIO(16) <= CYCLE;
	CE_LOW <= '0';
	OE_LOW <= (not CYCLE);
	WE_LOW <= CYCLE or CLK or (not WRITE_READY);
	
	-- Should *only* output on the data bus if we're doing a write.
	Write_Data_On_Bus: process (CLK, CYCLE, WRITE_READY)
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
			ADDR  <= VGA_ROW_COUNT(8 downto 0) & VGA_PIXEL_COUNT;
		end if;
	end process;

	-- Code for Display Logic - this is our typical VGA logic
	-- including timing, spitting out pixels, etc.
	Display_Logic: process (CLK, ACK_USER_RESET)
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
				
				if (WRITE_COLUMN = "1001111111" or WRITE_COLUMN = "1111111111") then -- 639, or 640 pixels into the row
					IF (WRITE_ROW = "111011111" or WRITE_ROW = "1111111111") then -- 479, or 480 lines into memory
						WRITE_ROW <= (others => '0');
					else
						WRITE_ROW <= STD_LOGIC_VECTOR(unsigned(WRITE_ROW) + 1);
					end if;
					WRITE_COLUMN <= "0000000000";
				else
					WRITE_COLUMN <= STD_LOGIC_VECTOR(unsigned(WRITE_COLUMN) + 1);
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
				USER_MODE        	<= '0';
				ACK_USER_RESET   	<= '1';
				--WRITE_ROW     		<= (others => '1');
				--WRITE_COLUMN     	<= (others => '1');
			
			
			else
				-- No reset flag up, so do whatever you want with the mode in your code
				if (SPI_CMD_RESET_FLAG = '1') then
					CACHE_RESET_FLAG <= STD_LOGIC_VECTOR( unsigned(CACHE_RESET_FLAG) + 1);
				end if;
				
				USER_MODE        <= '1';
				
			end if; -- End Cache Full
			
			-- Following this line is code which executes every other clock.
			
			-------------------------------------------------------------------------------------
			--            Framebuffer Read Display Driver Code                                 --
			-------------------------------------------------------------------------------------			
			if (CYCLE = '1') then -- First clock, do display things
				
				-- Kick out a pixel, unless in the blanking period.
				
				if (unsigned(VGA_ROW_COUNT) < 480 and unsigned(VGA_PIXEL_COUNT) < 640) then
					PIXEL <= DATA;
				else
					PIXEL <= "00000000";
				end if;
				
				-- Carefully timed HSync
				
				if (unsigned(VGA_PIXEL_COUNT) >= 656 and unsigned(VGA_PIXEL_COUNT) < 752) then
					HSYNC <= '0';
				else
					HSYNC <= '1';
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

