-- coppied from here: 
-- https://www.nandland.com/vhdl/examples/example-record.html

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
use work.example_record_pkg.all; -- USING PACKAGE HERE!
 
entity example_record is
  port (
    i_clk  : in  std_logic;
    i_fifo : in  t_FROM_FIFO;
    o_fifo : out t_TO_FIFO := c_TO_FIFO_INIT  -- intialize output record
    );
end example_record;
 
architecture behave of example_record is
 
  signal r_WR_DATA : unsigned(7 downto 0) := (others => '0');
   
begin
 
  -- Handles writes to the FIFO
  p_FIFO_WR : process (i_clk) is
  begin
    if rising_edge(i_clk) then
      if i_fifo.wr_full = '0' then
        o_fifo.wr_en   <= '1';
        o_fifo.wr_data <= std_logic_vector(r_WR_DATA + 1);
      end if;
    end if;
  end process p_FIFO_WR;
   
  -- Handles reads from the FIFO
  p_FIFO_RD : process (i_clk) is
  begin
    if rising_edge(i_clk) then
      if i_fifo.rd_empty = '0' then
        o_fifo.rd_en <= '1';
      end if;
    end if;
  end process p_FIFO_RD;
   
end behave;