// decode_i's Field Labels
`define pc_msb 					291
`define pc_lsb 					228

`define instruction_msb 		227
`define instruction_lsb 		196

`define funct5_msb 				227
`define funct5_lsb 				223

`define funct7_msb 				227
`define funct7_lsb 				221

`define rs2_msb 				220
`define rs2_lsb 				216

`define rs1_msb 				215
`define rs1_lsb 				211

`define funct3_msb 				210
`define funct3_lsb 				208

`define rd_msb 					207
`define rd_lsb 					203

`define opcode_msb 				202
`define opcode_lsb 				196

`define valid_bit 				195

`define branch_prediction_msb 	194
`define branch_prediction_lsb 	129

`define is_branch_bit 			194
`define branch_decision_bit 	193
`define predicted_pc_msb 		192
`define predicted_pc_lsb 		129

`define exception_vector_msb 	128
`define exception_vector_lsb 	0

`define exception_cause_msb 	128
`define exception_cause_lsb 	65
`define exceptional_pc_msb 		64
`define exceptional_pc_lsb 		1
`define valid_exception_bit	 	0

// decode_o's Labels
`define decode_o_valid_bit 				358

`define decode_o_pc_msb 				357
`define decode_o_pc_lsb					294

`define decode_o_prediction_vector_msb 	293

`define decode_o_prediction_vector_lsb 	228

`define decode_o_exception_vector_msb 	227
`define decode_o_exception_vector_lsb	99

`define decode_o_exception_cause_msb 	227
`define decode_o_exception_cause_lsb 	164

`define decode_o_exception_origin_msb 	163
`define decode_o_exception_origin_lsb  	100

`define decode_o_exception_valid_bit 	99

`define decode_o_rs1_msb				98
`define decode_o_rs1_lsb				94

`define decode_o_rs2_msb				93
`define decode_o_rs2_lsb				89

`define decode_o_rd_msb					88
`define decode_o_rd_lsb					84

`define decode_o_use_immediate_bit 		83
`define decode_o_use_pc_bit				82
`define decode_o_op_32_bit 				81

// Changed from "unit"
`define decode_o_functional_unit_msb 	80
`define decode_o_functional_unit_lsb 	78

// Changed from "change_pc_ena"
`define decode_o_pc_write_enable_bit 	77

// Changed from "regfile_ena"
// * sirf = Scalar Integer Register File
`define decode_o_sirf_write_enable 		76

// Changed from "instr_type"
`define decode_o_instruction_type_msb	75
`define decode_o_instruction_type_lsb 	69

`define decode_o_result_msb				68
`define decode_o_result_lsb				5

`define decode_o_signed_operation_bit 	4

// lowRISC Related
`define decode_o_memory_size_msb 		3
`define decode_o_memory_size_lsb 		1

`define decode_o_stall_csr_fence_bit 	0