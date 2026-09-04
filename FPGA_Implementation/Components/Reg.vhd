library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Reg is
generic (N: integer);
port(
    load : in STD_LOGIC;
    input : in STD_LOGIC_VECTOR(N-1 downto 0);
    clk : in STD_LOGIC;
    clr : in STD_LOGIC;
    q : out STD_LOGIC_VECTOR(N-1 downto 0)
    );
end Reg;

architecture Behavioral of Reg is
signal qhold: STD_LOGIC_VECTOR(N-1 downto 0);

begin
process(clk,clr)
begin
    if clr = '1' then
        qhold <= (others => '0');
    elsif clk'event and clk = '1' then
        if load = '1' then
            qhold <= input;
        end if;
    end if;       
end process;

q <= qhold;

end Behavioral;