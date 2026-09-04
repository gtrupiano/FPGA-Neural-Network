library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
use work.components.all;

entity Forward_Pass_Neuron_Hidden is
    Port (W1,W2,W3,W4,W5,W6,W7,W8: in std_logic_vector(31 downto 0);
          a1,a2,a3,a4,a5,a6,a7,a8: in std_logic_vector(31 downto 0);
          aout: out std_logic_vector(31 downto 0);
          a_prime: out std_logic
          );
end Forward_Pass_Neuron_Hidden;

architecture Behavioral of Forward_Pass_Neuron_Hidden is

signal sum: std_logic_vector(31 downto 0);
signal mul1,mul2,mul3,mul4,mul5,mul6,mul7,mul8: std_logic_vector(63 downto 0);
signal temp: std_logic_vector(63 downto 0);

begin
    
mul1 <= W1 * a1;
mul2 <= W2 * a2;
mul3 <= W3 * a3;
mul4 <= W4 * a4;
mul5 <= W5 * a5;
mul6 <= W6 * a6;
mul7 <= W7 * a7;
mul8 <= W8 * a8;

temp <= mul1 + mul2 + mul3 + mul4 + mul5 + mul6 + mul7 + mul8;

sum <= temp(55 downto 24);

RLU: ReLu port map(sum => sum, a => aout, a_Prime => a_Prime);

end Behavioral;