module Control(
					clk,
					rst,
					
					SW,
					alu_status,
					instruction,
					
					// register
					register_address_a,
					register_address_b,
					register_wren,
					register_mux,
					register_immediate,
					result_wren,
						 
						 
					// alu
					alu_a_mux,
					alu_b_mux,
					alu_immediate,
					alu_op,
						 
						 
					// memory
					memory_wren,
					memory_width,
					memory_sign,
					memory_mux,
						 
						 
					// programcounter
					programcounter_wren,
					programcounter_mux,
					programcounter_immediate,						 
						 
						 
					// instructionregister
					instructionregister_wren
					);


//------------------------------------------------------------------
//                 -- Input/Output Declarations --                  
//------------------------------------------------------------------

input clk, rst;
input [15:0]SW;
input [2:0]alu_status;
input [31:0]instruction;

output [4:0]register_address_a, register_address_b;
reg [4:0]register_address_a, register_address_b;
output register_wren;
reg register_wren;
output [1:0]register_mux;
reg [1:0]register_mux;
output [31:0]register_immediate;
reg [31:0]register_immediate;
output result_wren;
reg result_wren;
	
output alu_a_mux;
reg alu_a_mux;
output alu_b_mux;
reg alu_b_mux;
output [31:0]alu_immediate;
reg [31:0]alu_immediate;	
output [2:0]alu_op;
reg [2:0]alu_op;
	
output memory_wren;
reg memory_wren;
output [1:0]memory_width;
reg [1:0]memory_width;
output memory_sign;
reg memory_sign;
output memory_mux;
reg memory_mux;
	
output programcounter_wren;
reg programcounter_wren;
output [1:0]programcounter_mux;
reg [1:0]programcounter_mux;
output [9:0]programcounter_immediate;
reg [9:0]programcounter_immediate;
	
output instructionregister_wren;
reg instructionregister_wren;

//------------------------------------------------------------------
//                  -- State & Reg Declarations  --                   
//------------------------------------------------------------------

reg [26:0]counter;


//------------------------------------------------------------------
//                 -- Begin Declarations & Coding --                  
//------------------------------------------------------------------




endmodule