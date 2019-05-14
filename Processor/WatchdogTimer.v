module WatchdogTimer(clk, rst, in, interrupt);

	input clk, rst;
	input in;
	output reg interrupt;
	
	parameter THRESHOLD = 32'd150000000;

	reg [31:0]counter;
	
	always@(posedge clk or negedge rst)
	begin
		if (rst == 1'b0)
		begin
			interrupt <= 1'b0;
			counter <= 32'd0;
		end
		
		else
		begin
		
			if (in == 1'b0)
			begin
				interrupt <= 1'b0;
				counter <= 32'd0;
			end
			
			else if (counter >= THRESHOLD)
			begin
				interrupt <= 1'b1;
			end
			
			else
			begin
				counter <= counter + 1'd1;
				interrupt <= 1'b0;
			end
			
		end		
	end

endmodule