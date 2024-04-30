import numpy as np

class Neuron:
    def __init__(self, input_size):
        self.weights = (np.random.randn(input_size, 1) * 0.01).tolist()
        self.bias = 1
        self.output = None
        self.sensitivity = 0
        self.input = None

    def activate(self, x):
        return max(0, x)

    def activate_derivative(self, x):
        return 1 if x > 0 else 0

    def forward(self, x):
        self.input = x #This is the output of the previous layer of the network
        s = 0

        for i in range(0,len(x)-1):
            s += self.weights[i] * x[i]
        z = s + self.bias
        self.output = self.activate(z)
        return self.output
    
    def backward(self, error=None, weights_next_layer=None, sensitivity_next_layer=None):
        if weights_next_layer is None:  # Output layer
            self.sensitivity = error * self.activate_derivative(self.output)
        else:  # Hidden layer
            # non vector math version
            for i in range(len(weights_next_layer)):
                self.sensitivity +=weights_next_layer[i][0] * sensitivity_next_layer[i]
            self.sensitivity = self.sensitivity * self.activate_derivative(self.output)
        return self.sensitivity

    def update(self, learning_rate):
        temp = 0
        # print("Old Weights:", self.weights)
        for i in range(len(self.weights)):
            temp = 0
            temp = learning_rate * self.sensitivity * self.input[i]
            self.weights[i][0] += temp[0]
        # print("New Weights:", self.weights)

        # self.weights -= learning_rate * np.dot(self.input, self.sensitivity.T)
        self.bias -= learning_rate * self.sensitivity
    
class NeuralNetwork:
    def __init__(self, input_size, hidden_size, output_size):
        self.input_size = 2 #x,y coordinate
        self.input_size = input_size
        self.hidden_size = hidden_size

        #neurons hidden is a list of neurons
        self.neurons_hidden = [Neuron(input_size) for _ in range(hidden_size)]

        self.neuron_r = Neuron(hidden_size)
        self.neuron_g = Neuron(hidden_size)
        self.neuron_b = Neuron(hidden_size)

    def forward_pass(self, x, y):
        input_vector = np.array([x, y]).reshape(-1, 1)

        #hidden layer
        hidden_outputs_vector = []
        for neuron in self.neurons_hidden:
            hidden_outputs_vector.append(neuron.forward(input_vector))

        r = self.neuron_r.forward(hidden_outputs_vector)
        g = self.neuron_g.forward(hidden_outputs_vector)
        b = self.neuron_b.forward(hidden_outputs_vector)
        return r, g, b
    
    def backward_pass(self, r, g, b, target_r, target_g, target_b):

        error_r = target_r - r
        error_g = target_g - g
        error_b = target_b - b
        error = error_r + error_g + error_b
        print("Error:", error)

        output_sensitivity = []
        output_sensitivity.append(self.neuron_r.backward(error[0]))
        output_sensitivity.append(self.neuron_g.backward(error[0]))
        output_sensitivity.append(self.neuron_b.backward(error[0]))
        print("Output Layer Sensitivity:", output_sensitivity)
        self.neuron_r.update(0.01)
        self.neuron_g.update(0.01)
        self.neuron_b.update(0.01)

        hidden_sensitivity = []
        #hidden layer
        for i in range(len(self.neurons_hidden)):
            hidden_sensitivity.append(self.neurons_hidden[i].backward(error,weights_next_layer=[self.neuron_r.weights[i], self.neuron_g.weights[i], self.neuron_b.weights[i]], sensitivity_next_layer=output_sensitivity))
        print("Hidden Layer Sensitivity:", hidden_sensitivity)
        for neuron in self.neurons_hidden:
            neuron.update(0.01)

        
input_size = 2
model = NeuralNetwork(input_size, 3, 3)

x_test = 0.25
y_test = 0.55
predicted_r, predicted_g, predicted_b = model.forward_pass(x_test, y_test)
model.backward_pass(predicted_r, predicted_g, predicted_b, 0.5, 0.5, 0.5)
print(f"Predicted RGB: ({predicted_r[0]}, {predicted_g[0]}, {predicted_b[0]})")
predicted_r, predicted_g, predicted_b = model.forward_pass(x_test, y_test)
print(f"Predicted RGB: ({predicted_r[0]}, {predicted_g[0]}, {predicted_b[0]})")
model.backward_pass(predicted_r, predicted_g, predicted_b, 0.5, 0.5, 0.5)
predicted_r, predicted_g, predicted_b = model.forward_pass(x_test, y_test)
print(f"Predicted RGB: ({predicted_r[0]}, {predicted_g[0]}, {predicted_b[0]})")
model.backward_pass(predicted_r, predicted_g, predicted_b, 0.5, 0.5, 0.5)
predicted_r, predicted_g, predicted_b = model.forward_pass(x_test, y_test)
print(f"Predicted RGB: ({predicted_r[0]}, {predicted_g[0]}, {predicted_b[0]})")
model.backward_pass(predicted_r, predicted_g, predicted_b, 0.5, 0.5, 0.5)
