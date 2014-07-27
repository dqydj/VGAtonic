----------------------------------------------------------------------------------

-- SPI Slave Example and FIFO Arbitration
-- Author: PK, http://dqydj.net
-- License: MIT
-- (Please see the root directory for a copy)

--    This module demonstrates crossing clock domains from an independently 
--    controlled SPI process or a 'main' user logic process (for this project, 
--    it will be a display controller).
--
--    It features a fairly standard two flip flop cross domain clocking scheme for 
--    'command reset', defined as deselecting our CPLD/FPGA, and another two-flop
--    synchronizer for a full cache, which means we have a byte in our FIFO ready
--    for consumption by the user logic.

-----------------------------------------------------------------------------------


-----------------------------------------------------------------------------------

-- Top SPI Speed Calculation (Please check my math - no warranties implied)

--    To determine top speed, look at worst case and count user clocks
--    1) SPI_CACHE_FULL_FLAG goes high too late for tSU to react
--    2) CACHE_FULL_FLAG(0) = '1'
--    3) CACHE_FULL_FLAG(1) = '1'.  User Logic sends reset signal.
--
--    
--    We can accept up to 7 bits of the full SPI (plus a half clock minus setup
--    time, actually, due to "if (ACK_SPI_BYTE = '1')") based on our code - 
--    so 7.5 clocks of SPI cannot be faster than 3 clocks of User Logic.  We write
--    the inverse to convert to time, as time is 1/frequency:
--
--       (3/7.5)tUSER < tSPI
--
--    "How much" less is determined by the setup time on the user logic flip flop,
--    so we can constrain it further, and add back the setup time factor:
--
--       (7.5 * tSPI) > (3 * tUSER) + tSU + tSU
--       tSPI > (3*tUSER + 2*tSU)/7.5
--
--    Example: For a 25.125 MHz User Clock and a Xilinx XC95144XL-10 with an internal 
--    logic setup time of 3.0 ns:
--
--    tSPI > ((3 * 39.801) +(3.0 + 3.0))/7.5 = 16.7204 ns

--    For that part combination and our code, SPI speed shouldn't exceed 
--    59.807 MHz...

----------------------------------------------------------------------------------

library IEEE;
use     IEEE.STD_LOGIC_1164.ALL;
use     IEEE.NUMERIC_STD.ALL;

entity SPISlave is

	Port (
				-- Clock from our 'main' module.  The final target for my project
				-- is a display controller
				CLK : in STD_LOGIC; 
				
				-- Whatever output you need
				LED : inout STD_LOGIC_VECTOR(7 downto 0) := "00000000";
							
				-- SPI Pins
				SCK : in STD_LOGIC;
				SEL : in STD_LOGIC;
				MOSI: in STD_LOGIC;
				
				-- If you need to 'talk back', use a MISO line as well.
				-- If you have other devices on the line and don't need it, leave 
				-- it floating - but if it is the only one consider pullup or 
				-- pulldown resistors depending on the SPI master.
				
				MISO: out STD_LOGIC := '0'
	
	);
	
end SPISlave;

architecture Behavioral of SPISlave is
	
	--------------------------------------------------------
	--                   SPI Declarations                 --
	--------------------------------------------------------

	-- Temporary Storage for SPI (We cheat by one bit to save a flip-flop)
	signal SPI_DATA_REG      	: STD_LOGIC_VECTOR(6 downto 0) := "0000000";

	-- Our one byte FIFO 
	-- receive data even before we write to memory asynchronously
	signal SPI_DATA_CACHE    	: STD_LOGIC_VECTOR(7 downto 0) := "00000000";
	signal SCK_COUNTER		 	: STD_LOGIC_VECTOR(2 downto 0) := "000";
	
	-- Asynchronous flags for signals to display logic
	signal SPI_CACHE_FULL_FLAG : STD_LOGIC := '0'; 
	signal SPI_CMD_RESET_FLAG 	: STD_LOGIC := '0';

	--------------------------------------------------------
	--              Receiver Declarations                 --
	--------------------------------------------------------
	
	-- Your active memory, fresh off the presses
	signal USER_DATA      	   : STD_LOGIC_VECTOR(7 downto 0) := "00000000";
	
	-- How should the user logic process the data?
	signal USER_MODE           : STD_LOGIC := '0';
	
	-- Double flip-flop sync signals for full/command reset - increase these
	-- sizes to harden more against metastability
	signal CACHE_FULL_FLAG     : STD_LOGIC_VECTOR(1 downto 0) := "00";
	signal CACHE_RESET_FLAG    : STD_LOGIC_VECTOR(1 downto 0) := "00";
	
	-- Async acknowledgement flags for SPI logic
	signal ACK_SPI_BYTE      	: STD_LOGIC := '0';
	signal ACK_USER_RESET    	: STD_LOGIC := '0';

