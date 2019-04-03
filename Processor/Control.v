module Control(
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


//------------------------------------------------------------------
//                 -- Input/Output Declarations --                  
//------------------------------------------------------------------

input rst;

output [4:0]register_address_a, register_address_b;
reg [4:0]register_address_a, register_address_b;
output register_wren_a;
reg register_wren_a;
	
output [2:0]alu_op;
reg [2:0]alu_op;
	
output memory_wren;
reg memory_wren;
output [1:0]memory_width;
reg [1:0]memory_width;
output memory_sign;
reg memory_sign;
	
output programcounter_wren;
reg programcounter_wren;
output programcounter_add_or_set;
reg programcounter_add_or_set;
output [9:0]programcounter_value;
reg [9:0]programcounter_value;
	
output instructionregister_wren;
reg instructionregister_wren;

//------------------------------------------------------------------
//                  -- State & Reg Declarations  --                   
//------------------------------------------------------------------

parameter LUI = 6'd0,
          AUIPC = 6'd1,
          JAL = 6'd2,
          JALR = 6'd3,
          BEQ = 6'd4,
          BNE = 6'd5,
          BLT = 6'd6,
          BGE = 6'd7,
          BLTU = 6'd8,
          BGEU = 6'd9,
          LB = 6'd10,
          LH = 6'd11,
          LW = 6'd12,
          LBU = 6'd13,
          LHU = 6'd14,
          SB = 6'd15,
          SH = 6'd16,
          SW = 6'd17,
          ADDI = 6'd18,
          SLTI = 6'd19,
          SLTIU = 6'd20,
          XORI = 6'd21,
          ORI = 6'd22,
          ANDI = 6'd23,
          SLLI = 6'd24,
          SRLI = 6'd25,
          SRAI = 6'd26,
          ADD = 6'd27,
          SUB = 6'd28,
          SLL = 6'd29,
          SLT = 6'd30,
          SLTU = 6'd31,
          XOR = 6'd32,
          SRL = 6'd33,
          SRA = 6'd34,
          OR = 6'd35,
          AND = 6'd36,
          ECALL = 6'd37;

reg [5:0]STATE, NEXT_STATE;


//------------------------------------------------------------------
//                 -- Begin Declarations & Coding --                  
//------------------------------------------------------------------

always@(posedge clk or negedge rst)     // Determine STATE
begin

	if (rst == 1'b0)
		STATE <= #####;
	else
		STATE <= NEXT_STATE;

end


always@(*)                              // Determine NEXT_STATE
begin
	case(STATE)

	LUI:
	begin
		NEXT_STATE = #####;
	end

	AUIPC:
	begin
		NEXT_STATE = #####;
	end

	JAL:
	begin
		NEXT_STATE = #####;
	end

	JALR:
	begin
		NEXT_STATE = #####;
	end

	BEQ:
	begin
		NEXT_STATE = #####;
	end

	BNE:
	begin
		NEXT_STATE = #####;
	end

	BLT:
	begin
		NEXT_STATE = #####;
	end

	BGE:
	begin
		NEXT_STATE = #####;
	end

	BLTU:
	begin
		NEXT_STATE = #####;
	end

	BGEU:
	begin
		NEXT_STATE = #####;
	end

	LB:
	begin
		NEXT_STATE = #####;
	end

	LH:
	begin
		NEXT_STATE = #####;
	end

	LW:
	begin
		NEXT_STATE = #####;
	end

	LBU:
	begin
		NEXT_STATE = #####;
	end

	LHU:
	begin
		NEXT_STATE = #####;
	end

	SB:
	begin
		NEXT_STATE = #####;
	end

	SH:
	begin
		NEXT_STATE = #####;
	end

	SW:
	begin
		NEXT_STATE = #####;
	end

	ADDI:
	begin
		NEXT_STATE = #####;
	end

	SLTI:
	begin
		NEXT_STATE = #####;
	end

	SLTIU:
	begin
		NEXT_STATE = #####;
	end

	XORI:
	begin
		NEXT_STATE = #####;
	end

	ORI:
	begin
		NEXT_STATE = #####;
	end

	ANDI:
	begin
		NEXT_STATE = #####;
	end

	SLLI:
	begin
		NEXT_STATE = #####;
	end

	SRLI:
	begin
		NEXT_STATE = #####;
	end

	SRAI:
	begin
		NEXT_STATE = #####;
	end

	ADD:
	begin
		NEXT_STATE = #####;
	end

	SUB:
	begin
		NEXT_STATE = #####;
	end

	SLL:
	begin
		NEXT_STATE = #####;
	end

	SLT:
	begin
		NEXT_STATE = #####;
	end

	SLTU:
	begin
		NEXT_STATE = #####;
	end

	XOR:
	begin
		NEXT_STATE = #####;
	end

	SRL:
	begin
		NEXT_STATE = #####;
	end

	SRA:
	begin
		NEXT_STATE = #####;
	end

	OR:
	begin
		NEXT_STATE = #####;
	end

	AND:
	begin
		NEXT_STATE = #####;
	end

	ECALL:
	begin
		NEXT_STATE = #####;
	end

	default:
	begin
		NEXT_STATE = #####;
	end

	endcase
end


always@(posedge clk or negedge rst)     // Determine outputs
begin

	if (rst == 1'b0)
	begin

		#####;

	end

	else
	begin
		case(STATE)

		LUI:
		begin
			##### <= #####;
		end

		AUIPC:
		begin
			##### <= #####;
		end

		JAL:
		begin
			##### <= #####;
		end

		JALR:
		begin
			##### <= #####;
		end

		BEQ:
		begin
			##### <= #####;
		end

		BNE:
		begin
			##### <= #####;
		end

		BLT:
		begin
			##### <= #####;
		end

		BGE:
		begin
			##### <= #####;
		end

		BLTU:
		begin
			##### <= #####;
		end

		BGEU:
		begin
			##### <= #####;
		end

		LB:
		begin
			##### <= #####;
		end

		LH:
		begin
			##### <= #####;
		end

		LW:
		begin
			##### <= #####;
		end

		LBU:
		begin
			##### <= #####;
		end

		LHU:
		begin
			##### <= #####;
		end

		SB:
		begin
			##### <= #####;
		end

		SH:
		begin
			##### <= #####;
		end

		SW:
		begin
			##### <= #####;
		end

		ADDI:
		begin
			##### <= #####;
		end

		SLTI:
		begin
			##### <= #####;
		end

		SLTIU:
		begin
			##### <= #####;
		end

		XORI:
		begin
			##### <= #####;
		end

		ORI:
		begin
			##### <= #####;
		end

		ANDI:
		begin
			##### <= #####;
		end

		SLLI:
		begin
			##### <= #####;
		end

		SRLI:
		begin
			##### <= #####;
		end

		SRAI:
		begin
			##### <= #####;
		end

		ADD:
		begin
			##### <= #####;
		end

		SUB:
		begin
			##### <= #####;
		end

		SLL:
		begin
			##### <= #####;
		end

		SLT:
		begin
			##### <= #####;
		end

		SLTU:
		begin
			##### <= #####;
		end

		XOR:
		begin
			##### <= #####;
		end

		SRL:
		begin
			##### <= #####;
		end

		SRA:
		begin
			##### <= #####;
		end

		OR:
		begin
			##### <= #####;
		end

		AND:
		begin
			##### <= #####;
		end

		ECALL:
		begin
			##### <= #####;
		end

		endcase
	end

end


endmodule