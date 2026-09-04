import numpy as np
import cv2
from PIL import Image
import math

class Neuron:
    def __init__(self, input_size):
        self.weights = abs(np.random.randn(input_size, 1) * 0.001).tolist()
        print("Weights:", self.weights)
        self.bias = 0.000000
        self.output = None
        self.sensitivity = 0
        self.input = None

    def activate(self, x):
        t = max(0.0*x, x)
        return max(0.0*x, x)

    def activate_derivative(self, x):
        if(x > 0):
            return 1
        else:
            return 0
            


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
            self.weights[i][0] -= temp[0]
        # print("New Weights:", self.weights)

        # self.weights -= learning_rate * np.dot(self.input, self.sensitivity.T)
        self.bias -= learning_rate * self.sensitivity
    
class NeuralNetwork:
    def __init__(self, input_size, hidden_size, hidden2_size, output_size):
        self.input_size = 2 #x,y coordinate
        self.input_size = input_size
        self.hidden_size = hidden_size
        self.hidden2_size = hidden2_size
        self.output_size = output_size
        self.error = None
        self.learning_rate = 0.00001

        #
        # self.neurons_hidden2 = [Neuron(input_size) for _ in range(hidden2_size)]
        # neurons hidden is a list of neurons
        self.neurons_hidden = [Neuron(input_size) for _ in range(hidden_size)]

        self.neuron_r = Neuron(hidden_size)
        self.neuron_g = Neuron(hidden_size)
        self.neuron_b = Neuron(hidden_size)

    def forward_pass(self, x, y, last_r, last_g, last_b, last_r2, last_g2, last_b2):
        input_vector = np.array([x,y,last_r,last_g,last_b,last_r2,last_g2,last_b2]).reshape(-1, 1)

        #hidden layer 2
        # hidden2_outputs_vector = []
        # for neuron in self.neurons_hidden2:
        #     hidden2_outputs_vector.append(neuron.forward(input_vector))


        #hidden layer
        hidden_outputs_vector = []
        for neuron in self.neurons_hidden:
            hidden_outputs_vector.append(neuron.forward(input_vector))
        # print("Hidden Layer Outputs:", hidden_outputs_vector)
        
        # for neuron in self.neurons_hidden:
        #     hidden_outputs_vector.append(neuron.forward(hidden_outputs_vector))
        r = self.neuron_r.forward(hidden_outputs_vector)
        g = self.neuron_g.forward(hidden_outputs_vector)
        b = self.neuron_b.forward(hidden_outputs_vector)
        return r, g, b
    
    def backward_pass(self, r, g, b, target_r, target_g, target_b):

        error_r = 2 * (r - target_r)
        error_g = 2 * (g - target_g)
        error_b = 2 * (b - target_b)
        error = math.sqrt(error_r**2 + error_g**2 + error_b**2) 
        # print("Error:", error)
        # print("Error:", error)

        output_sensitivity = []
        output_sensitivity.append(self.neuron_r.backward(error_r))
        output_sensitivity.append(self.neuron_g.backward(error_g))
        output_sensitivity.append(self.neuron_b.backward(error_b))
        # print("Output Layer Sensitivity:", output_sensitivity)
        self.neuron_r.update(self.learning_rate)
        self.neuron_g.update(self.learning_rate)
        self.neuron_b.update(self.learning_rate)

        hidden_sensitivity = []
        hidden_weights = []
        #hidden layer
        for i in range(len(self.neurons_hidden)):
            hidden_weights.append(self.neurons_hidden[i].weights)
            hidden_sensitivity.append(self.neurons_hidden[i].backward(None,weights_next_layer=[self.neuron_r.weights[i], self.neuron_g.weights[i], self.neuron_b.weights[i]], sensitivity_next_layer=output_sensitivity))
        # print("weights", hidden_weights)
        # print("Hidden Layer Sensitivity:", hidden_sensitivity)
        for neuron in self.neurons_hidden:
            neuron.update(self.learning_rate)

        # hidden2_sensitivity = []
        # #hidden layer 2
        # for i in range(len(self.neurons_hidden2)):
        #     hidden2_sensitivity.append(self.neurons_hidden2[i].backward(None,weights_next_layer=hidden_weights[i], sensitivity_next_layer=hidden_sensitivity))
        # for neuron in self.neurons_hidden2:
        #     neuron.update(self.learning_rate)



def read_image_as_array(image_path):
    # Open the image
    img = Image.open(image_path)
    
    # Convert the image to a NumPy array
    img_array = np.array(img)

    return img_array
        
input_size = 8
model = NeuralNetwork(input_size, 6 ,3, 3)

x_test = 0.25
y_test = 0.9
# for i in range(10000):
#     predicted_r, predicted_g, predicted_b = model.forward_pass(x_test, y_test)
#     model.backward_pass(predicted_r, predicted_g, predicted_b, 0.1, 0.3, 0.8)
#     print(f"Predicted RGB: ({predicted_r[0]}, {predicted_g[0]}, {predicted_b[0]})")


