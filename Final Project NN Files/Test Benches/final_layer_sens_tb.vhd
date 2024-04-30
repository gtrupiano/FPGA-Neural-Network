library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.components.all;

entity final_layer_sens_tb is
end final_layer_sens_tb;

architecture Behavioral of final_layer_sens_tb is

signal pval, tval, sens : std_logic_vector(31 downto 0);

begin

test : Final_Layer_Sensitivity port map
(
    predicted_value => pval,
    target_value => tval,
    sensitivityL => sens
);

tb : process
begin
    pval <= "00000000100111000010100011110101"; --0.61
    tval <= "00000000010101110000101000111101"; --0.34
    wait; --hand calculated output: 0.54
end process;

end Behavioral;
