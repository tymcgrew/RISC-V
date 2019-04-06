module Memory(clk, address, in, wren, width, sign, out);

input clk;
input [9:0]address;
input [31:0]in;
input wren, sign;
input [1:0]width;
output [31:0]out;
reg [31:0]out;

reg [5:0]address0, address1, address2, address3;

wire [7:0]mem0out, mem1out, mem2out, mem3out;

reg mem0wren, mem1wren, mem2wren, mem3wren;

parameter BYTE = 2'b00,
			 HALF = 2'b01,
			 WORD = 2'b11;

parameter SIGNED = 1'b1,
		  UNSIGNED = 1'b0;

always@(*)
begin

	if (address % 4 == 6'd0)
	begin
		case(width)
		
			BYTE:
			begin
				if (wren == 1'b1)
					mem0wren = 1'b1;
				else
					mem0wren = 1'b0;
				mem1wren = 1'b0;
				mem2wren = 1'b0;
				mem3wren = 1'b0;
				
				address0 = address / 10'd4;
				address1 = 6'd0;
				address2 = 6'd0;
				address3 = 6'd0;
						
				if (sign == SIGNED)
					out = {{24{mem0out[7]}}, mem0out};
				else
					out = {24'd0, mem0out};
			end
			
			HALF:
			begin
				if (wren == 1'b1)
				begin
					mem0wren = 1'b1;
					mem1wren = 1'b1;
				end
				else
				begin
					mem0wren = 1'b0;
					mem1wren = 1'b0;
				end
				mem2wren = 1'b0;
				mem3wren = 1'b0;
				
				address0 = address / 10'd4;
				address1 = address / 10'd4;
				address2 = 6'd0;
				address3 = 6'd0;
				
				if (sign == SIGNED)
					out = {{16{mem0out[7]}}, mem0out, mem1out};
				else
					out = {16'd0, mem0out, mem1out};
			end
			
			default:
			begin
				if (wren == 1'b1)
				begin
					mem0wren = 1'b1;
					mem1wren = 1'b1;
					mem2wren = 1'b1;
					mem3wren = 1'b1;
				end
				else
				begin
					mem0wren = 1'b0;
					mem1wren = 1'b0;
					mem2wren = 1'b0;
					mem3wren = 1'b0;
				end
				
				address0 = address / 10'd4;
				address1 = address / 10'd4;
				address2 = address / 10'd4;
				address3 = address / 10'd4;
				
				out = {mem0out, mem1out, mem2out, mem3out};
			end	
			
		endcase		
	end
	
	else if (address % 4 == 6'd1)
	begin
		case(width)
		
			BYTE:
			begin
				if (wren == 1'b1)
					mem1wren = 1'b1;
				else
					mem1wren = 1'b0;
				mem0wren = 1'b0;
				mem2wren = 1'b0;
				mem3wren = 1'b0;
				
				address0 = 6'd0;
				address1 = (address - 10'd1) / 10'd4;
				address2 = 6'd0;
				address3 = 6'd0;
			
				if (sign == SIGNED)
					out = {{24{mem1out[7]}}, mem1out};
				else
					out = {24'd0, mem1out};
			end
			
			HALF:
			begin
				if (wren == 1'b1)
				begin
					mem1wren = 1'b1;
					mem2wren = 1'b1;
				end
				else
				begin
					mem1wren = 1'b0;
					mem2wren = 1'b0;
				end
				mem0wren = 1'b0;
				mem3wren = 1'b0;
				
				address0 = 6'd0;
				address1 = (address - 10'd1) / 10'd4;
				address2 = (address - 10'd1) / 10'd4;
				address3 = 6'd0;
				
				if (sign == SIGNED)
					out = {{16{mem1out[7]}}, mem1out, mem2out};
				else
					out = {16'd0, mem1out, mem2out};
			end
			
			default:
			begin
				if (wren == 1'b1)
				begin
					mem0wren = 1'b1;
					mem1wren = 1'b1;
					mem2wren = 1'b1;
					mem3wren = 1'b1;
				end
				else
				begin
					mem0wren = 1'b0;
					mem1wren = 1'b0;
					mem2wren = 1'b0;
					mem3wren = 1'b0;
				end
				
				address1 = (address - 10'd1) / 10'd4;
				address2 = (address - 10'd1) / 10'd4;
				address3 = (address - 10'd1) / 10'd4;
				address0 = (address - 10'd1) / 10'd4 + 10'd1;
				
				out = {mem1out, mem2out, mem3out, mem0out};
			end	
			
		endcase		
	end
	
	else if (address % 4 == 6'd2)
	begin
		case(width)
		
			BYTE:
			begin
				if (wren == 1'b1)
					mem2wren = 1'b1;
				else
					mem2wren = 1'b0;
				mem0wren = 1'b0;
				mem1wren = 1'b0;
				mem3wren = 1'b0;
				
				address0 = 6'd0;
				address1 = 6'd0;
				address2 = (address - 10'd2) / 10'd4;
				address3 = 6'd0;
			
				if (sign == SIGNED)
					out = {{24{mem2out[7]}}, mem2out};
				else
					out = {24'd0, mem2out};
			end
			
			HALF:
			begin
				if (wren == 1'b1)
				begin
					mem2wren = 1'b1;
					mem3wren = 1'b1;
				end
				else
				begin
					mem2wren = 1'b0;
					mem3wren = 1'b0;
				end
				mem0wren = 1'b0;
				mem1wren = 1'b0;
				
				address0 = 6'd0;
				address1 = 6'd0;
				address2 = (address - 10'd2) / 10'd4;
				address3 = (address - 10'd2) / 10'd4;
				
				if (sign == SIGNED)
					out = {{16{mem2out[7]}}, mem2out, mem3out};
				else
					out = {16'd0, mem2out, mem3out};
			end
		
			default:
			begin
				if (wren == 1'b1)
				begin
					mem0wren = 1'b1;
					mem1wren = 1'b1;
					mem2wren = 1'b1;
					mem3wren = 1'b1;
				end
				else
				begin
					mem0wren = 1'b0;
					mem1wren = 1'b0;
					mem2wren = 1'b0;
					mem3wren = 1'b0;
				end
				
				address2 = (address - 10'd2) / 10'd4;
				address3 = (address - 10'd2) / 10'd4;
				address0 = (address - 10'd2) / 10'd4 + 10'd1;
				address1 = (address - 10'd2) / 10'd4 + 10'd1;
				
				out = {mem2out, mem3out, mem0out, mem1out};
			end
			
		endcase		
	end
	
	else
	begin
		case(width)
		
			BYTE:
			begin
				if (wren == 1'b1)
					mem3wren = 1'b1;
				else
					mem3wren = 1'b0;
				mem0wren = 1'b0;
				mem1wren = 1'b0;
				mem2wren = 1'b0;
				
				address0 = 6'd0;
				address1 = 6'd0;
				address2 = 6'd0;
				address3 = (address - 10'd3) / 10'd4;
			
				if (sign == SIGNED)
					out = {{24{mem3out[7]}}, mem3out};
				else
					out = {24'd0, mem3out};
			end
			
			HALF:
			begin
				if (wren == 1'b1)
				begin
					mem3wren = 1'b1;
					mem0wren = 1'b1;
				end
				else
				begin
					mem3wren = 1'b0;
					mem0wren = 1'b0;
				end
				mem1wren = 1'b0;
				mem2wren = 1'b0;
				
				address3 = (address - 10'd3) / 10'd4;
				address0 = (address - 10'd3) / 10'd4 + 10'd1;
				address1 = 6'd0;
				address2 = 6'd0;
				
				if (sign == SIGNED)
					out = {{16{mem3out[7]}}, mem3out, mem0out};
				else
					out = {16'd0, mem3out, mem0out};
			end
		
			default:
			begin
				if (wren == 1'b1)
				begin
					mem0wren = 1'b1;
					mem1wren = 1'b1;
					mem2wren = 1'b1;
					mem3wren = 1'b1;
				end
				else
				begin
					mem0wren = 1'b0;
					mem1wren = 1'b0;
					mem2wren = 1'b0;
					mem3wren = 1'b0;
				end
				
				address3 = (address - 10'd3) / 10'd4;
				address0 = (address - 10'd3) / 10'd4 + 10'd1;
				address1 = (address - 10'd3) / 10'd4 + 10'd1;
				address2 = (address - 10'd3) / 10'd4 + 10'd1;
				
				out = {mem3out, mem0out, mem1out, mem2out};
			end
			
		endcase		
	end
	
end

MemoryModule0 mem0(address0, clk, in[31:24], mem0wren, mem0out);
MemoryModule1 mem1(address1, clk, in[23:16], mem1wren, mem1out);
MemoryModule2 mem2(address2, clk, in[15:8], mem2wren, mem2out);
MemoryModule3 mem3(address3, clk, in[7:0], mem3wren, mem3out);

//module MemoryModule0 (
//	address,
//	clock,
//	data,
//	wren,
//	q);
//
//	input	[5:0]  address;
//	input	  clock;
//	input	[7:0]  data;
//	input	  wren;
//	output	[7:0]  q;

endmodule