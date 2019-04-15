module Control(
					clk,
					rst,
					
					SW,
					LEDG0,
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
						 
						 
					// programcounter
					programcounter_wren,
					programcounter_mux,
					programcounter_immediate,						 
						 
						 
					// instructionregister
					instructionregister_wren,
					
					out_update,
					
					STATE
					);


//------------------------------------------------------------------
//                 -- Input/Output Declarations --                  
//------------------------------------------------------------------

input clk, rst;
input [31:0]SW;


output LEDG0;
reg LEDG0;


output [5:0]STATE;

input KEY0;
input [31:0]register_out_b;
input [2:0]alu_status;
input [31:0]instruction;

output [4:0]register_address_a;
output [4:0]register_address_b;
reg [4:0]register_address_a;
reg [4:0]register_address_b;
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
output [31:0]programcounter_immediate;
reg [31:0]programcounter_immediate;
	
output instructionregister_wren;
reg instructionregister_wren;

output out_update;
reg out_update;

//------------------------------------------------------------------
//                  -- State & Reg Declarations  --                   
//------------------------------------------------------------------

reg [26:0]counter;

parameter START = 6'd0,
          WAIT1 = 6'd1,
          WAIT2 = 6'd2,
          FETCH = 6'd3,
          DECODE = 6'd4,
          LUI = 6'd5,
          AUIPC = 6'd6,
          JAL1 = 6'd7,
          JAL2 = 6'd8,
          JALR1 = 6'd9,
          JALR2 = 6'd10,
          JALR3 = 6'd11,
          BRANCH1 = 6'd12,
          BRANCH2 = 6'd13,
          LOAD = 6'd14,
          STORE = 6'd15,
          REGI1 = 6'd16,
			 REGI2 = 6'd41,
          REGISHIFT = 6'd17,
          SETONI = 6'd18,
          SETON = 6'd19,
          SETZERO = 6'd20,
          SETONE = 6'd21,
          REGREG1 = 6'd22,
          REGREG2 = 6'd23,
          FENCE = 6'd24,
          FENCEI = 6'd25,
          ECALL = 6'd26,
          PRINT = 6'd27,
          READ1 = 6'd28,
          READ2 = 6'd29,
          EXIT = 6'd30,
          EBREAK = 6'd31,
          CSSRW = 6'd32,
          CSRRS = 6'd33,
          CSRRC = 6'd34,
          CSRRWI = 6'd35,
          CSRRSI = 6'd36,
          CSRRCI = 6'd37,
          RESETA = 6'd38,
          INCREMENTPC = 6'd39,
          RESETB = 6'd40;

reg [5:0]STATE, NEXT_STATE;


//------------------------------------------------------------------
//                 -- Begin Declarations & Coding --                  
//------------------------------------------------------------------

