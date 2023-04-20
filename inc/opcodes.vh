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
`define funct5_lr_d			5'b00010
`define funct5_sc_d			5'b00011
`define funct5_amoswap_d	5'b00001
`define funct5_amoadd_d 	5'b00000
`define funct5_amoxor_d 	5'b00100
`define funct5_amoand_d 	5'b01100
`define funct5_amoor_d 		5'b01000
`define funct5_amomin_d 	5'b10000
`define funct5_amomax_d 	5'b10100
`define funct5_amominu_d 	5'b11000
`define funct5_amomaxu_d 	5'b11100

// Atomic-W Type
`define funct5_lr_w			5'b00010
`define funct5_sc_w			5'b00011
`define funct5_amoswap_w	5'b00001
`define funct5_amoadd_w 	5'b00000
`define funct5_amoxor_w 	5'b00100
`define funct5_amoand_w 	5'b01100
`define funct5_amoor_w 		5'b01000
`define funct5_amomin_w 	5'b10000
`define funct5_amomax_w 	5'b10100
`define funct5_amominu_w 	5'b11000
`define funct5_amomaxu_w 	5'b11100

// Special RS2 Values
`define rs2_ecall_eret		5'b00000
`define rs2_ebreak_sfencevm 5'b00001
`define rs2_uret_sret_mret 	5'b00010
`define rs2_wfi 			5'b00101

// funct7
// ALU Type
`define funct7_srai_sub_sra 7'b0100000
`define funct7_common		7'b0000000

// MUL-DIV Type
`define funct7_mul_div 		7'b0000001

// ALU-I-W Type
`define funct7_sraiw_subw_sraw 	7'b0100000
`define funct7_common 			7'b0000000

// SYSTEM Type
`define funct7_ecall_ebreak_uret		7'b0000000
`define funct7_sret_wfi_eret_sfence		7'b0001000
`define sfence_vm						7'b0001001
`define mret_mrts 						7'b0011000