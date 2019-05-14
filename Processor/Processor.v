module Processor(SW, 
					  KEY, 
					  clk, 
					  LEDG, 
					  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, 
					  
					  // Debugging outputs
					  STATE, 
					  instruction, 
					  alu_in_a,
					  alu_in_b,
					  alu_out,
					  alu_status,
					  register_wren,
					  register_in_a,
					  register_address_a,
					  register_address_b,
					  programcounter_wren,
					  programcounter_in,
					  result_wren,
					  result_reg_out,
					  memory_address,
					  register_out_a,
					  memory_wren,
					  instructionregister_wren,
					  out_update,
					  interrupt
					  );
	
	input [17:0]SW;
	output [8:0]LEDG;
	wire LEDG0;
	assign LEDG[0] = LEDG0;
	wire LEDG1;
	assign LEDG[1] = LEDG1;
	input [3:0]KEY;
	wire KEY0;
	assign KEY0 = KEY[0];
	wire rst;
	assign rst = SW[17];
	input clk;
	output signed [0:6]HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
	reg signed [0:6]HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;
	
	
	// Debugging outputs
	output [5:0]STATE;
	output [31:0]instruction;
	output [31:0]alu_in_a;
	output [31:0]alu_in_b;
	output [31:0]alu_out;
	output [2:0]alu_status;
	output register_wren;
	output [31:0]register_in_a;
	output [4:0]register_address_a;
	output [4:0]register_address_b;
	output programcounter_wren;
	output [31:0]programcounter_in;
	output result_wren;
	output [31:0]result_reg_out;
	output [31:0]memory_address;
	output [31:0]register_out_a;
	output memory_wren;
	output instructionregister_wren;
	output out_update;
	output interrupt;
	
	
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
	wire [3:0]alu_op;
	
	wire memory_wren;
	wire [1:0]memory_width;
	wire memory_sign;
	wire memory_mux;
	wire cacheHit;
	
	wire interrupt;
	
	wire programcounter_wren;
	wire [1:0]programcounter_mux;
	wire [31:0]programcounter_immediate;
	
	wire instructionregister_wren;
	
	wire out_update;
	
	// Non-control wires
	reg  [31:0]register_in_a;
	wire [31:0]register_out_a;
	wire [31:0]register_out_b;
	wire [31:0]alu_in_a;
	wire [31:0]alu_in_b;
	wire [31:0]alu_out;
	wire [31:0]memory_address;
	wire [31:0]memory_out;
	wire tmr_rst;
	reg  [31:0]programcounter_in;
	wire [31:0]programcounter_out;
	wire [31:0]result_reg_out;

	Control control(
						 clk,
						 rst,
						 
						 {{16{SW[15]}},SW[15:0]},
						 LEDG0,
						 LEDG1,
						 KEY0,
						 register_out_b,
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
						 cacheHit,
						 
						 interrupt,
						 
						 
						 // programcounter
						 programcounter_wren,
						 programcounter_mux,
						 programcounter_immediate,						 
						 
						 
						 // instructionregister
						 instructionregister_wren,

						 out_update,
						 
						 STATE
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

	
	
	assign memory_address = (memory_mux)? alu_out : programcounter_out;
	Cache cache(
					  clk,
					  rst,
					  memory_address,
					  register_out_a,          // memory_in
					  memory_wren,
					  memory_width,
					  memory_sign,
					  memory_out,
					  cacheHit,
					  tmr_rst
					  );
					  
					  
					  
	WatchdogTimer timer(
							  clk,
							  rst,
							  tmr_rst,
							  interrupt
							  );

	
	always@(*)
	begin
		case(programcounter_mux)
		2'b11: programcounter_in = programcounter_out + programcounter_immediate;
		2'b10: programcounter_in = 32'd0;
		2'b01: programcounter_in = programcounter_immediate;
		2'b00: programcounter_in = alu_out;//{alu_out[31:1], 1'b0};
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

														 
	reg signed [31:0] num;
	reg signed [3:0]ones, tens, hundreds, thousands, tenthousands, hundredthousands, millions;
	reg signed sign;
	always@(posedge clk)
	begin
		if (register_out_a[31] == 1'b1)
		begin
			num <= (32'sb11111111111111111111111111111111 * register_out_a);
			sign <= 1'b1;
		end
		else
		begin
			num <= (32'sb00000000000000000000000000000001 * register_out_a);
			sign <= 1'b0;
		end
		ones <= num % 32'sd10;
		tens <= (num%32'sd100)/32'sd10;
		hundreds <= (num%32'sd1000)/32'sd100;
		thousands <= (num%32'sd10000)/32'sd1000;
		tenthousands <= (num%32'sd100000)/32'sd10000;
		hundredthousands <= (num%32'sd1000000)/32'sd100000;
		millions <= (num%32'sd10000000)/32'sd1000000;
	end

	always@(posedge clk or negedge rst)
	begin
		if (rst == 1'b0)
		begin
			HEX0 <= 7'b0000001;
			HEX1 <= 7'b0000001;
			HEX2 <= 7'b0000001;
			HEX3 <= 7'b0000001;
			HEX4 <= 7'b0000001;
			HEX5 <= 7'b0000001;
			HEX6 <= 7'b0000001;
			HEX7 <= 7'b1111111;
		end
		
		else if (out_update == 1'b1)
		begin
			case (ones)
				4'd0: HEX0 <= 7'b0000001;
				4'd1: HEX0 <= 7'b1001111;
				4'd2: HEX0 <= 7'b0010010;
				4'd3: HEX0 <= 7'b0000110;
				4'd4: HEX0 <= 7'b1001100;
				4'd5: HEX0 <= 7'b0100100;
				4'd6: HEX0 <= 7'b0100000;
				4'd7: HEX0 <= 7'b0001111;
				4'd8: HEX0 <= 7'b0000000;
				4'd9: HEX0 <= 7'b0001100;
				default: HEX0 <= 7'b0110000;
			endcase
			case (tens)
				4'd0: HEX1 <= 7'b0000001;
				4'd1: HEX1 <= 7'b1001111;
				4'd2: HEX1 <= 7'b0010010;
				4'd3: HEX1 <= 7'b0000110;
				4'd4: HEX1 <= 7'b1001100;
				4'd5: HEX1 <= 7'b0100100;
				4'd6: HEX1 <= 7'b0100000;
				4'd7: HEX1 <= 7'b0001111;
				4'd8: HEX1 <= 7'b0000000;
				4'd9: HEX1 <= 7'b0001100;
				default: HEX1 <= 7'b0110000;
			endcase
			case (hundreds)
				4'd0: HEX2 <= 7'b0000001;
				4'd1: HEX2 <= 7'b1001111;
				4'd2: HEX2 <= 7'b0010010;
				4'd3: HEX2 <= 7'b0000110;
				4'd4: HEX2 <= 7'b1001100;
				4'd5: HEX2 <= 7'b0100100;
				4'd6: HEX2 <= 7'b0100000;
				4'd7: HEX2 <= 7'b0001111;
				4'd8: HEX2 <= 7'b0000000;
				4'd9: HEX2 <= 7'b0001100;
				default: HEX2 <= 7'b0110000;
			endcase
			case (thousands)
				4'd0: HEX3 <= 7'b0000001;
				4'd1: HEX3 <= 7'b1001111;
				4'd2: HEX3 <= 7'b0010010;
				4'd3: HEX3 <= 7'b0000110;
				4'd4: HEX3 <= 7'b1001100;
				4'd5: HEX3 <= 7'b0100100;
				4'd6: HEX3 <= 7'b0100000;
				4'd7: HEX3 <= 7'b0001111;
				4'd8: HEX3 <= 7'b0000000;
				4'd9: HEX3 <= 7'b0001100;
				default: HEX3 <= 7'b0110000;
			endcase
			case (tenthousands)
				4'd0: HEX4 <= 7'b0000001;
				4'd1: HEX4 <= 7'b1001111;
				4'd2: HEX4 <= 7'b0010010;
				4'd3: HEX4 <= 7'b0000110;
				4'd4: HEX4 <= 7'b1001100;
				4'd5: HEX4 <= 7'b0100100;
				4'd6: HEX4 <= 7'b0100000;
				4'd7: HEX4 <= 7'b0001111;
				4'd8: HEX4 <= 7'b0000000;
				4'd9: HEX4 <= 7'b0001100;
				default: HEX4 <= 7'b0110000;
			endcase
			case (hundredthousands)
				4'd0: HEX5 <= 7'b0000001;
				4'd1: HEX5 <= 7'b1001111;
				4'd2: HEX5 <= 7'b0010010;
				4'd3: HEX5 <= 7'b0000110;
				4'd4: HEX5 <= 7'b1001100;
				4'd5: HEX5 <= 7'b0100100;
				4'd6: HEX5 <= 7'b0100000;
				4'd7: HEX5 <= 7'b0001111;
				4'd8: HEX5 <= 7'b0000000;
				4'd9: HEX5 <= 7'b0001100;
				default: HEX5 <= 7'b0110000;
			endcase
			case (millions)
				4'd0: HEX6 <= 7'b0000001;
				4'd1: HEX6 <= 7'b1001111;
				4'd2: HEX6 <= 7'b0010010;
				4'd3: HEX6 <= 7'b0000110;
				4'd4: HEX6 <= 7'b1001100;
				4'd5: HEX6 <= 7'b0100100;
				4'd6: HEX6 <= 7'b0100000;
				4'd7: HEX6 <= 7'b0001111;
				4'd8: HEX6 <= 7'b0000000;
				4'd9: HEX6 <= 7'b0001100;
				default: HEX6 <= 7'b0110000;
			endcase
			case (sign)
				1'sb1: HEX7 <= 7'b1111110;
				1'sb0: HEX7 <= 7'b1111111;
			endcase
		end
end														 
														 

endmodule