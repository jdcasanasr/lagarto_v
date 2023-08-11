`define		XLEN_LENGTH				64
`define		INSTRUCTION_SIZE		32
`define		REGFILE_WIDTH			5
`define 	decode_instruction_i	291:0
`define		decode_instruction_o	358:0
`define		jal_id_if_o_length		64:0
`define		imm_value_length		63:0

//
`define		jal_id_if_o_valid			64
`define		jal_id_if_o_jump_address	63-:`XLEN_LENGTH

//
`define		decode_i_instruction_pc_inst		291:228
`define		decode_i_instruction_inst			227:196
`define		decode_i_instruction_inst_funct7	227:221
`define		decode_i_instruction_inst_funct5	227:223
`define		decode_i_instruction_rs2			220:216
`define		decode_i_instruction_rs1			215:211
`define		decode_i_instruction_funct3			210:208
`define		decode_i_instruction_rd				207:203
`define		decode_i_instruction_opcode			202:196	
`define		decode_i_instruction_valid			195
`define		decode_i_instruction_bpred			194:129
`define		decode_i_instruction_ex				128:0	
`define		decode_i_instruction_ex_valid		0	

//
`define		decode_o_valid					358
`define		decode_o_pc						357:294
`define		decode_o_bpred					293:228
`define		decode_o_ex						227:99
`define		decode_o_ex_cause				227:164
`define		decode_o_ex_origin				163:100
`define		decode_o_ex_valid				99
`define		decode_o_rs1					98:94
`define		decode_o_rs2					93:89
`define		decode_o_rd						88:84
`define		decode_o_use_immediate			83
`define		decode_o_use_pc					82
`define		decode_o_operation_32			81
`define		decode_o_unit_select			80:78	
`define		decode_o_change_pc_enable		77
`define		decode_o_regfile_write_enable	76
`define		decode_o_instruction_type		75:69
`define		decode_o_result					68:5
`define		decode_o_signed_operation		4
`define		decode_o_memory_size			3:1			
`define		decode_o_stall_csr_fence		0

// opcode
`define lui_type 		7'b0110111
`define auipc_type 		7'b0010111
`define jal_type 		7'b1101111
`define jalr_type 		7'b1100111
`define branch_type 	7'b1100011
`define load_type 		7'b0000011
`define store_type 		7'b0100011
`define atomic_type 	7'b0101111
`define alu_i_type 		7'b0010011
`define alu_type 		7'b0110011
`define alu_i_w_type 	7'b0011011
`define alu_w_type 		7'b0111011
`define fence_type 		7'b0001111
`define system_type		7'b1110011		

// funct3
// Branch Type
`define funct3_beq		3'b000
`define funct3_bne		3'b001
`define funct3_blt		3'b100
`define funct3_bge		3'b101
`define funct3_bltu		3'b110
`define funct3_bgeu		3'b111

// Load Type
`define funct3_lb 		3'b000
`define funct3_lh		3'b001
`define funct3_lw		3'b010
`define funct3_ld		3'b011
`define funct3_lbu		3'b100
`define funct3_lhu		3'b101
`define funct3_lwu		3'b110

// Store Type
`define funct3_sb 		3'b000
`define funct3_sh		3'b001
`define funct3_sw		3'b010
`define funct3_sd		3'b011

// Atomic Type
`define funct3_amo32 	3'b010
`define funct3_amo64 	3'b011

// ALU-Immediate Type
`define funct3_addi		3'b000
`define funct3_slti		3'b010
`define funct3_sltiu	3'b011
`define funct3_xori		3'b100
`define funct3_ori		3'b110
`define funct3_andi		3'b111
`define funct3_slli		3'b001
`define funct3_srai		3'b101

// ALU Type
`define funct3_add_sub 	3'b000
`define funct3_sll 		3'b001
`define funct3_slt		3'b010
`define funct3_sltu		3'b011
`define funct3_xor		3'b100
`define funct3_srl_sra 	3'b101
`define funct3_or		3'b110
`define funct3_and		3'b111

// MUL-DIV Type
`define funct3_mul 		3'b000
`define funct3_mulh 	3'b001
`define funct3_mulhsu	3'b010
`define funct3_mulhu	3'b011
`define funct3_div		3'b100
`define funct3_divu		3'b101
`define funct3_rem		3'b110
`define funct3_remu		3'b111

// ALU-I-W Type
`define funct3_addiw		3'b000
`define funct3_slliw 		3'b001
`define funct3_srliw_sraiw 	3'b101

// ALU-W Type
`define funct3_addw_subw 	3'b000
`define funct3_sllw			3'b001
`define funct3_srlw_sraw 	3'b101
`define funct3_mulw			3'b000
`define funct3_divw			3'b100
`define funct3_divuw		3'b101
`define funct3_remw			3'b110
`define funct3_remuw		3'b111

// FENCE Type
`define funct3_fence		3'b000
`define funct3_fence_i 		3'b001

// SYSTEM Type
`define funct3_ecall_ebreak_eret 	3'b000
`define funct3_csrrw				3'b001
`define funct3_csrrs				3'b010
`define funct3_csrrc				3'b011
`define funct3_csrrwi				3'b101
`define funct3_csrrsi				3'b110
`define funct3_csrrci				3'b111

// funct5
// Atomic Type
`define funct5_lr_d				5'b00010
`define funct5_sc_d				5'b00011
`define funct5_amoswap_d		5'b00001
`define funct5_amoadd_d 		5'b00000
`define funct5_amoxor_d 		5'b00100
`define funct5_amoand_d 		5'b01100
`define funct5_amoor_d 			5'b01000
`define funct5_amomin_d 		5'b10000
`define funct5_amomax_d 		5'b10100
`define funct5_amominu_d 		5'b11000
`define funct5_amomaxu_d 		5'b11100
	
