module vector_merge_unit(
	input				chip_enable_i,
	input		[2:0]	vsew_i,
	input		[127:0]	vs1_i,
	input		[127:0]	vs2_i,
	input		[15:0]	vmask_i,
	output reg	[127:0]	vd_o
);
	always @(*)
		if(chip_enable_i)
			case (vsew_i)
				3'b000:
					begin
						vd_o[7:0] 		= (vmask_i[0] ? vs1_i[7:0]    : vs2_i[7:0]);
						vd_o[15:8] 		= (vmask_i[1] ? vs1_i[15:8]   : vs2_i[15:8]);
						vd_o[23:16] 	= (vmask_i[2] ? vs1_i[23:16]  : vs2_i[23:16]);
						vd_o[31:24] 	= (vmask_i[3] ? vs1_i[31:24]  : vs2_i[31:24]);
						vd_o[39:32] 	= (vmask_i[4] ? vs1_i[39:32]  : vs2_i[39:32]);
						vd_o[47:40] 	= (vmask_i[5] ? vs1_i[47:40]  : vs2_i[47:40]);
						vd_o[55:48] 	= (vmask_i[6] ? vs1_i[55:48]  : vs2_i[55:48]);
						vd_o[63:56] 	= (vmask_i[7] ? vs1_i[63:56]  : vs2_i[63:56]);
						vd_o[71:64] 	= (vmask_i[8] ? vs1_i[71:64]  : vs2_i[71:64]);
						vd_o[79:72] 	= (vmask_i[9] ? vs1_i[79:72]  : vs2_i[79:72]);
						vd_o[87:80] 	= (vmask_i[10]? vs1_i[87:80]  : vs2_i[87:80]);
						vd_o[95:88] 	= (vmask_i[11]? vs1_i[95:88]  : vs2_i[95:88]);
						vd_o[103:96] 	= (vmask_i[12]? vs1_i[103:96] : vs2_i[103:96]);
						vd_o[111:104] 	= (vmask_i[13]? vs1_i[111:104]: vs2_i[111:104]);
						vd_o[119:112] 	= (vmask_i[14]? vs1_i[119:112]: vs2_i[119:112]);
						vd_o[127:120] 	= (vmask_i[15]? vs1_i[127:120]: vs2_i[127:120]);
					end
				
				3'b001:
					begin
						vd_o[15:0] 		= (vmask_i[0] ? vs1_i[15:0]   : vs2_i[15:0]);
						vd_o[31:16] 	= (vmask_i[1] ? vs1_i[31:16]  : vs2_i[31:16]);
						vd_o[47:32] 	= (vmask_i[2] ? vs1_i[47:32]  : vs2_i[47:32]);
						vd_o[63:48] 	= (vmask_i[3] ? vs1_i[63:48]  : vs2_i[63:48]);
						vd_o[79:64] 	= (vmask_i[4] ? vs1_i[79:64]  : vs2_i[79:64]);
						vd_o[95:80] 	= (vmask_i[5] ? vs1_i[95:80]  : vs2_i[95:80]);
						vd_o[111:96] 	= (vmask_i[6] ? vs1_i[111:96] : vs2_i[111:96]);
						vd_o[127:112] 	= (vmask_i[7] ? vs1_i[127:112]: vs2_i[127:112]);
					end
				
				3'b010:
					begin
						vd_o[31:0] 		= (vmask_i[0] ? vs1_i[31:0]   : vs2_i[31:0]);
						vd_o[63:32] 	= (vmask_i[1] ? vs1_i[63:32]  : vs2_i[63:32]);
						vd_o[95:64] 	= (vmask_i[2] ? vs1_i[95:64]  : vs2_i[95:64]);
						vd_o[127:96] 	= (vmask_i[3] ? vs1_i[127:96] : vs2_i[127:96]);
					end
					
				3'b011:
					begin
						vd_o[63:0] 	 	= (vmask_i[0] ? vs1_i[63:0]   : vs2_i[63:0]);
						vd_o[127:64] 	= (vmask_i[1] ? vs1_i[127:64] : vs2_i[127:64]);
					end
				
			endcase
		else
			vd_o <= 'b0;
	
endmodule