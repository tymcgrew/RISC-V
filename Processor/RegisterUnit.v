module RegisterUnit (
							address_a,
							address_b,
							clk,
							rst,
							in_a,
							wren_a,
							out_a,
							out_b
							);

	input	 [4:0]address_a;
	input	 [4:0]address_b;
	input	 clk, rst;
	input	 [31:0]in_a;
	input  wren_a;
	output [31:0]out_a;
	reg [31:0]out_a;
	output [31:0]out_b;
	reg [31:0]out_b;
	
	reg [1023:0]data;
	
	always@(posedge clk or negedge rst)
	begin
	
		if (rst == 1'b0)
		begin
			data <= 1024'd0;
			out_a <= 32'd0;
			out_b <= 32'd0;
		end
		
		else
		begin
		
			case (address_a)
				5'd0: out_a <= 32'd0;
				5'd1: out_a <= data[63:32];
				5'd2: out_a <= data[95:64];
				5'd3: out_a <= data[127:96];
				5'd4: out_a <= data[159:128];
				5'd5: out_a <= data[191:160];
				5'd6: out_a <= data[223:192];
				5'd7: out_a <= data[255:224];
				5'd8: out_a <= data[287:256];
				5'd9: out_a <= data[319:288];
				5'd10: out_a <= data[351:320];
				5'd11: out_a <= data[383:352];
				5'd12: out_a <= data[415:384];
				5'd13: out_a <= data[447:416];
				5'd14: out_a <= data[479:448];
				5'd15: out_a <= data[511:480];
				5'd16: out_a <= data[543:512];
				5'd17: out_a <= data[575:544];
				5'd18: out_a <= data[607:576];
				5'd19: out_a <= data[639:608];
				5'd20: out_a <= data[671:640];
				5'd21: out_a <= data[703:672];
				5'd22: out_a <= data[735:704];
				5'd23: out_a <= data[767:736];
				5'd24: out_a <= data[799:768];
				5'd25: out_a <= data[831:800];
				5'd26: out_a <= data[863:832];
				5'd27: out_a <= data[895:864];
				5'd28: out_a <= data[927:896];
				5'd29: out_a <= data[959:928];
				5'd30: out_a <= data[991:960];
				5'd31: out_a <= data[1023:992];
			endcase
			
			case (address_b)
				5'd0: out_b <= 32'd0;
				5'd1: out_b <= data[63:32];
				5'd2: out_b <= data[95:64];
				5'd3: out_b <= data[127:96];
				5'd4: out_b <= data[159:128];
				5'd5: out_b <= data[191:160];
				5'd6: out_b <= data[223:192];
				5'd7: out_b <= data[255:224];
				5'd8: out_b <= data[287:256];
				5'd9: out_b <= data[319:288];
				5'd10: out_b <= data[351:320];
				5'd11: out_b <= data[383:352];
				5'd12: out_b <= data[415:384];
				5'd13: out_b <= data[447:416];
				5'd14: out_b <= data[479:448];
				5'd15: out_b <= data[511:480];
				5'd16: out_b <= data[543:512];
				5'd17: out_b <= data[575:544];
				5'd18: out_b <= data[607:576];
				5'd19: out_b <= data[639:608];
				5'd20: out_b <= data[671:640];
				5'd21: out_b <= data[703:672];
				5'd22: out_b <= data[735:704];
				5'd23: out_b <= data[767:736];
				5'd24: out_b <= data[799:768];
				5'd25: out_b <= data[831:800];
				5'd26: out_b <= data[863:832];
				5'd27: out_b <= data[895:864];
				5'd28: out_b <= data[927:896];
				5'd29: out_b <= data[959:928];
				5'd30: out_b <= data[991:960];
				5'd31: out_b <= data[1023:992];
			endcase
			
			if (wren_a == 1'b1)
				case (address_a)
					5'd0: data[31:0] <= 32'd0;
					5'd1: data[63:32] <= in_a;
					5'd2: data[95:64] <= in_a;
					5'd3: data[127:96] <= in_a;
					5'd4: data[159:128] <= in_a;
					5'd5: data[191:160] <= in_a;
					5'd6: data[223:192] <= in_a;
					5'd7: data[255:224] <= in_a;
					5'd8: data[287:256] <= in_a;
					5'd9: data[319:288] <= in_a;
					5'd10: data[351:320] <= in_a;
					5'd11: data[383:352] <= in_a;
					5'd12: data[415:384] <= in_a;
					5'd13: data[447:416] <= in_a;
					5'd14: data[479:448] <= in_a;
					5'd15: data[511:480] <= in_a;
					5'd16: data[543:512] <= in_a;
					5'd17: data[575:544] <= in_a;
					5'd18: data[607:576] <= in_a;
					5'd19: data[639:608] <= in_a;
					5'd20: data[671:640] <= in_a;
					5'd21: data[703:672] <= in_a;
					5'd22: data[735:704] <= in_a;
					5'd23: data[767:736] <= in_a;
					5'd24: data[799:768] <= in_a;
					5'd25: data[831:800] <= in_a;
					5'd26: data[863:832] <= in_a;
					5'd27: data[895:864] <= in_a;
					5'd28: data[927:896] <= in_a;
					5'd29: data[959:928] <= in_a;
					5'd30: data[991:960] <= in_a;
					5'd31: data[1023:992] <= in_a;
				endcase
			
		end
	
	end	
endmodule