module ALU (	
	in_a,
	in_b,
	op,

	status,
	out	
);


//------------------------------------------------------------------
//                 -- Input/output Declarations --                  
//------------------------------------------------------------------
input [31:0]in_a;
input [31:0]in_b;
input [3:0]op;

output [2:0]status;
output [31:0]out;
reg [2:0]status;
reg [31:0]out;


//------------------------------------------------------------------
//                 -- Begin Declarations & Coding --                  
//------------------------------------------------------------------

parameter   ADD = 4'd0,
				SUB = 4'd1,
				AND = 4'd2,
				OR =  4'd3,
				XOR = 4'd4,
				SLL = 4'd5,
				SRL = 4'd6,
				SRA = 4'd7,
				MUL = 4'd8;

			
always @(*)
begin

// out: out

	case (op)
		ADD: out = in_a + in_b;
		SUB: out = in_a - in_b;
		AND: out = in_a & in_b;
		OR:  out = in_a | in_b;
		XOR: out = in_a ^ in_b;
		
		// Note: Shift amount from in_a, value in in_B
		SLL: out = in_b << in_a[4:0];
		SRL: out = in_b >> in_a[4:0];
		SRA: out = $signed(in_b) >>> $signed(in_a[4:0]);
		MUL: out = in_a * in_b;
		default: out = in_a + in_b;
	endcase
		
		
		
		
// STATUS REGISTERS: status

	// equal
	if (in_a == in_b)
		status[0] = 1'b1;
	else
		status[0] = 1'b0;
			
	// less than signed		
	if (	(in_a[31] == 1'b1 && in_b[31] == 1'b0) || (in_a[31] == in_b[31] && in_a < in_b) )
		status[1] = 1'b1;
	else
		status[1] = 1'b0;
		
	// less than unsigned
	if (in_a < in_b)
		status[2] = 1'b1;
	else
		status[2] = 1'b0;
	
end



endmodule