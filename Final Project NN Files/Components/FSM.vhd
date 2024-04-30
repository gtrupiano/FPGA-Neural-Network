library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity NNControl is
    Port ( clk : in STD_LOGIC;
           clr : in STD_LOGIC;
           hsync : in STD_LOGIC;
           vsync : in STD_LOGIC;
           ram_we : out STD_LOGIC;
           load_inputs : out STD_LOGIC;
           x : inout STD_LOGIC_VECTOR(15 downto 0);
           y : inout STD_LOGIC_VECTOR(15 downto 0);
           rom_addr16 : out STD_LOGIC_VECTOR (15 downto 0);
           sel_init : out STD_LOGIC;
           aLoad : out STD_LOGIC;
           load_hidden : out STD_LOGIC;
           load_hidden_activation : out STD_LOGIC;
           load_output_activation : out STD_LOGIC;
           load_rgb : out STD_LOGIC;
           load_output : out STD_LOGIC);
end NNControl;

architecture Behavioral of NNControl is

type state is (Initialize, WaitState, ForwardPass1, ForwardPass2, DoneForwardPass, BackPass1, BackPass2, Done, checkY);
signal s: state;

signal xsig, ysig: STD_LOGIC_VECTOR(15 downto 0);

begin

Trans: process (clr, clk, hsync, vsync, x, y)
	begin
		if clr = '1' then
			s <= Initialize;
		elsif (clk'event and clk = '1') then
			case s is
				when Initialize =>
					s <= WaitState;
				when WaitState =>
					if hsync = '0' and vsync = '0' then 
					   s <= ForwardPass1;
					else
					   s <= WaitState;
					end if;
				when ForwardPass1 =>
					s <= ForwardPass2;					
				when ForwardPass2 =>
					s <= DoneForwardPass;					
				when DoneForwardPass =>
					s <= BackPass1;					
				when BackPass1 =>
					s <= BackPass2;					
				when BackPass2 =>
					s <= Done;					
				when Done =>
					if x < "1010" then
					   s <= ForwardPass1;
					else
					   s <= checkY;
					end if;					
				when checkY =>
					if y < "1010" then 
					   s <= ForwardPass1;
					else 
					   s <= WaitState;
					end if;
			end case;			
		end if;		
	end process;
	
Output: process (y)
	begin
		rom_addr16 <= x"0000"; sel_init <= '0'; load_hidden <= '0'; load_hidden_activation <= '0'; load_output_activation <= '0'; load_rgb <= '0'; load_output <= '0'; 
		case s is
			when Initialize =>
				rom_addr16 <= x"0000"; sel_init <= '1'; load_hidden <= '1'; load_hidden_activation <= '1'; load_output_activation <= '1'; load_rgb <= '1'; load_output <= '1'; load_inputs <= '1'; 
			when WaitState =>
			    rom_addr16 <= x"0000"; x <= x"0000"; y <= x"0000";
			when ForwardPass1 =>
			    load_hidden_activation <= '1';
			when ForwardPass2 =>
			    load_output_activation <= '1';
			when DoneForwardPass =>
			    load_rgb <= '1';
			    aLoad <= '1';
			when BackPass1 =>
			    load_hidden <= '1';
			when BackPass2 =>
			    load_output <= '1';
			when Done =>
			    ram_we <= '1'; load_inputs <= '1';
			when checkY =>
			    if y < "1010" then
			       x <= x"0000";
			    end if;
			when others => 
		end case;
	end process;


end Behavioral;
