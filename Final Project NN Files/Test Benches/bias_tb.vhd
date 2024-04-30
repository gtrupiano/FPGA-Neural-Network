library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.components.all;

entity bias_tb is
end bias_tb;

architecture Behavioral of bias_tb is

signal init_Bij, sens, learn_rate, Bij : std_logic_vector(31 downto 0);
signal sel_init, load_Bij, clk, clr : std_logic;

begin

test : Bias port map
(
    initialize_Bij => init_Bij,
    sel_init => sel_init,
    load_Bij => load_Bij,
    clr => clr,
    clk => clk,
    sensitivity => sens,
    learning_Rate => learn_rate,
    Bij => Bij
);

clock : process
begin
    clk <= '1'; wait for 5 ns;
    clk <= '0'; wait for 5 ns;
end process;

tb : process --0.64, 0.95, 0.12
begin
    clr <= '1'; sel_init <= '1'; load_Bij <= '1'; wait for 10 ns;
    clr <= '0'; 
    init_Bij <= "00000000101000111101011100001010"; --signed fixed point, 8 bits int, 24 bits fraction
    sens <= "00000000111100110011001100110011";
    learn_rate <= "00000000000111101011100001010001"; wait for 10 ns;
    sel_init <= '0'; wait for 40 ns; --hand calculated output: -0.526
end process;

end Behavioral;

