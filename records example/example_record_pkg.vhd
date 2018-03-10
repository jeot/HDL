-- coppied from here: 
-- https://www.nandland.com/vhdl/examples/example-record.html

library ieee;
use ieee.std_logic_1164.all;
 
package example_record_pkg is
 
	-- Outputs from the FIFO.
	type t_FROM_FIFO is record
		wr_full  : std_logic;                -- FIFO Full Flag
		rd_empty : std_logic;                -- FIFO Empty Flag
		rd_dv    : std_logic;
		rd_data  : std_logic_vector(7 downto 0);
	end record t_FROM_FIFO;  
 
	-- Inputs to the FIFO.
	type t_TO_FIFO is record
		wr_en    : std_logic;
		wr_data  : std_logic_vector(7 downto 0);
		rd_en    : std_logic;
	end record t_TO_FIFO;
 
	constant c_FROM_FIFO_INIT : t_FROM_FIFO := 
		(wr_full => '0',
		rd_empty => '1',
		rd_dv => '0',
		rd_data => (others => '0'));
 
	constant c_TO_FIFO_INIT : t_TO_FIFO := 
		(wr_en => '0',
		wr_data => (others => '0'),
		rd_en => '0');
	 
	 
end package example_record_pkg;