begin

	-- (Do something real with it in your code)
	LED <= USER_DATA;

	-- Code for SPI receiver
	SPI_Logic: process (SCK, SEL)
	begin
	
	
	-- Code to handle 'Mode Reset' in the User Logic
	if (ACK_USER_RESET = '1') then -- User Logic acknowledges it was reset
	
		SPI_CMD_RESET_FLAG <= '0';
	
	else -- User doesn't currently acknowledge a reset
	
		if (rising_edge(SCK)) then -- CPLD was just deselected
			SPI_CMD_RESET_FLAG <= '1';
		end if;
		
	end if;
	
	
	
	-- Code to handle our SPI arbitration, reading, and clocking
	if (ACK_SPI_BYTE = '1') then -- User Logic acknowledges receiving a byte
	
		-- Lower the Cache Full flag
		SPI_CACHE_FULL_FLAG <= '0';
		
		-- If we continue clocking while the user logic is reacting,
		-- put it into our data register.  This is the logic
		-- which limits the top speed of the logic - but usually you'll be 
		-- hardware limited.
		if (rising_edge(SCK)) then
			if (SEL = '0') then
				SPI_DATA_REG <= SPI_DATA_REG(5 downto 0) & MOSI;
				SCK_COUNTER  <= STD_LOGIC_VECTOR(unsigned(SCK_COUNTER) + 1);
			end if;
		end if;
		
	else  -- User Logic is NOT currently acknowledging a byte received
	
		-- Normal, conventional, everyday, typical, average SPI logic begins.
		if (rising_edge(SCK)) then
		
			-- Our CPLD is selected
			if (SEL = '0') then
				
				-- If we've just received a whole byte...
				if (SCK_COUNTER = "111") then
					SCK_COUNTER  <= "000";
					SPI_DATA_REG <= "0000000";
					
					-- Put the received byte into the single entry FIFO
					SPI_DATA_CACHE <= SPI_DATA_REG(6 downto 0) & MOSI;
					
					-- To: User Logic... "You've got mail."
					SPI_CACHE_FULL_FLAG <= '1';
			
				-- We're not full yet so the bits will keep coming
				else
				
					SPI_DATA_REG <= SPI_DATA_REG(5 downto 0) & MOSI;
					SCK_COUNTER  <= STD_LOGIC_VECTOR(unsigned(SCK_COUNTER) + 1);
					
				end if;
			
			-- CPLD is NOT selected
			else
					-- Reset counter, register
					SCK_COUNTER  <= "000";
					SPI_DATA_REG <= "0000000";
					
			end if; -- End CPLD Selected
		
		end if; --  End Rising SCK edge
		
	end if; -- end Byte Received
	end process; -- end SPI
		
	
	-- Code for User Logic
	User_Logic: process (CLK)
	begin
		-- This is our user logic clock now, not SPI anymore
		if (rising_edge(CLK)) then
		
			-- If the cache is full, we need to read it into our working register
			if (CACHE_FULL_FLAG(1) = '1') then
			
				CACHE_FULL_FLAG <= "00";
				USER_DATA    <= SPI_DATA_CACHE;
				ACK_SPI_BYTE <= '1';
			
			-- If the cache isn't full, keep checking the flag - but don't change
			-- our currently active data
			else
			
				CACHE_FULL_FLAG <= CACHE_FULL_FLAG(0) & SPI_CACHE_FULL_FLAG;
				USER_DATA       <= USER_DATA;
				ACK_SPI_BYTE    <= '0';
				
			end if; -- End Cache Full
			
			
			-- If the mode reset flag is full, we need to set the mode back to
			-- whatever the initial state is
			if (CACHE_RESET_FLAG(1) = '1') then
			
				CACHE_RESET_FLAG <= "00";
				USER_MODE        <= '0';
				ACK_USER_RESET   <= '1';
			
			-- No reset flag up, so do whatever you want with the mode in your code
			else
			
				CACHE_RESET_FLAG <= CACHE_RESET_FLAG(0) & SPI_CMD_RESET_FLAG;
				USER_MODE        <= '1';
				ACK_USER_RESET   <= '0';
				
			end if; -- End Cache Full
			
			
			
		end if; -- End rising edge user clock
		
	end process;
	
end Behavioral;

