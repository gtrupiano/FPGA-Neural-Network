library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
use work.components.all;

entity Hidden_Layer_Neuron is
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
end Hidden_Layer_Neuron;

architecture Behavioral of Hidden_Layer_Neuron is

--W1Blk
signal W11,W12,W13,W14,W15,W16,W17,W18:std_logic_vector(31 downto 0);
signal sensitivity: std_logic_vector(31 downto 0);

--FPassNeruon
signal a_prime: std_logic;
signal aout: std_logic_vector(31 downto 0);

--BPassNeuron
--signal activationPrev: std_logic_vector(31 downto 0);
--signal prevLayerSens: std_logic_vector(31 downto 0);

--aPrimeReg
signal aPrimeRegOut: std_logic;
--signal aPrimeLoad: std_logic;
signal hold: std_logic;

--aReg
signal aRegOut: std_logic_vector(31 downto 0);


--BiasReg
--signal load_Bij: std_logic;
--signal initialize_Bij: std_logic_vector(31 downto 0); -- may need to be an input to neuron
signal Bij: std_logic_vector(31 downto 0);

begin
    sensitivity_out <= sensitivity;
    
    W1Blk: weight port map(initialize_Wij => initialize_W11, sensitivity => sensitivity, activation_L1 => activation_11,
                           learning_Rate => learning_Rate, Wij => W11, sel_init => sel_init, load_Wij => load_Wij, clr => clr, clk => clk
                           );
                           
    W2Blk: weight port map(initialize_Wij => initialize_W12, sensitivity => sensitivity, activation_L1 => activation_12,
                           learning_Rate => learning_Rate, Wij => W12, sel_init => sel_init, load_Wij => load_Wij, clr => clr, clk => clk
                           );
    
    W3Blk: weight port map(initialize_Wij => initialize_W13, sensitivity => sensitivity, activation_L1 => activation_13,
                           learning_Rate => learning_Rate, Wij => W13, sel_init => sel_init, load_Wij => load_Wij, clr => clr, clk => clk
                           );
                           
    W4Blk: weight port map(initialize_Wij => initialize_W14, sensitivity => sensitivity, activation_L1 => activation_14,
                           learning_Rate => learning_Rate, Wij => W14, sel_init => sel_init, load_Wij => load_Wij, clr => clr, clk => clk
                           );  
                           
    W5Blk: weight port map(initialize_Wij => initialize_W15, sensitivity => sensitivity, activation_L1 => activation_15,
                           learning_Rate => learning_Rate, Wij => W15, sel_init => sel_init, load_Wij => load_Wij, clr => clr, clk => clk
                           );     
    
    W6Blk: weight port map(initialize_Wij => initialize_W16, sensitivity => sensitivity, activation_L1 => activation_16,
                           learning_Rate => learning_Rate, Wij => W16, sel_init => sel_init, load_Wij => load_Wij, clr => clr, clk => clk
                           );
    
    W7Blk: weight port map(initialize_Wij => initialize_W17, sensitivity => sensitivity, activation_L1 => activation_17,
                           learning_Rate => learning_Rate, Wij => W17, sel_init => sel_init, load_Wij => load_Wij, clr => clr, clk => clk
                           );
                           
    W8Blk: weight port map(initialize_Wij => initialize_W18, sensitivity => sensitivity, activation_L1 => activation_18,
                           learning_Rate => learning_Rate, Wij => W18, sel_init => sel_init, load_Wij => load_Wij, clr => clr, clk => clk
                           );                       
                                                                  
    FPassNeuron: Forward_Pass_Neuron_Hidden port map( W1 => W11, W2 => W12, W3 => W13, W4 => W14, W5 => W15, W6 => W16, W7 => W17, W8 => W18,
                                                      a1 => activation_11, a2 => activation_12, a3 => activation_13, a4 => activation_14, a5 => activation_15, a6 => activation_16, a7 => activation_17, a8 => activation_18,
                                                      aout => aout, a_Prime => a_Prime
                                                      );                                          
                                                      
    BPassNeuron: Back_Propagation_Neuron_Hidden port map(nextW1 => nextW1, nextW2 => nextW2, nextW3 => nextW3,
                                                         nextSens1 => nextSens1, nextSens2 => nextSens2, nextSens3 => nextSens3,
                                                         a_Prime => a_Prime, sensitivity => sensitivity
                                                         );
    
    aPrimeReg: Reg generic map(N => 2) port map(load => aLoad,input(1) => '0', input(0) => a_Prime, clk => clk, clr => clr, q(1) => hold, q(0) => aPrimeRegOut);
    
    
    aReg: Reg generic map(N => 32) port map(load => aLoad, input => aout, clk => clk, clr => clr, q => aRegOut);
    

    BiasReg: Bias port map(initialize_Bij => (others => '0'), sel_init => sel_init, load_Bij => load_Wij, clk => clk, clr => clr,
                           sensitivity => sensitivity, learning_Rate => learning_Rate, Bij => Bij
                           );

    activation_out <= aRegOut;

end Behavioral;
