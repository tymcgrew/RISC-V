/*
	Direct Mapping Cache
	
		- 8 blocks each with 32 bit word and 30 bit address from MSB of address (address[31:2])
		- Mapping is determined by line number%8 (address[4:2])
		- Cache hit: 1 clock cycle
		- Cache miss: 2 clock cycles
*/


module Cache(clk, rst, address, in, wren, width, sign, out, cacheHit);

	input clk, rst;
	input [31:0]address;
	input [31:0]in;
	input wren, sign;
	input [1:0]width;
	output [31:0]out;
	reg [31:0]out;
	output cacheHit;
	reg cacheHit;

	reg [61:0]cache0;            // {30' address, 32' value}
	reg [61:0]cache1;
	reg [61:0]cache2;
	reg [61:0]cache3;
	reg [61:0]cache4;
	reg [61:0]cache5;
	reg [61:0]cache6;
	reg [61:0]cache7;
	reg rstFlag; 
	reg [31:0]prevAddress;
	reg cacheHitComb;

	parameter BYTE = 2'b00,
				 HALF = 2'b01,
				 WORD = 2'b11;
	parameter SIGNED = 1'b1,
				 UNSIGNED = 1'b0;
				 
				 
				 
				 
	wire [31:0]memOut;
	Memory memory(clk, address, in, wren, width, memOut);
	
	
	always@(*)       // Updating cacheHitComb to serve as continous check on cache hit conditions and setting output from cache or memory based on address, prevAddress, cacheHitComb, and cacheHit         
	begin
	
		// Always updating cacheHitComb to check if an address and width is a valid cache hit
		if (
			 width == BYTE &&                     // if reading a byte and the line is in the cache, then there is a cache hit
			 address[31:2] == cache0[61:32] ||
			 address[31:2] == cache1[61:32] ||
			 address[31:2] == cache2[61:32] ||
			 address[31:2] == cache3[61:32] ||
			 address[31:2] == cache4[61:32] ||
			 address[31:2] == cache5[61:32] ||
			 address[31:2] == cache6[61:32] ||
			 address[31:2] == cache7[61:32])        cacheHitComb = 1'b1;
			
		else if (
					width == HALF &&                // if reading a half and the half is contained on one line and the line is in the cache, then there is a cache hit
					address[1:0] != 2'b11 &&
					address[31:2] == cache0[61:32] ||
					address[31:2] == cache1[61:32] ||
					address[31:2] == cache2[61:32] ||
					address[31:2] == cache3[61:32] ||
					address[31:2] == cache4[61:32] ||
					address[31:2] == cache5[61:32] ||
					address[31:2] == cache6[61:32] ||
					address[31:2] == cache7[61:32])   cacheHitComb = 1'b1;
		
		else if (
					width == WORD &&                // if reading a word and the word is word-alligned and the line is in the cache, then there is a cache hit
					address[1:0] == 2'b00 &&
					address[31:2] == cache0[61:32] ||
					address[31:2] == cache1[61:32] ||
					address[31:2] == cache2[61:32] ||
					address[31:2] == cache3[61:32] ||
					address[31:2] == cache4[61:32] ||
					address[31:2] == cache5[61:32] ||
					address[31:2] == cache6[61:32] ||
					address[31:2] == cache7[61:32])   cacheHitComb = 1'b1;
		else
			cacheHitComb = 1'b0;
	
		// Always determining output based on if the cache is a hit or not
		// If address is unchanged, use sequential cacheHit. If address is different, use combinational cacheHitComb.
		if ((address == prevAddress && cacheHit == 1'b1) || (address != prevAddress && cacheHitComb == 1'b1))  
		
		// cache hit, use cache for output
		begin
			case (address[4:2])
				3'd0:
				begin
					case(width)
						BYTE:
							case(address[1:0])
								2'b00: out = (sign == SIGNED)? {{24{cache0[31]}}, cache0[31:24]} : {24'd0, cache0[31:24]};
								2'b01: out = (sign == SIGNED)? {{24{cache0[23]}}, cache0[23:16]} : {24'd0, cache0[23:16]};
								2'b10: out = (sign == SIGNED)? {{24{cache0[15]}}, cache0[15:8]}  : {24'd0, cache0[15:8]};
								2'b11: out = (sign == SIGNED)? {{24{cache0[7]}},  cache0[7:0]}   : {24'd0, cache0[7:0]};
							endcase						
							
						HALF:
							case(address[1:0])
								2'b00:   out = (sign == SIGNED)? {{16{cache0[31]}}, cache0[31:16]} : {16'd0, cache0[31:16]};
								2'b01:   out = (sign == SIGNED)? {{16{cache0[23]}}, cache0[23:8]}  : {16'd0, cache0[23:8]};
								default: out = (sign == SIGNED)? {{16{cache0[15]}}, cache0[15:0]}  : {16'd0, cache0[15:0]};
							endcase
							
						default:  // word
							out = cache0[31:0];
					endcase
				end
					
				3'd1:
				begin
					case(width)
						BYTE:
							case(address[1:0])
								2'b00: out = (sign == SIGNED)? {{24{cache1[31]}}, cache1[31:24]} : {24'd0, cache1[31:24]};
								2'b01: out = (sign == SIGNED)? {{24{cache1[23]}}, cache1[23:16]} : {24'd0, cache1[23:16]};
								2'b10: out = (sign == SIGNED)? {{24{cache1[15]}}, cache1[15:8]}  : {24'd0, cache1[15:8]};
								2'b11: out = (sign == SIGNED)? {{24{cache1[7]}},  cache1[7:0]}   : {24'd0, cache1[7:0]};
							endcase						
							
						HALF:
							case(address[1:0])
								2'b00:   out = (sign == SIGNED)? {{16{cache1[31]}}, cache1[31:16]} : {16'd0, cache1[31:16]};
								2'b01:   out = (sign == SIGNED)? {{16{cache1[23]}}, cache1[23:8]}  : {16'd0, cache1[23:8]};
								default: out = (sign == SIGNED)? {{16{cache1[15]}}, cache1[15:0]}  : {16'd0, cache1[15:0]};
							endcase
							
						default:  // word
							out = cache1[31:0];
					endcase
				end
					
				3'd2:
				begin
					case(width)
						BYTE:
							case(address[1:0])
								2'b00: out = (sign == SIGNED)? {{24{cache2[31]}}, cache2[31:24]} : {24'd0, cache2[31:24]};
								2'b01: out = (sign == SIGNED)? {{24{cache2[23]}}, cache2[23:16]} : {24'd0, cache2[23:16]};
								2'b10: out = (sign == SIGNED)? {{24{cache2[15]}}, cache2[15:8]}  : {24'd0, cache2[15:8]};
								2'b11: out = (sign == SIGNED)? {{24{cache2[7]}},  cache2[7:0]}   : {24'd0, cache2[7:0]};
							endcase						
							
						HALF:
							case(address[1:0])
								2'b00:   out = (sign == SIGNED)? {{16{cache2[31]}}, cache2[31:16]} : {16'd0, cache2[31:16]};
								2'b01:   out = (sign == SIGNED)? {{16{cache2[23]}}, cache2[23:8]}  : {16'd0, cache2[23:8]};
								default: out = (sign == SIGNED)? {{16{cache2[15]}}, cache2[15:0]}  : {16'd0, cache2[15:0]};
							endcase
							
						default:  // word
							out = cache2[31:0];
					endcase
				end
				
				3'd3:
				begin
					case(width)
						BYTE:
							case(address[1:0])
								2'b00: out = (sign == SIGNED)? {{24{cache3[31]}}, cache3[31:24]} : {24'd0, cache3[31:24]};
								2'b01: out = (sign == SIGNED)? {{24{cache3[23]}}, cache3[23:16]} : {24'd0, cache3[23:16]};
								2'b10: out = (sign == SIGNED)? {{24{cache3[15]}}, cache3[15:8]}  : {24'd0, cache3[15:8]};
								2'b11: out = (sign == SIGNED)? {{24{cache3[7]}},  cache3[7:0]}   : {24'd0, cache3[7:0]};
							endcase						
							
						HALF:
							case(address[1:0])
								2'b00:   out = (sign == SIGNED)? {{16{cache3[31]}}, cache3[31:16]} : {16'd0, cache3[31:16]};
								2'b01:   out = (sign == SIGNED)? {{16{cache3[23]}}, cache3[23:8]}  : {16'd0, cache3[23:8]};
								default: out = (sign == SIGNED)? {{16{cache3[15]}}, cache3[15:0]}  : {16'd0, cache3[15:0]};
							endcase
							
						default:  // word
							out = cache3[31:0];
					endcase
				end
					
				3'd4:
				begin
					case(width)
						BYTE:
							case(address[1:0])
								2'b00: out = (sign == SIGNED)? {{24{cache4[31]}}, cache4[31:24]} : {24'd0, cache4[31:24]};
								2'b01: out = (sign == SIGNED)? {{24{cache4[23]}}, cache4[23:16]} : {24'd0, cache4[23:16]};
								2'b10: out = (sign == SIGNED)? {{24{cache4[15]}}, cache4[15:8]}  : {24'd0, cache4[15:8]};
								2'b11: out = (sign == SIGNED)? {{24{cache4[7]}},  cache4[7:0]}   : {24'd0, cache4[7:0]};
							endcase						
							
						HALF:
							case(address[1:0])
								2'b00:   out = (sign == SIGNED)? {{16{cache4[31]}}, cache4[31:16]} : {16'd0, cache4[31:16]};
								2'b01:   out = (sign == SIGNED)? {{16{cache4[23]}}, cache4[23:8]}  : {16'd0, cache4[23:8]};
								default: out = (sign == SIGNED)? {{16{cache4[15]}}, cache4[15:0]}  : {16'd0, cache4[15:0]};
							endcase
							
						default:  // word
							out = cache4[31:0];
					endcase
				end
					
				3'd5:
				begin
					case(width)
						BYTE:
							case(address[1:0])
								2'b00: out = (sign == SIGNED)? {{24{cache5[31]}}, cache5[31:24]} : {24'd0, cache5[31:24]};
								2'b01: out = (sign == SIGNED)? {{24{cache5[23]}}, cache5[23:16]} : {24'd0, cache5[23:16]};
								2'b10: out = (sign == SIGNED)? {{24{cache5[15]}}, cache5[15:8]}  : {24'd0, cache5[15:8]};
								2'b11: out = (sign == SIGNED)? {{24{cache5[7]}},  cache5[7:0]}   : {24'd0, cache5[7:0]};
							endcase						
							
						HALF:
							case(address[1:0])
								2'b00:   out = (sign == SIGNED)? {{16{cache5[31]}}, cache5[31:16]} : {16'd0, cache5[31:16]};
								2'b01:   out = (sign == SIGNED)? {{16{cache5[23]}}, cache5[23:8]}  : {16'd0, cache5[23:8]};
								default: out = (sign == SIGNED)? {{16{cache5[15]}}, cache5[15:0]}  : {16'd0, cache5[15:0]};
							endcase
							
						default:  // word
							out = cache5[31:0];
					endcase
				end
					
				3'd6:
				begin
					case(width)
						BYTE:
							case(address[1:0])
								2'b00: out = (sign == SIGNED)? {{24{cache6[31]}}, cache6[31:24]} : {24'd0, cache6[31:24]};
								2'b01: out = (sign == SIGNED)? {{24{cache6[23]}}, cache6[23:16]} : {24'd0, cache6[23:16]};
								2'b10: out = (sign == SIGNED)? {{24{cache6[15]}}, cache6[15:8]}  : {24'd0, cache6[15:8]};
								2'b11: out = (sign == SIGNED)? {{24{cache6[7]}},  cache6[7:0]}   : {24'd0, cache6[7:0]};
							endcase						
							
						HALF:
							case(address[1:0])
								2'b00:   out = (sign == SIGNED)? {{16{cache6[31]}}, cache6[31:16]} : {16'd0, cache6[31:16]};
								2'b01:   out = (sign == SIGNED)? {{16{cache6[23]}}, cache6[23:8]}  : {16'd0, cache6[23:8]};
								default: out = (sign == SIGNED)? {{16{cache6[15]}}, cache6[15:0]}  : {16'd0, cache6[15:0]};
							endcase
							
						default:  // word
							out = cache6[31:0];
					endcase
				end
					
				3'd7:
				begin
					case(width)
						BYTE:
							case(address[1:0])
								2'b00: out = (sign == SIGNED)? {{24{cache7[31]}}, cache7[31:24]} : {24'd0, cache7[31:24]};
								2'b01: out = (sign == SIGNED)? {{24{cache7[23]}}, cache7[23:16]} : {24'd0, cache7[23:16]};
								2'b10: out = (sign == SIGNED)? {{24{cache7[15]}}, cache7[15:8]}  : {24'd0, cache7[15:8]};
								2'b11: out = (sign == SIGNED)? {{24{cache7[7]}},  cache7[7:0]}   : {24'd0, cache7[7:0]};
							endcase						
							
						HALF:
							case(address[1:0])
								2'b00:   out = (sign == SIGNED)? {{16{cache7[31]}}, cache7[31:16]} : {16'd0, cache7[31:16]};
								2'b01:   out = (sign == SIGNED)? {{16{cache7[23]}}, cache7[23:8]}  : {16'd0, cache7[23:8]};
								default: out = (sign == SIGNED)? {{16{cache7[15]}}, cache7[15:0]}  : {16'd0, cache7[15:0]};
							endcase
							
						default:  // word
							out = cache7[31:0];
					endcase
				end
			endcase
		end
	
	   // cache miss, use memory for output
		else
			case(width)
				BYTE: out = (sign == SIGNED)? {{24{memOut[31]}}, memOut[31:24]} : {24'd0, memOut[31:24]};
				HALF: out = (sign == SIGNED)? {{16{memOut[31]}}, memOut[31:16]} : {16'd0, memOut[31:16]};
				default: out = memOut;
			endcase
		end


	always@(posedge clk or negedge rst)       // Sequential block determines when the address changes, decides whether there is a cache hit, and updates correct cache when there is a miss or when writing
	begin

		if (rst == 1'b0)
		begin
			cacheHit <= 1'b0;	
			prevAddress <= 32'd0;
			rstFlag <= 1'b1;
			cache0 <= {30'hffffffff, 32'd0};   // default address is 2^32 - 1, default value is 0
			cache1 <= {30'hffffffff, 32'd0};
			cache2 <= {30'hffffffff, 32'd0};
			cache3 <= {30'hffffffff, 32'd0};
			cache4 <= {30'hffffffff, 32'd0};
			cache5 <= {30'hffffffff, 32'd0};
			cache6 <= {30'hffffffff, 32'd0};
			cache7 <= {30'hffffffff, 32'd0};
		end
		else if (rstFlag == 1'b0)             // if process starts with reset switch already flipped up, this ensures that cache addresses default to 0xffffffff and not 0x00000000
		begin                                 // otherwise address 0 would be a cache hit on the first load instruction with an incorrect value of 0
			cacheHit <= 1'b0;	
			prevAddress <= 32'd0;
			rstFlag <= 1'b1;
			cache0 <= {30'hffffffff, 32'd0};
			cache1 <= {30'hffffffff, 32'd0};
			cache2 <= {30'hffffffff, 32'd0};
			cache3 <= {30'hffffffff, 32'd0};
			cache4 <= {30'hffffffff, 32'd0};
			cache5 <= {30'hffffffff, 32'd0};
			cache6 <= {30'hffffffff, 32'd0};
			cache7 <= {30'hffffffff, 32'd0};
		end		
		
		
		else
		begin
		
			prevAddress <= address;            // update prevAddress on the clock
			
			if (prevAddress != address)        // when address changes, update sequential cacheHit from combinational cacheHitComb
			begin
				cacheHit <= cacheHitComb;
			end
		
			case (address[4:2])                // Based on mapping of line number%8, update cache if writing to memory or if there there is a cache miss
				3'd0:
				begin
					if ((address == prevAddress && cacheHit == 1'b1) || (address != prevAddress && cacheHitComb == 1'b1))  // this condition checks for a cache hit combinationally and sequentially
					begin
						if (wren == 1'b1)         // update cache if cache hit and wren are true
						begin
							case(width)
								BYTE:
									case(address[1:0])
										2'b00: cache0[31:24] <= in[7:0];
										2'b01: cache0[23:16] <= in[7:0];
										2'b10: cache0[15:8]  <= in[7:0];
										2'b11: cache0[7:0]   <= in[7:0];
									endcase
								HALF:
									case(address[1:0])
										2'b00: cache0[31:16] <= in[15:0];
										2'b01: cache0[23:8]  <= in[15:0];
										default: cache0[15:0]  <= in[15:0];
									endcase
								default:     // word
									cache0[31:0] <= in;
							endcase
						end
					end
					else if (address[1:0] == 2'b00)          // if cache miss, only update cache if address is word alligned, otherwise memory will not read correct value since cache is always word-alligned but memory output is not
						cache0 <= {address[31:2], memOut};
				end
				
				3'd1:
				begin
					if ((address == prevAddress && cacheHit == 1'b1) || (address != prevAddress && cacheHitComb == 1'b1))
					begin
						if (wren == 1'b1)
						begin
							case(width)
								BYTE:
									case(address[1:0])
										2'b00: cache1[31:24] <= in[7:0];
										2'b01: cache1[23:16] <= in[7:0];
										2'b10: cache1[15:8]  <= in[7:0];
										2'b11: cache1[7:0]   <= in[7:0];
									endcase
								HALF:
									case(address[1:0])
										2'b00: cache1[31:16] <= in[15:0];
										2'b01: cache1[23:8]  <= in[15:0];
										default: cache1[15:0]  <= in[15:0];
									endcase
								default:     // word
									cache1[31:0] <= in;
							endcase
						end
					end
					else if (address[1:0] == 2'b00)         
						cache1 <= {address[31:2], memOut};
				end
				
				3'd2:
				begin
					if ((address == prevAddress && cacheHit == 1'b1) || (address != prevAddress && cacheHitComb == 1'b1))
					begin
						if (wren == 1'b1)
						begin
							case(width)
								BYTE:
									case(address[1:0])
										2'b00: cache2[31:24] <= in[7:0];
										2'b01: cache2[23:16] <= in[7:0];
										2'b10: cache2[15:8]  <= in[7:0];
										2'b11: cache2[7:0]   <= in[7:0];
									endcase
								HALF:
									case(address[1:0])
										2'b00: cache2[31:16] <= in[15:0];
										2'b01: cache2[23:8]  <= in[15:0];
										default: cache2[15:0]  <= in[15:0];
									endcase
								default:     // word
									cache2[31:0] <= in;
							endcase
						end
					end
					else if (address[1:0] == 2'b00)          
						cache2 <= {address[31:2], memOut};
				end
				
				3'd3:
				begin
					if ((address == prevAddress && cacheHit == 1'b1) || (address != prevAddress && cacheHitComb == 1'b1))
					begin
						if (wren == 1'b1)
						begin
							case(width)
								BYTE:
									case(address[1:0])
										2'b00: cache3[31:24] <= in[7:0];
										2'b01: cache3[23:16] <= in[7:0];
										2'b10: cache3[15:8]  <= in[7:0];
										2'b11: cache3[7:0]   <= in[7:0];
									endcase
								HALF:
									case(address[1:0])
										2'b00: cache3[31:16] <= in[15:0];
										2'b01: cache3[23:8]  <= in[15:0];
										default: cache3[15:0]  <= in[15:0];
									endcase
								default:     // word
									cache3[31:0] <= in;
							endcase
						end
					end
					else if (address[1:0] == 2'b00)          
						cache3 <= {address[31:2], memOut};
				end
				
				3'd4:
				begin
					if ((address == prevAddress && cacheHit == 1'b1) || (address != prevAddress && cacheHitComb == 1'b1))
					begin
						if (wren == 1'b1)
						begin
							case(width)
								BYTE:
									case(address[1:0])
										2'b00: cache4[31:24] <= in[7:0];
										2'b01: cache4[23:16] <= in[7:0];
										2'b10: cache4[15:8]  <= in[7:0];
										2'b11: cache4[7:0]   <= in[7:0];
									endcase
								HALF:
									case(address[1:0])
										2'b00: cache4[31:16] <= in[15:0];
										2'b01: cache4[23:8]  <= in[15:0];
										default: cache4[15:0]  <= in[15:0];
									endcase
								default:     // word
									cache4[31:0] <= in;
							endcase
						end
					end
					else if (address[1:0] == 2'b00)         
						cache4 <= {address[31:2], memOut};
				end
				
				3'd5:
				begin
					if ((address == prevAddress && cacheHit == 1'b1) || (address != prevAddress && cacheHitComb == 1'b1))
					begin
						if (wren == 1'b1)
						begin
							case(width)
								BYTE:
									case(address[1:0])
										2'b00: cache5[31:24] <= in[7:0];
										2'b01: cache5[23:16] <= in[7:0];
										2'b10: cache5[15:8]  <= in[7:0];
										2'b11: cache5[7:0]   <= in[7:0];
									endcase
								HALF:
									case(address[1:0])
										2'b00: cache5[31:16] <= in[15:0];
										2'b01: cache5[23:8]  <= in[15:0];
										default: cache5[15:0]  <= in[15:0];
									endcase
								default:     // word
									cache5[31:0] <= in;
							endcase
						end
					end
					else if (address[1:0] == 2'b00)         
						cache5 <= {address[31:2], memOut};
				end
				
				3'd6:
				begin
					if ((address == prevAddress && cacheHit == 1'b1) || (address != prevAddress && cacheHitComb == 1'b1))
					begin
						if (wren == 1'b1)
						begin
							case(width)
								BYTE:
									case(address[1:0])
										2'b00: cache6[31:24] <= in[7:0];
										2'b01: cache6[23:16] <= in[7:0];
										2'b10: cache6[15:8]  <= in[7:0];
										2'b11: cache6[7:0]   <= in[7:0];
									endcase
								HALF:
									case(address[1:0])
										2'b00: cache6[31:16] <= in[15:0];
										2'b01: cache6[23:8]  <= in[15:0];
										default: cache6[15:0]  <= in[15:0];
									endcase
								default:     // word
									cache6[31:0] <= in;
							endcase
						end
					end
					else if (address[1:0] == 2'b00)         
						cache6 <= {address[31:2], memOut};
				end
				
				3'd7:
				begin
					if ((address == prevAddress && cacheHit == 1'b1) || (address != prevAddress && cacheHitComb == 1'b1))
					begin
						if (wren == 1'b1)
						begin
							case(width)
								BYTE:
									case(address[1:0])
										2'b00: cache7[31:24] <= in[7:0];
										2'b01: cache7[23:16] <= in[7:0];
										2'b10: cache7[15:8]  <= in[7:0];
										2'b11: cache7[7:0]   <= in[7:0];
									endcase
								HALF:
									case(address[1:0])
										2'b00: cache7[31:16] <= in[15:0];
										2'b01: cache7[23:8]  <= in[15:0];
										default: cache7[15:0]  <= in[15:0];
									endcase
								default:     // word
									cache7[31:0] <= in;
							endcase
						end
					end
					else if (address[1:0] == 2'b00)         
						cache7 <= {address[31:2], memOut};
				end
			endcase		
		end
		
end
	
endmodule











