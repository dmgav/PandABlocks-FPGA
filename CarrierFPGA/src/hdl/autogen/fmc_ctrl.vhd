--------------------------------------------------------------------------------
--  File:       fmc_ctrl.vhd
--  Desc:       Autogenerated block control module.
--
--  Author:     Isa Uzun - Diamond Light Source
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.addr_defines.all;
use work.top_defines.all;

entity fmc_ctrl is
port (
    -- Clock and Reset
    clk_i               : in std_logic;
    reset_i             : in std_logic;
    sysbus_i            : in sysbus_t;
    posbus_i            : in posbus_t;
    -- Block Parameters
    FMC_PRSNT       : in  std_logic_vector(31 downto 0);
    LINK_UP       : in  std_logic_vector(31 downto 0);
    ERROR_COUNT       : in  std_logic_vector(31 downto 0);
    LA_P_ERROR       : in  std_logic_vector(31 downto 0);
    LA_N_ERROR       : in  std_logic_vector(31 downto 0);
    GTREFCLK       : in  std_logic_vector(31 downto 0);
    FMC_CLK0       : in  std_logic_vector(31 downto 0);
    FMC_CLK1       : in  std_logic_vector(31 downto 0);
    SOFT_RESET       : out std_logic_vector(31 downto 0);
    SOFT_RESET_WSTB  : out std_logic;
    EXT_CLK       : in  std_logic_vector(31 downto 0);
    -- Memory Bus Interface
    mem_cs_i            : in  std_logic;
    mem_wstb_i          : in  std_logic;
    mem_addr_i          : in  std_logic_vector(BLK_AW-1 downto 0);
    mem_dat_i           : in  std_logic_vector(31 downto 0);
    mem_dat_o           : out std_logic_vector(31 downto 0)
);
end fmc_ctrl;

architecture rtl of fmc_ctrl is

signal mem_addr : natural range 0 to (2**mem_addr_i'length - 1);


begin

mem_addr <= to_integer(unsigned(mem_addr_i));

--
-- Control System Interface
--
REG_WRITE : process(clk_i)
begin
    if rising_edge(clk_i) then
        if (reset_i = '1') then
            SOFT_RESET <= (others => '0');
            SOFT_RESET_WSTB <= '0';
        else
            SOFT_RESET_WSTB <= '0';

            if (mem_cs_i = '1' and mem_wstb_i = '1') then
                -- Input Select Control Registers
                if (mem_addr = FMC_SOFT_RESET) then
                    SOFT_RESET <= mem_dat_i;
                    SOFT_RESET_WSTB <= '1';
                end if;

            end if;
        end if;
    end if;
end process;

--
-- Status Register Read
--
REG_READ : process(clk_i)
begin
    if rising_edge(clk_i) then
        if (reset_i = '1') then
            mem_dat_o <= (others => '0');
        else
            case (mem_addr) is
                when FMC_FMC_PRSNT =>
                    mem_dat_o <= FMC_PRSNT;
                when FMC_LINK_UP =>
                    mem_dat_o <= LINK_UP;
                when FMC_ERROR_COUNT =>
                    mem_dat_o <= ERROR_COUNT;
                when FMC_LA_P_ERROR =>
                    mem_dat_o <= LA_P_ERROR;
                when FMC_LA_N_ERROR =>
                    mem_dat_o <= LA_N_ERROR;
                when FMC_GTREFCLK =>
                    mem_dat_o <= GTREFCLK;
                when FMC_FMC_CLK0 =>
                    mem_dat_o <= FMC_CLK0;
                when FMC_FMC_CLK1 =>
                    mem_dat_o <= FMC_CLK1;
                when FMC_EXT_CLK =>
                    mem_dat_o <= EXT_CLK;
                when others =>
                    mem_dat_o <= (others => '0');
            end case;
        end if;
    end if;
end process;

--
-- Instantiate Delay Blocks for System and Position Bus Fields
--



end rtl;