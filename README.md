# Sigmoid
This is a circuit that computes the approximation of the sigmoid
function. There are two input signals for the circuit, i.e., i_x with 8 bits, and a 1-bit 
i_in_valid. The i_x is a fixed-point format with a 1-bit sign, 2-bit integer, and 5-bit 
fraction. The circuit contains two output signals, i.e., up to 16-bit o_y for the 
approximation output value, and a 1-bit o_out_valid. The o_y is a fixed-point format 
with 1-bit integer and up to 15-bit fraction, and you don't need to use all 15 bits for your 
design's output. Note that the input signal is signed, and the output signal is unsigned. 
The relation between the input and the output signals is
Y ≅ sigmoid(x) = 1 / (1 + e^−X)