TPU inputs Matrices through UART into BRAM. Weights come from ROM for now. 
Clock is divided so memory can output part of the matrix per divide, as memory takes a full clock cycle to retrieve.
Input leaves memory and enters an im2col, which converts 2d matrix convolution into a 1d dot product. (same math)
The output is then skewed so that the values reach the proper processing elements/units as the partial sums pipelines down.
The 8x8 dsp slice array performs 8 matrix convolutions simultaneously before outputting into ram. 
The ram is then dumped back through the UART to the user. 

NEXT CHANGES:
im2col can be done on the embedded ZYNQ processing system in order to perform just accelerating functions on the PL.
im2col currently isnt versatile because of rapidly scaling logic block usage with scaling data size versatility.
Essentially, it takes a lot of PL logic to have an adaptable fit to the image matrix preprocessing.
