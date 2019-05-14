Use Ripes RISC-V simulator and assembly editor to compile programs to binary.
https://github.com/mortbopet/Ripes

There are four parallel memory modules on this processor to maximize load/store speed so there is a python script in this folder that will split the code.
Put the machine code binary into the input.txt file, save input.txt, and run script.py.
Move the four resulting .mif files into the Processor folder and overwrite the existing .mif files in that folder, recompile the project, and you're done.