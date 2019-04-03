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
input [2:0]op;

output [2:0]status;
output [31:0]out;
reg [2:0]status;
reg [31:0]out;


//------------------------------------------------------------------
//                 -- Begin Declarations & Coding --                  
//------------------------------------------------------------------

parameter ADD = 3'd0,
			 SUB = 3'd1,
			 AND = 3'd2,
			 OR =  3'd3,
			 XOR = 3'd4,
			 SLL = 3'd5,
			 SRL = 3'd6,
			 SRA = 3'd7;



always @(*)
begin

// out: out

	case (op)
		ADD: out = in_a + in_b;
		SUB: out = in_a - in_b;
		AND: out = in_a & in_b;
		OR:  out = in_a | in_b;
		XOR: out = in_a ^ in_b;
		SLL: out = in_a << in_b;
		SRL: out = in_a >> in_b;
		SRA: out = $signed(in_a) >>> $signed(in_b);
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