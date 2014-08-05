------------------------------------------------------------------------------------------------
--                                  VGAtonic Color Bar Test                                   --
--                                                                                            --
--   This code demonstrates VGA and NTSC from the same source clock, a 3.5795454 MHz          --
--   colorburst signal for NTSC.  Using a PLL, we multiply that source by 7 to get 25.0568    --
--   MHz - a 0.47% error from the VGA standard 25.175 MHz clock (Doing it in the reverse      --
--   direction - dividing 25.175 MHz by 7 - gives a rainbow pattern for a single phase...     --
--   no good)                                                                                 --
--                                                                                            --
--  License: MIT (see root directory).                                                        --
------------------------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity video is
		Port ( 	CLK 			: in    STD_LOGIC;
		
					-- Output to PLL
					CLK_OUT 		: out   STD_LOGIC;
					
					-- Input from a switch (go between NTSC/VGA)
					MODE			: in    STD_LOGIC;
						
					
					-- VGA Signals
					PIXEL      	: out   unsigned(7 downto 0)  := "00000000";
					HSYNC			: out   STD_LOGIC;
					VSYNC			: out   STD_LOGIC;		
		
					-- NTSC Signals
					COLORBURST 	: out   std_logic := '0';
					SYNC       	: out   std_logic := '1';
					LUMA      	: out   unsigned(3 downto 0)  := "0000";
					CLK_COUNTER : inout unsigned(10 downto 0) := (others => '0');
					ROW_COUNTER	: inout unsigned(9 downto 0)  := (others => '0')

				);
end video;


architecture Behavioral of video is

 -- This ring counter pulls double duty.  
 -- First, it divides our PLL output by 7 for the feedback (to get 25 and change MHz out of 3.5795454 
 --       - division here becomes multiplication)
 -- Second, we have 14 phases of 3.5795454 at the same time - all the positions in the ring counter, 
 --       and all the 'nots'.
signal PHASE_SHIFTER   	: unsigned(6 downto 0) := "1111111";

begin

-- For this PLL, position (4) worked best achieving lock - you should experiment
CLK_OUT <= not PHASE_SHIFTER(4);

