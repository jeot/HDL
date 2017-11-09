LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY testbench_uart_ex IS
END testbench_uart_ex;
 
ARCHITECTURE behavior OF testbench_uart_ex IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT UART_EX
    generic (
			ClkFrequency : integer;
			Baud : integer
		);
    PORT(
         clk : IN  std_logic;
         RX : IN  std_logic;
         TX : OUT  std_logic;
         TxStart : IN  std_logic;
         TxBusy : OUT  std_logic;
         RxReady : OUT  std_logic;
         RxByte : OUT  std_logic_vector(7 downto 0);
         TxData : IN  std_logic_vector(63 downto 0);
         TxDataWidth : IN  std_logic_vector(2 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal RX : std_logic := '0';
   signal TxStart : std_logic := '0';
   signal TxData : std_logic_vector(63 downto 0) := (others => '0');
   signal TxDataWidth : std_logic_vector(2 downto 0) := (others => '0');

 	--Outputs
   signal TX : std_logic;
   signal TxBusy : std_logic;
   signal RxReady : std_logic;
   signal RxByte : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: UART_EX 
   	Generic map (ClkFrequency => 50000000, Baud => 115200) 
   	PORT MAP (
          clk => clk,
          RX => RX,
          TX => TX,
          TxStart => TxStart,
          TxBusy => TxBusy,
          RxReady => RxReady,
          RxByte => RxByte,
          TxData => TxData,
          TxDataWidth => TxDataWidth
        );
   	RX <= TX;

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

    -- Stimulus process
    stim_proc: process
    begin		
    	-- hold reset state for 100 ns.
		wait for 100 ns;	
		wait for clk_period*10;
		wait for clk_period/4;
	
		-- insert stimulus here 
		TxStart <= '1';
		txData <= x"0123456789012345";
		TxDataWidth <= "111"; 
		wait for clk_period;
		TxStart <= '0';
		txData <= (others => '0');
		TxDataWidth <= (others => '0');
		wait for clk_period*1000;
		TxStart <= '1';	 -- ignore due to TxBusy!
		txData <= x"0123456789012345";
		TxDataWidth <= "100"; 
		wait for clk_period;
		TxStart <= '0';
		wait until TxBusy = '0';
		wait;
		wait for clk_period*10;
		wait for clk_period/4;
		TxStart <= '1';
		txData <= x"ab01ab01cd23cd23";
		TxDataWidth <= "011"; 
		wait for clk_period;
		TxStart <= '0';
		wait;
    end process;

END;
