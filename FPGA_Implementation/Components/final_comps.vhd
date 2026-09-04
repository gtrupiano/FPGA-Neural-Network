library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package components is

    component vga_bsprite is
        port ( vidon: in std_logic;
               hc : in std_logic_vector(9 downto 0);
               vc : in std_logic_vector(9 downto 0);
               M: in std_logic_vector(7 downto 0);
               sw: in std_logic_vector(7 downto 0);
               rom_addr16: out std_logic_vector(15 downto 0);
               red : out std_logic_vector(2 downto 0);
               x,y: out std_logic_vector(9 downto 0);
               spriteon: out std_logic;
               green : out std_logic_vector(2 downto 0);
               blue : out std_logic_vector(1 downto 0)
        );
    end component;
    
    component Final_Layer_Sensitivity is
        Port (perdicted_value: in STD_LOGIC_VECTOR(31 downto 0);
             target_value: in STD_LOGIC_VECTOR(31 downto 0);
             sensitivityL: out STD_LOGIC_VECTOR(31 downto 0)
            );
    end component;
    
    component vga_bsprite_top is
         port(
            mclk : in STD_LOGIC;
            btn : in STD_LOGIC_VECTOR(3 downto 0);
            sw : in STD_LOGIC_VECTOR(7 downto 0);
            a : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
            d : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
            we : IN STD_LOGIC;
            spo : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
            hsync : out STD_LOGIC;
            vsync : out STD_LOGIC;
            red : out std_logic_vector(3 downto 0);
            green : out std_logic_vector(3 downto 0);
            blue : out std_logic_vector(3 downto 0);
            clk25OUT: out STD_LOGIC
             );
    end component;
    
    component Bias is
      Port (initialize_Bij: in std_logic_vector(31 downto 0);
            sel_init: in std_logic;
            load_Bij: in std_logic;
            clr: in std_logic;
            clk: in std_logic;
            sensitivity: in std_logic_vector(31 downto 0);
            learning_Rate: in std_logic_vector(31 downto 0);
            Bij: out std_logic_vector(31 downto 0)
            );
    end component;
    
    
    component clkdiv is
         port(
             mclk : in STD_LOGIC;
             clr : in STD_LOGIC;
             clk190 : out STD_LOGIC
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
    
    component Output_Layer_Neuron is
    Port (-- Forward Propagation
          activation_21, activation_22, activation_23, activation_24, activation_25, activation_26: in std_logic_vector(31 downto 0);
          initialize_W21,initialize_W22, initialize_W23, initialize_W24, initialize_W25, initialize_W26: in std_logic_vector(31 downto 0);
          load_Wij: in STD_LOGIC;
          sel_init,aLoad: in STD_LOGIC;
          clk,clr: in STD_LOGIC;
          learning_Rate: in std_logic_vector(31 downto 0);
          
          --Back Propagation
          targetR: in STD_LOGIC_VECTOR(31 downto 0); -- From picture
          
          --Outputs for Final Layer Neuron
          predictedR: out STD_LOGIC_VECTOR(31 downto 0) -- aout
          );
    end component;
        
    component Reg is
    generic (N: integer);
    port(
        load : in STD_LOGIC;
        input : in STD_LOGIC_VECTOR(N-1 downto 0);
        clk : in STD_LOGIC;
        clr : in STD_LOGIC;
        q : out STD_LOGIC_VECTOR(N-1 downto 0)
        );
    end component;
    
    component Mux2to1 is
        generic (N:integer);
        port (
            a: in STD_LOGIC_VECTOR(N-1 downto 0);
            b: in STD_LOGIC_VECTOR(N-1 downto 0);
            s: in STD_LOGIC;
            y: out STD_LOGIC_VECTOR(N-1 downto 0)
        );
    end component;
    
    component ReLu is
        Port (sum: in std_logic_vector(31 downto 0);
              a: out std_logic_vector(31 downto 0);
              a_Prime: out std_logic
              );
    end component;
    
    component weight is
      Port (initialize_Wij: in std_logic_vector(31 downto 0);
            sel_init: in std_logic;
            load_Wij: in std_logic;
            clr: in std_logic;
            clk: in std_logic;
            sensitivity: in std_logic_vector(31 downto 0);
            activation_L1: in std_logic_vector(31 downto 0);
            learning_Rate: in std_logic_vector(31 downto 0);
            Wij: out std_logic_vector(31 downto 0)
            );
    end component;
    
    component Forward_Pass_Neuron_Hidden is
    Port (W1,W2,W3,W4,W5,W6,W7,W8: in std_logic_vector(31 downto 0);
          a1,a2,a3,a4,a5,a6,a7,a8: in std_logic_vector(31 downto 0);
          aout: out std_logic_vector(31 downto 0);
          a_Prime: out std_logic
          );
    end component;
    
    component Back_Propagation_Neuron_Hidden is
    Port (nextW1,nextW2,nextW3: in std_logic_vector(31 downto 0);
          nextSens1,nextSens2,nextSens3: in std_logic_vector(31 downto 0);
          a_prime: in std_logic;
          sensitivity: out std_logic_vector(31 downto 0)
          );
    end component;
    
    component Output_Layer_Forward_Pass_Neuron is
        Port (W1,W2,W3,W4,W5,W6: in std_logic_vector(31 downto 0);
              a1,a2,a3,a4,a5,a6: in std_logic_vector(31 downto 0);
              aout: out std_logic_vector(31 downto 0);
              a_prime: out std_logic
              );
    end component;  
    
    component Hidden_Layer_Neuron is
        Port (-- Forward Propagation
              activation_11, activation_12, activation_13, activation_14, activation_15, activation_16, activation_17, activation_18: in std_logic_vector(31 downto 0);
              initialize_W11,initialize_W12, initialize_W13, initialize_W14, initialize_W15, initialize_W16, initialize_W17, initialize_W18: in std_logic_vector(31 downto 0);
              load_Wij: in STD_LOGIC;
              sel_init: in STD_LOGIC;
              clr,clk: in std_logic;
              
              --Back Propagation
              nextW1,nextW2,nextW3: in std_logic_vector(31 downto 0);
              nextSens1,nextSens2,nextSens3: in std_logic_vector(31 downto 0);
              learning_Rate: in std_logic_vector(31 downto 0);
    
              
              --Outputs from hidden layer neuron
              aLoad: in std_logic;
              sensitivity_out: out std_logic_vector(31 downto 0);
              activation_out: out std_logic_vector(31 downto 0)
              ); 
    end component;        
    
    component NNControl is
    PORT ( clk : in STD_LOGIC;
           clr : in STD_LOGIC;
           hsync : in STD_LOGIC;
           vsync : in STD_LOGIC;
           ram_we : out STD_LOGIC;
           load_inputs : out STD_LOGIC;
           x : inout STD_LOGIC_VECTOR(15 downto 0);
           y : inout STD_LOGIC_VECTOR(15 downto 0);
           rom_addr16I: in std_logic_vector(15 downto 0);
           rom_addr16O : out STD_LOGIC_VECTOR (15 downto 0);
           sel_init : out STD_LOGIC;
           aLoad : out STD_LOGIC;
           load_hidden : out STD_LOGIC;
           load_hidden_activation : out STD_LOGIC;
           load_output_activation : out STD_LOGIC;
           load_rgb : out STD_LOGIC;
           load_output : out STD_LOGIC);
end component;
end components;