always@(posedge clk or negedge rst)     // Determine STATE
begin

	if (rst == 1'b0)
		STATE <= START;
	else
		STATE <= NEXT_STATE;

end


always@(*)                              // Determine NEXT_STATE
begin
	case(STATE)

	START:
	begin
		NEXT_STATE = WAIT1;
	end

	WAIT1:
	begin
		NEXT_STATE = WAIT2;//(counter < 27'd10000000)? WAIT1 : WAIT2;
	end

	WAIT2:
	begin
		NEXT_STATE = FETCH;
	end

	FETCH:
	begin
		NEXT_STATE = (counter < 27'd3)? FETCH : DECODE;
	end

	DECODE:
	begin
		case (instruction[6:0])
			7'b0110111: NEXT_STATE = LUI;
			7'b0010111: NEXT_STATE = AUIPC;
			7'b1101111: NEXT_STATE = JAL1;
			7'b1100111: NEXT_STATE = JALR1;
			7'b1100011: NEXT_STATE = BRANCH1;
			7'b0000011: NEXT_STATE = LOAD;
			7'b0100011: NEXT_STATE = STORE;
			7'b0010011:
			begin
				if (instruction[14:12] == 3'b111 || instruction[14:12] == 3'b110 || instruction[14:12] == 3'b100 || instruction[14:12] == 3'b000)
					NEXT_STATE = REGI1;
				else if (instruction[14:12] == 3'b001 || instruction[14:12] == 3'b101 || instruction[14:12] == 3'b111)
					NEXT_STATE = REGISHIFT;
				else
					NEXT_STATE = SETONI;
			end
			7'b0110011: NEXT_STATE = (instruction[14:12] == 3'b010 || instruction[14:12] == 3'b011)? SETON : REGREG1;
			7'b1110011: NEXT_STATE = (instruction[19:12] == 8'b00000000 && instruction[20] == 1'b0)? ECALL : EXIT;
			default: NEXT_STATE = EXIT;
		endcase
	end

	LUI:
	begin
		NEXT_STATE = RESETA;
	end

	AUIPC:
	begin
		NEXT_STATE = RESETA;
	end

	JAL1:
	begin
		NEXT_STATE = JAL2;
	end

	JAL2:
	begin
		NEXT_STATE = RESETB;
	end

	JALR1:
	begin
		NEXT_STATE = JALR2;
	end

	JALR2:
	begin
		NEXT_STATE = JALR3;
	end

	JALR3:
	begin
		NEXT_STATE = RESETB;
	end

	BRANCH1:
	begin
		if (counter < 27'd2)
			NEXT_STATE = BRANCH1;
		else
			NEXT_STATE = (
						  (instruction[14:12] == 3'b000 && alu_status[0] == 1'b1) ||        // BEQ
						  (instruction[14:12] == 3'b001 && alu_status[0] == 1'b0) ||        // BNE
						  (instruction[14:12] == 3'b100 && alu_status[1] == 1'b1) ||        // BLT
						  (instruction[14:12] == 3'b101 && alu_status[1] == 1'b0) ||        // BGE
						  (instruction[14:12] == 3'b110 && alu_status[2] == 1'b1) ||        // BLTU
						  (instruction[14:12] == 3'b111 && alu_status[2] == 1'b0)           // BGEU
						  )? BRANCH2 : RESETA;
	end

	BRANCH2:
	begin
		NEXT_STATE = RESETB;
	end

	LOAD:
	begin
		NEXT_STATE = (counter < 27'd5)? LOAD : RESETA;
	end

	STORE:
	begin
		NEXT_STATE = (counter < 27'd4)? STORE : RESETA;
	end

	REGI1:
	begin
		NEXT_STATE = (counter < 27'd2)? REGI1 : REGI2;
	end

	REGI2:
	begin
		NEXT_STATE = RESETA;
	end
	
	REGISHIFT:
	begin
		NEXT_STATE = (counter < 27'd2)? REGISHIFT : RESETA;
	end

	SETONI:
	begin
		NEXT_STATE = (counter < 27'd2)? SETONI : RESETA;
	end

	SETON:
	begin
		NEXT_STATE = (instruction[14:12] == 3'b010 && alu_status[1] == 1'b1 || instruction[14:12] == 3'b011 && alu_status[2] == 1'b1)? SETONE : SETZERO;
	end

	SETZERO:
	begin
		NEXT_STATE = RESETA;
	end

	SETONE:
	begin
		NEXT_STATE = RESETA;
	end

	REGREG1:
	begin
		NEXT_STATE = REGREG2;
	end

	REGREG2:
	begin
		NEXT_STATE = RESETA;
	end

	FENCE:
	begin
		NEXT_STATE = EXIT;
	end

	FENCEI:
	begin
		NEXT_STATE = EXIT;
	end

	ECALL:
	begin
		if (counter < 27'd2)
			NEXT_STATE = ECALL;
		else
		begin
			case (register_out_b)
				32'd1: NEXT_STATE = PRINT;
				32'd5: NEXT_STATE = READ1;
				default: NEXT_STATE = EXIT;
			endcase
		end
	end

	PRINT:
	begin
		NEXT_STATE = (counter < 27'd6)? PRINT : RESETA;
	end

	READ1:
	begin
		NEXT_STATE = (KEY0 == 1'b1)? READ1 : READ2; 
	end

	READ2:
	begin
		NEXT_STATE = (counter < 27'd10000000)? READ2 : RESETA;
	end

	EXIT:
	begin
		NEXT_STATE = EXIT;
	end

	EBREAK:
	begin
		NEXT_STATE = EXIT;
	end

	CSSRW:
	begin
		NEXT_STATE = EXIT;
	end

	CSRRS:
	begin
		NEXT_STATE = EXIT;
	end

	CSRRC:
	begin
		NEXT_STATE = EXIT;
	end

	CSRRWI:
	begin
		NEXT_STATE = EXIT;
	end

	CSRRSI:
	begin
		NEXT_STATE = EXIT;
	end

	CSRRCI:
	begin
		NEXT_STATE = EXIT;
	end

	RESETA:
	begin
		NEXT_STATE = INCREMENTPC;
	end

	INCREMENTPC:
	begin
		NEXT_STATE = RESETB;
	end

	RESETB:
	begin
		NEXT_STATE = FETCH;
	end

	default:
	begin
		NEXT_STATE = EXIT;
	end

	endcase
end


always@(posedge clk or negedge rst)     // Determine outputs
begin

	if (rst == 1'b0)
	begin
		register_address_a <= 5'd0;
		register_address_b <= 5'd0;
		register_wren <= 1'd0;
		register_mux <= 2'd0;
		register_immediate <= 32'd0;
		result_wren <= 1'd0;
						 
		alu_a_mux <= 1'd0;
		alu_b_mux <= 1'd0;
		alu_immediate <= 32'd0;
		alu_op <= 3'd0;
						 	 
		memory_wren <= 1'b0;
		memory_width <= 2'd0;
		memory_sign <= 1'd0;
		memory_mux <= 1'd0;
						 
		programcounter_wren <= 1'd0;
		programcounter_mux <= 2'd0;
		programcounter_immediate <= 32'd0;						 
						 
		instructionregister_wren <= 1'd0;
					
		out_update <= 1'd0;
		
		LEDG0 <= 1'b0;
	end

	else
	begin
		case(STATE)

		START:
		begin
			register_address_a <= 5'd0;
			register_address_b <= 5'd0;
			register_wren <= 1'd0;
			register_mux <= 2'd0;
			register_immediate <= 32'd0;
			result_wren <= 1'd0;
							 
			alu_a_mux <= 1'd0;
			alu_b_mux <= 1'd0;
			alu_immediate <= 32'd0;
			alu_op <= 3'd0;
								 
			memory_wren <= 1'b0;
			memory_width <= 2'd0;
			memory_sign <= 1'd0;
			memory_mux <= 1'd0;
							 
			programcounter_wren <= 1'd0;
			programcounter_mux <= 2'd0;
			programcounter_immediate <= 32'd0;						 
							 
			instructionregister_wren <= 1'd0;
						
			out_update <= 1'd0;
					
			LEDG0 <= 1'b0;
		end

		WAIT1:
		begin
			counter <= counter + 27'd1;
		end

		WAIT2:
		begin
			counter <= 27'd0;
		end

		FETCH:
		begin
			memory_width <= 2'b11;             // word
			memory_mux <= 1'b0;
			instructionregister_wren <= 1'b1;
			counter <= counter + 27'd1;
		end

		DECODE:
		begin
			instructionregister_wren <= 1'b0;
			counter <= 27'd0;
		end

		LUI:
		begin
			register_address_a <= instruction[11:7];
			register_immediate <= {instruction[31:12], 12'd0};
			register_mux <= 2'b11;
			register_wren <= 1'b1;
		end

		AUIPC:
		begin
			register_address_a <= instruction[11:7];
			alu_immediate <= {instruction[31:12], 12'd0};
			alu_a_mux <= 1'b0;
			alu_b_mux <= 1'b1;
			alu_op <= 3'd0;                  // add
			register_wren <= 1'b1;
		end

		JAL1:
		begin
			alu_a_mux <= 1'b0;
			alu_b_mux <= 1'b1;
			alu_immediate <= 32'd4;
			alu_op <= 3'd0;                   // add
			register_address_a <= instruction[11:7];
			register_wren <= 1'b1;
			register_mux <= 2'b01;
		end

		JAL2:
		begin
			register_wren <= 1'b0;
			programcounter_wren <= 1'b1;
			programcounter_immediate <= {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0};
			programcounter_mux <= 2'b11;
		end

		JALR1:
		begin
			alu_a_mux <= 1'b0;
			alu_b_mux <= 1'b1;
			alu_immediate <= 32'd4;
			alu_op <= 3'd0;                   // add
			register_address_a <= instruction[11:7];
			register_wren <= 1'b1;
			register_mux <= 2'b01;
		end

		JALR2:
		begin
			register_wren <= 1'b0;
			register_address_b <= instruction[19:15];
		end

		JALR3:
		begin
			alu_a_mux <= 1'b0;
			alu_b_mux <= 1'b0;
			alu_immediate <= {{20{instruction[31]}}, instruction[31:20]};
			alu_op <= 3'd0;                   // add
			programcounter_mux <= 2'b00;
			programcounter_wren <= 1'd1;
		end

		BRANCH1:
		begin
			register_address_a <= instruction[19:15];
			register_address_b <= instruction[24:20];
			alu_a_mux <= 1'd1;
			alu_b_mux <= 1'd0;
			counter <= counter + 27'd1;
		end

		BRANCH2:
		begin
			register_wren <= 1'd0;
			programcounter_mux <= 2'b11;
			programcounter_immediate <= {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};
			programcounter_wren <= 1'd1;
		end

		LOAD:
		begin
			alu_a_mux <= 1'd0;
			alu_b_mux <= 1'd0;
			register_address_b <= instruction[19:15];
			alu_immediate <= {{20{instruction[31]}}, instruction[31:20]};
			alu_op <= 3'd0;                   // add

			memory_mux <= 1'd1;
			case (instruction[14:12])
				3'b000: memory_width <= 2'b00;     // byte
				3'b001: memory_width <= 2'b01;     // half
				3'b010: memory_width <= 2'b11;     // word
				3'b100: memory_width <= 2'b00;     // byte
				3'b101: memory_width <= 2'b01;     // half
				default: memory_width <= 2'b11;
			endcase
			memory_sign <= (instruction[14:12] == 3'b000 || instruction[14:12] == 3'b001 || instruction[14:12] == 3'b011)? 1'b1 : 1'b0;    // signed : unsigned

			register_address_a <= instruction[11:7];
			register_wren <= 1'd1;
			register_mux <= 2'b00;

			counter <= counter + 27'd1;
		end

		STORE:
		begin
			alu_a_mux <= 1'd0;
			alu_b_mux <= 1'd0;
			register_address_b <= instruction[19:15];
			alu_immediate <= {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
			alu_op <= 3'd0;                   // add

			register_address_a <= instruction[24:20];
			memory_wren <= 1'd1;
			memory_mux <= 1'd1;
			case (instruction[14:12])
				3'b000: memory_width <= 2'b00;     // byte
				3'b001: memory_width <= 2'b01;     // half
				3'b010: memory_width <= 2'b11;     // word
				default: memory_width <= 2'b11;
			endcase

			counter <= counter + 27'd1;
		end

		REGI1:   // ANDI, ORI, XORI, ADDI
		begin
			alu_a_mux <= 1'b0;
			alu_b_mux <= 1'b0;
			register_address_b <= instruction[19:15];
			alu_immediate <= {{20{instruction[31]}}, instruction[31:20]};
			
			//alu_op:
			if (instruction[14:12] == 3'b111)
				alu_op <= 3'd2;                   // and
			else if (instruction[14:12] == 3'b110)
				alu_op <= 3'd3;                   // or
			else if (instruction[14:12] == 3'b100)
				alu_op <= 3'd4;                   // xor
			else
				alu_op <= 3'd0;                   // add
				
			register_address_a <= instruction[11:7];
			result_wren <= 1'd1;
			register_mux <= 2'b11;
			register_immediate <= 32'd0;
			
			counter <= counter + 27'd1;
		end
		
		REGI2:
		begin
			register_mux <= 2'b10;
			result_wren <= 1'b0;
			register_wren <= 1'b1;
		end

		REGISHIFT: // SLLI, SRLI, SRAI
		begin
			alu_a_mux <= 1'd0;
			alu_b_mux <= 1'd0;
			register_address_b <= instruction[19:15];
			alu_immediate <= {27'd0, instruction[24:20]};
			
			//alu_op:
			if (instruction[14:12] == 3'b001)
				alu_op <= 3'd5;                   // sll
			else if (instruction[30] == 1'b1)
				alu_op <= 3'd7;                   // sra
			else
				alu_op <= 3'd6;                   // srl

			register_address_a <= instruction[11:7];
			register_wren <= 1'd1;
			register_mux <= 2'b01;

			counter <= counter + 27'd1;
		end

		SETONI:  // SLTI, SLTIU
		begin
			alu_a_mux <= 1'd0;
			alu_b_mux <= 1'd0;
			alu_immediate <= {{12{instruction[31]}}, instruction[31:20]};
			register_address_b <= instruction[19:15];

			register_immediate <= (instruction[14:12] == 3'b010 && alu_status[1] == 1'b0 || instruction[14:12] == 011 && alu_status[2] == 1'b0)? 32'd1 : 32'd0;
			register_address_a <= instruction[11:7];
			register_mux <= 2'b11;
			register_wren <= 1'd1;

			counter <= counter + 27'd1;
		end

		SETON:
		begin
			alu_a_mux <= 1'd1;
			alu_b_mux <= 1'd0;
			register_address_a <= instruction[19:15];
			register_address_b <= instruction[24:20];
		end

		SETZERO:
		begin
			register_immediate <= 32'd0;
			register_address_a <= instruction[11:7];
			register_wren <= 1'd1;
			register_mux <= 2'b11;
		end

		SETONE:
		begin
			register_immediate <= 32'd1;
			register_address_a <= instruction[11:7];
			register_wren <= 1'd1;
			register_mux <= 2'b11;
		end

		REGREG1:  // AND, OR, XOR, ADD, SUB, SLL, SRL, SRA
		begin
			alu_a_mux <= 1'd1;
			alu_b_mux <= 1'd0;
			register_address_a <= instruction[19:15];
			register_address_b <= instruction[24:20];
			
			case(instruction[14:12])
				3'b000: alu_op <= (instruction[30] == 1'b1)? 3'd1 : 3'd0;     // sub : add
				3'b001: alu_op <= 3'd5;                                       // sll
				3'b100: alu_op <= 3'd4;                                       // xor
				3'b101: alu_op <= (instruction[30] == 1'b1)? 3'd7 : 3'd6;     // sra : srl
				3'b110: alu_op <= 3'd3;                                       // or
				3'b111: alu_op <= 3'd2;                                       // and
			endcase
			
			result_wren <= 1'd1;
		end

		REGREG2:
		begin
			result_wren <= 1'd0;
			register_address_a <= instruction[11:7];
			register_wren <= 1'd1;
			register_mux <= 2'b01;
		end

		FENCE:
		begin
		end

		FENCEI:
		begin
		end

		ECALL:
		begin
			counter<= counter + 27'd1;
			register_address_b <= 5'd10;              //a0
		end

		PRINT:
		begin
			register_address_a <= 5'd11;
			out_update <= 1'd1;
			counter <= counter + 27'd1;
		end

		READ1:
		begin
			register_address_a <= 5'd10;
			alu_immediate <= SW;
			register_mux <= 2'b11;
			register_wren <= 1'd1;
			counter <= 27'd0;
		end

		READ2:
		begin
			register_wren <= 1'd0;
			counter <= counter + 27'd1;
		end

		EXIT:
		begin
			LEDG0 <= 1'b1;
		end

		EBREAK:
		begin
		end

		CSSRW:
		begin
		end

		CSRRS:
		begin
		end

		CSRRC:
		begin
		end

		CSRRWI:
		begin
		end

		CSRRSI:
		begin
		end

		CSRRCI:
		begin
		end

		RESETA:
		begin
			counter <= 27'd0;
			register_wren <= 1'd0;
			result_wren <= 1'd0;
			memory_wren <= 1'd0;
			programcounter_wren <= 1'd0;
			instructionregister_wren <= 1'd0;
			out_update <= 1'd0;
		end

		INCREMENTPC:
		begin
			programcounter_wren <= 1'b1;
			programcounter_mux <= 2'b11;
			programcounter_immediate <= 32'd4;
			memory_mux <= 1'b0;
		end

		RESETB:
		begin
			counter <= 27'd0;
			register_wren <= 1'd0;
			result_wren <= 1'd0;
			memory_wren <= 1'd0;
			programcounter_wren <= 1'd0;
			instructionregister_wren <= 1'd0;
			out_update <= 1'd0;
		end

		endcase
	end

end


endmodule