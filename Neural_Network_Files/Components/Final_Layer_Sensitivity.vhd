library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_signed.ALL;


entity Final_Layer_Sensitivity is
  Port (perdicted_value: in STD_LOGIC_VECTOR(31 downto 0);
        target_value: in STD_LOGIC_VECTOR(31 downto 0);
        sensitivityL: out STD_LOGIC_VECTOR(31 downto 0)
        );
end Final_Layer_Sensitivity;

architecture Behavioral of Final_Layer_Sensitivity is

begin

sensitivityL <= (perdicted_value - target_value) + (perdicted_value - target_value);

end Behavioral;