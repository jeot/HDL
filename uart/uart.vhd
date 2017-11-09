-- Shamim Keshani (sh.keshani@gmail.com)

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UART is
	generic (
		ClkFrequency : integer := 50000000;
		Baud : integer := 115200
		);
    port ( clk : in  STD_LOGIC;
           RxD : in  STD_LOGIC;
           TxD : out  STD_LOGIC;
           tx_start : in  STD_LOGIC;
           tx_busy : out  STD_LOGIC;
           rx_ready : out  STD_LOGIC;
           RxByte : out  STD_LOGIC_VECTOR (7 downto 0);
           TxByte : in  STD_LOGIC_VECTOR (7 downto 0));
end UART;

architecture Behavioral of UART is
	component async_receiver
	generic (
		ClkFrequency : integer;
		Baud : integer
		);
	port (
		clk : in std_logic;
		RxD : in std_logic;
		RxD_data_ready: out std_logic;
		RxD_data: out std_logic_vector(7 downto 0);  --// data received, valid only (for one clock cycle) when RxD_data_ready is asserted
		RxD_idle: out std_logic; --// asserted when no data has been received for a while
		RxD_endofpacket: out std_logic  --// asserted for one clock cycle when a packet has been detected (i.e. RxD_idle is going high)
	);
	end component;
	
	component async_transmitter
	generic (
		ClkFrequency : integer;
		Baud : integer
		);
	port (
		clk : in std_logic;
		TxD_start : in std_logic;
		TxD_data : in std_logic_vector(7 downto 0);
		TxD: out std_logic;
		TxD_busy: out std_logic
	);
	end component;
	
begin

	RS232_Receiver : async_receiver 
		Generic map (ClkFrequency => ClkFrequency, Baud=>Baud)
		port map ( clk=>clk, RxD=>RxD, RXD_data_ready=>rx_ready, RxD_data=>RxByte, RXD_idle=>open, RxD_endofpacket=>open );
	RS232_Transmiter : async_transmitter 
		Generic map (ClkFrequency => ClkFrequency, Baud=>Baud)
		port map ( clk=>clk, TxD=>TxD, TxD_start=>tx_start, TxD_data=>TxByte, TxD_busy=>tx_busy );		

end Behavioral;

