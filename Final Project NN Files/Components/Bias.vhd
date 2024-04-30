library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
use work.components.all;


entity Bias is
  Port (initialize_Bij: in std_logic_vector(31 downto 0);
        sel_init: in std_logic;
        load_Bij: in std_logic;
        clr: in std_logic;
        clk: in std_logic;
        sensitivity: in std_logic_vector(31 downto 0);
        learning_Rate: in std_logic_vector(31 downto 0);
        Bij: out std_logic_vector(31 downto 0)
        );
end Bias;

architecture Behavioral of Bias is

signal muxOut: std_logic_vector(31 downto 0);
signal new_Bij: std_logic_vector(31 downto 0);
signal Bias_ij: std_logic_vector(31 downto 0);
signal multOut: std_logic_vector(63 downto 0);


begin

initialization_max: Mux2to1 generic map(N => 32) port map(a => new_Bij(31 downto 0), b => initialize_Bij, s => sel_init, y => muxOut);
bias_register: Reg generic map(N => 32) port map(load => Load_Bij, input => muxOut, clk => clk, clr => clr, q => Bias_ij);

multOut <= sensitivity * learning_Rate;

new_Bij <= multOut(55 downto 24) - Bias_ij;


Bij <= new_Bij;

end Behavioral;