// "from_rr_i" Labels
`define from_rr_i_instruction_valid 	551
`define from_rr_i_pc 					550:487

// Prediction Vector
`define from_rr_i_is_branch				486
`define from_rr_i_branch_decision 		485
`define from_rr_i_predicted_address 	484:421

// Exception Vector
`define from_rr_i_exception_cause 		420:357
`define from_rr_i_exception_origin 		356:293
`define from_rr_i_exception_valid 		292

`define from_rr_i_rs1_address 			291:287
`define from_rr_i_rs2_address 			286:282
`define from_rr_i_rd_address 			281:277

`define from_rr_i_use_immediate 		276
`define from_rr_i_use_pc 				275
`define from_rr_i_operation_32b 		274

`define from_rr_i_functional_unit 		273:271

`define from_rr_i_pc_write_enable 		270

// * irf = Integer Register File
`define irf_write_enable 				269

`define from_rr_i_instruction_type 		268:262
`define from_rr_i_immediate 			261:198

`define from_rr_i_signed_operation		197

`define from_rr_i_memory_operation_size 196:194

`define from_rr_i_stall_csr_fence		193

`define from_rr_i_rs1_data 				192:129
`define from_rr_i_rs2_data 				128:65

`define from_rr_i_csr_interrupt 		64
`define from_rr_i_csr_interrupt_cause 	63:0

// "to_wb_o" Labels
`define to_wb_o_instruction_valid 		420
`define to_wb_o_pc						419:356
`define to_wb_o_rs1_address 			355:351
`define to_wb_o_instruction_type		350:344
`define to_wb_o_result_pc 				343:280
`define to_wb_o_rd_address				279:275
`define to_wb_o_result 					274:211
`define to_wb_o_branch_taken 			210
`define to_wb_o_prediction_vector		209:144
`define to_wb_o_exception_vector		143:15
`define to_wb_o_irf_write_enable 		14
`define to_wb_o_pc_write_enable			13
`define to_wb_o_stall_csr_fence   		12
`define to_wb_o_csr_address				11:0