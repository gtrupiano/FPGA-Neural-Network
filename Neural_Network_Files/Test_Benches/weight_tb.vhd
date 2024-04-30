library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.components.all;

entity weight_tb is
end weight_tb;

architecture Behavioral of weight_tb is

signal init_Wij, sens, act_L1, learn_rate, Wij : std_logic_vector(31 downto 0);
signal sel_init, load_Wij, clk, clr : std_logic;

begin

test : weight port map
(
    initialize_Wij => init_Wij,
    sel_init => sel_init,
    load_Wij => load_Wij,
    clr => clr,
    clk => clk,
    sensitivity => sens,
    activation_L1 => act_L1,
    learning_Rate => learn_rate,
    Wij => Wij
);

clock : process
begin
    clk <= '1'; wait for 5 ns;
    clk <= '0'; wait for 5 ns;
end process;

tb : process --0.23, 0.75, 0.54, 0.33
begin
    clr <= '1'; sel_init <= '1'; load_Wij <= '1'; wait for 10 ns;
    clr <= '0'; 
    init_Wij <= "00000000001110101110000101000111"; --signed fixed point, 8 bits int, 24 bits fraction
    sens <= "00000000110000000000000000000000"; 
    act_L1 <= "00000000100010100011110101110000";
    learn_rate <= "00000000010101000111101011100001"; wait for 10 ns;
    sel_init <= '0'; wait for 40 ns; --hand calculated output: -0.09635
end process;

end Behavioral;
