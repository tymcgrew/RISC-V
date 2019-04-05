module GenericRegister(clk, rst, in, out, wren);

input rst, clk;
input wren;
input [31:0]in;

output [31:0]out;
reg [31:0]out;

always@(posedge clk or negedge rst)
begin

	if (rst == 1'b0)
		out <= 32'd0;
		
	else if (wren == 1'b1)
		out <= in;	

end

endmodule