module Processor(clk, rst);

	input clk, rst;
	
	wire [4:0]register_address_a, register_address_b;
	wire register_wren_a;
	
	wire [2:0]alu_op;
	
	wire memory_wren;
	wire [1:0]memory_width;
	wire memory_sign;
	
	wire programcounter_wren;
	wire programcounter_add_or_set;
	wire [9:0]programcounter_value;
	
	wire instructionregister_wren;
	

	Control control(
						 rst,
						 
						 // register
						 register_address_a,
						 register_address_b,
						 register_wren_a,						 
						 
						 
						 // alu
						 alu_op,
						 
						 
						 // memory
						 memory_wren,
						 memory_width,
						 memory_sign,						 
						 
						 
						 // programcounter
						 programcounter_wren,
						 programcounter_add_or_set,
						 programcounter_value,						 
						 
						 
						 // instructionregister
						 instructionregister_wren						 
						 );
	
	
	Register register(
							register_address_a, 
							register_address_b,
							clk,
							register_in_a,
							32'd0,                 //register_in_b
							register_wren_a,
							1'b0,                  //register_wren_b
							out_a,
							out_b
							);	
	//	input	[4:0]  address_a;
	//	input	[4:0]  address_b;
	//	input	  clock;
	//	input	[31:0]  data_a;
	//	input	[31:0]  data_b;
	//	input	  wren_a;
	//	input	  wren_b;
	//	output	[31:0]  q_a;
	//	output	[31:0]  q_b;

	
	ALU alu(
			  alu_in_a,
			  alu_in_b,
			  alu_op,
			  alu_status,
			  alu_out
			  );			  
	// input [31:0]in_a;
	// input [31:0]in_b;
	// input [2:0]op;
	// output [2:0]status;
	// output [31:0]out;
	// reg [2:0]status;
	// reg [31:0]out;	
	
	
	Memory memory(
					  clk,
					  memory_address,
					  memory_in,
					  memory_wren,
					  memory_width,
					  memory_sign,
					  memory_out
					  );
	//	input clk;
	//	input [9:0]address;
	//	input [31:0]in;
	//	input wren, sign;
	//	input [1:0]width;
	//	output [31:0]out;
	//	reg [31:0]out;
	
	
	assign programcounter_in = (programcounter_add_or_set == 1'b1)? programcounter_out + programcounter_value : programcounter_value;
	ProgramCounter programcounter(
											clk,
											rst,
											programcounter_in,
											programcounter_out,
											programcounter_wren
										   );
	// input rst, clk;
	// input wren;
	// input [31:0]in;
	// output [31:0]out;
	// reg [31:0]out;
	
	
	InstructionRegister instructionregister(
														 clk,
														 rst,
														 instructionregister_in,
														 instructionregister_out,
														 instructionregister_wren
														 );
	// input rst, clk;
	// input wren;
	// input [31:0]in;
	// output [31:0]out;
	// reg [31:0]out;

endmodule