// Atomic-W Type	
`define funct5_lr_w				5'b00010
`define funct5_sc_w				5'b00011
`define funct5_amoswap_w		5'b00001
`define funct5_amoadd_w 		5'b00000
`define funct5_amoxor_w 		5'b00100
`define funct5_amoand_w 		5'b01100
`define funct5_amoor_w 			5'b01000
`define funct5_amomin_w 		5'b10000
`define funct5_amomax_w 		5'b10100
`define funct5_amominu_w 		5'b11000
`define funct5_amomaxu_w 		5'b11100

// Special RS2 Values
`define rs2_ecall_eret				5'b00000
`define rs2_ebreak_sfencevm 		5'b00001
`define rs2_uret_sret_mret 			5'b00010
`define rs2_wfi 					5'b00101

// funct7
// ALU Type
`define funct7_srai_sub_sra 			7'b0100000
`define funct7_common					7'b0000000

// MUL-DIV Type
`define funct7_mul_div 					7'b0000001

// ALU-I-W Type
`define funct7_sraiw_subw_sraw 			7'b0100000
`define funct7_common 					7'b0000000

// SYSTEM Type
`define funct7_ecall_ebreak_uret		7'b0000000
`define funct7_sret_wfi_eret_sfence		7'b0001000
`define sfence_vm						7'b0001001
`define mret_mrts 						7'b0011000

// Instruction Type
`define		inst_add			7'd0
`define		inst_sub			7'd1
`define		inst_addw			7'd2
`define		inst_subw			7'd3
`define		inst_xor			7'd4
`define		inst_or				7'd5
`define		inst_and			7'd6
`define		inst_sra			7'd7
`define		inst_srl			7'd8
`define		inst_sll			7'd9
`define		inst_srlw			7'd10
`define		inst_sllw			7'd11
`define		inst_sraw			7'd12
`define		inst_blt			7'd13
`define		inst_bltu			7'd14
`define		inst_bge			7'd15
`define		inst_bgeu			7'd16
`define		inst_beq			7'd17
`define		inst_bne			7'd18
`define		inst_jalr			7'd19
`define		inst_jal			7'd20
`define		inst_slt			7'd21
`define		inst_sltu			7'd22
`define		inst_mret			7'd23
`define		inst_sret			7'd24
`define		inst_uret			7'd25
`define		inst_ecall			7'd26
`define		inst_ebreak			7'd27
`define		inst_wfi			7'd28
`define		inst_fence			7'd29
`define		inst_fence_i		7'd30
`define		inst_sfence_vma		7'd31
`define		inst_csrrw			7'd36
`define		inst_csrrs			7'd37
`define		inst_csrrc			7'd38
`define		inst_csrrwi			7'd39
`define		inst_csrrsi			7'd40
`define		inst_csrrci			7'd41
`define		inst_ld				7'd42
`define		inst_sd				7'd43
`define		inst_lw				7'd44
`define		inst_lwu			7'd45
`define		inst_sw				7'd46
`define		inst_lh				7'd47
`define		inst_lhu			7'd48
`define		inst_sh				7'd49
`define		inst_lb				7'd50
`define		inst_sb				7'd51
`define		inst_lbu			7'd52
`define		inst_amo_lrw		7'd53
`define		inst_amo_lrd		7'd54
`define		inst_amo_scw		7'd55
`define		inst_amo_scd		7'd56
`define		inst_amo_swapw		7'd57
`define		inst_amo_addw		7'd58
`define		inst_amo_andw		7'd59
`define		inst_amo_orw		7'd60
`define		inst_amo_xorw		7'd61
`define		inst_amo_maxw		7'd62
`define		inst_amo_maxwu		7'd63
`define		inst_amo_minw		7'd64
`define		inst_amo_minwu		7'd65
`define		inst_amo_swapd		7'd66
`define		inst_amo_addd		7'd67
`define		inst_amo_ord		7'd69
`define		inst_amo_xord		7'd70
`define		inst_amo_andd		7'd68
`define		inst_amo_maxd		7'd71
`define		inst_amo_mind		7'd73
`define		inst_amo_maxdu		7'd72
`define		inst_amo_mindu		7'd74
`define		inst_amo_mul		7'd75
`define		inst_amo_mulh		7'd76
`define		inst_amo_mulhu		7'd77
`define		inst_amo_mulhsu		7'd78
`define		inst_mulw			7'd79
`define		inst_amo_div		7'd80
`define		inst_amo_divu		7'd81
`define		inst_divw			7'd82
`define		inst_divuw			7'd83
`define		inst_amo_rem		7'd84
`define		inst_amo_remu		7'd85
`define		inst_remw			7'd86
`define		inst_remuw			7'd87							
													
// UNIT Select
`define		unit_alu		3'd0
`define		unit_div		3'd1
`define		unit_mul		3'd2
`define		unit_branch		3'd3
`define		unit_memory		3'd4
`define		unit_system		3'd6

// Error Flags
`define		address_misaligned		64'h0000000000000000
`define		illegal_instruction		64'h0000000000000002
`define		none					64'h00000000000000ff