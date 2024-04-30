# FPGA_Neural_Network
In this project, the design and implementation of a neural network on a field-programmable gate array
(FPGA) is explored. The neural network is tailored to learn and display a 10x10 pixel image on a VGA screen. The
objective is to create an efficient solution capable of recognizing and displaying pixelated images in real time. The
chosen neural network architecture, based on much testing, was adapted for implementation on the Nexys A-7
board. In order to test the theory of the idea, the same network was implemented in Python using TensorFlow which yielded
resulting images. VHDL was employed for the encoding of the neural network’s layers and training algorithms onto the board.
Various simulations were conducted to validate the networks learning capabilities and were compared with results
from the same network structure built in python to ensure correct execution in VHDL. Results showed the creation
of a successful network in python. The operation of many components in the network were validated but a failed
completion of the VHDL top file caused an ultimately non-functioning final product on the FPGA board.
