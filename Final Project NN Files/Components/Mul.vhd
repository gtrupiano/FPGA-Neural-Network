library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Mul is
    Port ( a : in std_logic_vector (15 downto 0);
           b : in std_logic_vector (15 downto 0);
           y : out std_logic_vector (15 downto 0)
          );
end Mul;

architecture Behavioral of Mul is
signal ysig: std_logic_vector (31 downto 0);
begin

ysig <= a * b;
y <= ysig(15 downto 0);

end Behavioral;
