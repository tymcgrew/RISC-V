/*
	Memory modules logic unit
		
		- Allows four parralel memory modules to act as one cohesive module to outside user
		- Determines addresses, data, and wren to respective modules based on offset and width
		- Also determines output based on offset
*/


module Memory(clk, address, in, wren, width, out);

	input clk;
	input [9:0]address;
	input [31:0]in;
	input wren;
	input [1:0]width;
	output [31:0]out;
	reg [31:0]out;

	reg [5:0]mem3address, mem2address, mem1address, mem0address;

	wire [7:0]mem3out, mem2out, mem1out, mem0out;

	reg mem3wren, mem2wren, mem1wren, mem0wren;
	reg [7:0]mem3in, mem2in, mem1in, mem0in;

	parameter BYTE = 2'b00,
				 HALF = 2'b01,
				 WORD = 2'b11;

	parameter SIGNED = 1'b1,
				 UNSIGNED = 1'b0;

	always@(*)
	begin

		if (address % 4 == 6'd0)
		begin
		
			mem3address = address >> 2;
			mem2address = address >> 2;
			mem1address = address >> 2;
			mem0address = address >> 2;
							
			out = {mem3out, mem2out, mem1out, mem0out};
		
			case(width)
			
				BYTE:
				begin
					if (wren == 1'b1)
						mem3wren = 1'b1;
					else
						mem3wren = 1'b0;
					mem2wren = 1'b0;
					mem1wren = 1'b0;
					mem0wren = 1'b0;
					
					mem3in = in[7:0];
					mem2in = 8'd0;
					mem1in = 8'd0;
					mem0in = 8'd0;					
				end
				
				
				HALF:
				begin
					if (wren == 1'b1)
					begin
						mem3wren = 1'b1;
						mem2wren = 1'b1;
					end
					else
					begin
						mem3wren = 1'b0;
						mem2wren = 1'b0;
					end
					mem1wren = 1'b0;
					mem0wren = 1'b0;
					
					mem3in = in[15:8];
					mem2in = in[7:0];
					mem1in = 8'd0;
					mem0in = 8'd0;					
				end
				
				
				default:   // word
				begin
					if (wren == 1'b1)
					begin
						mem3wren = 1'b1;
						mem2wren = 1'b1;
						mem1wren = 1'b1;
						mem0wren = 1'b1;
					end
					else
					begin
						mem3wren = 1'b0;
						mem2wren = 1'b0;
						mem1wren = 1'b0;
						mem0wren = 1'b0;
					end
					
					mem3in = in[31:24];
					mem2in = in[23:16];
					mem1in = in[15:8];
					mem0in = in[7:0];
				end	
				
				
			endcase		
		end
		
		else if (address % 4 == 6'd1)
		begin
		
			mem2address = address >> 2;
			mem1address = address >> 2;
			mem0address = address >> 2;
			mem3address = (address + 6'd3) >> 2;
			
			out = {mem2out, mem1out, mem0out, mem3out};
		
			case(width)
		
			
				BYTE:
				begin
					mem3wren = 1'b0;
					if (wren == 1'b1)
						mem2wren = 1'b1;
					else
						mem2wren = 1'b0;
					mem1wren = 1'b0;
					mem0wren = 1'b0;
	
					mem2in = in[7:0];
					mem1in = 8'd0;
					mem0in = 8'd0;
					mem3in = 8'd0;	
	
				end
		
		
				HALF:
				begin
					mem3wren = 1'b0;
					if (wren == 1'b1)
					begin
						mem2wren = 1'b1;
						mem1wren = 1'b1;
					end
					else
					begin
						mem2wren = 1'b0;
						mem1wren = 1'b0;
					end
					mem0wren = 1'b0;
					
					mem2in = in[15:8];
					mem1in = in[7:0];
					mem0in = 8'd0;
					mem3in = 8'd0;		
				end


				default:   // word
				begin
					if (wren == 1'b1)
					begin
						mem2wren = 1'b1;
						mem1wren = 1'b1;
						mem0wren = 1'b1;
						mem3wren = 1'b1;
					end
					else
					begin
						mem2wren = 1'b0;
						mem1wren = 1'b0;
						mem0wren = 1'b0;
						mem3wren = 1'b0;
					end
					
					mem2in = in[31:24];
					mem1in = in[23:16];
					mem0in = in[15:8];
					mem3in = in[7:0];
				end	
				
			endcase		
		end
		
		else if (address % 4 == 6'd2)
		begin
		
			mem1address = address >> 2;
			mem0address = address >> 2;
			mem3address = (address + 6'd2) >> 2;
			mem2address = (address + 6'd2) >> 2;
					
			out = {mem1out, mem0out, mem3out, mem2out};
		
			case(width)
			
			
				BYTE:
				begin
					mem3wren = 1'b0;
					mem2wren = 1'b0;
					if (wren == 1'b1)
						mem1wren = 1'b1;
					else
						mem1wren = 1'b0;
					mem0wren = 1'b0;
					
					mem1in = in[7:0];
					mem0in = 8'd0;
					mem3in = 8'd0;
					mem2in = 8'd0;							
				end	
				
				
				HALF:
				begin
					mem3wren = 1'b0;
					mem2wren = 1'b0;
					if (wren == 1'b1)
					begin
						mem1wren = 1'b1;
						mem0wren = 1'b1;
					end
					else
					begin
						mem1wren = 1'b0;
						mem0wren = 1'b0;
					end
					
					mem1in = in[15:8];
					mem0in = in[7:0];
					mem3in = 8'd0;
					mem2in = 8'd0;							
				end
				
				
				default:   // word
				begin
					if (wren == 1'b1)
					begin
						mem1wren = 1'b1;
						mem0wren = 1'b1;
						mem3wren = 1'b1;
						mem2wren = 1'b1;
					end
					else
					begin
						mem1wren = 1'b0;
						mem0wren = 1'b0;
						mem3wren = 1'b0;
						mem2wren = 1'b0;
					end
					
					mem1in = in[31:24];
					mem0in = in[23:16];
					mem3in = in[15:8];
					mem2in = in[7:0];
				end	
				
				
			endcase		
		end
		
		else
		begin
		
			mem0address = address >> 2;
			mem3address = (address + 6'd1) >> 2;
			mem2address = (address + 6'd1) >> 2;
			mem1address = (address + 6'd1) >> 2;
					
			out = {mem0out, mem3out, mem2out, mem1out};	
		
			case(width)
			
			
				BYTE:
				begin
					mem3wren = 1'b0;
					mem2wren = 1'b0;
					mem1wren = 1'b0;
					if (wren == 1'b1)
						mem0wren = 1'b1;
					else
						mem0wren = 1'b0;
						
					mem0in = in[7:0];
					mem3in = 8'd0;
					mem2in = 8'd0;
					mem1in = 8'd0;	
				end		
			
		
				HALF:
				begin
					if (wren == 1'b1)
					begin
						mem0wren = 1'b1;
						mem3wren = 1'b1;
					end
					else
					begin
						mem0wren = 1'b0;
						mem3wren = 1'b0;
					end
					mem2wren = 1'b0;
					mem1wren = 1'b0;
					
					mem0in = in[15:8];
					mem3in = in[7:0];
					mem2in = 8'd0;
					mem1in = 8'd0;		
				end	
				
				
				default:   // word
				begin
					if (wren == 1'b1)
					begin
						mem0wren = 1'b1;
						mem3wren = 1'b1;
						mem2wren = 1'b1;
						mem1wren = 1'b1;
					end
					else
					begin
						mem0wren = 1'b0;
						mem3wren = 1'b0;
						mem2wren = 1'b0;
						mem1wren = 1'b0;
					end
					
					mem0in = in[31:24];
					mem3in = in[23:16];
					mem2in = in[15:8];
					mem1in = in[7:0];
				end	
				
				
			endcase		
		end
		
	end

	MemoryModule3 mem3(mem3address, clk, mem3in, mem3wren, mem3out);
	MemoryModule2 mem2(mem2address, clk, mem2in, mem2wren, mem2out);
	MemoryModule1 mem1(mem1address, clk, mem1in, mem1wren, mem1out);
	MemoryModule0 mem0(mem0address, clk, mem0in, mem0wren, mem0out);


endmodule