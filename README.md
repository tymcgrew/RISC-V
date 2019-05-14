# RISC-V

* An implementation of a RISC-V 32I ISA, minus FENCE and CSR instructions, plus MUL.
* Implemented on an Altera Cyclone IV FPGA development board in Verilog.
* Implements a watchdog timer, an interrupt handler, and a [process-switching OS](https://github.com/tymcgrew/RISC-V/blob/master/Program%20stuff/programs/os.s).
* Includes an 8 line direct-mapping cache.

![Diagram](https://github.com/tymcgrew/RISC-V/blob/master/misc/RISC-V.png)

![State Machine](https://github.com/tymcgrew/RISC-V/blob/master/misc/Control.png)


Here you can view a demonstration of the Process Handling OS running two programs simultaneously:

[![Demonstration](https://github.com/tymcgrew/RISC-V/blob/master/misc/thumbnail.jpg)](https://youtu.be/mVovRGVpMVY)
