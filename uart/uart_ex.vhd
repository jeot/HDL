-- Shamim Keshani (sh.keshani@gmail.com)

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity UART_EX is
	generic (
		ClkFrequency : integer := 50000000;
		Baud : integer := 115200
	);
    port ( 
    	clk : in STD_LOGIC;
        RX : in STD_LOGIC;
        TX : out STD_LOGIC;
        TxStart : in STD_LOGIC;
        TxBusy : out STD_LOGIC;
        RxReady : out STD_LOGIC;
        RxByte : out STD_LOGIC_VECTOR (7 downto 0);
        TxData : in STD_LOGIC_VECTOR (63 downto 0);
        TxDataWidth : in STD_LOGIC_VECTOR (2 downto 0)
    );
end UART_EX;

architecture behaveural of UART_EX is
	component UART
		generic (
			ClkFrequency : integer;
			Baud : integer
		);
		Port ( 
			clk : in  STD_LOGIC;
			RxD : in  STD_LOGIC;
			TxD : out  STD_LOGIC;
			tx_start : in  STD_LOGIC;
			tx_busy : out  STD_LOGIC;
			rx_ready : out  STD_LOGIC;
			RxByte : out  STD_LOGIC_VECTOR (7 downto 0);
			TxByte : in  STD_LOGIC_VECTOR (7 downto 0)
		);
	end component;
	signal TxDataReg : STD_LOGIC_VECTOR (63 downto 0);
	signal TxDataWidthReg : STD_LOGIC_VECTOR (2 downto 0);
	signal TxByteCounter : STD_LOGIC_VECTOR (2+1 downto 0);
	signal TxBusyReg : STD_LOGIC;
	signal uart_tx_byte, uart_rx_byte : STD_LOGIC_VECTOR (7 downto 0);
	signal uart_tx_start, uart_rx_ready, uart_tx_busy : STD_LOGIC;

	type state_type is (
		state_idle, 
		state_send_check,
		state_send_data
	);
								
	signal state : state_type := state_idle;

begin
	uart_unit : UART 
		Generic map (ClkFrequency => ClkFrequency, Baud => Baud) 
		port map (
		  clk=>clk, RxD=>RX, TXD=>TX, 
		  tx_start=>uart_tx_start, tx_busy=>uart_tx_busy, rx_ready=>uart_rx_ready, 
		  RxByte=>uart_rx_byte, TxByte=>uart_tx_byte
		);

	RxByte <= uart_rx_byte;
	RxReady <= uart_rx_ready;

	the_transmition_process: process (clk) begin
		if clk = '1' and clk'event then
			case (state) is
			when state_idle =>
				if (TxStart = '1') then
					TxDataReg <= TxData;
					TxDataWidthReg <= TxDataWidth;
					TxBusyReg <= '1';
					TxByteCounter <= (others => '1'); -- "1111" = -1
					state <= state_send_check;
				else
					TxBusyReg <= '0';
					state <= state;
				end if;
			when state_send_check =>
				if (uart_tx_busy = '1') then
					state <= state;
				elsif (TxByteCounter = TxDataWidthReg) then
					state <= state_idle;
				else
					TxDataReg(63-8 downto 0) <= TxDataReg(63 downto 8);
					TxDataReg(63 downto 63-7) <= TxDataReg(7 downto 0);
					state <= state_send_data;
				end if;
			when state_send_data =>
				TxByteCounter <= TxByteCounter + '1';
				state <= state_send_check;
			when others =>
				state <= state_idle;
			end case;
		end if;
	end process;
	uart_tx_start <= '1' when state = state_send_data else '0';

	TxBusy <= TxBusyReg;
	uart_tx_byte <= TxDataReg(63 downto 63-7);
end architecture;