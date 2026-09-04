library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.components.all;

entity out_layer_forward_pass_neuron_tb is
end out_layer_forward_pass_neuron_tb;

architecture Behavioral of out_layer_forward_pass_neuron_tb is

signal w1, w2, w3, w4, w5, w6, a1, a2, a3, a4, a5, a6, aout : std_logic_vector(31 downto 0);
signal a_prime : std_logic;

begin

test : Output_Layer_Forward_Pass_Neuron port map
(
    W1 => w1,
    W2 => w2,
    W3 => w3,
    W4 => w4,
    W5 => w5,
    W6 => w6,
    a1 => a1,
    a2 => a2,
    a3 => a3,
    a4 => a4,
    a5 => a5,
    a6 => a6,
    aout => aout,
    a_prime => a_prime
);

tb : process 
begin
    w1 <= "00000000011011100001010001111010"; --0.43
    w2 <= "00000000101111010111000010100011"; --0.74
    w3 <= "00000000010010100011110101110000"; --0.29
    w4 <= "00000000100000101000111101011100"; --0.51
    w5 <= "00000000100101110000101000111101"; --0.59
    w6 <= "00000000110011001100110011001100"; --0.80
    a1 <= "00000000101000010100011110101110"; --0.63
    a2 <= "00000000000000101000111101011100"; --0.01
    a3 <= "00000000111111010111000010100011"; --0.99
    a4 <= "00000000001110101110000101000111"; --0.23
    a5 <= "00000000100011001100110011001100"; --0.55
    a6 <= "00000000000111101011100001010001"; --0.12
    wait; --hand calculated output: 1.1032
end process;

end Behavioral;
