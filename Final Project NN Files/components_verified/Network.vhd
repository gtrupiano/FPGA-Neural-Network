library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
use work.components.all;


entity Network is
  Port (x ,y: in STD_LOGIC_VECTOR(31 downto 0);
        target_r, target_g, target_b: in STD_LOGIC_VECTOR(31 downto 0);  
        go: in STD_LOGIC;
        learning_Rate: in std_logic_vector(31 downto 0):= "000000000000000010100111";
        reset: in STD_LOGIC;
        start: in STD_LOGIC;
        clk: in STD_LOGIC;
        clr: in STD_LOGIC;
        r,b,g: out STD_LOGIC_VECTOR(31 downto 0)    
  );
end Network;

architecture Behavioral of Network is

TYPE hidden_layer_init_weights is array (0 to 7) of STD_LOGIC_VECTOR(31 downto 0);--amount of weights
TYPE hidden_layer_neurons is array (0 to 5) of hidden_layer_init_weights; --number of neurons

TYPE hidden_to_last_array_neuron is array (0 to 5) of STD_LOGIC_VECTOR(31 downto 0); --amount of weights
TYPE hidden_to_last_array_layer is array (0 to 2) of hidden_to_last_array_neuron; --number of neurons

TYPE hidden_to_last_array_activation_neuron is array (0 to 5) of STD_LOGIC_VECTOR(31 downto 0);

TYPE predicted_color_array is array (0 to 2) of  STD_LOGIC_VECTOR(31 downto 0);

SIGNAL predicted_color: predicted_color_array;
SIGNAL target_color: predicted_color_array;

SIGNAL init_hidden_weights : hidden_layer_neurons;

SIGNAL last_layer_weight : hidden_to_last_array_layer;
SIGNAL last_layer_sensitivity : hidden_to_last_array_layer;

SIGNAL hidden_layer_activations: hidden_to_last_array_activation_neuron;

SIGNAL load_Wij,aLoadSig: STD_LOGIC;

SIGNAL sel_init: STD_LOGIC;
SIGNAL load_inputs: STD_LOGIC;
SIGNAL load_hidden: STD_LOGIC;

SIGNAL x_normal: STD_LOGIC_VECTOR(31 downto 0);
SIGNAL y_normal: STD_LOGIC_VECTOR(31 downto 0);

SIGNAL x_normal_reg: STD_LOGIC_VECTOR(31 downto 0);
SIGNAL y_normal_reg: STD_LOGIC_VECTOR(31 downto 0);

SIGNAL predicted_r: STD_LOGIC_VECTOR(31 downto 0);
SIGNAL predicted_b: STD_LOGIC_VECTOR(31 downto 0);
SIGNAL predicted_g: STD_LOGIC_VECTOR(31 downto 0);

SIGNAL predicted_r_reg: STD_LOGIC_VECTOR(31 downto 0);
SIGNAL predicted_b_reg: STD_LOGIC_VECTOR(31 downto 0);
SIGNAL predicted_g_reg: STD_LOGIC_VECTOR(31 downto 0);

SIGNAL predicted_r2_reg: STD_LOGIC_VECTOR(31 downto 0);
SIGNAL predicted_b2_reg: STD_LOGIC_VECTOR(31 downto 0);
SIGNAL predicted_g2_reg: STD_LOGIC_VECTOR(31 downto 0);


begin
    target_color(0) <= target_r; target_color(1) <= target_g; target_color(2) <= target_b;
    
    init_hidden_weights(0)(0) <= X"00003832"; init_hidden_weights(0)(1) <= X"00001734"; init_hidden_weights(0)(2) <= X"00009584"; init_hidden_weights(0)(3) <= X"00006594";
    init_hidden_weights(0)(4) <= X"00006729"; init_hidden_weights(0)(5) <= X"00001102"; init_hidden_weights(0)(6) <= X"00004932"; init_hidden_weights(0)(7) <= X"00009173";

    
    
