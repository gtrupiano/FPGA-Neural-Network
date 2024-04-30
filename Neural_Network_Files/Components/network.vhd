library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
use work.components.all;


entity Network is
  Port (target_r, target_g, target_b: in STD_LOGIC_VECTOR(31 downto 0);  
        go: in STD_LOGIC;
        learning_Rate: in std_logic_vector(31 downto 0):= "00000000000000000000000010100111";
        reset: in STD_LOGIC;
        start: in STD_LOGIC;
        btn: in std_logic_vector(3 downto 0);
        sw: in std_logic_vector(7 downto 0);
        clk: in STD_LOGIC;
        clr: in STD_LOGIC;
        aLoad: in STD_LOGIC;
        
        write_enable: inout STD_LOGIC;
        ram_rom_location: inout STD_LOGIC_VECTOR(31 downto 0);
        r,b,g: inout STD_LOGIC_VECTOR(31 downto 0)    
        );
end Network;

architecture Behavioral of Network is

TYPE hidden_layer_init_weights is array (0 to 7) of STD_LOGIC_VECTOR(31 downto 0);--amount of weights
TYPE hidden_layer_neurons is array (0 to 5) of hidden_layer_init_weights; --number of neurons

-- hidden_layer_activation is array
TYPE hidden_to_last_array_neuron is array (0 to 2) of STD_LOGIC_VECTOR(31 downto 0); --amount of weights
TYPE hidden_to_last_array_layer is array (0 to 5) of hidden_to_last_array_neuron; --number of neurons

TYPE hidden_to_last_array_activation_neuron is array (0 to 5) of STD_LOGIC_VECTOR(31 downto 0);

TYPE predicted_color_array is array (0 to 2) of  STD_LOGIC_VECTOR(31 downto 0);

signal hidden_activation: hidden_to_last_array_activation_neuron;

SIGNAL predicted_color: predicted_color_array;
SIGNAL target_color: predicted_color_array;

SIGNAL init_hidden_weights : hidden_layer_neurons;

SIGNAL last_layer_weight : hidden_to_last_array_layer;
SIGNAL last_layer_sensitivity : hidden_to_last_array_neuron;

SIGNAL load_Wij: STD_LOGIC;

SIGNAL sel_init: STD_LOGIC;
SIGNAL load_inputs: STD_LOGIC;
SIGNAL load_hidden: STD_LOGIC;
SIGNAL load_output: STD_LOGIC;
SIGNAL load_rgb: STD_LOGIC;

SIGNAL hsync,vsync,ram_we,load_hidden_activation,load_output_activation: std_logic;
SIGNAL rom_addr16: std_logic_vector(15 downto 0);




SIGNAL x: STD_LOGIC_VECTOR(31 downto 0);
SIGNAL y: STD_LOGIC_VECTOR(31 downto 0);

SIGNAL x_normal_reg: STD_LOGIC_VECTOR(31 downto 0);
SIGNAL y_normal_reg: STD_LOGIC_VECTOR(31 downto 0);

signal rom116: std_logic_vector(15 downto 0);

SIGNAL predicted_r: STD_LOGIC_VECTOR(31 downto 0);
SIGNAL predicted_b: STD_LOGIC_VECTOR(31 downto 0);
SIGNAL predicted_g: STD_LOGIC_VECTOR(31 downto 0);

SIGNAL predicted_r_reg: STD_LOGIC_VECTOR(31 downto 0);
SIGNAL predicted_b_reg: STD_LOGIC_VECTOR(31 downto 0);
SIGNAL predicted_g_reg: STD_LOGIC_VECTOR(31 downto 0);

SIGNAL predicted_r2_reg: STD_LOGIC_VECTOR(31 downto 0);
SIGNAL predicted_b2_reg: STD_LOGIC_VECTOR(31 downto 0);
SIGNAL predicted_g2_reg: STD_LOGIC_VECTOR(31 downto 0);
signal rgb: STD_LOGIC_VECTOR(11 downto 0);
signal a: STD_LOGIC_VECTOR(6 DOWNTO 0);
signal d: STD_LOGIC_VECTOR(11 DOWNTO 0);

