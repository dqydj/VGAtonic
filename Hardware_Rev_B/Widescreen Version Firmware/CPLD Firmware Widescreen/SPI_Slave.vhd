-----------------------------------------------------------------------------------

-- Top SPI Speed Calculation for Widescreen (Please check my math - no warranties implied)

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
--    Example: For a 30 MHz User Clock and a Xilinx XC95144XL-10 with an internal 
--    logic setup time of 3.0 ns:
--
--    tSPI > ((3 * 33.3333) +(3.0 + 3.0))/7.5 = 14.13333 ns

--    For that part combination and our code, SPI speed shouldn't exceed 
--    70.754 MHz...

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SPI_Slave is
	Port (
		--------------------------------------------------------
		--                   SPI Declarations                 --
		--------------------------------------------------------
		
		SEL_SPI							: in STD_LOGIC;
		
		-- SPI Pins from World
		EXT_SCK 							: in STD_LOGIC;
		EXT_SEL 							: in STD_LOGIC;
		EXT_MOSI							: in STD_LOGIC;
		EXT_MISO							: out STD_LOGIC;	
		
		-- SPI Pins from AVR
		AVR_SCK 							: in STD_LOGIC;
		AVR_SEL 							: in STD_LOGIC;
		AVR_MOSI							: in STD_LOGIC;
--		AVR_MISO							: out STD_LOGIC;	
		
		-- One byte FIFO 
		SPI_DATA_CACHE    		: out STD_LOGIC_VECTOR(7 downto 0) := "00000000";

		-- Asynchronous flags for signals to display logic
		SPI_CACHE_FULL_FLAG 		: out STD_LOGIC := '0'; 
		SPI_CMD_RESET_FLAG 		: out STD_LOGIC := '0';
		
		-- Async Flags returned from user logic
		ACK_USER_RESET          : in STD_LOGIC;
		ACK_SPI_BYTE            : in STD_LOGIC
	
	);

end SPI_Slave;

architecture Behavioral of SPI_Slave is

	-- Temporary Storage for SPI (Sneaky: cheat by one bit out of 8 to save a flip-flop)
	signal SPI_DATA_REG      	: STD_LOGIC_VECTOR(6 downto 0) := "0000000";
	-- Counter for our receiver
	signal SCK_COUNTER		 	: STD_LOGIC_VECTOR(2 downto 0) := "000";

	signal SCK						: STD_LOGIC := '0';
	signal SEL						: STD_LOGIC := '0';
	signal MOSI						: STD_LOGIC := '0';
begin

	--SEL  <= (not SEL_SPI or  EXT_SEL)  and (SEL_SPI or  AVR_SEL); -- Normally High, when SEL_SPI = 0 AVR can drive low.
	--SCK  <= (not SEL_SPI and AVR_SCK)  or (SEL_SPI and EXT_SCK);
	--MOSI <= (not SEL_SPI and AVR_MOSI) or (SEL_SPI and EXT_MOSI);
	-- Code for SPI receiver
	SPI_Logic: process (SEL_SPI, SCK, SEL, ACK_USER_RESET, ACK_SPI_BYTE)
	begin
	
	if (SEL_SPI = '1') then
		SEL <= AVR_SEL;
		SCK <= AVR_SCK;
		MOSI <= AVR_MOSI;
	else
		SEL <= EXT_SEL;
		SCK <= EXT_SCK;
		MOSI <= EXT_MOSI;
	end if;
	
	-- Code to handle 'Mode Reset' in the User Logic
	if (ACK_USER_RESET = '1') then -- User Logic acknowledges it was reset
	
		SPI_CMD_RESET_FLAG <= '0';
	
	else -- User doesn't currently acknowledge a reset
	
		if (rising_edge(SEL)) then -- CPLD was just deselected
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
		
	else  -- NOT currently acknowledging a byte received RISING EDGE
	
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
	

end Behavioral;