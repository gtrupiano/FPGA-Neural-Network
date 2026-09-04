library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.components.all;

entity back_prop_neuron_hidden_tb is
end back_prop_neuron_hidden_tb;

architecture Behavioral of back_prop_neuron_hidden_tb is

signal w1, w2, w3, sens1, sens2, sens3, sensitivity : std_logic_vector(31 downto 0);
signal a_prime : std_logic;

begin

test : Back_Propagation_Neuron_Hidden port map
(
    nextW1 => w1,
    nextW2 => w2,
    nextW3 => w3,
    nextSens1 => sens1,
    nextSens2 => sens2,
    nextSens3 => sens3,
    a_prime => a_prime,
    sensitivity=> sensitivity
);

tb : process
begin
    a_prime <= '1';
    w1 <= "00000000101110101110000101000111"; --0.73
    w2 <= "00000000111000010100011110101110"; --0.88
    w3 <= "00000000001111010111000010100011"; --0.24
    sens1 <= "00000000111001100110011001100110"; --0.90
    sens2 <= "00000000100001010001111010111000"; --0.52
    sens3 <= "00000000001010111000010100011110"; --0.17
    wait; --hand calculated output: 1.1554
end process;

end Behavioral;