--NORMILAZATION INPUTS
--Values will be store prenormalized in ram

-- INPUT LAYER
register_last_r: Reg generic map (N => 32) port map ( load => load_inputs, input => predicted_color(0), clk => clk, clr => clr, q => predicted_r_reg);
register_last_g: Reg generic map (N => 32) port map ( load => load_inputs, input => predicted_color(1), clk => clk, clr => clr, q => predicted_g_reg);
register_last_b: Reg generic map (N => 32) port map ( load => load_inputs, input => predicted_color(2), clk => clk, clr => clr, q => predicted_b_reg);

register_last_r2: Reg generic map (N => 32) port map ( load => load_inputs, input => predicted_r_reg, clk => clk, clr => clr, q => predicted_r2_reg);
register_last_g2: Reg generic map (N => 32) port map ( load => load_inputs, input => predicted_g_reg, clk => clk, clr => clr, q => predicted_g2_reg);
register_last_b2: Reg generic map (N => 32) port map ( load => load_inputs, input => predicted_b_reg, clk => clk, clr => clr, q => predicted_b2_reg);

register_x: Reg generic map (N => 32) port map ( load => load_inputs, input => x, clk => clk, clr => clr, q => x_normal_reg);
register_y: Reg generic map (N => 32) port map ( load => load_inputs, input => x, clk => clk, clr => clr, q => y_normal_reg);

generate_hidden_neuron: for i in 0 to 5 generate
    hidden_neuron: Hidden_Layer_Neuron port map(activation_11 => predicted_r_reg, activation_12 => predicted_b_reg, activation_13 => predicted_g_reg, activation_14 => predicted_r2_reg,
                                                activation_15 => predicted_b2_reg, activation_16 => predicted_g2_reg, activation_17 => predicted_g_reg, activation_18 => predicted_r2_reg,
                                                initialize_W11 => init_hidden_weights(i)(0), initialize_W12 => init_hidden_weights(i)(1),initialize_W13 => init_hidden_weights(i)(2),initialize_W14 => init_hidden_weights(i)(3),
                                                initialize_W15 => init_hidden_weights(i)(4), initialize_W16 => init_hidden_weights(i)(5),initialize_W17 => init_hidden_weights(i)(6),initialize_W18 => init_hidden_weights(i)(7),
                                                Load_Wij => load_hidden, sel_init => sel_init, clk => clk, clr => clr, nextW1 => last_layer_weight(i)(0), nextW2 => last_layer_weight(i)(1), nextW3 => last_layer_weight(i)(2),
                                                nextSens1 => last_layer_sensitivity(i)(0), nextSens2 => last_layer_sensitivity(i)(1), nextSens3 => last_layer_sensitivity(i)(2), learning_Rate => learning_Rate,
                                                activation_out =>  hidden_layer_activations(i)
                                                );
end generate generate_hidden_neuron;
        
generate_output_neuron: for i in 0 to 2 generate -- go over arrays to make sure that they are going to the correct ones as well as final signals (should they be signals or ports?)
    output_neuron: Output_Layer_Neuron port map(activation_21 => hidden_layer_activations(0), activation_22 => hidden_layer_activations(1), activation_23 => hidden_layer_activations(2), activation_24 => hidden_layer_activations(3),
                                                activation_25 => hidden_layer_activations(4), activation_26 => hidden_layer_activations(5), initialize_W21 => last_layer_weight(i)(0), initialize_W22 => last_layer_weight(i)(1),
                                                initialize_W23 => last_layer_weight(i)(2),initialize_W24 => last_layer_weight(i)(3),initialize_W25 => last_layer_weight(i)(4), initialize_W26 => last_layer_weight(i)(5),
                                                load_Wij => load_Wij, sel_init => sel_init, clk => clk, clr => clr, learning_Rate => learning_Rate, targetR => target_color(i), predictedR => predicted_color(i), aLoad => aLoadSig
                                                );

end generate generate_output_neuron;

end Behavioral;