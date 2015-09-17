library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Display_Controller is

	Port (
				-- User logic clock
				CLK 						: in STD_LOGIC; -- 5x NTSC Colorburst Clock
				-- NTSC Color clock = 5 color variations plus inverse gives us 10 shades
				-- Then 16 levels of Luma, with the last few possibly too low to register
				
				-- NTSC Signals
				COLORBURST 	: inout   std_logic := '0';
				SYNC       	: inout   std_logic := '1';
				LUMA      	: inout   STD_LOGIC_VECTOR(3 downto 0)  := "0000";
				
				-- Memory Interface:
				ADDR						: out STD_LOGIC_VECTOR(18 downto 0) := (others => '0');
				DATA						: inout STD_LOGIC_VECTOR(7 downto 0);
				OE_LOW						: out STD_LOGIC := '1';
				WE_LOW						: out STD_LOGIC := '1';
				CE_LOW						: out STD_LOGIC := '1';
				
				-- For ease of oscilloscope testing you can put one of the color phases here
				-- CPLD_GPIO				: out STD_LOGIC := '0';
				
				
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
	
	-- READ for our constant refresh out the RCA Jack - 63.5 ms line length x262 rows @ 60 FPS
	-- We are abusing and shifting it to do 320x240, but pixels will be narrow (fix it with TV settings?)
	signal NTSC_ROW_COUNT             	: STD_LOGIC_VECTOR(9 downto 0) := (others => '0');
	signal NTSC_PIXEL_COUNT           	: STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
	
	
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
	
	
	-- ALWAYS IN 320x240 in 16 colors FOR THIS NTSC FIRMWARE!
	
	signal PIXEL			   	: STD_LOGIC_VECTOR(3 downto 0) := "0000";
	
	-- Five counter one toggles on the rising edge of the clock while
	-- Five counter two toggles on the falling edge.  By oring the two
	-- at different points we create all of our clock phases.
	signal FIVE_COUNTER_ONE   	: STD_LOGIC_VECTOR(2 downto 0) := "001";
	signal FIVE_COUNTER_TWO   	: STD_LOGIC_VECTOR(2 downto 0) := "001";
	
	-- 5 phases of our color, and since it is odd we also get the inverse
	-- Gives us a color every 36 degrees
	
	signal PHASE_SHIFTER_ONE	: STD_LOGIC := '0';
	signal PHASE_SHIFTER_TWO	: STD_LOGIC := '0';
	signal PHASE_SHIFTER_THREE	: STD_LOGIC := '0';
	signal PHASE_SHIFTER_FOUR	: STD_LOGIC := '0';
	signal PHASE_SHIFTER_FIVE	: STD_LOGIC := '0';

begin


	-- Our Write/Read Logic
	-- Be very careful here since this controls writing/reading from the memory!
	-- Carelessness can lead to a short and you resoldering a new CPLD/SRAM
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
			-- We're doing normal bus reads.  160 addresses for 320 columns.
			-- Since this count happens 2x our user clock, mask the last bit.
			-- Since it is 4 bit not 8 bit, mask the penultimate bit.
			ADDR  <= NTSC_ROW_COUNT(8 downto 0) & NTSC_PIXEL_COUNT(9 downto 2) & "00";
			
		end if;
		
		
	end process;
	
	-- Use ors to make 5 sweet phases of colors.  One of them (we picked 'one')
	-- is your colorburst, everything else is in reference to it
	Phase_Shifter: process (FIVE_COUNTER_TWO, FIVE_COUNTER_ONE)
	begin
		-- 4 or 5
		if ( FIVE_COUNTER_TWO = "100" or FIVE_COUNTER_TWO = "101" or
			  FIVE_COUNTER_ONE = "100" or FIVE_COUNTER_ONE = "101"	) then
			PHASE_SHIFTER_ONE <= '1';
		else
			PHASE_SHIFTER_ONE <= '0';
		end if;
		
		-- 3 or 4
		if ( FIVE_COUNTER_TWO = "100" or FIVE_COUNTER_TWO = "011" or
			  FIVE_COUNTER_ONE = "100" or FIVE_COUNTER_ONE = "011"	) then
			PHASE_SHIFTER_TWO <= '1';
		else
			PHASE_SHIFTER_TWO <= '0';
		end if;
		
		-- 2 or 3
		if ( FIVE_COUNTER_TWO = "010" or FIVE_COUNTER_TWO = "011" or
			  FIVE_COUNTER_ONE = "010" or FIVE_COUNTER_ONE = "011"	) then
			PHASE_SHIFTER_THREE <= '1';
		else
			PHASE_SHIFTER_THREE <= '0';
		end if;
		
		-- 1 or 2
		if ( FIVE_COUNTER_TWO = "010" or FIVE_COUNTER_TWO = "001" or
			  FIVE_COUNTER_ONE = "010" or FIVE_COUNTER_ONE = "001"	) then
			PHASE_SHIFTER_FOUR <= '1';
		else
			PHASE_SHIFTER_FOUR <= '0';
		end if;
		
		-- 1 or 5
		if ( FIVE_COUNTER_TWO = "101" or FIVE_COUNTER_TWO = "001" or
			  FIVE_COUNTER_ONE = "101" or FIVE_COUNTER_ONE = "001"	) then
			PHASE_SHIFTER_FIVE <= '1';
		else
			PHASE_SHIFTER_FIVE <= '0';
		end if;
		
	end process;

	-- There is no hardware accelerated resolutions and colors in this NTSC example.
	-- Youget 320x240 at 4 bit (16 colors) fixed.  Palette is RGBI.

	Display_Logic: process (CLK, ACK_USER_RESET)
		
	begin
	
		if (falling_edge(CLK)) then
		
			if (FIVE_COUNTER_TWO = "101") then
				FIVE_COUNTER_TWO <= "001";
			else
				FIVE_COUNTER_TWO <= STD_LOGIC_VECTOR(unsigned(FIVE_COUNTER_TWO) + 1);
			end if;
			
		end if;
		
		if (rising_edge(CLK)) then -- 60 and change MHz
		-- This is our user logic clock now, not SPI anymore
		
			if (FIVE_COUNTER_ONE = "101") then
				FIVE_COUNTER_ONE <= "001";
			else
				FIVE_COUNTER_ONE <= STD_LOGIC_VECTOR(unsigned(FIVE_COUNTER_ONE) + 1);
			end if;
			
			if ( 	( to_integer(unsigned(NTSC_ROW_COUNT)) = 243 ) or 
					( to_integer(unsigned(NTSC_ROW_COUNT)) = 244 ) or
					( to_integer(unsigned(NTSC_ROW_COUNT)) = 245 ) ) then
							
							
						if (to_integer(unsigned(NTSC_PIXEL_COUNT)) = 1137) then
							NTSC_PIXEL_COUNT <= "000000000000";
							-- Add another line to row counter
							NTSC_ROW_COUNT <= STD_LOGIC_VECTOR(unsigned(NTSC_ROW_COUNT) + 1);
							-- Kick off our line
							SYNC    <= '0';
							COLORBURST <= '0';
							LUMA <= "0000";
						else
							NTSC_PIXEL_COUNT <= STD_LOGIC_VECTOR(unsigned(NTSC_PIXEL_COUNT) + 1);
							COLORBURST <= '0';
						end if;
					-- Sync is reversed on a VSYNC line
						
						
					-- Sync 817 to 901
					if ( to_integer(unsigned(NTSC_PIXEL_COUNT)) = 817) then
						SYNC    <= '1';
					end if;
					if ( to_integer(unsigned(NTSC_PIXEL_COUNT)) = 901) then
						SYNC    <= '0';
					end if;
						
				else -- Normal, non-VSync lines with a normal reverse sync
				 
					if (to_integer(unsigned(NTSC_PIXEL_COUNT)) = 1137) then
						NTSC_PIXEL_COUNT <= "000000000000";
						
						if (to_integer(unsigned(NTSC_ROW_COUNT)) = 261) then
							NTSC_ROW_COUNT <= "0000000000";
						else
							-- Add another line to row counter
							NTSC_ROW_COUNT <= STD_LOGIC_VECTOR(unsigned(NTSC_ROW_COUNT) + 1);
						end if;
									
						-- Kick off our line
						SYNC    <= '1';
					else
						NTSC_PIXEL_COUNT <= STD_LOGIC_VECTOR(unsigned(NTSC_PIXEL_COUNT) + 1);
					end if;
					
					

					-- Sync 817 - 901
					if ( to_integer(unsigned(NTSC_PIXEL_COUNT)) = 817) then
						SYNC    <= '0';
					end if;
					if ( to_integer(unsigned(NTSC_PIXEL_COUNT)) = 901) then
						SYNC    <= '1';
					end if;
							
							
					-- Color burst - 912 to 957
					if  ( to_integer(unsigned(NTSC_PIXEL_COUNT)) >= 912 and to_integer(unsigned(NTSC_PIXEL_COUNT)) < 957) then
					
						-- Do not burst in the lines right after our active video!  This is our reverse sync area.
						if (to_integer(unsigned(NTSC_ROW_COUNT)) < 240 or to_integer(unsigned(NTSC_ROW_COUNT)) > 249) then
							COLORBURST <= PHASE_SHIFTER_ONE;
							
						else 
							COLORBURST <= '0';
						end if;
					end if;
					
					-- Colorburst may have left itself in the high position so change this.
					if (to_integer(unsigned(NTSC_PIXEL_COUNT)) = 957) then
						COLORBURST <= '0';
					end if;
					
					-- After active video fade to black
					if (to_integer(unsigned(NTSC_PIXEL_COUNT)) > 640) then
						LUMA <= "0000";
					end if;
					
					
					-- Start counting in the active video area
					if ( to_integer(unsigned(NTSC_ROW_COUNT)) < 240) then
						
						-- Stop counting after 640 ticks to make our math easier (just mask off
						-- bits we do not use)
						
						if ( to_integer(unsigned(NTSC_PIXEL_COUNT)) < 640) then
							
								-- Following is a lookup table for converting our RGB 4 bit pixels to 
								-- the luminance-chrominance color wheel used by NTSC
								
								-- NTSC uses the YIQ color plane, and moving to 8 bits probably needs to do a conversion
								-- Check Wikipedia for the matrix math if you decide to upgrade to 6/8 bit color.
								
								-- 16 colors is easy enough to do by looking at a color wheel (especially with 4 shades of non-color)

							  CASE ( PIXEL ) IS
								 WHEN  "0000"  =>  COLORBURST <= '0'; LUMA <= "0000";
								 WHEN  "0001"  =>  COLORBURST <= '0'; LUMA <= "0011";
								 WHEN  "0010"  =>  COLORBURST <= not PHASE_SHIFTER_ONE; LUMA <= "0010";
								 WHEN  "0011"  =>  COLORBURST <= not PHASE_SHIFTER_ONE; LUMA <= "1001";
								 WHEN  "0100"  =>  COLORBURST <= PHASE_SHIFTER_TWO;  LUMA <= "0010";
								 WHEN  "0101"  =>  COLORBURST <= PHASE_SHIFTER_TWO;  LUMA <= "1000";
								 WHEN  "0110"  =>  COLORBURST <= not PHASE_SHIFTER_FIVE; LUMA <= "0011";
								 WHEN  "0111"  =>  COLORBURST <= not PHASE_SHIFTER_FIVE; LUMA <= "1100";
								 WHEN  "1000"  =>  COLORBURST <= PHASE_SHIFTER_FIVE; LUMA <= "0010";
								 WHEN  "1001"  =>  COLORBURST <= PHASE_SHIFTER_FIVE; LUMA <= "1010";
								 WHEN  "1010"  =>  COLORBURST <= PHASE_SHIFTER_FOUR; LUMA <= "0011";
								 WHEN  "1011"  =>  COLORBURST <= PHASE_SHIFTER_FOUR; LUMA <= "1010";
								 WHEN  "1100"  =>  COLORBURST <= PHASE_SHIFTER_ONE; LUMA <= "0010";
								 WHEN  "1101"  =>  COLORBURST <= PHASE_SHIFTER_ONE; LUMA <= "1100";
								 WHEN  "1110"  =>  COLORBURST <= '0'; LUMA <= "0101";
								 WHEN OTHERS   =>  COLORBURST <= '0'; LUMA <= "1111";
							  END CASE;
							  
						end if;
					
						
					end if; -- End of row counter above 19	
					
				end if; -- end our 'if not lines 1-9
			
			
			-- Cyle back and forth between read/write, forever
			CYCLE <= not CYCLE;
			 
			-------------------------------------------------------------------------------------
			--            Framebuffer Write/Memory Management Code                             --
			-------------------------------------------------------------------------------------
			
			-- If the cache is full, we need to read it into our working register
			if (CACHE_FULL_FLAG = '1' and SPI_CACHE_FULL_FLAG = '1') then
				
				CACHE_FULL_FLAG <= '0';
				
					WRITE_DATA    <= SPI_DATA_CACHE;
					
					
					-- The first digits will 'look like' 319, and the end will equal our shift.
					if ( 		WRITE_COLUMN = "1001111100" 									
							or WRITE_COLUMN = "1111111111"  
					) then -- 640 pixels
						if (WRITE_ROW(9) = '1') then WRITE_ROW <= "0000000000"; -- End of the line
						else
						
							-- Since we are faking progressive scan, all we do is increase rows by one.
							-- We count to 240 then hopefully the driver stops and resets
							WRITE_ROW <= STD_LOGIC_VECTOR(unsigned(WRITE_ROW) + 1);

							
						end if;
						WRITE_COLUMN <= "0000000000";
						
					else
					
						-- 640 pixels wide, but we only want 320 (1 << 1)
						-- 320 pixels wide by 4 bit color not 8 bit (10 << 1)
						-- That's a total of 001 shiftleft 2, or 100 (4)
						WRITE_COLUMN <= STD_LOGIC_VECTOR(unsigned(WRITE_COLUMN) + 4);

					end if;

				
				-- ACK back to the SPI logic so it can reset the flag
				ACK_SPI_BYTE 	<= '1';
				WRITE_READY		<= '1';
			
			else
			
				-- If the cache isn't full, keep checking the flag - but don't change
				-- our currently active data
				CACHE_FULL_FLAG    	<= SPI_CACHE_FULL_FLAG;
				ACK_SPI_BYTE    		<= '0';
				
			end if; -- End Cache Full
			
			
			if ( CACHE_RESET_FLAG = '1' and SPI_CMD_RESET_FLAG = '1') then
				-- If the mode reset flag is full, we need to set the mode back to
				-- whatever the initial state is
				RESET_NEXT <= '1'; -- Reset next time you get a chance
				CACHE_RESET_FLAG 	<= '0';
				ACK_USER_RESET   	<= '1';
			
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

				if (NTSC_PIXEL_COUNT(2) = '0') then
					PIXEL <= DATA( 7 downto 4 );
				else
					PIXEL <= DATA( 3 downto 0 );
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

								-- Nothing now for NTSC, this is where we change modes in the *VGA* VGATonic firmware.
								-- You could certainly add mode changing here.  160x120, 80x60 and 2 and 1 bit color are
								-- somewhat simple, but as discussed in the comments 256 color/8 bit would require work/decoding
								-- and 640x480 is only possible with interlacing (and maximum 30 FPS... well, 29.97 anyway)
								
							end if;
		
					end if;
				end if;
				
				if (WRITE_READY = '1') then
					-- Reset our write so we don't write every cycle.
					WRITE_READY <= '0';
				end if;
				
				
				-- In this mode, keep Sync and Luma the same
				SYNC <= SYNC;
				LUMA(3 downto 0) <= LUMA(3 downto 0);
							
				
			end if;
		
		end if; -- End rising edge user logicclock
		
		
		
	end process;
	
	-- Framebuffer Core
end Behavioral;