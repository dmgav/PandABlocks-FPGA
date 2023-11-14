library ieee;
use ieee.std_logic_1164.all;

entity rs_flipflop is
port(
    -- Clock and Reset
    clk_i : in std_logic;
    -- Inputs
    set_i, reset_i : in std_logic := '0';
    -- Outputs
    q_o, qd_o : out std_logic
);
end rs_flipflop;

architecture rtl of rs_flipflop is

begin

    flip : process(clk_i)
        variable is_initialized: std_logic := '0';
    begin
        if rising_edge(clk_i) then
            if set_i = '1' then
                q_o <= '1';
                qd_o <= '0';
            elsif reset_i = '1' then
                q_o <= '0';
                qd_o <= '1';
            elsif is_initialized = '0' then
                q_o <= '0';
                qd_o <= '1';
            end if;
            is_initialized := '1';
        end if;
    end process;

end rtl;