process (CLK,  PHASE_SHIFTER, MODE)
begin


		-- Got a ring counter to divide our clock into two for ~ 3.5795454 MHz colorbursts
		-- Note that 'EVENT means a double edged flip flop is necessary.
		if (CLK'EVENT) then
			PHASE_SHIFTER <= unsigned(PHASE_SHIFTER (5 downto 0)) & not PHASE_SHIFTER(6);
		end if;

		-- Video generation code.
		if (rising_edge(CLK)) then
		
			if (MODE = '1') then -- NTSC Mode = '1'.  Technically, NTSC-J, fine - but show me a recent TV that cares.
				
				-- Zero out VGA signal while driving NTSC
				PIXEL <= "00000000";
				HSYNC <= '0';
				VSYNC <= '0';
			
			
			
				if ( (ROW_COUNTER = "0000000100") or (ROW_COUNTER = "0000000101") or (ROW_COUNTER = "0000000110")) then
				-- Sync is reversed on a VSYNC line
					if (CLK_COUNTER = "11000110111") then
						CLK_COUNTER <= "00000000000";
						-- Add another line to row counter
						ROW_COUNTER <= row_counter + 1;
						-- Kick off our line
						SYNC    <= '0';
						COLORBURST <= '0';
					else
						CLK_COUNTER <= CLK_COUNTER + 1;
						COLORBURST <= '0';
					end if;
					
					-- Front porch 0 - 38 cycles
					if (clk_counter = 38) then
						SYNC    <= '1';
						COLORBURST <= '0';
					end if;
					
					-- Sync end after 155 cycles
					if (clk_counter = 156) then
						SYNC    <= '0';
						COLORBURST <= '0';
					end if;
						
				else -- Normal, non-VSync lines with a normal reverse sync
				 
					if (clk_counter = "11000110111") then
						clk_counter <= "00000000000";
						
						if (row_counter = "0100000110") then
							row_counter <= "0000000000";
						else
							-- Add another line to row counter
							row_counter <= row_counter + 1;
						end if;
									
						-- Kick off our line
						SYNC    <= '1';
						LUMA    <= "0000";
						COLORBURST <= '0';
					else
						clk_counter <= clk_counter + 1;
					end if;
					
					
					-- Front porch 0 - 38
					if (clk_counter = 38) then
						SYNC    <= '0';
					end if;
					
					-- Sync end after 155
					if (clk_counter = 156) then
						SYNC    <= '1';
					end if;
					
					
					-- After 273, real picture drawing can begin
					
					-- Can only draw picture with row counter above 19
					if (row_counter > 19) then
					
						--Color burst - 182 to 245
						if  (CLK_COUNTER >= 182 and CLK_COUNTER < 245) then
							COLORBURST <= PHASE_SHIFTER(0); 
						elsif (clk_counter >= 244 and CLK_COUNTER < 273) then
							-- Voltage Ramp ?
							LUMA       <= "0000";
							COLORBURST <= '0';  
						end if;
						
						if (CLK_COUNTER >= 300 and CLK_COUNTER < 1590) then
							-- Luma is the brightness of the color being sent to the screen.
							-- On one of my screens (camera reverse monitor), I could see all 
							-- 16 steps - but the TVs didn't show the difference in the LSBs.
							LUMA       <= ROW_COUNTER(6 downto 3);
							
							-- All I'm doing here is assigning colors randomly to these 4 digits of the
							-- clock counter.  This is your chrominance.
							  CASE CLK_COUNTER(9 downto 6) IS
								 WHEN  "0000"  =>  COLORBURST <= PHASE_SHIFTER(0);
								 WHEN  "0001"  =>  COLORBURST <= PHASE_SHIFTER(1);
								 WHEN  "0010"  =>  COLORBURST <= PHASE_SHIFTER(2);
								 WHEN  "0011"  =>  COLORBURST <= PHASE_SHIFTER(3);
								 WHEN  "0100"  =>  COLORBURST <= PHASE_SHIFTER(4);
								 WHEN  "0101"  =>  COLORBURST <= PHASE_SHIFTER(5);
								 WHEN  "0110"  =>  COLORBURST <= PHASE_SHIFTER(6);
								 WHEN  "0111"  =>  COLORBURST <= not PHASE_SHIFTER(0);
								 WHEN  "1000"  =>  COLORBURST <= not PHASE_SHIFTER(1);
								 WHEN  "1001"  =>  COLORBURST <= not PHASE_SHIFTER(2);
								 WHEN  "1010"  =>  COLORBURST <= not PHASE_SHIFTER(3);
								 WHEN  "1011"  =>  COLORBURST <= not PHASE_SHIFTER(4);
								 WHEN  "1100"  =>  COLORBURST <= not PHASE_SHIFTER(5);
								 WHEN  "1101"  =>  COLORBURST <= not PHASE_SHIFTER(6);
								 WHEN OTHERS   =>  COLORBURST <= '0';
							  END CASE;
							  
						elsif clk_counter > 1590 then
							LUMA       <= "0000";
							COLORBURST <= '0';  
						end if;
					
						
					end if; -- End of row counter above 19	
					
				end if; -- end our 'if not lines 1-9
		
		
		else -- mode = '0', so do VGA
				-- Zero out control signals for NTSC
				LUMA       <= "0000";
				COLORBURST <= '0';  
				SYNC		  <= '0'; 
				
				-- Now clock counter is used to count VGA rows.
				if (CLK_COUNTER = "01100100000") then
					CLK_COUNTER <= "00000000000";
					
					if (ROW_COUNTER = "1000001100") then
						ROW_COUNTER <= "0000000000";
					else
						ROW_COUNTER <= ROW_COUNTER + 1;
					end if;	
				else
				
					CLK_COUNTER <= CLK_COUNTER + 1;
					
				end if;
				
				-- VGA sync timing
				if (CLK_COUNTER >= 656 and CLK_COUNTER < 752) then
					HSync <= '0';
				else
					HSync <= '1';
				end if;
				
				if (ROW_COUNTER = 490 or ROW_COUNTER = 491) then
					VSync <= '0';
				else
					VSync <= '1';
				end if;
				
				-- Wow, VGA is much easier than NTSC with the color test patterns, eh?
				if (ROW_COUNTER < 480 and CLK_COUNTER < 640) then
					-- color
					PIXEL <= ROW_COUNTER (7 downto 4) & CLK_COUNTER (7 downto 4);
				else 
					-- color
					PIXEL <= "00000000";
					end if;
					

							
		end if; -- End MODE Check
	end if; -- end clock rising edge
end process;

end Behavioral;