image = "C:\\Users\\JoeyV\\OneDrive\\4510\\Projects\\augmented-reality-master (1)\\augmented-reality-master\\NN\\dot2.png"
image_array = read_image_as_array(image)
image_array_normal = np.zeros((len(image_array), len(image_array[0]), 4), dtype=np.float)

image_output = np.zeros((len(image_array), len(image_array[0]), 4), dtype=np.float)
# print(image_array)
# print(image_array[1][0][0])

for x in range(len(image_array)):
    for y in range(len(image_array[x])):
        for i in range(3):
            image_array_normal[x][y][i] = ((float)(image_array[x][y][i]) / 255)
            

# for x in range(len(image_array)):
#     for y in range(len(image_array[x])):
#         for i in range(3):
#             print("X:", x, "Y:", y)
#             print("RGB:", image_array_normal[x][y][0],",",image_array_normal[x][y][1],",",image_array_normal[x][y][2])

k = 0 
last_predicted_r, last_predicted_g, last_predicted_b = [0], [0], [0]
last_predicted_r2, last_predicted_g2, last_predicted_b2 = [0], [0], [0]
while k < 1000:
    k += 1    
    # x = 1
    # y = 2
    for p in range(1): 
        
        for j in range(10):
            for i in range(10):
                # print("X:", j, "Y:", i) 
                y = i
                x = j
                # print("Last perdicted: ", last_predicted_r, last_predicted_g, last_predicted_b)
                predicted_r, predicted_g, predicted_b = model.forward_pass((x/16), (y/16), last_predicted_r[0], last_predicted_g[0], last_predicted_b[0],last_predicted_b2[0], last_predicted_g2[0], last_predicted_b2[0])
                last_predicted_r, last_predicted_g, last_predicted_b = predicted_r, predicted_g, predicted_b
                last_predicted_r2, last_predicted_g2, last_predicted_b2 = last_predicted_r, last_predicted_g, last_predicted_b
           
                model.backward_pass(predicted_r, predicted_g, predicted_b, image_array_normal[x][y][0], image_array_normal[x][y][1], image_array_normal[x][y][2])
                # print("x, y", x, y)
                # print(image_array_normal[x][y][0])
                try:
                    image_output[x][y] = [predicted_r[0]*255, predicted_g[0]*255, predicted_b[0]*255,255]
                    # print(f"Predicted RGB:",x , y, predicted_r, predicted_g, predicted_b)
                    # print(f"Target RGB:"," ", " " ,image_array_normal[x][y][0], image_array_normal[x][y][1], image_array_normal[x][y][2])
                except:
                    image_output[x][y] = [predicted_r, predicted_g, predicted_b, 255]
                    # print(f"Predicted RGB:",x , y, predicted_r, predicted_g, predicted_b)
                    # print(f"Target RGB:"," ", " " ,image_array[x][y][0], image_array[x][y][1], image_array[x][y][2])
    img = Image.fromarray(np.uint8(image_output))
    img.save("C:\\Users\\JoeyV\\OneDrive\\4510\\Projects\\augmented-reality-master (1)\\augmented-reality-master\\NN\\output.png")
    image = cv2.imread("C:\\Users\\JoeyV\\OneDrive\\4510\\Projects\\augmented-reality-master (1)\\augmented-reality-master\\NN\\output.png")
    resized_image = cv2.resize(image, (900, 900), interpolation = cv2.INTER_NEAREST)
    cv2.imshow("output", resized_image)
    cv2.waitKey(1)
    

# range(3):
    #     for y in range(3):
    #         predicted_r, predicted_g, predicted_b = model.forward_pass((x/3), (y/3))
    #         print("input",(x/3), (y/3))
    #         model.backward_pass(predicted_r, predicted_g, predicted_b, image_array_normal[x][y][0], image_array_normal[x][y][1], image_array_normal[x][y][2])
    #         try:
    #             print(f"Predicted RGB:", predicted_r, predicted_g, predicted_b)
    #             print(f"Target RGB:", image_array_normal[x][y][0], image_array_normal[x][y][1], image_array_normal[x][y][2])
    #         except:
    #             pass
    # for x in 

# for x in range(3):
#     for y in range(3):
#         predicted_r, predicted_g, predicted_b = model.forward_pass(x,y)
#         print(f"Predicted RGB: ({predicted_r}, {predicted_g}, {predicted_b})")
#         try:
#             print(f"Predicted RGB: ({predicted_r}, {predicted_g}, {predicted_b})")
#             image_output[x][y] = [predicted_r[0] * 255, predicted_g[0]* 255, predicted_b[0]* 255,255]
#         except:
#             image_output[x][y] = [predicted_r* 255, predicted_g* 255, predicted_b* 255,255]
            

# print(image_output)

# img = Image.fromarray(np.uint8(image_output))

# # Save the image or display it
# img.save("C:\\Users\\JoeyV\\OneDrive\\4510\\Projects\\augmented-reality-master (1)\\augmented-reality-master\\NN\\output.png")  # Save the image to a file
# img.show()  # Display the image

