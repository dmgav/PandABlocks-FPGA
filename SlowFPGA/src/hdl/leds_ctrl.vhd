--------------------------------------------------------------------------------
--  PandA Motion Project - 2016
--      Diamond Light Source, Oxford, UK
--      SOLEIL Synchrotron, GIF-sur-YVETTE, France
--
--  Author      : Dr. Isa Uzun (isa.uzun@diamond.ac.uk)
--------------------------------------------------------------------------------
--
--  Description : Encoder Daugther Card receive interface.
--
--
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.slow_defines.all;
use work.type_defines.all;

library unisim;
use unisim.vcomponents.all;

entity leds_ctrl is
generic (
    AW              : natural := 10;
    DW              : natural := 32
);
port (
    -- 50MHz system clock
    clk_i           : in  std_logic;
    reset_i         : in  std_logic;
    -- Serial Receive Interface
    rx_addr_i       : in  std_logic_vector(AW-1 downto 0);
    rx_valid_i      : in  std_logic;
    rx_data_i       : in  std_logic_vector(DW-1 downto 0);
    -- Encoder Daughter Card Control interface
    ttl_leds_o      : out std_logic_vector(15 downto 0);
    status_leds_o   : out std_logic_vector(3 downto 0)
);
end leds_ctrl;

architecture rtl of leds_ctrl is

signal rx_addr    : natural range 0 to (2**AW - 1);

begin

rx_addr <= to_integer(unsigned(rx_addr_i));

--
-- Receive Register Interface
--
process(clk_i) begin
    if rising_edge(clk_i) then
        if (reset_i = '1') then
            ttl_leds_o <= (others => '0');
            status_leds_o <= (others => '0');
        else
            if (rx_valid_i = '1' and rx_addr = TTL_LEDS) then
                ttl_leds_o <= rx_data_i(15 downto 0);
            end if;

            if (rx_valid_i = '1' and rx_addr = STATUS_LEDS) then
                status_leds_o <= rx_data_i(3 downto 0);
            end if;
        end if;
    end if;
end process;

end rtl;
