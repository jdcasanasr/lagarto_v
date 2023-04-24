module exe_stage (
	clk_i,
	rstn_i,
	kill_i,
	csr_interrupt_i,
	csr_interrupt_cause_i,
	from_rr_i,
	from_wb_i,
	resp_dcache_cpu_i,
	io_base_addr_i,
	to_wb_o,
	stall_o,
	req_cpu_dcache_o,
	correct_branch_pred_o,
	exe_if_branch_pred_o,
	pmu_is_branch_o,
	pmu_branch_taken_o,
	pmu_miss_prediction_o,
	pmu_stall_mul_o,
	pmu_stall_div_o,
	pmu_stall_mem_o
);
	input wire clk_i;
	input wire rstn_i;
	input wire kill_i;
	input wire csr_interrupt_i;
	input wire [63:0] csr_interrupt_cause_i;
	localparam riscv_pkg_XLEN = 64;
	localparam drac_pkg_REGFILE_WIDTH = 5;
	input wire [551:0] from_rr_i;
	input wire [69:0] from_wb_i;
	input wire [133:0] resp_dcache_cpu_i;
	localparam drac_pkg_ADDR_SIZE = 40;
	input wire [39:0] io_base_addr_i;
	localparam drac_pkg_CSR_ADDR_SIZE = 12;
	output reg [420:0] to_wb_o;
	output wire stall_o;
	output wire [248:0] req_cpu_dcache_o;
	output reg correct_branch_pred_o;
	output wire [129:0] exe_if_branch_pred_o;
	output wire pmu_is_branch_o;
	output wire pmu_branch_taken_o;
	output wire pmu_miss_prediction_o;
	output wire pmu_stall_mul_o;
	output wire pmu_stall_div_o;
	output wire pmu_stall_mem_o;
	wire [63:0] rs1_data_bypass;
	wire [63:0] rs2_data_bypass;
	wire [63:0] rs1_data_def;
	wire [63:0] rs2_data_def;
	wire [63:0] result_alu;
	wire [63:0] result_mul;
	wire stall_mul;
	wire [63:0] result_div;
	wire [63:0] result_rmd;
	wire stall_div;
	wire taken_branch;
	wire [63:0] result_branch;
	wire [63:0] linked_pc;
	wire [63:0] result_mem;
	wire stall_mem;
	assign rs1_data_bypass = (((from_rr_i[291-:5] != 0) & (from_rr_i[291-:5] == from_wb_i[68-:5])) & from_wb_i[69] ? from_wb_i[63-:64] : from_rr_i[192-:64]);
	assign rs2_data_bypass = (((from_rr_i[286-:5] != 0) & (from_rr_i[286-:5] == from_wb_i[68-:5])) & from_wb_i[69] ? from_wb_i[63-:64] : from_rr_i[128-:64]);
	assign rs1_data_def = (from_rr_i[275] ? from_rr_i[550-:64] : rs1_data_bypass);
	assign rs2_data_def = (from_rr_i[276] ? from_rr_i[261-:64] : rs2_data_bypass);
	alu alu_inst(
		.data_rs1_i(rs1_data_def),
		.data_rs2_i(rs2_data_def),
		.instr_type_i(from_rr_i[268-:7]),
		.result_o(result_alu)
	);
	mul_unit mul_unit_inst(
		.clk_i(clk_i),
		.rstn_i(rstn_i),
		.kill_mul_i(kill_i),
		.request_i(from_rr_i[273-:3] == 3'd2),
		.func3_i(from_rr_i[196-:3]),
		.int_32_i(from_rr_i[274]),
		.src1_i(rs1_data_bypass),
		.src2_i(rs2_data_bypass),
		.result_o(result_mul),
		.stall_o(stall_mul)
	);
	div_unit div_unit_inst(
		.clk_i(clk_i),
		.rstn_i(rstn_i),
		.kill_div_i(kill_i),
		.request_i(from_rr_i[273-:3] == 3'd1),
		.int_32_i(from_rr_i[274]),
		.signed_op_i(from_rr_i[197]),
		.dvnd_i(rs1_data_bypass),
		.dvsr_i(rs2_data_def),
		.quo_o(result_div),
		.rmd_o(result_rmd),
		.stall_o(stall_div)
	);
	branch_unit branch_unit_inst(
		.instr_type_i(from_rr_i[268-:7]),
		.pc_i(from_rr_i[550-:64]),
		.data_rs1_i(rs1_data_bypass),
		.data_rs2_i(rs2_data_bypass),
		.imm_i(from_rr_i[261-:64]),
		.taken_o(taken_branch),
		.result_o(result_branch),
		.link_pc_o(linked_pc)
	);
	assign req_cpu_dcache_o[248] = (from_rr_i[273-:3] == 3'd4) && from_rr_i[551];
	assign req_cpu_dcache_o[247] = kill_i;
	assign req_cpu_dcache_o[246-:64] = rs1_data_bypass;
	assign req_cpu_dcache_o[182-:64] = rs2_data_bypass;
	assign req_cpu_dcache_o[118-:7] = from_rr_i[268-:7];
	assign req_cpu_dcache_o[111-:3] = from_rr_i[196-:3];
	assign req_cpu_dcache_o[108-:5] = from_rr_i[281-:5];
	assign req_cpu_dcache_o[103-:64] = from_rr_i[261-:64];
	assign req_cpu_dcache_o[39-:drac_pkg_ADDR_SIZE] = io_base_addr_i;
	assign result_mem = resp_dcache_cpu_i[132-:64];
	assign stall_mem = resp_dcache_cpu_i[68];
	wire [1:1] sv2v_tmp_7D50B;
	assign sv2v_tmp_7D50B = from_rr_i[551];
	always @(*) to_wb_o[420] = sv2v_tmp_7D50B;
	wire [64:1] sv2v_tmp_FB1DD;
	assign sv2v_tmp_FB1DD = from_rr_i[550-:64];
	always @(*) to_wb_o[419-:64] = sv2v_tmp_FB1DD;
	wire [66:1] sv2v_tmp_B2ABD;
	assign sv2v_tmp_B2ABD = from_rr_i[486-:66];
	always @(*) to_wb_o[209-:66] = sv2v_tmp_B2ABD;
	wire [5:1] sv2v_tmp_85684;
	assign sv2v_tmp_85684 = from_rr_i[291-:5];
	always @(*) to_wb_o[355-:5] = sv2v_tmp_85684;
	wire [5:1] sv2v_tmp_91C38;
	assign sv2v_tmp_91C38 = from_rr_i[281-:5];
	always @(*) to_wb_o[279-:5] = sv2v_tmp_91C38;
	wire [1:1] sv2v_tmp_052C4;
	assign sv2v_tmp_052C4 = from_rr_i[270];
	always @(*) to_wb_o[13] = sv2v_tmp_052C4;
	wire [1:1] sv2v_tmp_A483E;
	assign sv2v_tmp_A483E = from_rr_i[269];
	always @(*) to_wb_o[14] = sv2v_tmp_A483E;
	wire [7:1] sv2v_tmp_607D5;
	assign sv2v_tmp_607D5 = from_rr_i[268-:7];
	always @(*) to_wb_o[350-:7] = sv2v_tmp_607D5;
	wire [1:1] sv2v_tmp_7658C;
	assign sv2v_tmp_7658C = from_rr_i[193];
	always @(*) to_wb_o[12] = sv2v_tmp_7658C;
	wire [12:1] sv2v_tmp_02EC1;
	assign sv2v_tmp_02EC1 = from_rr_i[209:198];
	always @(*) to_wb_o[11-:drac_pkg_CSR_ADDR_SIZE] = sv2v_tmp_02EC1;
	function automatic [63:0] sv2v_cast_81851;
		input reg [63:0] inp;
		sv2v_cast_81851 = inp;
	endfunction
	always @(*) begin
		to_wb_o[143-:64] = sv2v_cast_81851(64'h0000000000000000);
		to_wb_o[79-:64] = 0;
		to_wb_o[15] = 0;
		if (from_rr_i[292])
			to_wb_o[143-:129] = from_rr_i[420-:129];
		else if (from_rr_i[551])
			if ((from_rr_i[273-:3] != 3'd4) && csr_interrupt_i) begin
				to_wb_o[143-:64] = sv2v_cast_81851(csr_interrupt_cause_i);
				to_wb_o[79-:64] = 64'b0000000000000000000000000000000000000000000000000000000000000000;
				to_wb_o[15] = 1;
			end
			else if (resp_dcache_cpu_i[67] && (from_rr_i[273-:3] == 3'd4)) begin
				to_wb_o[143-:64] = sv2v_cast_81851(64'h0000000000000006);
				to_wb_o[79-:64] = resp_dcache_cpu_i[63-:64];
				to_wb_o[15] = 1;
			end
			else if (resp_dcache_cpu_i[66] && (from_rr_i[273-:3] == 3'd4)) begin
				to_wb_o[143-:64] = sv2v_cast_81851(64'h0000000000000004);
				to_wb_o[79-:64] = resp_dcache_cpu_i[63-:64];
				to_wb_o[15] = 1;
			end
			else if (resp_dcache_cpu_i[65] && (from_rr_i[273-:3] == 3'd4)) begin
				to_wb_o[143-:64] = sv2v_cast_81851(64'h000000000000000f);
				to_wb_o[79-:64] = resp_dcache_cpu_i[63-:64];
				to_wb_o[15] = 1;
			end
			else if (resp_dcache_cpu_i[64] && (from_rr_i[273-:3] == 3'd4)) begin
				to_wb_o[143-:64] = sv2v_cast_81851(64'h000000000000000d);
				to_wb_o[79-:64] = resp_dcache_cpu_i[63-:64];
				to_wb_o[15] = 1;
			end
			else if (((|resp_dcache_cpu_i[63:40] && !resp_dcache_cpu_i[39]) || (!(&resp_dcache_cpu_i[63:40]) && resp_dcache_cpu_i[39])) && (from_rr_i[273-:3] == 3'd4))
				case (from_rr_i[268-:7])
					7'd43, 7'd46, 7'd49, 7'd51, 7'd53, 7'd54, 7'd55, 7'd56, 7'd57, 7'd58, 7'd59, 7'd60, 7'd61, 7'd62, 7'd63, 7'd64, 7'd65, 7'd66, 7'd67, 7'd68, 7'd69, 7'd70, 7'd71, 7'd72, 7'd73, 7'd74: begin
						to_wb_o[143-:64] = sv2v_cast_81851(64'h0000000000000007);
						to_wb_o[79-:64] = resp_dcache_cpu_i[63-:64];
						to_wb_o[15] = 1;
					end
					7'd42, 7'd44, 7'd45, 7'd47, 7'd48, 7'd50, 7'd52: begin
						to_wb_o[143-:64] = sv2v_cast_81851(64'h0000000000000005);
						to_wb_o[79-:64] = resp_dcache_cpu_i[63-:64];
						to_wb_o[15] = 1;
					end
					default: to_wb_o[15] = 0;
				endcase
			else if ((((result_branch[1:0] != 0) && (from_rr_i[273-:3] == 3'd3)) && ((from_rr_i[268-:7] == 7'd19) || (((((((from_rr_i[268-:7] == 7'd13) || (from_rr_i[268-:7] == 7'd14)) || (from_rr_i[268-:7] == 7'd15)) || (from_rr_i[268-:7] == 7'd16)) || (from_rr_i[268-:7] == 7'd17)) || (from_rr_i[268-:7] == 7'd18)) && taken_branch))) && from_rr_i[551]) begin
				to_wb_o[143-:64] = sv2v_cast_81851(64'h0000000000000000);
				to_wb_o[79-:64] = result_branch;
				to_wb_o[15] = 1;
			end
	end
	always @(*) begin
		to_wb_o[210] = 1'b0;
		case (from_rr_i[273-:3])
			3'd0: to_wb_o[274-:64] = result_alu;
			3'd2: to_wb_o[274-:64] = result_mul;
			3'd1:
				case (from_rr_i[268-:7])
					7'd80, 7'd81, 7'd82, 7'd83: to_wb_o[274-:64] = result_div;
					7'd84, 7'd85, 7'd86, 7'd87: to_wb_o[274-:64] = result_rmd;
					default: to_wb_o[274-:64] = 0;
				endcase
			3'd3: begin
				to_wb_o[210] = taken_branch;
				to_wb_o[274-:64] = linked_pc;
			end
			3'd4: to_wb_o[274-:64] = result_mem;
			3'd6: to_wb_o[274-:64] = rs1_data_bypass;
			default: to_wb_o[274-:64] = 0;
		endcase
	end
	assign exe_if_branch_pred_o[129-:64] = from_rr_i[550-:64];
	always @(*)
		if (from_rr_i[268-:7] == 7'd20) begin
			correct_branch_pred_o = 1'b1;
			to_wb_o[343-:64] = 0;
		end
		else if (((((((from_rr_i[268-:7] != 7'd13) && (from_rr_i[268-:7] != 7'd14)) && (from_rr_i[268-:7] != 7'd15)) && (from_rr_i[268-:7] != 7'd16)) && (from_rr_i[268-:7] != 7'd17)) && (from_rr_i[268-:7] != 7'd18)) && (from_rr_i[268-:7] != 7'd19)) begin
			correct_branch_pred_o = ~from_rr_i[486] | (from_rr_i[485] == 1'd0);
			to_wb_o[343-:64] = from_rr_i[550-:64] + 64'h0000000000000004;
		end
		else if (from_rr_i[486]) begin
			correct_branch_pred_o = (from_rr_i[485] == taken_branch) && ((from_rr_i[485] == 1'd0) || (from_rr_i[484-:riscv_pkg_XLEN] == result_branch));
			to_wb_o[343-:64] = result_branch;
		end
		else begin
			correct_branch_pred_o = ~taken_branch;
			to_wb_o[343-:64] = result_branch;
		end
	assign exe_if_branch_pred_o[65-:64] = result_branch;
	assign exe_if_branch_pred_o[1] = taken_branch == 1'd1;
	assign exe_if_branch_pred_o[0] = (((((from_rr_i[268-:7] == 7'd13) | (from_rr_i[268-:7] == 7'd14)) | (from_rr_i[268-:7] == 7'd15)) | (from_rr_i[268-:7] == 7'd16)) | (from_rr_i[268-:7] == 7'd17)) | (from_rr_i[268-:7] == 7'd18);
	assign stall_o = (from_rr_i[551] & (from_rr_i[273-:3] == 3'd2) ? stall_mul : (from_rr_i[551] & (from_rr_i[273-:3] == 3'd1) ? stall_div : (from_rr_i[551] & (from_rr_i[273-:3] == 3'd4) ? stall_mem : 0)));
	assign pmu_is_branch_o = from_rr_i[486] && from_rr_i[551];
	assign pmu_branch_taken_o = (from_rr_i[486] && from_rr_i[485]) && from_rr_i[551];
	assign pmu_miss_prediction_o = !correct_branch_pred_o;
	assign pmu_stall_mul_o = (from_rr_i[551] & (from_rr_i[273-:3] == 3'd2)) & stall_mul;
	assign pmu_stall_div_o = (from_rr_i[551] & (from_rr_i[273-:3] == 3'd1)) & stall_div;
	assign pmu_stall_mem_o = (from_rr_i[551] & (from_rr_i[273-:3] == 3'd4)) & stall_mem;
endmodule