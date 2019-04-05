module Processor(SW, clk, rst);
	
	input [15:0]SW;
	input clk, rst;
	
	
	// Control wires
	wire [2:0]alu_status;
	wire [31:0]instruction;
	
	wire [4:0]register_address_a;
	wire [4:0]register_address_b;
	wire register_wren;
	wire [1:0]register_mux;
	wire [31:0]register_immediate;
	wire result_wren;
	
	wire alu_a_mux;
	wire alu_b_mux;
	wire [31:0]alu_immediate;
	wire [2:0]alu_op;
	
	wire memory_wren;
	wire [1:0]memory_width;
	wire memory_sign;
	wire memory_mux;
	
	wire programcounter_wren;
	wire [1:0]programcounter_mux;
	wire [31:0]programcounter_immediate;
	
	wire instructionregister_wren;
	
	// Non-control wires
	reg [31:0]register_in_a;
	wire [31:0]register_out_a;
	wire [31:0]register_out_b;
	wire [31:0]alu_in_a;
	wire [31:0]alu_in_b;
	wire [31:0]alu_out;
	wire [9:0]memory_address;
	wire [31:0]memory_out;
	reg [31:0]programcounter_in;
	wire [31:0]programcounter_out;
	wire [31:0]result_reg_out;

	Control control(
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
						 
	
	GenericRegister result_reg(clk, rst, alu_out, result_reg_out, result_wren);
	
	always@(*)
	begin
		case(register_mux)
			2'b11: register_in_a = register_immediate;
			2'b10: register_in_a = result_reg_out;
			2'b01: register_in_a = alu_out;
			2'b00: register_in_a = memory_out;
		endcase
	end
	RegisterUnit register(
							register_address_a, 
							register_address_b,
							clk,
							rst,
							register_in_a,
							register_wren,
							register_out_a,
							register_out_b
							);	


	assign alu_in_a = (alu_a_mux == 1'b1)? register_out_a : alu_immediate;
	assign alu_in_b = (alu_b_mux == 1'b1)? programcounter_out : register_out_b;
	ALU alu(
			  alu_in_a,
			  alu_in_b,
			  alu_op,
			  alu_status,
			  alu_out
			  );			  

	
	
	assign memory_address = (memory_mux)? alu_out[9:0] : programcounter_out[9:0];
	Memory memory(
					  clk,
					  memory_address,
					  register_out_a,          // memory_in
					  memory_wren,
					  memory_width,
					  memory_sign,
					  memory_out
					  );

	
	always@(*)
	begin
		case(programcounter_mux)
		2'b11: programcounter_in = programcounter_out + programcounter_immediate;
		2'b10: programcounter_in = 32'd0;
		2'b01: programcounter_in = programcounter_immediate;
		2'b00: programcounter_in = {alu_out[31:1], 1'b0} + programcounter_out;
		endcase
	end
	GenericRegister programcounter(
											clk,
											rst,
											programcounter_in,
											programcounter_out,
											programcounter_wren
										   );

	
	
	GenericRegister instructionregister(
														 clk,
														 rst,
														 memory_out,                     // instruction_register_in
														 instruction,                    // instruction_register_out
														 instructionregister_wren
														 );


endmodule