LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

library work;
use work.test_interface.all;
use work.type_defines.all;

entity panda_top_tb is
    port (
        ttlin_pad       : in std_logic_vector(5 downto 0)
    );
end panda_top_tb;

ARCHITECTURE behavior OF panda_top_tb IS

--Inputs
signal enc0_ctrl_pad_i : std_logic_vector(3 downto 0) := (others => '0');

--BiDirs
signal DDR_addr         : std_logic_vector(14 downto 0);
signal DDR_ba           : std_logic_vector(2 downto 0);
signal DDR_cas_n        : std_logic;
signal DDR_ck_n         : std_logic;
signal DDR_ck_p         : std_logic;
signal DDR_cke          : std_logic;
signal DDR_cs_n         : std_logic;
signal DDR_dm           : std_logic_vector(3 downto 0);
signal DDR_dq           : std_logic_vector(31 downto 0);
signal DDR_dqs_n        : std_logic_vector(3 downto 0);
signal DDR_dqs_p        : std_logic_vector(3 downto 0);
signal DDR_odt          : std_logic;
signal DDR_ras_n        : std_logic;
signal DDR_reset_n      : std_logic;
signal DDR_we_n         : std_logic;
signal FIXED_IO_ddr_vrn : std_logic;
signal FIXED_IO_ddr_vrp : std_logic;
signal FIXED_IO_mio     : std_logic_vector(53 downto 0);
signal FIXED_IO_ps_clk  : std_logic;
signal FIXED_IO_ps_porb : std_logic;
signal FIXED_IO_ps_srstb: std_logic;
signal Am0_pad_io       : std_logic_vector(3 downto 0);
signal Bm0_pad_io       : std_logic_vector(3 downto 0);
signal Zm0_pad_io       : std_logic_vector(3 downto 0);
signal As0_pad_io       : std_logic_vector(3 downto 0);
signal Bs0_pad_io       : std_logic_vector(3 downto 0);
signal Zs0_pad_io       : std_logic_vector(3 downto 0);

--Outputs
signal enc0_ctrl_pad_o  : std_logic_vector(11 downto 0);
signal leds             : std_logic_vector(1 downto 0);
signal clk              : std_logic := '1';
signal clk50            : std_logic := '1';
signal reset            : std_logic := '1';

signal A_IN_P           : std_logic_vector(3 downto 0);
signal B_IN_P           : std_logic_vector(3 downto 0);
signal Z_IN_P           : std_logic_vector(3 downto 0);
signal CLK_OUT_P        : std_logic_vector(3 downto 0);
signal DATA_IN_P        : std_logic_vector(3 downto 0);

signal A_OUT_P          : std_logic_vector(3 downto 0);
signal B_OUT_P          : std_logic_vector(3 downto 0);
signal Z_OUT_P          : std_logic_vector(3 downto 0);
signal CLK_IN_P         : std_logic_vector(3 downto 0);
signal DATA_OUT_P       : std_logic_vector(3 downto 0);

signal inputs           : unsigned(15 downto 0) := X"0000";

signal lvdsin_pad       : std_logic_vector(1 downto 0);

signal enc_ctrl1_io     : std_logic_vector(15 downto 0);
signal enc_ctrl2_io     : std_logic_vector(15 downto 0);
signal enc_ctrl3_io     : std_logic_vector(15 downto 0);
signal enc_ctrl4_io     : std_logic_vector(15 downto 0);

signal spi_sclk_i       : std_logic;
signal spi_dat_i        : std_logic;
signal spi_sclk_o       : std_logic;
signal spi_dat_o        : std_logic;
signal ssi_data         : natural;
signal ssi_slave_data   : std_logic_vector(31 downto 0);
signal ssi_master_data  : std_logic_vector(31 downto 0);

signal shift_reg_sdata_o: std_logic;
signal shift_reg_sclk_o : std_logic;
signal shift_reg_latch_o: std_logic;
signal shift_reg_oe_n_o : std_logic;

signal shift_reg        : std_logic_vector(31 downto 0);
signal led_x            : std_logic_vector(0 to 15);
signal term_x           : std_logic_vector(0 to  5);
signal led_status_x     : std_logic_vector(0 to  3);


constant BLOCK_SIZE     : integer := 8192;

begin

-- System Clock
clk <= not clk after 4 ns;
clk50 <= not clk50 after 10 ns;
reset <= '0' after 100 ns;
--
-- TTL/LVDS IO
--
process(clk)
begin
    if rising_edge(clk) then
        inputs <= inputs + 1;
    end if;
end process;

lvdsin_pad <= std_logic_vector(inputs(15 downto 14));

