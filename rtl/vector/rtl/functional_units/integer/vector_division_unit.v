module vector_division_unit(
	input					chip_enable_i,
	input		[1:0]		division_type_i,
	input		[2:0]		vsew_i,
	input 		[127:0]		vs1_i,
	input 		[127:0]		vs2_i,
	output	reg [127:0]		vd_o
);
	always @(*)
		begin
			if(chip_enable_i)
				case(division_type_i)
					2'b00:	//	Signed Remainder
						case(vsew_i)
							3'b000:
								begin
									vd_o[7:0]	=	((vs2_i[7:0]	 == 8'b0)	?	8'b0	:	($signed(vs1_i[7:0])	 % $signed(vs2_i[7:0])));
									vd_o[15:8] 	=	((vs2_i[15:8]	 == 8'b0) 	?	8'b0	:	($signed(vs1_i[15:8]) 	 % $signed(vs2_i[15:8])));
									vd_o[23:16] =	((vs2_i[23:16]	 == 8'b0) 	?	8'b0	:	($signed(vs1_i[23:16]) 	 % $signed(vs2_i[23:16])));
									vd_o[31:24] =	((vs2_i[31:24]	 == 8'b0) 	?	8'b0	:	($signed(vs1_i[31:24]) 	 % $signed(vs2_i[31:24])));
									vd_o[39:32] =	((vs2_i[39:32]	 == 8'b0) 	?	8'b0	:	($signed(vs1_i[39:32]) 	 % $signed(vs2_i[39:32])));
									vd_o[47:40] =	((vs2_i[47:40]	 == 8'b0) 	?	8'b0	:	($signed(vs1_i[47:40]) 	 % $signed(vs2_i[47:40])));
									vd_o[55:48] =	((vs2_i[55:48]	 == 8'b0) 	?	8'b0	:	($signed(vs1_i[55:48]) 	 % $signed(vs2_i[55:48])));
									vd_o[63:56] =	((vs2_i[63:56]	 == 8'b0) 	?	8'b0	:	($signed(vs1_i[63:56]) 	 % $signed(vs2_i[63:56])));
									vd_o[71:64] =	((vs2_i[71:64]	 == 8'b0) 	?	8'b0	:	($signed(vs1_i[71:64]) 	 % $signed(vs2_i[71:64])));
									vd_o[79:72] =	((vs2_i[79:72]	 == 8'b0) 	?	8'b0	:	($signed(vs1_i[79:72]) 	 % $signed(vs2_i[79:72])));
									vd_o[87:80] =	((vs2_i[87:80]	 == 8'b0) 	?	8'b0	:	($signed(vs1_i[87:80]) 	 % $signed(vs2_i[87:80])));
									vd_o[95:88] =	((vs2_i[95:88]	 == 8'b0) 	?	8'b0	:	($signed(vs1_i[95:88]) 	 % $signed(vs2_i[95:88])));
									vd_o[103:96] =	((vs2_i[103:96]	 == 8'b0)	?	8'b0	:	($signed(vs1_i[103:96])	 % $signed(vs2_i[103:96])));
									vd_o[111:104] =	((vs2_i[111:104] == 8'b0)	?	8'b0	:	($signed(vs1_i[111:104]) % $signed(vs2_i[111:104])));
									vd_o[119:112] =	((vs2_i[119:112] == 8'b0)	?	8'b0	:	($signed(vs1_i[119:112]) % $signed(vs2_i[119:112])));
									vd_o[127:120] =	((vs2_i[127:120] == 8'b0)	?	8'b0	:	($signed(vs1_i[127:120]) % $signed(vs2_i[127:120])));
								end
							3'b001:
								begin
									vd_o[15:0]	  =	((vs2_i[15:0]    == 16'b0)	?	16'b0	:	($signed(vs1_i[15:0])  	 % $signed(vs2_i[15:0])));
									vd_o[31:16]	  =	((vs2_i[31:16]	 == 16'b0) 	?	16'b0	:	($signed(vs1_i[31:16]) 	 % $signed(vs2_i[31:16])));
									vd_o[47:32]	  =	((vs2_i[47:32]	 == 16'b0) 	?	16'b0	:	($signed(vs1_i[47:32]) 	 % $signed(vs2_i[47:32])));
									vd_o[63:48]	  =	((vs2_i[63:48]	 == 16'b0) 	?	16'b0	:	($signed(vs1_i[63:48]) 	 % $signed(vs2_i[63:48])));
									vd_o[79:64]	  =	((vs2_i[79:64]	 == 16'b0) 	?	16'b0	:	($signed(vs1_i[79:64]) 	 % $signed(vs2_i[79:64])));
									vd_o[95:80]	  =	((vs2_i[95:80]	 == 16'b0) 	?	16'b0	:	($signed(vs1_i[95:80]) 	 % $signed(vs2_i[95:80])));
									vd_o[111:96]  =	((vs2_i[111:96]  == 16'b0) 	?	16'b0	:	($signed(vs1_i[111:96])	 % $signed(vs2_i[111:96])));
									vd_o[127:112] =	((vs2_i[127:112] == 16'b0) 	?	16'b0	:	($signed(vs1_i[127:112]) % $signed(vs2_i[127:112])));
								end
							3'b010:
								begin
									vd_o[31:0]	  =	((vs2_i[31:0]  	 == 32'b0) 	?	32'b0	:	($signed(vs1_i[31:0]) 	 % $signed(vs2_i[31:0])));
									vd_o[63:32]	  =	((vs2_i[63:32] 	 == 32'b0) 	?	32'b0	:	($signed(vs1_i[63:32]) 	 % $signed(vs2_i[63:32])));
									vd_o[95:64]	  =	((vs2_i[95:64] 	 == 32'b0) 	?	32'b0	:	($signed(vs1_i[95:64]) 	 % $signed(vs2_i[95:64])));
									vd_o[127:96] =	((vs2_i[127:96]	 == 32'b0) 	?	32'b0	:	($signed(vs1_i[127:96])	 % $signed(vs2_i[127:96])));
								end
							3'b011:
								begin
									vd_o[63:0]	  =	((vs2_i[63:0] 	 == 64'b0) 	?	64'b0	:	($signed(vs1_i[63:0])   % $signed(vs2_i[63:0])));
									vd_o[127:64] =	((vs2_i[127:64]	 == 64'b0) 	?	64'b0	:	($signed(vs1_i[127:64]) % $signed(vs2_i[127:64])));
								end
							default:
									vd_o <= 'b0;
						endcase
					2'b01:	//	Unsigned Remainder
						case(vsew_i)
							3'b000:
								begin
									vd_o[7:0]	=	((vs2_i[7:0]	 == 8'b0)	?	8'b0	:	($unsigned(vs1_i[7:0])		 % $unsigned(vs2_i[7:0])));
									vd_o[15:8] 	=	((vs2_i[15:8]	 == 8'b0) 	?	8'b0	:	($unsigned(vs1_i[15:8]) 	 % $unsigned(vs2_i[15:8])));
									vd_o[23:16] =	((vs2_i[23:16]	 == 8'b0) 	?	8'b0	:	($unsigned(vs1_i[23:16]) 	 % $unsigned(vs2_i[23:16])));
									vd_o[31:24] =	((vs2_i[31:24]	 == 8'b0) 	?	8'b0	:	($unsigned(vs1_i[31:24]) 	 % $unsigned(vs2_i[31:24])));
									vd_o[39:32] =	((vs2_i[39:32]	 == 8'b0) 	?	8'b0	:	($unsigned(vs1_i[39:32]) 	 % $unsigned(vs2_i[39:32])));
									vd_o[47:40] =	((vs2_i[47:40]	 == 8'b0) 	?	8'b0	:	($unsigned(vs1_i[47:40]) 	 % $unsigned(vs2_i[47:40])));
									vd_o[55:48] =	((vs2_i[55:48]	 == 8'b0) 	?	8'b0	:	($unsigned(vs1_i[55:48]) 	 % $unsigned(vs2_i[55:48])));
									vd_o[63:56] =	((vs2_i[63:56]	 == 8'b0) 	?	8'b0	:	($unsigned(vs1_i[63:56]) 	 % $unsigned(vs2_i[63:56])));
									vd_o[71:64] =	((vs2_i[71:64]	 == 8'b0) 	?	8'b0	:	($unsigned(vs1_i[71:64]) 	 % $unsigned(vs2_i[71:64])));
									vd_o[79:72] =	((vs2_i[79:72]	 == 8'b0) 	?	8'b0	:	($unsigned(vs1_i[79:72]) 	 % $unsigned(vs2_i[79:72])));
									vd_o[87:80] =	((vs2_i[87:80]	 == 8'b0) 	?	8'b0	:	($unsigned(vs1_i[87:80]) 	 % $unsigned(vs2_i[87:80])));
									vd_o[95:88] =	((vs2_i[95:88]	 == 8'b0) 	?	8'b0	:	($unsigned(vs1_i[95:88]) 	 % $unsigned(vs2_i[95:88])));
									vd_o[103:96] =	((vs2_i[103:96]	 == 8'b0)	?	8'b0	:	($unsigned(vs1_i[103:96])	 % $unsigned(vs2_i[103:96])));
									vd_o[111:104] =	((vs2_i[111:104] == 8'b0)	?	8'b0	:	($unsigned(vs1_i[111:104])	 % $unsigned(vs2_i[111:104])));
									vd_o[119:112] =	((vs2_i[119:112] == 8'b0)	?	8'b0	:	($unsigned(vs1_i[119:112])	 % $unsigned(vs2_i[119:112])));
									vd_o[127:120] =	((vs2_i[127:120] == 8'b0)	?	8'b0	:	($unsigned(vs1_i[127:120])	 % $unsigned(vs2_i[127:120])));
								end
							3'b001:
								begin
									vd_o[15:0]	  =	((vs2_i[15:0]    == 16'b0)	?	16'b0	:	($unsigned(vs1_i[15:0])  	 % $unsigned(vs2_i[15:0])));
									vd_o[31:16]	  =	((vs2_i[31:16]	 == 16'b0) 	?	16'b0	:	($unsigned(vs1_i[31:16]) 	 % $unsigned(vs2_i[31:16])));
									vd_o[47:32]	  =	((vs2_i[47:32]	 == 16'b0) 	?	16'b0	:	($unsigned(vs1_i[47:32]) 	 % $unsigned(vs2_i[47:32])));
									vd_o[63:48]	  =	((vs2_i[63:48]	 == 16'b0) 	?	16'b0	:	($unsigned(vs1_i[63:48]) 	 % $unsigned(vs2_i[63:48])));
									vd_o[79:64]	  =	((vs2_i[79:64]	 == 16'b0) 	?	16'b0	:	($unsigned(vs1_i[79:64]) 	 % $unsigned(vs2_i[79:64])));
									vd_o[95:80]	  =	((vs2_i[95:80]	 == 16'b0) 	?	16'b0	:	($unsigned(vs1_i[95:80]) 	 % $unsigned(vs2_i[95:80])));
									vd_o[111:96]  =	((vs2_i[111:96]  == 16'b0) 	?	16'b0	:	($unsigned(vs1_i[111:96])	 % $unsigned(vs2_i[111:96])));
									vd_o[127:112] =	((vs2_i[127:112] == 16'b0) 	?	16'b0	:	($unsigned(vs1_i[127:112])	 % $unsigned(vs2_i[127:112])));
								end
							3'b010:
								begin
									vd_o[31:0]	  =	((vs2_i[31:0]  	 == 32'b0) 	?	32'b0	:	($unsigned(vs1_i[31:0]) 	 % $unsigned(vs2_i[31:0])));
									vd_o[63:32]	  =	((vs2_i[63:32] 	 == 32'b0) 	?	32'b0	:	($unsigned(vs1_i[63:32]) 	 % $unsigned(vs2_i[63:32])));
									vd_o[95:64]	  =	((vs2_i[95:64] 	 == 32'b0) 	?	32'b0	:	($unsigned(vs1_i[95:64]) 	 % $unsigned(vs2_i[95:64])));
									vd_o[127:96] =	((vs2_i[127:96]	 == 32'b0) 	?	32'b0	:	($unsigned(vs1_i[127:96])	 % $unsigned(vs2_i[127:96])));
								end
							3'b011:
								begin
									vd_o[63:0]	  =	((vs2_i[63:0] 	 == 64'b0) 	?	64'b0	:	($unsigned(vs1_i[63:0])  	 % $unsigned(vs2_i[63:0])));
									vd_o[127:64] =	((vs2_i[127:64]	 == 64'b0) 	?	64'b0	:	($unsigned(vs1_i[127:64])	 % $unsigned(vs2_i[127:64])));
								end
							default:
									vd_o <= 'b0;
						endcase
					2'b10:	//	Signed Division
						case(vsew_i)
							3'b000:
								begin
									vd_o[7:0]	=	((vs2_i[7:0]	 == 8'b0)	?	8'b0	:	($signed(vs1_i[7:0])	 / $signed(vs2_i[7:0])));
									vd_o[15:8] 	=	((vs2_i[15:8]	 == 8'b0) 	?	8'b0	:	($signed(vs1_i[15:8]) 	 / $signed(vs2_i[15:8])));
									vd_o[23:16] =	((vs2_i[23:16]	 == 8'b0) 	?	8'b0	:	($signed(vs1_i[23:16]) 	 / $signed(vs2_i[23:16])));
									vd_o[31:24] =	((vs2_i[31:24]	 == 8'b0) 	?	8'b0	:	($signed(vs1_i[31:24]) 	 / $signed(vs2_i[31:24])));
									vd_o[39:32] =	((vs2_i[39:32]	 == 8'b0) 	?	8'b0	:	($signed(vs1_i[39:32]) 	 / $signed(vs2_i[39:32])));
									vd_o[47:40] =	((vs2_i[47:40]	 == 8'b0) 	?	8'b0	:	($signed(vs1_i[47:40]) 	 / $signed(vs2_i[47:40])));
									vd_o[55:48] =	((vs2_i[55:48]	 == 8'b0) 	?	8'b0	:	($signed(vs1_i[55:48]) 	 / $signed(vs2_i[55:48])));
									vd_o[63:56] =	((vs2_i[63:56]	 == 8'b0) 	?	8'b0	:	($signed(vs1_i[63:56]) 	 / $signed(vs2_i[63:56])));
									vd_o[71:64] =	((vs2_i[71:64]	 == 8'b0) 	?	8'b0	:	($signed(vs1_i[71:64]) 	 / $signed(vs2_i[71:64])));
									vd_o[79:72] =	((vs2_i[79:72]	 == 8'b0) 	?	8'b0	:	($signed(vs1_i[79:72]) 	 / $signed(vs2_i[79:72])));
									vd_o[87:80] =	((vs2_i[87:80]	 == 8'b0) 	?	8'b0	:	($signed(vs1_i[87:80]) 	 / $signed(vs2_i[87:80])));
									vd_o[95:88] =	((vs2_i[95:88]	 == 8'b0) 	?	8'b0	:	($signed(vs1_i[95:88]) 	 / $signed(vs2_i[95:88])));
									vd_o[103:96] =	((vs2_i[103:96]	 == 8'b0)	?	8'b0	:	($signed(vs1_i[103:96])	 / $signed(vs2_i[103:96])));
									vd_o[111:104] =	((vs2_i[111:104] == 8'b0)	?	8'b0	:	($signed(vs1_i[111:104]) / $signed(vs2_i[111:104])));
									vd_o[119:112] =	((vs2_i[119:112] == 8'b0)	?	8'b0	:	($signed(vs1_i[119:112]) / $signed(vs2_i[119:112])));
									vd_o[127:120] =	((vs2_i[127:120] == 8'b0)	?	8'b0	:	($signed(vs1_i[127:120]) / $signed(vs2_i[127:120])));
								end
							3'b001:
								begin
									vd_o[15:0]	  =	((vs2_i[15:0]    == 16'b0)	?	16'b0	:	($signed(vs1_i[15:0])  	 / $signed(vs2_i[15:0])));
									vd_o[31:16]	  =	((vs2_i[31:16]	 == 16'b0) 	?	16'b0	:	($signed(vs1_i[31:16]) 	 / $signed(vs2_i[31:16])));
									vd_o[47:32]	  =	((vs2_i[47:32]	 == 16'b0) 	?	16'b0	:	($signed(vs1_i[47:32]) 	 / $signed(vs2_i[47:32])));
									vd_o[63:48]	  =	((vs2_i[63:48]	 == 16'b0) 	?	16'b0	:	($signed(vs1_i[63:48]) 	 / $signed(vs2_i[63:48])));
									vd_o[79:64]	  =	((vs2_i[79:64]	 == 16'b0) 	?	16'b0	:	($signed(vs1_i[79:64]) 	 / $signed(vs2_i[79:64])));
									vd_o[95:80]	  =	((vs2_i[95:80]	 == 16'b0) 	?	16'b0	:	($signed(vs1_i[95:80]) 	 / $signed(vs2_i[95:80])));
									vd_o[111:96]  =	((vs2_i[111:96]  == 16'b0) 	?	16'b0	:	($signed(vs1_i[111:96])	 / $signed(vs2_i[111:96])));
									vd_o[127:112] =	((vs2_i[127:112] == 16'b0) 	?	16'b0	:	($signed(vs1_i[127:112]) / $signed(vs2_i[127:112])));
								end
							3'b010:
								begin
									vd_o[31:0]	  =	((vs2_i[31:0]  	 == 32'b0) 	?	32'b0	:	($signed(vs1_i[31:0]) 	 / $signed(vs2_i[31:0])));
									vd_o[63:32]	  =	((vs2_i[63:32] 	 == 32'b0) 	?	32'b0	:	($signed(vs1_i[63:32]) 	 / $signed(vs2_i[63:32])));
									vd_o[95:64]	  =	((vs2_i[95:64] 	 == 32'b0) 	?	32'b0	:	($signed(vs1_i[95:64]) 	 / $signed(vs2_i[95:64])));
									vd_o[127:96] =	((vs2_i[127:96]	 == 32'b0) 	?	32'b0	:	($signed(vs1_i[127:96])	 / $signed(vs2_i[127:96])));
								end
							3'b011:
								begin
									vd_o[63:0]	  =	((vs2_i[63:0] 	 == 64'b0) 	?	64'b0	:	($signed(vs1_i[63:0])   / $signed(vs2_i[63:0])));
									vd_o[127:64] =	((vs2_i[127:64]	 == 64'b0) 	?	64'b0	:	($signed(vs1_i[127:64]) / $signed(vs2_i[127:64])));
								end
							default:
									vd_o <= 'b0;
						endcase
					2'b11:	//	Unsigned Division
						case(vsew_i)
							3'b000:
								begin
									vd_o[7:0]	=	((vs2_i[7:0]	 == 8'b0)	?	8'b0	:	($unsigned(vs1_i[7:0])		/ $unsigned(vs2_i[7:0])));
									vd_o[15:8] 	=	((vs2_i[15:8]	 == 8'b0) 	?	8'b0	:	($unsigned(vs1_i[15:8]) 	/ $unsigned(vs2_i[15:8])));
									vd_o[23:16] =	((vs2_i[23:16]	 == 8'b0) 	?	8'b0	:	($unsigned(vs1_i[23:16]) 	/ $unsigned(vs2_i[23:16])));
									vd_o[31:24] =	((vs2_i[31:24]	 == 8'b0) 	?	8'b0	:	($unsigned(vs1_i[31:24]) 	/ $unsigned(vs2_i[31:24])));
									vd_o[39:32] =	((vs2_i[39:32]	 == 8'b0) 	?	8'b0	:	($unsigned(vs1_i[39:32]) 	/ $unsigned(vs2_i[39:32])));
									vd_o[47:40] =	((vs2_i[47:40]	 == 8'b0) 	?	8'b0	:	($unsigned(vs1_i[47:40]) 	/ $unsigned(vs2_i[47:40])));
									vd_o[55:48] =	((vs2_i[55:48]	 == 8'b0) 	?	8'b0	:	($unsigned(vs1_i[55:48]) 	/ $unsigned(vs2_i[55:48])));
									vd_o[63:56] =	((vs2_i[63:56]	 == 8'b0) 	?	8'b0	:	($unsigned(vs1_i[63:56]) 	/ $unsigned(vs2_i[63:56])));
									vd_o[71:64] =	((vs2_i[71:64]	 == 8'b0) 	?	8'b0	:	($unsigned(vs1_i[71:64]) 	/ $unsigned(vs2_i[71:64])));
									vd_o[79:72] =	((vs2_i[79:72]	 == 8'b0) 	?	8'b0	:	($unsigned(vs1_i[79:72]) 	/ $unsigned(vs2_i[79:72])));
									vd_o[87:80] =	((vs2_i[87:80]	 == 8'b0) 	?	8'b0	:	($unsigned(vs1_i[87:80]) 	/ $unsigned(vs2_i[87:80])));
									vd_o[95:88] =	((vs2_i[95:88]	 == 8'b0) 	?	8'b0	:	($unsigned(vs1_i[95:88]) 	/ $unsigned(vs2_i[95:88])));
									vd_o[103:96] =	((vs2_i[103:96]	 == 8'b0)	?	8'b0	:	($unsigned(vs1_i[103:96])	/ $unsigned(vs2_i[103:96])));
									vd_o[111:104] =	((vs2_i[111:104] == 8'b0)	?	8'b0	:	($unsigned(vs1_i[111:104])	/ $unsigned(vs2_i[111:104])));
									vd_o[119:112] =	((vs2_i[119:112] == 8'b0)	?	8'b0	:	($unsigned(vs1_i[119:112])	/ $unsigned(vs2_i[119:112])));
									vd_o[127:120] =	((vs2_i[127:120] == 8'b0)	?	8'b0	:	($unsigned(vs1_i[127:120])	/ $unsigned(vs2_i[127:120])));
								end
							3'b001:
								begin
									vd_o[15:0]	  =	((vs2_i[15:0]    == 16'b0)	?	16'b0	:	($unsigned(vs1_i[15:0])  	 / $unsigned(vs2_i[15:0])));
									vd_o[31:16]	  =	((vs2_i[31:16]	 == 16'b0) 	?	16'b0	:	($unsigned(vs1_i[31:16]) 	 / $unsigned(vs2_i[31:16])));
									vd_o[47:32]	  =	((vs2_i[47:32]	 == 16'b0) 	?	16'b0	:	($unsigned(vs1_i[47:32]) 	 / $unsigned(vs2_i[47:32])));
									vd_o[63:48]	  =	((vs2_i[63:48]	 == 16'b0) 	?	16'b0	:	($unsigned(vs1_i[63:48]) 	 / $unsigned(vs2_i[63:48])));
									vd_o[79:64]	  =	((vs2_i[79:64]	 == 16'b0) 	?	16'b0	:	($unsigned(vs1_i[79:64]) 	 / $unsigned(vs2_i[79:64])));
									vd_o[95:80]	  =	((vs2_i[95:80]	 == 16'b0) 	?	16'b0	:	($unsigned(vs1_i[95:80]) 	 / $unsigned(vs2_i[95:80])));
									vd_o[111:96]  =	((vs2_i[111:96]  == 16'b0) 	?	16'b0	:	($unsigned(vs1_i[111:96])	 / $unsigned(vs2_i[111:96])));
									vd_o[127:112] =	((vs2_i[127:112] == 16'b0) 	?	16'b0	:	($unsigned(vs1_i[127:112])	 / $unsigned(vs2_i[127:112])));
								end
							3'b010:
								begin
									vd_o[31:0]	  =	((vs2_i[31:0]  	 == 32'b0) 	?	32'b0	:	($unsigned(vs1_i[31:0]) 	 / $unsigned(vs2_i[31:0])));
									vd_o[63:32]	  =	((vs2_i[63:32] 	 == 32'b0) 	?	32'b0	:	($unsigned(vs1_i[63:32]) 	 / $unsigned(vs2_i[63:32])));
									vd_o[95:64]	  =	((vs2_i[95:64] 	 == 32'b0) 	?	32'b0	:	($unsigned(vs1_i[95:64]) 	 / $unsigned(vs2_i[95:64])));
									vd_o[127:96] =	((vs2_i[127:96]	 == 32'b0) 	?	32'b0	:	($unsigned(vs1_i[127:96])	 / $unsigned(vs2_i[127:96])));
								end
							3'b011:
								begin
									vd_o[63:0]	  =	((vs2_i[63:0] 	 == 64'b0) 	?	64'b0	:	($unsigned(vs1_i[63:0])  	 / $unsigned(vs2_i[63:0])));
									vd_o[127:64] =	((vs2_i[127:64]	 == 64'b0) 	?	64'b0	:	($unsigned(vs1_i[127:64])	 / $unsigned(vs2_i[127:64])));
								end
							default:
									vd_o <= 'b0;
						endcase
					default:
						vd_o <= 'b0;
				endcase
			else
				vd_o <= 'b0;
		end
	
endmodule