begin
    rgb <= r(23 downto 20) & g(23 downto 20) & b(23 downto 20);
    target_color(0) <= target_r; target_color(1) <= target_g; target_color(2) <= target_b;
    
    init_hidden_weights(0)(0) <= X"00003832"; init_hidden_weights(0)(1) <= X"00001734"; init_hidden_weights(0)(2) <= X"00009584"; init_hidden_weights(0)(3) <= X"00006594";
    init_hidden_weights(0)(4) <= X"00006729"; init_hidden_weights(0)(5) <= X"00001102"; init_hidden_weights(0)(6) <= X"00004932"; init_hidden_weights(0)(7) <= X"00009173";
    
    init_hidden_weights(1)(0) <= X"00008372"; init_hidden_weights(1)(1) <= X"00002002"; init_hidden_weights(1)(2) <= X"00001977"; init_hidden_weights(1)(3) <= X"00006611";
    init_hidden_weights(1)(4) <= X"00001922"; init_hidden_weights(1)(5) <= X"00002003"; init_hidden_weights(1)(6) <= X"00009200"; init_hidden_weights(1)(7) <= X"00000242";
    
    init_hidden_weights(2)(0) <= X"00003742"; init_hidden_weights(2)(1) <= X"00004854"; init_hidden_weights(2)(2) <= X"00009402"; init_hidden_weights(2)(3) <= X"00001011";
    init_hidden_weights(2)(4) <= X"00004928"; init_hidden_weights(2)(5) <= X"00003723"; init_hidden_weights(2)(6) <= X"00006712"; init_hidden_weights(2)(7) <= X"00000717";
    
    init_hidden_weights(3)(0) <= X"00001210"; init_hidden_weights(3)(1) <= X"00007283"; init_hidden_weights(3)(2) <= X"00004903"; init_hidden_weights(3)(3) <= X"00002722";
    init_hidden_weights(3)(4) <= X"00001152"; init_hidden_weights(3)(5) <= X"00007371"; init_hidden_weights(3)(6) <= X"00007201"; init_hidden_weights(3)(7) <= X"00009506";
    
    init_hidden_weights(4)(0) <= X"00000001"; init_hidden_weights(4)(1) <= X"00003124"; init_hidden_weights(4)(2) <= X"00008234"; init_hidden_weights(4)(3) <= X"00007234";
    init_hidden_weights(4)(4) <= X"00008291"; init_hidden_weights(4)(5) <= X"00009876"; init_hidden_weights(4)(6) <= X"00007482"; init_hidden_weights(4)(7) <= X"00001739";
    
    init_hidden_weights(5)(0) <= X"00009284"; init_hidden_weights(5)(1) <= X"00005581"; init_hidden_weights(5)(2) <= X"00008355"; init_hidden_weights(5)(3) <= X"00004680";
    init_hidden_weights(5)(4) <= X"00004804"; init_hidden_weights(5)(5) <= X"00006233"; init_hidden_weights(5)(6) <= X"00001823"; init_hidden_weights(5)(7) <= X"00001726";

    
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
   
    network_state_machine: NNControl port map(clk => clk, clr => clr, hsync => hsync, vsync => vsync, ram_we => ram_we, load_inputs => load_inputs, x => x, y => y, rom_addr16I => rom_addr16, rom_addr16O => rom_addr16, sel_init => sel_init, load_hidden => load_hidden,
                           load_hidden_activation => load_hidden_activation, load_output_activation => load_output_activation, load_rgb => load_rgb, load_output => load_output
                           );
    
    generate_hidden_neuron: for i in 0 to 5 generate
    hidden_neuron: Hidden_Layer_Neuron port map(activation_11 => predicted_r_reg, activation_12 => predicted_b_reg, activation_13 => predicted_g_reg, activation_14 => predicted_r2_reg,
                                                activation_15 => predicted_b2_reg, activation_16 => predicted_g2_reg, activation_17 => predicted_g_reg, activation_18 => predicted_r2_reg,
                                                initialize_W11 => init_hidden_weights(i)(0), initialize_W12 => init_hidden_weights(i)(1),initialize_W13 => init_hidden_weights(i)(2),initialize_W14 => init_hidden_weights(i)(3),
                                                initialize_W15 => init_hidden_weights(i)(4), initialize_W16 => init_hidden_weights(i)(5),initialize_W17 => init_hidden_weights(i)(6),initialize_W18 => init_hidden_weights(i)(7),
                                                Load_Wij => load_hidden, sel_init => sel_init, clk => clk, clr => clr, nextW1 => last_layer_weight(i)(0), nextW2 => last_layer_weight(i)(1), nextW3 => last_layer_weight(i)(2),
                                                nextSens1 => last_layer_sensitivity(0), nextSens2 => last_layer_sensitivity(1), nextSens3 => last_layer_sensitivity(2), learning_Rate => learning_Rate, activation_out =>  hidden_activation(i),
                                                aLoad => aLoad
                                                );
    end generate generate_hidden_neuron;
        
        
        
    generate_output_neuron: for i in 0 to 2 generate
    output_neuron: Output_Layer_Neuron port map (activation_21 => hidden_activation(0), activation_22 => hidden_activation(1), activation_23 => hidden_activation(2), 
                                                 activation_24 => hidden_activation(3), activation_25 => hidden_activation(4), activation_26 => hidden_activation(5),
                                                 initialize_W21 => last_layer_weight(0)(i), initialize_W22 => last_layer_weight(1)(i), initialize_W23 => last_layer_weight(2)(i),
                                                 initialize_W24 => last_layer_weight(3)(i), initialize_W25 => last_layer_weight(4)(i),load_Wij => load_output, sel_init => sel_init,
                                                 initialize_W26 => last_layer_weight(5)(i),clk => clk, clr => clr, learning_Rate => learning_Rate, targetR => target_color(i),
                                                 predictedR => predicted_color(i), aLoad => aLoad
                                                 );
    end generate generate_output_neuron;
    
    r <= predicted_color(0); g <= predicted_color(1); b <= predicted_color(2);
    
    register_r: Reg generic map (N => 32) port map ( load => load_rgb, input => predicted_color(0), clk => clk, clr => clr, q => predicted_r_reg);
    register_g: Reg generic map (N => 32) port map ( load => load_rgb, input => predicted_color(1), clk => clk, clr => clr, q => predicted_g_reg);
    register_b: Reg generic map (N => 32) port map ( load => load_rgb, input => predicted_color(2), clk => clk, clr => clr, q => predicted_b_reg);
    vgaTop: vga_bsprite_top port map(mclk => clk, btn => btn,sw => sw, a => ram_rom_location(6 downto 0), d => rgb, we => write_enable, hsync => hsync, vsync => vsync,
                                     red => r, green => g, blue => b
                                     );
    
    
    
    -- Assign the predicted color values to the output ports
    
end Behavioral;