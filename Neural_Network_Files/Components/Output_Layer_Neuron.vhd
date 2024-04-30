library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
use work.components.all;

entity Output_Layer_Neuron is
    Port (-- Forward Propagation
          activation_21, activation_22, activation_23, activation_24, activation_25, activation_26: in std_logic_vector(31 downto 0);
          initialize_W21,initialize_W22, initialize_W23, initialize_W24, initialize_W25, initialize_W26: in std_logic_vector(31 downto 0);
          load_Wij: in STD_LOGIC;
          sel_init: in STD_LOGIC;
          clk,clr: in STD_LOGIC;
          aLoad: in STD_LOGIC;
          learning_Rate: in std_logic_vector(31 downto 0);
          
          --Back Propagation
          targetR: in STD_LOGIC_VECTOR(31 downto 0); -- From picture
          
          --Outputs for Final Layer Neuron
          predictedR: out STD_LOGIC_VECTOR(31 downto 0) -- aout
          );
end Output_Layer_Neuron;


architecture Behavioral of Output_Layer_Neuron is

signal W21,W22,W23,W24,W25,W26:std_logic_vector(31 downto 0);
signal sensitivity: std_logic_vector(31 downto 0);-- coming from sensitivityL final layer sens block

--FPassNeuron
signal W1,W2,W3,W4,W5,W6: std_logic_vector(31 downto 0);
signal a1,a2,a3,a4,a5,a6,aout: std_logic_vector(31 downto 0);
signal a_prime: std_logic;

--BPassNeuron
signal activationPrev: std_logic_vector(31 downto 0);
signal prevLlayerSens: std_logic_vector(31 downto 0);

--aReg
signal aRegOut: std_logic_vector(31 downto 0);

--BiasReg
signal load_Bij: std_logic;
signal initialize_Bij: std_logic_vector(31 downto 0); -- may need to be an input to neuron
signal Bij: std_logic_vector(31 downto 0);

begin

    W1Blk: weight port map(initialize_Wij => initialize_W21, sensitivity => sensitivity, activation_L1 => activation_21,
                           learning_Rate => learning_Rate, Wij => W21, sel_init => sel_init, load_Wij => load_Wij, clr => clr, clk => clk
                           );
                           
    W2Blk: weight port map(initialize_Wij => initialize_W22, sensitivity => sensitivity, activation_L1 => activation_22,
                           learning_Rate => learning_Rate, Wij => W22, sel_init => sel_init, load_Wij => load_Wij, clr => clr, clk => clk
                           );
    
    W3Blk: weight port map(initialize_Wij => initialize_W23, sensitivity => sensitivity, activation_L1 => activation_23,
                           learning_Rate => learning_Rate, Wij => W23, sel_init => sel_init, load_Wij => load_Wij, clr => clr, clk => clk
                           );
                           
    W4Blk: weight port map(initialize_Wij => initialize_W24, sensitivity => sensitivity, activation_L1 => activation_24,
                           learning_Rate => learning_Rate, Wij => W24, sel_init => sel_init, load_Wij => load_Wij, clr => clr, clk => clk
                           );  
                           
    W5Blk: weight port map(initialize_Wij => initialize_W25, sensitivity => sensitivity, activation_L1 => activation_25,
                           learning_Rate => learning_Rate, Wij => W25, sel_init => sel_init, load_Wij => load_Wij, clr => clr, clk => clk
                           );     
    
    W6Blk: weight port map(initialize_Wij => initialize_W26, sensitivity => sensitivity, activation_L1 => activation_26,
                           learning_Rate => learning_Rate, Wij => W26, sel_init => sel_init, load_Wij => load_Wij, clr => clr, clk => clk
                           );
                           
    OutLayerFPassNeuron: Output_Layer_Forward_Pass_Neuron port map(W1 => W1, W2 => W2, W3 => W3, W4 => W4, W5 => W5, W6 => W6,
                                                                   a1 => a1, a2 => a2, a3 => a3, a4 => a4, a5 => a5, a6 => a6,
                                                                   aout => aout, a_Prime => a_Prime
                                                                   );                                                    
    
    aReg: Reg generic map(N => 32) port map(load => aLoad, input => aout, clk => clk, clr => clr, q => aRegOut);
    
    FLayerSensBlk: Final_Layer_Sensitivity port map(perdicted_value => aRegOut, target_value => targetR, sensitivityL => sensitivity);
    
    BiasReg: Bias port map(initialize_Bij => X"00000000", sel_init => sel_init, load_Bij => load_Bij, clk => clk, clr => clr,
                           sensitivity => sensitivity, learning_Rate => learning_Rate, Bij => Bij
                           );
    
    predictedR <= aRegOut;

end Behavioral;
