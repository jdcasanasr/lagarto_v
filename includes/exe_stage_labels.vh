// "from_rr_i" Labels
`define from_rr_i_instruction_valid 			551
`define from_rr_i_pc 							550:487

// Prediction Vector
`define from_rr_i_prediction_branch				486:421
`define from_rr_i_is_branch						486
`define from_rr_i_branch_decision 				485
`define from_rr_i_predicted_address 			484:421

// Exception Vector
`define from_rr_i_exception_cause 				420:357
`define from_rr_i_exception_origin 				356:293
`define from_rr_i_exception_valid 				292

`define from_rr_i_rs1_address 					291:287
`define from_rr_i_rs2_address 					286:282
`define from_rr_i_rd_address 					281:277

`define from_rr_i_use_immediate 				276
`define from_rr_i_use_pc 						275
`define from_rr_i_operation_32b 				274

`define from_rr_i_functional_unit 				273:271

`define from_rr_i_pc_write_enable 				270

// * irf = Integer Register File
`define irf_write_enable 						269

`define from_rr_i_instruction_type 				268:262
`define from_rr_i_immediate 					261:198

`define from_rr_i_signed_operation				197

`define from_rr_i_memory_operation_size 		196:194

`define from_rr_i_stall_csr_fence				193

`define from_rr_i_rs1_data 						192:129
`define from_rr_i_rs2_data 						128:65

`define from_rr_i_csr_interrupt 				64
`define from_rr_i_csr_interrupt_cause 			63:0

//Data to Write Back
`define from_rr_i_csr_address_size 				209:198
`define from_rr_i_instruction_exception 		420:292

//"from_wb_i" Labels
`define from_wb_i_valid							69
`define from_wb_i_rd							68:64
`define from_wb_i_data							63:0

// "to_wb_o" Labels
`define to_wb_o_instruction_valid 				420
`define to_wb_o_pc								419:356
`define to_wb_o_rs1_address 					355:351
`define to_wb_o_instruction_type				350:344
`define to_wb_o_result_pc 						343:280
`define to_wb_o_rd_address						279:275
`define to_wb_o_result 							274:211
`define to_wb_o_branch_taken 					210
`define to_wb_o_prediction_vector				209:144
`define to_wb_o_exception_vector				143:15
`define to_wb_o_exception_cause					143:80
`define to_wb_o_exception_origin				79:16
`define to_wb_o_exception_valid					15
`define to_wb_o_irf_write_enable 				14
`define to_wb_o_pc_write_enable					13
`define to_wb_o_stall_csr_fence   				12
`define to_wb_o_csr_address						11:0

//"req_cpu_dcache_o" Labels
`define req_cpu_dcache_o_valid					248
`define req_cpu_dcache_o_kill					247
`define req_cpu_dcache_o_data_rs1				246:183
`define req_cpu_dcache_o_data_rs2				182:119
`define req_cpu_dcache_o_instruction_type		118:112		
`define req_cpu_dcache_o_memory_size			111:109
`define req_cpu_dcache_o_rd						108:104
`define req_cpu_dcache_o_immediate				103:40
`define req_cpu_dcache_o_io_base_address		39:0

//"resp_dcache_cpu_i" Labels
`define resp_dcache_cpu_i_data							132:69
`define resp_dcache_cpu_i_lock							68
`define resp_dcache_cpu_i_address						63:0
`define resp_dcache_cpu_i_exception_misaligned_store	67				
`define resp_dcache_cpu_i_exception_misaligned_load		66		
`define resp_dcache_cpu_i_exception_page_fault_store	65
`define resp_dcache_cpu_i_exception_page_fault_load		64

//"exe_if_branch_prediction_o" Labels
`define exe_if_branch_prediction_o_pc_execution						129:66
`define exe_if_branch_prediction_o_branch_address_result_exe		65:2
`define exe_if_branch_prediction_o_branch_taken_result_exe			1
`define exe_if_branch_prediction_o_is_branch_exe					0