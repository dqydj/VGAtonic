library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


-- In/out for top level module
entity VGAtonic_Firmware is
	PORT(
		CLK : in STD_LOGIC;
		
		--SPI (no MISO)
		EXT_SCK 		: in STD_LOGIC;
		EXT_MOSI		: in STD_LOGIC;
		EXT_MISO		: out STD_LOGIC := '0';
		EXT_SEL_CPLD: in STD_LOGIC; -- Active low
		
		-- VGA
		PIXEL			: inout STD_LOGIC_VECTOR(7 downto 0);
		HSYNC			: inout STD_LOGIC;
		VSYNC			: inout STD_LOGIC;
		--CPLD_GPIO 	: out STD_LOGIC_VECTOR(16 downto 16) := "0";
		
		-- Memory
		DATA			: inout STD_LOGIC_VECTOR(7 downto 0);
		ADDR			: out STD_LOGIC_VECTOR(18 downto 0);
		OE_LOW		: out STD_LOGIC := '1';
		WE_LOW		: out STD_LOGIC := '1';
		CE_LOW		: out STD_LOGIC := '1'
				
	);
end VGAtonic_Firmware;

architecture Behavioral of VGAtonic_Firmware is
	
	
	-- Handshaking signals from SPI
	signal SPI_DATA_CACHE			: STD_LOGIC_VECTOR(7 downto 0);
	signal SPI_CACHE_FULL_FLAG 	: STD_LOGIC;
	signal SPI_CMD_RESET_FLAG   	: STD_LOGIC;
	
	-- Handshaking signals to SPI
	signal ACK_USER_RESET 			: STD_LOGIC;
	signal ACK_SPI_BYTE   			: STD_LOGIC;
	
	-- Instantiating our SPI slave code (see earlier entries)
	COMPONENT SPI_Slave
	PORT(
		SCK : IN std_logic;
		SEL : IN std_logic;
		MOSI : IN std_logic;
		ACK_USER_RESET : IN std_logic;
		ACK_SPI_BYTE : IN std_logic;          
		MISO : OUT std_logic;
		SPI_DATA_CACHE : OUT std_logic_vector(7 downto 0);
		SPI_CACHE_FULL_FLAG : OUT std_logic;
		SPI_CMD_RESET_FLAG : OUT std_logic
		);
	END COMPONENT;
	
	-- Instantiating our Display Controller code
	-- Just VGA for now
	COMPONENT Display_Controller
	PORT(
		CLK : IN std_logic;
		SPI_DATA_CACHE : IN std_logic_vector(7 downto 0);
		SPI_CACHE_FULL_FLAG : IN std_logic;
		SPI_CMD_RESET_FLAG : IN std_logic;    
		PIXEL : INOUT std_logic_vector(7 downto 0);
		HSYNC : INOUT std_logic;
		VSYNC : INOUT std_logic;      
		--CPLD_GPIO : OUT std_logic_vector(16 to 16);
		ACK_USER_RESET : INOUT std_logic;
		ACK_SPI_BYTE : OUT std_logic;
		ADDR : OUT std_logic_vector(18 downto 0);
		DATA : INOUT std_logic_vector(7 downto 0);
		OE_LOW		: out STD_LOGIC := '1';
		WE_LOW		: out STD_LOGIC := '1';
		CE_LOW		: out STD_LOGIC := '1'
		);
	END COMPONENT;
	
begin


	-- Nothing special here; we don't even really change the names of the signals.
	-- Here we map all of the internal and external signals to the respective
	-- modules for SPI input and VGA output.
	
	Inst_SPI_Slave: SPI_Slave PORT MAP(
		SCK => EXT_SCK,
		SEL => EXT_SEL_CPLD,
		MOSI => EXT_MOSI,
		MISO => EXT_MISO,
		SPI_DATA_CACHE => SPI_DATA_CACHE,
		SPI_CACHE_FULL_FLAG => SPI_CACHE_FULL_FLAG,
		SPI_CMD_RESET_FLAG => SPI_CMD_RESET_FLAG,
		ACK_USER_RESET => ACK_USER_RESET,
		ACK_SPI_BYTE => ACK_SPI_BYTE
	);

	
	Inst_Display_Controller: Display_Controller PORT MAP(
		CLK => CLK,
		PIXEL => PIXEL,
		HSYNC => HSYNC,
		VSYNC => VSYNC,
		--CPLD_GPIO => CPLD_GPIO,
		SPI_DATA_CACHE => SPI_DATA_CACHE,
		SPI_CACHE_FULL_FLAG => SPI_CACHE_FULL_FLAG,
		SPI_CMD_RESET_FLAG => SPI_CMD_RESET_FLAG,
		ACK_USER_RESET => ACK_USER_RESET,
		ACK_SPI_BYTE => ACK_SPI_BYTE,
		DATA => DATA,
		ADDR => ADDR,
		OE_LOW => OE_LOW,
		WE_LOW => WE_LOW,
		CE_LOW => CE_LOW
	);

end Behavioral;
