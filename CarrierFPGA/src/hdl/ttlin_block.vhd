--------------------------------------------------------------------------------
--  PandA Motion Project - 2016
--      Diamond Light Source, Oxford, UK
--      SOLEIL Synchrotron, GIF-sur-YVETTE, France
--
--  Author      : Dr. Isa Uzun (isa.uzun@diamond.ac.uk)
--------------------------------------------------------------------------------
--
--  Description : Control register interface for TTLIN block.
--                User select System Bus bit to be assigned to output.
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.type_defines.all;
use work.top_defines.all;

entity ttlin_block is
port (
    -- Clock and Reset
    clk_i               : in  std_logic;
    reset_i             : in  std_logic;
    -- Memory Bus Interface
    mem_cs_i            : in  std_logic;
    mem_wstb_i          : in  std_logic;
    mem_addr_i          : in  std_logic_vector(BLK_AW-1 downto 0);
    mem_dat_i           : in  std_logic_vector(31 downto 0);
    -- Output pulse
    pad_i               : in  std_logic;
    val_o               : out std_logic
);
end ttlin_block;

architecture rtl of ttlin_block is

begin

-- Always register external I/O pads.
process(clk_i)
begin
    if rising_edge(clk_i) then
        val_o <= pad_i;
    end if;
end process;

end rtl;