-- Instantiate the Unit Under Test (UUT)
uut: entity work.panda_top
PORT MAP (
    DDR_addr            => DDR_addr,
    DDR_ba              => DDR_ba,
    DDR_cas_n           => DDR_cas_n,
    DDR_ck_n            => DDR_ck_n,
    DDR_ck_p            => DDR_ck_p,
    DDR_cke             => DDR_cke,
    DDR_cs_n            => DDR_cs_n,
    DDR_dm              => DDR_dm,
    DDR_dq              => DDR_dq,
    DDR_dqs_n           => DDR_dqs_n,
    DDR_dqs_p           => DDR_dqs_p,
    DDR_odt             => DDR_odt,
    DDR_ras_n           => DDR_ras_n,
    DDR_reset_n         => DDR_reset_n,
    DDR_we_n            => DDR_we_n,
    FIXED_IO_ddr_vrn    => FIXED_IO_ddr_vrn,
    FIXED_IO_ddr_vrp    => FIXED_IO_ddr_vrp,
    FIXED_IO_mio        => FIXED_IO_mio,
    FIXED_IO_ps_clk     => FIXED_IO_ps_clk,
    FIXED_IO_ps_porb    => FIXED_IO_ps_porb,
    FIXED_IO_ps_srstb   => FIXED_IO_ps_srstb,
    Am0_pad_io          => Am0_pad_io,
    Bm0_pad_io          => Bm0_pad_io,
    Zm0_pad_io          => Zm0_pad_io,
    As0_pad_io          => As0_pad_io,
    Bs0_pad_io          => Bs0_pad_io,
    Zs0_pad_io          => Zs0_pad_io,
    ttlin_pad_i         => ttlin_pad,
    lvdsin_pad_i        => lvdsin_pad,
    ttlout_pad_o        => open,
    lvdsout_pad_o       => open,

    spi_sclk_i          => spi_sclk_i,
    spi_dat_i           => spi_dat_i,
    spi_dat_o           => spi_dat_o,
    spi_sclk_o          => spi_sclk_o,

    enc0_ctrl_pad_i     => enc0_ctrl_pad_i,
    enc0_ctrl_pad_o     => open
);


slow_top_inst : entity work.slow_top
port map (
    clk50_i             => clk50,
    -- Encoder Daughter Card Control Interface
    enc_ctrl1_io        => enc_ctrl1_io,
    enc_ctrl2_io        => enc_ctrl2_io,
    enc_ctrl3_io        => enc_ctrl3_io,
    enc_ctrl4_io        => enc_ctrl4_io,
    -- Serial Physical Interface
    spi_sclk_i          => spi_sclk_o,
    spi_dat_i           => spi_dat_o,
    spi_dat_o           => spi_dat_i,
    spi_sclk_o          => spi_sclk_i,
    -- Front Panel Interface
    shift_reg_sdata_o   => shift_reg_sdata_o,
    shift_reg_sclk_o    => shift_reg_sclk_o,
    shift_reg_latch_o   => shift_reg_latch_o,
    shift_reg_oe_n_o    => shift_reg_oe_n_o
);


--
-- Front Panel Shift Registers = 4x SN74HC595
--

process(shift_reg_sclk_o)
begin
    if rising_edge(shift_reg_sclk_o) then
        shift_reg <= shift_reg_sdata_o & shift_reg(31 downto 1);
    end if;
end process;

process(shift_reg_latch_o)
begin
    if rising_edge(shift_reg_latch_o) then
        led_x <= shift_reg(31 downto 16);
        term_x <= shift_reg(15 downto 10);
        led_status_x <= shift_reg(7 downto 4);
    end if;
end process;

enc_ctrl1_io(15 downto 12) <= "1000";
enc_ctrl2_io(15 downto 12) <= "1000";
enc_ctrl3_io(15 downto 12) <= "1000";
enc_ctrl4_io(15 downto 12) <= "1000";

--
-- There are 4x Daughter Cards on the system
--
DCARD : FOR I IN 0 TO 3 GENERATE

    daughter_card : entity work.daughter_card_model
    port map (
        -- panda_top interface.
        A_IN        => Am0_pad_io(I),
        B_IN        => Bm0_pad_io(I),
        Z_IN        => Zm0_pad_io(I),
        A_OUT       => As0_pad_io(I),
        B_OUT       => Bs0_pad_io(I),
        Z_OUT       => Zs0_pad_io(I),

        -- Front Panel via DB15
        A_IN_P      => A_IN_P(I),
        B_IN_P      => B_IN_P(I),
        Z_IN_P      => Z_IN_P(I),
        CLK_OUT_P   => CLK_OUT_P(I),
        DATA_IN_P   => DATA_IN_P(I),

        A_OUT_P     => A_OUT_P(I),
        B_OUT_P     => B_OUT_P(I),
        Z_OUT_P     => Z_OUT_P(I),
        CLK_IN_P    => CLK_IN_P(I),
        DATA_OUT_P  => DATA_OUT_P(I),

        CTRL_IN     => enc_ctrl1_io(11 downto 0),
        CTRL_OUT    => open --enc0_ctrl_pad_i
    );

END GENERATE;

encoder : entity work.incr_encoder_model
port map (
    CLK         => clk,
    A           => A_IN_P(0),
    B           => B_IN_P(0)
);

--
-- SSI SLAVE -> PANDA -> SSI MASTER
--

process
begin
    ssi_data <= 0;
    PROC_CLK_EAT(1250, clk);

    LOOP
        ssi_data <= ssi_data + 100;
        PROC_CLK_EAT(12500, clk);
    END LOOP;
end process;

ssi_slave_data <= TO_SVECTOR(ssi_data, 32);

SSI_SLAVE : entity work.ssislv
port map (
    clk_i           => clk,
    reset_i         => reset,
    BITS            => TO_SVECTOR(24, 8),
    ssi_sck_i       => CLK_OUT_P(0),
    ssi_dat_o       => DATA_IN_P(0),
    posn_i          => ssi_slave_data
);


SSI_MASTER : entity work.ssimstr
port map (
    clk_i           => clk,
    reset_i         => reset,
    BITS            => TO_SVECTOR(16, 8),
    CLKRATE         => TO_SVECTOR(125, 32),
    FRAMERATE       => TO_SVECTOR(12500, 32),
    ssi_sck_o       => CLK_IN_P(0),
    ssi_dat_i       => DATA_OUT_P(0),
    posn_o          => ssi_master_data,
    posn_valid_o    => open
);

end;
