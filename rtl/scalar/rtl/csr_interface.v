module csr_interface (
	wb_xcpt_i,
	exe_to_wb_wb_i,
	stall_exe_i,
	wb_csr_ena_int_o,
	req_cpu_csr_o
);
	input wire wb_xcpt_i;
	localparam riscv_pkg_XLEN = 64;
	localparam drac_pkg_CSR_ADDR_SIZE = 12;
	localparam drac_pkg_REGFILE_WIDTH = 5;
	input wire [420:0] exe_to_wb_wb_i;
	input wire stall_exe_i;
	output wire wb_csr_ena_int_o;
	localparam drac_pkg_CSR_CMD_SIZE = 3;
	output wire [208:0] req_cpu_csr_o;
	reg [63:0] wb_csr_rw_data_int;
	reg wb_csr_ena_int;
	reg [2:0] wb_csr_cmd_int;
	function automatic [2:0] sv2v_cast_3A8E8;
		input reg [2:0] inp;
		sv2v_cast_3A8E8 = inp;
	endfunction
	always @(*) begin
		wb_csr_cmd_int = sv2v_cast_3A8E8(3'b000);
		wb_csr_rw_data_int = 64'b0000000000000000000000000000000000000000000000000000000000000000;
		wb_csr_ena_int = 1'b0;
		if (exe_to_wb_wb_i[420])
			case (exe_to_wb_wb_i[350-:7])
				7'd36: begin
					wb_csr_cmd_int = sv2v_cast_3A8E8(3'b001);
					wb_csr_rw_data_int = exe_to_wb_wb_i[274-:64];
					wb_csr_ena_int = 1'b1;
				end
				7'd37: begin
					wb_csr_cmd_int = (exe_to_wb_wb_i[355-:5] == 'h0 ? sv2v_cast_3A8E8(3'b101) : sv2v_cast_3A8E8(3'b010));
					wb_csr_rw_data_int = exe_to_wb_wb_i[274-:64];
					wb_csr_ena_int = 1'b1;
				end
				7'd38: begin
					wb_csr_cmd_int = (exe_to_wb_wb_i[355-:5] == 'h0 ? sv2v_cast_3A8E8(3'b101) : sv2v_cast_3A8E8(3'b011));
					wb_csr_rw_data_int = exe_to_wb_wb_i[274-:64];
					wb_csr_ena_int = 1'b1;
				end
				7'd39: begin
					wb_csr_cmd_int = sv2v_cast_3A8E8(3'b001);
					wb_csr_rw_data_int = {59'b00000000000000000000000000000000000000000000000000000000000, exe_to_wb_wb_i[355-:5]};
					wb_csr_ena_int = 1'b1;
				end
				7'd40: begin
					wb_csr_cmd_int = (exe_to_wb_wb_i[355-:5] == 'h0 ? sv2v_cast_3A8E8(3'b101) : sv2v_cast_3A8E8(3'b010));
					wb_csr_rw_data_int = {59'b00000000000000000000000000000000000000000000000000000000000, exe_to_wb_wb_i[355-:5]};
					wb_csr_ena_int = 1'b1;
				end
				7'd41: begin
					wb_csr_cmd_int = (exe_to_wb_wb_i[355-:5] == 'h0 ? sv2v_cast_3A8E8(3'b101) : sv2v_cast_3A8E8(3'b011));
					wb_csr_rw_data_int = {59'b00000000000000000000000000000000000000000000000000000000000, exe_to_wb_wb_i[355-:5]};
					wb_csr_ena_int = 1'b1;
				end
				7'd26, 7'd27, 7'd25, 7'd24, 7'd23, 7'd28, 7'd31, 7'd33: begin
					wb_csr_cmd_int = sv2v_cast_3A8E8(3'b100);
					wb_csr_rw_data_int = 64'b0000000000000000000000000000000000000000000000000000000000000000;
					wb_csr_ena_int = 1'b1;
				end
				default: wb_csr_ena_int = 1'b0;
			endcase
	end
	assign req_cpu_csr_o[208-:12] = (wb_csr_ena_int ? exe_to_wb_wb_i[11-:drac_pkg_CSR_ADDR_SIZE] : {drac_pkg_CSR_ADDR_SIZE {1'b0}});
	assign req_cpu_csr_o[196-:3] = (wb_csr_ena_int ? wb_csr_cmd_int : sv2v_cast_3A8E8(3'b000));
	assign req_cpu_csr_o[193-:64] = (wb_csr_ena_int ? wb_csr_rw_data_int : exe_to_wb_wb_i[79-:64]);
	assign req_cpu_csr_o[129] = wb_xcpt_i;
	assign req_cpu_csr_o[128] = (exe_to_wb_wb_i[420] && !wb_xcpt_i) && !stall_exe_i;
	assign req_cpu_csr_o[127-:64] = exe_to_wb_wb_i[143-:64];
	assign req_cpu_csr_o[63-:64] = exe_to_wb_wb_i[419-:64];
	assign wb_csr_ena_int_o = wb_csr_ena_int;
endmodule