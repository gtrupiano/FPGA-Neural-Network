library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
package vga_components is

component clkdiv is
	 port(
		 mclk : in STD_LOGIC;
		 clr : in STD_LOGIC;
		 clk25 : out STD_LOGIC
	     );
end component;

component vga_640x480 is
    port ( clk, clr : in std_logic;
           hsync : out std_logic;
           vsync : out std_logic;
           hc : out std_logic_vector(9 downto 0);
           vc : out std_logic_vector(9 downto 0);
           vidon : out std_logic
	);
end component;

component vga_bsprite is
    port ( vidon: in std_logic;
           hc : in std_logic_vector(9 downto 0);
           vc : in std_logic_vector(9 downto 0);
           M: in std_logic_vector(11 downto 0);
           sw: in std_logic_vector(7 downto 0);
           rom_addr16: out std_logic_vector(15 downto 0);
           red : out std_logic_vector(3 downto 0);
           green : out std_logic_vector(3 downto 0);
           blue : out std_logic_vector(3 downto 0)
	);
end component;

--component rom_140x140 IS
--  PORT (
--    clka : IN STD_LOGIC;
--    addra : IN STD_LOGIC_VECTOR(14 DOWNTO 0);
--    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
--  );
--END component;

--component blk_mem_gen_0 IS
--  PORT (
--    clka : IN STD_LOGIC;
--    addra : IN STD_LOGIC_VECTOR(14 DOWNTO 0);
--    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
--  );
--END component;

component blk_mem_gen_0 IS
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END component;

component DPRam is
     PORT (
    a : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    d : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
    dpra : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    clk : IN STD_LOGIC;
    we : IN STD_LOGIC;
    spo : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
    dpo : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
  );
end component;



end package;
