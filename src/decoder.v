`include "../inc/opcodes.vh"
`include "../inc/labels.vh"

module decoder
(
	input 		[291:0] decode_i,
	
	output 	reg [358:0] decode_o,
	
	// Changed from jal_id_if_o
	output 	reg [64:0] 	jal_o
);

	wire [63:0] imm_value;
	
	reg 		xcpt_illegal_instruction_int;
	reg 		xcpt_addr_misaligned_int;
	
	immediate immediate_inst
	(
		.instr_i 	(decode_i[`instruction_msb:`instruction_lsb]),
		.imm_o		(imm_value)
	);
	
	always @(*) 
		begin
			xcpt_illegal_instruction_int 	= 1'b0;
			xcpt_addr_misaligned_int 		= 1'b0;
			
			decode_o[`decode_o_valid_bit] 													= decode_i[`valid_bit];
			
			decode_o[`decode_o_pc_msb:`decode_o_pc_lsb] 									= decode_i[`pc_msb:`pc_lsb];
			decode_o[`decode_o_prediction_vector_msb:`decode_o_prediction_vector_lsb] 		= decode_i[`branch_prediction_msb:`branch_prediction_lsb];
			
			decode_o[`decode_o_rs1_msb:`decode_o_rs1_lsb] 									= decode_i[`rs1_msb:`rs1_lsb];
			decode_o[`decode_o_rs2_msb:`decode_o_rs2_lsb] 									= decode_i[`rs2_msb:`rs2_lsb];
			decode_o[`decode_o_rd_msb:`decode_o_rd_lsb] 									= decode_i[`rd_msb:`rd_lsb];
		
			// "Does not really matter"...
			decode_o[`decode_o_use_immediate_bit] 											= 1'b0;
			decode_o[`decode_o_use_pc_bit] 													= 1'b0;
			decode_o[`decode_o_op_32_bit] 													= 1'b0;
		
			decode_o[`decode_o_functional_unit_msb:`decode_o_functional_unit_lsb] 			= 3'd0;
		
			// These bits default to zero
			decode_o[`decode_o_pc_write_enable_bit] 										= 1'b0;
			decode_o[`decode_o_sirf_write_enable] 											= 1'b0;
			
			decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] 		= 7'd0;
			
			decode_o[`decode_o_result_msb:`decode_o_result_lsb] 							= imm_value;
		
			decode_o[`decode_o_signed_operation_bit] 										= 1'b0;
		
			decode_o[`decode_o_memory_size_msb:`decode_o_memory_size_lsb] 					= decode_i[`funct3_msb:`funct3_lsb];
		
			decode_o[`decode_o_stall_csr_fence_bit] 										= 1'b0;
		
			
			jal_o[`jal_o_valid_bit] 														= 1'b0;
			jal_o[`jal_o_jump_address_msb:`jal_o_jump_address_lsb] 							= 64'b0;
			
		
		
		if (!decode_i[`valid_exception_bit] && decode_i[`valid_bit])
			case (decode_i[`opcode_msb:`opcode_lsb])
				`lui_type		:
					begin
						decode_o[`decode_o_sirf_write_enable] 									= 1'b1;
						decode_o[`decode_o_use_immediate_bit] 									= 1'b1;
						decode_o[`decode_o_rs1_msb:`decode_o_rs1_lsb] 							= 1'sb0;
						decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd5;
					end
					
				`auipc_type 	:
					begin
						decode_o[`decode_o_sirf_write_enable] 									= 1'b1;
						decode_o[`decode_o_use_immediate_bit] 									= 1'b1;
						decode_o[`decode_o_use_pc_bit] 											= 1'b1;
						decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd0;
					end
					
				`jal_type 		:
					begin
						decode_o[`decode_o_sirf_write_enable] 									= 1'b1;
						decode_o[`decode_o_pc_write_enable_bit] 								= 1'b0;
						decode_o[`decode_o_use_immediate_bit] 									= 1'b1;
						decode_o[`decode_o_use_pc_bit] 											= 1'b1;
						decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd20;
						decode_o[`decode_o_functional_unit_msb:`decode_o_functional_unit_lsb] 	= 3'd3;
						
						xcpt_addr_misaligned_int 												= |imm_value[1:0];
						
						jal_o[`jal_o_valid_bit] 												= !xcpt_addr_misaligned_int & decode_i[`valid_bit];
						jal_o[`jal_o_jump_address_msb:`jal_o_jump_address_lsb] 					= imm_value + decode_i[`pc_msb:`pc_lsb];
					end
					
				`jalr_type 		:
					begin
						decode_o[`decode_o_sirf_write_enable] 									= 1'b1;
						decode_o[`decode_o_pc_write_enable_bit] 								= 1'b1;
						decode_o[`decode_o_use_immediate_bit] 									= 1'b1;
						decode_o[`decode_o_use_pc_bit] 											= 1'b1;
						decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd19;
						decode_o[`decode_o_functional_unit_msb:`decode_o_functional_unit_lsb] 	= 3'd3;
						
						if (decode_i[`funct3_msb:`funct3_lsb] != 3'b0)
							xcpt_illegal_instruction_int = 1'b1;
					end
					
				`branch_type 	:
					begin
						decode_o[`decode_o_sirf_write_enable] 									= 1'b0;
						decode_o[`decode_o_pc_write_enable_bit] 								= 1'b1;
						decode_o[`decode_o_use_immediate_bit] 									= 1'b1;
						decode_o[`decode_o_use_pc_bit] 											= 1'b1;
						decode_o[`decode_o_functional_unit_msb:`decode_o_functional_unit_lsb] 	= 3'd3;
						
						case (decode_i[`funct3_msb:`funct3_lsb])
							`funct3_beq 	: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd17;
							`funct3_bne 	: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd18;
							`funct3_blt 	: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd13;
							`funct3_bge 	: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd15;
							`funct3_bltu 	: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd14;
							`funct3_bgeu 	: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd16;
							
							default : xcpt_illegal_instruction_int = 1'b1;
						endcase
					end
					
				`load_type 		:
					begin
						decode_o[`decode_o_sirf_write_enable] 									= 1'b1;
						decode_o[`decode_o_use_immediate_bit] 									= 1'b1;
						decode_o[`decode_o_functional_unit_msb:`decode_o_functional_unit_lsb] 	= 3'd4;
						
						case (decode_i[`funct3_msb:`funct3_lsb])
							`funct3_lb	: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd50;
							`funct3_lh	: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd47;
							`funct3_lw	: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd44;
							`funct3_ld	: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd42;
							`funct3_lbu	: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd52;
							`funct3_lhu	: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd48;
							`funct3_lwu : decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd45;
							
							default : xcpt_illegal_instruction_int 	= 1'b1;
						endcase
					end
					
				`store_type 	:
					begin
						decode_o[`decode_o_sirf_write_enable] 									= 1'b0;
						decode_o[`decode_o_use_immediate_bit] 									= 1'b1;
						decode_o[`decode_o_functional_unit_msb:`decode_o_functional_unit_lsb] 	= 3'd4;
					
						case (decode_i[`funct3_msb:`funct3_lsb])
							`funct3_sb	: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd51;
							`funct3_sh	: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd49;
							`funct3_sw	: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd46;
							`funct3_sd 	: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd43;
							
							default : xcpt_illegal_instruction_int 	= 1'b1;
						endcase
					end
					
				`atomic_type 	: 
					begin
						decode_o[`decode_o_sirf_write_enable] 									= 1'b1;
						decode_o[`decode_o_use_immediate_bit] 									= 1'b0;
						decode_o[`decode_o_functional_unit_msb:`decode_o_functional_unit_lsb] 	= 3'd4;
					
						case (decode_i[`funct3_msb:`funct3_lsb])
							`funct3_amo32 	:
								case (decode_i[`funct5_msb:`funct5_lsb])
									`funct5_lr_d 		:
										if (decode_i[`rs2_msb:`rs2_lsb] != 5'b0)
											xcpt_illegal_instruction_int 											= 1'b1;
										else
											decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd53;
											
									`funct5_sc_d 		: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd55;
									`funct5_amoswap_d 	: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd57;
									`funct5_amoadd_d 	: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd58;
									`funct5_amoxor_d 	: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd61;
									`funct5_amoand_d 	: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd59;
									`funct5_amoor_d 	: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd60;
									`funct5_amomin_d 	: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd64;
									`funct5_amomax_d 	: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd62;
									`funct5_amominu_d 	: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd65;
									`funct5_amomaxu_d 	: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd63;
									
									default 	: xcpt_illegal_instruction_int 	= 1'b1;
								endcase
								
							`funct3_amo64 	:
								case (decode_i[`funct5_msb:`funct5_lsb])
									`funct5_lr_w 		:
										if (decode_i[`rs2_msb:`rs2_lsb] != 'h0)
											xcpt_illegal_instruction_int 												= 1'b1;
										else
											decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] 	= 7'd54;
											
									`funct5_sc_w		: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd56;
									`funct5_amoswap_w	: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd66;
									`funct5_amoadd_w	: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd67;
									`funct5_amoxor_w	: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd70;
									`funct5_amoand_w	: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd68;
									`funct5_amoor_w		: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd69;
									`funct5_amomin_w	: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd73;
									`funct5_amomax_w	: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd71;
									`funct5_amominu_w	: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd74;
									`funct5_amomaxu_w 	: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd72;
									
									default 	: xcpt_illegal_instruction_int 	= 1'b1;
								endcase
								
								
							default : xcpt_illegal_instruction_int = 1'b1;
						endcase
					end
					
				`alu_i_type 	:
					begin
						decode_o[`decode_o_use_immediate_bit] = 1'b1;
						decode_o[`decode_o_sirf_write_enable] = 1'b1;
						
						case (decode_i[`funct3_msb:`funct3_lsb])
							`funct3_addi : decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd0;
							`funct3_slti : decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd21;
							`funct3_sltiu : decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd22;
							`funct3_xori : decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd4;
							`funct3_ori : decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd5;
							`funct3_andi : decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd6;
							
							`funct3_slli :
								begin
								decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd9;
								
									if ((decode_i[`funct7_msb:`funct7_lsb] >> 1) != (7'b0000000 >> 1))
										xcpt_illegal_instruction_int = 1'b1;
									else
										xcpt_illegal_instruction_int = 1'b0;
								end
							
							`funct3_srai :
								case (decode_i[`funct7_msb:`funct7_lsb] >> 1)
									7'b0100000 >> 1: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd7;
									7'b0000000 >> 1: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd8;
									
									default : xcpt_illegal_instruction_int = 1'b1;
								endcase
						endcase
					end
				
				`alu_type 		: 
					begin
						decode_o[`decode_o_sirf_write_enable] = 1'b1;
					
						case ({decode_i[`funct7_msb:`funct7_lsb], decode_i[`funct3_msb:`funct3_lsb]})
							{`funct7_common, `funct3_add_sub} 		: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd0;
							{`funct7_srai_sub_sra, `funct3_add_sub} : decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd1;
							{`funct7_common, `funct3_sll} 			: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd9;
							{`funct7_common, `funct3_slt} 			: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd21;
							{`funct7_common, `funct3_sltu} 			: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd22;
							{`funct7_common, `funct3_xor} 			: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd4;
							{`funct7_common, `funct3_srl_sra} 		: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd8;
							{`funct7_sari_sub_sra, `funct3_srl_sra} : decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd7;
							{`funct7_common, `funct3_or} 			: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd5;
							{`funct7_common, `funct3_and} 			: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd6;
							
							{`funct7_mul_div, `funct3_mul} 	:
								begin
									decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd75;
									decode_o[`decode_o_functional_unit_msb:`decode_o_functional_unit_lsb] 	= 3'd2;
								end
								
							{`funct7_mul_div, `funct3_mulh} 		:
								begin
									decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd76;
									decode_o[`decode_o_functional_unit_msb:`decode_o_functional_unit_lsb] 	= 3'd2;
								end
								
							{`funct7_mul_div, `funct3_mulhsu} 		:
								begin
									decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd78;
									decode_o[`decode_o_functional_unit_msb:`decode_o_functional_unit_lsb] 	= 3'd2;
								end
								
							{`funct7_mul_div, `funct3_mulhu} 		:
								begin
									decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd77;
									decode_o[`decode_o_functional_unit_msb:`decode_o_functional_unit_lsb] 	= 3'd2;
								end
								
							{`funct7_mul_div, `funct3_div} 			:
								begin
									decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd80;
									decode_o[`decode_o_functional_unit_msb:`decode_o_functional_unit_lsb] 	= 3'd1;
									decode_o[`decode_o_signed_operation_bit] = 1'b1;
								end
								
							{`funct7_mul_div, `funct3_divu} 		:
								begin
									decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd81;
									decode_o[`decode_o_functional_unit_msb:`decode_o_functional_unit_lsb] 	= 3'd1;
								end
								
							{`funct7_mul_div, `funct3_rem} 			:
								begin
									decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd84;
									decode_o[`decode_o_functional_unit_msb:`decode_o_functional_unit_lsb] 	= 3'd1;
									decode_o[`decode_o_signed_operation_bit] = 1'b1;
								end
								
							{`funct7_mul_div, `funct3_remu} 		:
								begin
									decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd85;
									decode_o[`decode_o_functional_unit_msb:`decode_o_functional_unit_lsb] 	= 3'd1;
								end
							
							default 		: xcpt_illegal_instruction_int = 1'b1;
						endcase
					end
					
				`alu_i_w_type 	:
					begin
						decode_o[`decode_o_use_immediate_bit] = 1'b1;
						decode_o[`decode_o_sirf_write_enable] = 1'b1;
						decode_o[`decode_o_op_32_bit] = 1'b1;
						
						case (decode_i[`funct3_msb:`funct3_lsb])
							`funct3_addiw 		: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd2;
							
							`funct3_slliw 		:
								begin
									decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd11;
								
									if (decode_i[`funct7_msb:`funct7_lsb] != 7'b0000000)
										xcpt_illegal_instruction_int = 1'b1;
									else
										xcpt_illegal_instruction_int = 1'b0;
								end
								
							`funct3_srliw_sraiw :
								case (decode_i[`funct7_msb:`funct7_lsb])
									`funct7_sraiw_subw_sraw	: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd12;
									`funct7_common 	: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd10;
									
									default 	: xcpt_illegal_instruction_int = 1'b1;
								endcase
								
							default: xcpt_illegal_instruction_int = 1'b1;
						endcase
					end
				
				`alu_w_type 	:
					begin
						decode_o[`decode_o_sirf_write_enable] = 1'b1;
						decode_o[`decode_o_op_32_bit] = 1'b1;
						
						case ({decode_i[`funct7_msb:`funct7_lsb], decode_i[`funct3_msb:`funct3_lsb]})
							{`funct7_common, 		`funct3_addw_subw} 	: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd2;
							{`funct7_srai_sub_sra, 	`funct3_addw_subw} 	: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd3;
							{`funct7_common, 		`funct3_sllw} 		: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd11;
							{`funct7_common, 		`funct3_srlw_sraw} 	: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd10;
							{`funct7_srai_sub_sra, 	`funct3_addw_subw} 	: decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd12;
							
							{`funct7_mul_div, 		`funct3_mulw} 		:
								begin
									decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd79;
									decode_o[`decode_o_functional_unit_msb:`decode_o_functional_unit_lsb] 	= 3'd2;
								end
								
							{`funct7_mul_div, 		`funct3_divw} 		:
								begin
									decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd82;
									decode_o[`decode_o_functional_unit_msb:`decode_o_functional_unit_lsb] 	= 3'd1;
									decode_o[`decode_o_signed_operation_bit] = 1'b1;
								end
								
							{`funct7_mul_div, 		`funct3_divuw} 		:
								begin
									decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd83;
									decode_o[`decode_o_functional_unit_msb:`decode_o_functional_unit_lsb] 	= 3'd1;
								end
							
							{`funct7_mul_div, 		`funct3_remw} 		:
								begin
									decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd86;
									decode_o[`decode_o_functional_unit_msb:`decode_o_functional_unit_lsb] 	= 3'd1;
									decode_o[`decode_o_signed_operation_bit] = 1'b1;
								end
								
							{`funct7_mul_div, 		`funct3_remuw} 		:
								begin
									decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd87;
									decode_o[`decode_o_functional_unit_msb:`decode_o_functional_unit_lsb] 	= 3'd1;
								end
							
							default 		: xcpt_illegal_instruction_int = 1'b1;
						endcase
					end
					
				`fence_type 	:
					case (decode_i[`funct3_msb:`funct3_lsb])
						`funct3_fence 	:
							begin
								decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd29;
								decode_o[`decode_o_stall_csr_fence_bit] 								= 1'b1;
							end
							
						`funct3_fence_i :
							begin
								decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd30;
								decode_o[`decode_o_stall_csr_fence_bit] 								= 1'b1;
							end
							
						default: xcpt_illegal_instruction_int = 1'b1;
					endcase
					
				`system_type 	:
					begin
						decode_o[`decode_o_use_immediate_bit] 									= 1'b1;
						decode_o[`decode_o_sirf_write_enable] 									= 1'b1;
						decode_o[`decode_o_functional_unit_msb:`decode_o_functional_unit_lsb] 	= 3'd6;
						
					case (decode_i[`funct3_msb:`funct3_lsb])
						`funct3_ecall_ebreak_eret 	:
							begin
								decode_o[`decode_o_sirf_write_enable] = 1'b0;
								
							if (decode_i[`rd_msb:`rd_lsb] != 'h0)
								xcpt_illegal_instruction_int = 1'b1;
								
							else
								case (decode_i[`funct7_msb:`funct7_lsb])
									`funct7_ecall_ebreak_uret 		:
										if (decode_i[`rs1_msb:`rs1_lsb] != 'h0)
											xcpt_illegal_instruction_int = 1'b1;
											
										else
											case (decode_i[`rs2_msb:`rs2_lsb])
												`rs2_ecall_eret 		:
													begin
														decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd26;
														decode_o[`decode_o_stall_csr_fence_bit] 								= 1'b1;
													end
													
												`rs2_ebreak_sfencevm :
													begin
														decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd27;
														decode_o[`decode_o_stall_csr_fence_bit] 								= 1'b1;
													end
													
												`rs2_uret_sret_mret 	:
													begin
														decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd25;
														decode_o[`decode_o_stall_csr_fence_bit] 								= 1'b1;
													end
												
												default		: xcpt_illegal_instruction_int 	= 1'b1;
											endcase
											
									`funct7_sret_wfi_eret_sfence 	:
										if (decode_i[`rs1_msb:`rs1_lsb] != 5'b0)
											xcpt_illegal_instruction_int = 1'b1;
											
										else
											case (decode_i[`rs2_msb:`rs2_lsb])
												`rs2_uret_sret_mret 	:
													begin
														decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd24;
														decode_o[`decode_o_stall_csr_fence_bit] 								= 1'b1;
													end
													
												`rs2_wfi 			:
													begin
														decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd28;
														decode_o[`decode_o_stall_csr_fence_bit] 								= 1'b1;
													end
													
												`rs2_ebreak_sfencevm :
													begin
														decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd31;
														decode_o[`decode_o_stall_csr_fence_bit] 								= 1'b1;
													end
													
												default 	: xcpt_illegal_instruction_int 	= 1'b1;
											endcase
											
									`sfence_vm 						:
										if (decode_i[`rs1_msb:`rs1_lsb] != 'h0)
											xcpt_illegal_instruction_int = 1'b1;
											
										else
											case (decode_i[`rs2_msb:`rs2_lsb])
												`rs2_uret_sret_mret :
													begin
														decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd23;
														decode_o[`decode_o_stall_csr_fence_bit] 								= 1'b1;
													end
													
												default 	: xcpt_illegal_instruction_int = 1'b1;
											endcase
											
									`mret_mrts 						:
										begin
											decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd31;
											decode_o[`decode_o_stall_csr_fence_bit] 								= 1'b1;
										end
										
									default 	: xcpt_illegal_instruction_int = 1'b1;
								endcase
							end
							
						`funct3_csrrw 				:
							begin
								decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd36;
								decode_o[`decode_o_stall_csr_fence_bit] 								= 1'b1;
							end
							
						`funct3_csrrs 				:
							begin
								decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd37;
								decode_o[`decode_o_stall_csr_fence_bit] 								= 1'b1;
							end
							
						`funct3_csrrc 				:
							begin
								decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd38;
								decode_o[`decode_o_stall_csr_fence_bit] 								= 1'b1;
							end
							
						`funct3_csrrwi 				:
							begin
								decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd39;
								decode_o[`decode_o_stall_csr_fence_bit] 								= 1'b1;
							end
							
						`funct3_csrrsi 				:
							begin
								decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd40;
								decode_o[`decode_o_stall_csr_fence_bit] 								= 1'b1;
							end
							
						`funct3_csrrci 				:
							begin
								decode_o[`decode_o_instruction_type_msb:`decode_o_instruction_type_lsb] = 7'd41;
								decode_o[`decode_o_stall_csr_fence_bit] 								= 1'b1;
							end
							
						default : xcpt_illegal_instruction_int = 1'b1;
					endcase
				end
				
				default: xcpt_illegal_instruction_int = 1'b1;
			endcase
		end
	
	always @ (*)
		if (!decode_i[`valid_exception_bit])
			if (xcpt_addr_misaligned_int)
				begin
					decode_o[`decode_o_exception_valid_bit] 								= 1'b1;
					
					// Deleted the sv2v_cast_93998 function invocation (What is it for anyway?)
					decode_o[`decode_o_exception_cause_msb:`decode_o_exception_cause_lsb] 	= 64'b0;
					decode_o[`decode_o_exception_origin_msb:`decode_o_exception_origin_lsb] = jal_o[`jal_o_jump_address_msb:`jal_o_jump_address_lsb];
				end
				
			else if (xcpt_illegal_instruction_int)
				begin
					decode_o[`decode_o_exception_valid_bit] 								= 1'b1;
					
					// Trimmed large 64'hxx...xx declarations to the minimum
					decode_o[`decode_o_exception_cause_msb:`decode_o_exception_cause_lsb] 	= 64'h2;
					decode_o[`decode_o_exception_origin_msb:`decode_o_exception_origin_lsb] = 'h0;
				end
					
			else 
				begin
					decode_o[`decode_o_exception_valid_bit] 								= 1'b0;
					decode_o[`decode_o_exception_cause_msb:`decode_o_exception_cause_lsb] 	= 64'hff;
					decode_o[`decode_o_exception_origin_msb:`decode_o_exception_origin_lsb] = 'h0;
				end
		else
			decode_o[`decode_o_exception_vector_msb:`decode_o_exception_vector_lsb] = decode_i[`exception_vector_msb:`exception_vector_lsb];
			
endmodule