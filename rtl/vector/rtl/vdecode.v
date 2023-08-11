`include	"../../../includes/riscv_vector.vh"
`include	"../../../includes/riscv_vector_integer.vh"
`include	"../../../includes/riscv_vector_memory.vh"
`include	"../../../includes/riscv_vector_reduction.vh"
`include	"../../../includes/riscv_vector_permutation.vh"
`include	"../../../includes/riscv_vector_fixed_point.vh"
`include	"../../../includes/riscv_vector_floating_point.vh"
`include	"../../../includes/riscv_vector_mask.vh"

module	vdecode	
#(
	parameter INSTRUCTION_LENGTH	 	= 	`instruction_length,
	parameter SYSTEM_VECTOR_LENGTH 		=	`system_vector_length,
	parameter RESOURCE_VECTOR_LENGTH 	= 	`resource_vector_length,
	parameter REGISTER_VECTOR_LENGTH 	=	`register_vector_length,
	parameter OPERATION_VECTOR_LENGTH 	= 	`operation_vector_length
)                                            
(                                            
	input			[INSTRUCTION_LENGTH-1:0]			instruction_i,
		
	output	reg		[SYSTEM_VECTOR_LENGTH-1:0]			system_vector_o,
	output	reg		[RESOURCE_VECTOR_LENGTH-1:0]		resource_vector_o,
	output	reg		[REGISTER_VECTOR_LENGTH-1:0]		register_vector_o,
	output	reg		[OPERATION_VECTOR_LENGTH-1:0]		operation_vector_o
);
	always	@	(*)
	case	(instruction_i[`opcode])
	
		`op_arithmetic:		//arithmetic	&	permutation	&	reduction	&	fixed point	&	mask	&	floating point
			case	(instruction_i[`funct6])
				`vadd:		//vadd	&	vredsum	&	vfadd
					case	(instruction_i[`funct3_width])
						`OPIVV:		//vadd.vv
							begin
								system_vector_o		=	`vadd_vv_system_vector;
								resource_vector_o	=	`vadd_vv_resource_vector;
								register_vector_o	=	`vadd_vv_register_vector;
								operation_vector_o	=	`vadd_vv_operation_vector;
							end
						`OPIVX:		//vadd.vx
							begin
								system_vector_o		=	`vadd_vx_system_vector;
								resource_vector_o	=	`vadd_vx_resource_vector;
								register_vector_o	=	`vadd_vx_register_vector;
								operation_vector_o	=	`vadd_vx_operation_vector;
							end
						`OPIVI:		//vadd.vi
							begin
								system_vector_o		=	`vadd_vi_system_vector;
								resource_vector_o	=	`vadd_vi_resource_vector;
								register_vector_o	=	`vadd_vi_register_vector;
								operation_vector_o	=	`vadd_vi_operation_vector;
							end
						`OPMVV: 	// vredsum.vs
							begin
								system_vector_o		=	`vredsum_vs_system_vector;
								resource_vector_o	=	`vredsum_vs_resource_vector;
								register_vector_o	=	`vredsum_vs_register_vector;
								operation_vector_o	=	`vredsum_vs_operation_vector;
							end
						`OPFVV:		//vfadd.vv
							begin
								system_vector_o		=	`vfadd_vv_system_vector;
								resource_vector_o	=	`vfadd_vv_resource_vector;
								register_vector_o	=	`vfadd_vv_register_vector;
								operation_vector_o	=	`vfadd_vv_operation_vector;
							end
							
						`OPFVF:		//vfadd.vf
							begin
								system_vector_o		=	`vfadd_vf_system_vector;
								resource_vector_o	=	`vfadd_vf_resource_vector;
								register_vector_o	=	`vfadd_vf_register_vector;
								operation_vector_o	=	`vfadd_vf_operation_vector;
							end	
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
					
				`vsub:		//vsub	&	vredor
					case	(instruction_i[`funct3_width])
						`OPIVV:		//vsub.vv
							begin
								system_vector_o		=	`vsub_vv_system_vector;
								resource_vector_o	=	`vsub_vv_resource_vector;
								register_vector_o	=	`vsub_vv_register_vector;
								operation_vector_o	=	`vsub_vv_operation_vector;
							end
						`OPIVX:		//vsub.vx
							begin
								system_vector_o		=	`vsub_vx_system_vector;
								resource_vector_o	=	`vsub_vx_resource_vector;
								register_vector_o	=	`vsub_vx_register_vector;
								operation_vector_o	=	`vsub_vx_operation_vector;
							end
							
						`OPMVV: 	// vredor.vs
							begin
								system_vector_o		=	`vredor_vs_system_vector;
								resource_vector_o	=	`vredor_vs_resource_vector;
								register_vector_o	=	`vredor_vs_register_vector;
								operation_vector_o	=	`vredor_vs_operation_vector;
							end
							
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
					
				`vrsub:		//vrsub	&	vredxor	&	vfredosum
					case	(instruction_i[`funct3_width])
						`OPIVX:		//vrsub.vx
							begin
								system_vector_o		=	`vrsub_vx_system_vector;
								resource_vector_o	=	`vrsub_vx_resource_vector;
								register_vector_o	=	`vrsub_vx_register_vector;
								operation_vector_o	=	`vrsub_vx_operation_vector;
							end
						`OPIVI:		//vrsub.vi
							begin
								system_vector_o		=	`vrsub_vi_system_vector;
								resource_vector_o	=	`vrsub_vi_resource_vector;
								register_vector_o	=	`vrsub_vi_register_vector;
								operation_vector_o	=	`vrsub_vi_operation_vector;
							end
						`OPMVV: 	// vredxor.vs
							begin
								system_vector_o		=	`vredxor_vs_system_vector;
								resource_vector_o	=	`vredxor_vs_resource_vector;
								register_vector_o	=	`vredxor_vs_register_vector;
								operation_vector_o	=	`vredxor_vs_operation_vector;
							end
						`OPFVV:		// vfredosum.vs
							begin
								system_vector_o		=	`vfredosum_vs_system_vector;
								resource_vector_o	=	`vfredosum_vs_resource_vector;
								register_vector_o	=	`vfredosum_vs_register_vector;
								operation_vector_o	=	`vfredosum_vs_operation_vector;
							end
							
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
					
				`vwaddu:	//vwasaddu	&	vwredsumu	&	vfwaddu
					case	(instruction_i[`funct3_width])
						`OPMVV:		//vwaddu.vv
							begin
								system_vector_o		=	`vwaddu_vv_system_vector;
								resource_vector_o	=	`vwaddu_vv_resource_vector;
								register_vector_o	=	`vwaddu_vv_register_vector;
								operation_vector_o	=	`vwaddu_vv_operation_vector;
							end
						`OPMVX:		//vwaddu.vx
							begin
								system_vector_o		=	`vwaddu_vx_system_vector;
								resource_vector_o	=	`vwaddu_vx_resource_vector;
								register_vector_o	=	`vwaddu_vx_register_vector;
								operation_vector_o	=	`vwaddu_vx_operation_vector;
							end
							
						`OPIVV:		//vwredsumu.vs
							begin
								system_vector_o		=	`vwredsumu_vs_system_vector;
								resource_vector_o	=	`vwredsumu_vs_resource_vector;
								register_vector_o	=	`vwredsumu_vs_register_vector;
								operation_vector_o	=	`vwredsumu_vs_operation_vector;
							end
						`OPFVV:		//vfwadd.vv
							begin
								system_vector_o		=	`vfwadd_vv_system_vector;
								resource_vector_o	=	`vfwadd_vv_resource_vector;
								register_vector_o	=	`vfwadd_vv_register_vector;
								operation_vector_o	=	`vfwadd_vv_operation_vector;
							end
							
						`OPFVF:		//vfwadd.vf
							begin
								system_vector_o		=	`vfwadd_vf_system_vector;
								resource_vector_o	=	`vfwadd_vf_resource_vector;
								register_vector_o	=	`vfwadd_vf_register_vector;
								operation_vector_o	=	`vfwadd_vf_operation_vector;
							end
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
					
				`vwsubu:	//vwsubu	&	vfwsubu
					case	(instruction_i[`funct3_width])
						`OPMVV:		//vwsubu.vv
							begin
								system_vector_o		=	`vwsubu_vv_system_vector;
								resource_vector_o	=	`vwsubu_vv_resource_vector;
								register_vector_o	=	`vwsubu_vv_register_vector;
								operation_vector_o	=	`vwsubu_vv_operation_vector;
							end
						`OPMVX:		//vwsubu.vx
							begin
								system_vector_o		=	`vwsubu_vx_system_vector		;
								resource_vector_o	=	`vwsubu_vx_resource_vector;
								register_vector_o	=	`vwsubu_vx_register_vector;
								operation_vector_o	=	`vwsubu_vx_operation_vector;
							end
						`OPFVV:		//vfwsub.vv
							begin
								system_vector_o		=	`vfwsub_vv_system_vector;
								resource_vector_o	=	`vfwsub_vv_resource_vector;
								register_vector_o	=	`vfwsub_vv_register_vector;
								operation_vector_o	=	`vfwsub_vv_operation_vector;
							end
							
						`OPFVF:		//vfwsub.vf
							begin
								system_vector_o		=	`vfwsub_vf_system_vector		;
								resource_vector_o	=	`vfwsub_vf_resource_vector;
								register_vector_o	=	`vfwsub_vf_register_vector;
								operation_vector_o	=	`vfwsub_vf_operation_vector;
							end
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
					
				`vwadd:		//vwadd	&	vwredsum	&	vfwredusum
					case	(instruction_i[`funct3_width])
						`OPMVV:		//vwadd.vv
							begin
								system_vector_o		=	`vwadd_vv_system_vector;
								resource_vector_o	=	`vwadd_vv_resource_vector;
								register_vector_o	=	`vwadd_vv_register_vector;
								operation_vector_o	=	`vwadd_vv_operation_vector;
							end
						`OPMVX:		//vwadd.vx
							begin
								system_vector_o		=	`vwadd_vx_system_vector	;
								resource_vector_o	=	`vwadd_vx_resource_vector;
								register_vector_o	=	`vwadd_vx_register_vector;
								operation_vector_o	=	`vwadd_vx_operation_vector;
							end
							
						`OPIVV:		//vwredsum.vs
							begin
								system_vector_o		=	`vwredsum_vs_system_vector;
								resource_vector_o	=	`vwredsum_vs_resource_vector;
								register_vector_o	=	`vwredsum_vs_register_vector;
								operation_vector_o	=	`vwredsum_vs_operation_vector;
							end	
						
						`OPFVV:		// vfwredusum.vs
							begin
								system_vector_o		=	`vfwredusum_vs_system_vector;
								resource_vector_o	=	`vfwredusum_vs_resource_vector;
								register_vector_o	=	`vfwredusum_vs_register_vector;
								operation_vector_o	=	`vfwredusum_vs_operation_vector;
							end
						
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
					
				`vwsub:		//vwsub	&	vfwredosum
					case	(instruction_i[`funct3_width])
						`OPMVV:		//vwsub.vv
							begin
								system_vector_o		=	`vwsub_vv_system_vector;
								resource_vector_o	=	`vwsub_vv_resource_vector;
								register_vector_o	=	`vwsub_vv_register_vector;
								operation_vector_o	=	`vwsub_vv_operation_vector;
							end
						`OPMVX:		//vwsub.vx
							begin
								system_vector_o		=	`vwsub_vx_system_vector;
								resource_vector_o	=	`vwsub_vx_resource_vector;
								register_vector_o	=	`vwsub_vx_register_vector;
								operation_vector_o	=	`vwsub_vx_operation_vector;
							end
						`OPFVV:		//vfwredosum.vs
							begin
								system_vector_o		=	`vfwredosum_vs_system_vector;
								resource_vector_o	=	`vfwredosum_vs_resource_vector;
								register_vector_o	=	`vfwredosum_vs_register_vector;
								operation_vector_o	=	`vfwredosum_vs_operation_vector;
							end
							
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
					
				`vwaddu_w:	//vwaddu_w	&	vfwaddu_w
					case	(instruction_i[`funct3_width])
						`OPMVV:		//vwaddu.wv
							begin
								system_vector_o		=	`vwaddu_wv_system_vector;
								resource_vector_o	=	`vwaddu_wv_resource_vector;
								register_vector_o	=	`vwaddu_wv_register_vector;
								operation_vector_o	=	`vwaddu_wv_operation_vector;
							end
						`OPMVX:		//vwaddu.wx
							begin
								system_vector_o		=	`vwaddu_wx_system_vector;
								resource_vector_o	=	`vwaddu_wx_resource_vector;
								register_vector_o	=	`vwaddu_wx_register_vector;
								operation_vector_o	=	`vwaddu_wx_operation_vector;
							end
						`OPFVV:		//vfwadd.wv
							begin
								system_vector_o		=	`vfwadd_wv_system_vector;
								resource_vector_o	=	`vfwadd_wv_resource_vector;
								register_vector_o	=	`vfwadd_wv_register_vector;
								operation_vector_o	=	`vfwadd_wv_operation_vector;
							end
						`OPFVF:		//vfwadd.wf
							begin
								system_vector_o		=	`vfwadd_wf_system_vector;
								resource_vector_o	=	`vfwadd_wf_resource_vector;
								register_vector_o	=	`vfwadd_wf_register_vector;
								operation_vector_o	=	`vfwadd_wf_operation_vector;
							end
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
					
				`vwsubu_w:	//vwsubu_w	&	vfwsubu_w
					case	(instruction_i[`funct3_width])
						`OPMVV:		//vwsubu.wv
							begin
								system_vector_o		=	`vwsubu_wv_system_vector;
								resource_vector_o	=	`vwsubu_wv_resource_vector;
								register_vector_o	=	`vwsubu_wv_register_vector;
								operation_vector_o	=	`vwsubu_wv_operation_vector;
							end
						`OPMVX:		//vwsubu.wx
							begin
								system_vector_o		=	`vwsubu_wx_system_vector;
								resource_vector_o	=	`vwsubu_wx_resource_vector;
								register_vector_o	=	`vwsubu_wx_register_vector;
								operation_vector_o	=	`vwsubu_wx_operation_vector;
							end
						`OPFVV:		//vfwsub.wv
							begin
								system_vector_o		=	`vfwsub_wv_system_vector;
								resource_vector_o	=	`vfwsub_wv_resource_vector;
								register_vector_o	=	`vfwsub_wv_register_vector;
								operation_vector_o	=	`vfwsub_wv_operation_vector;
							end
						`OPFVF:		//vfwsub.wf
							begin
								system_vector_o		=	`vfwsub_wf_system_vector;
								resource_vector_o	=	`vfwsub_wf_resource_vector;
								register_vector_o	=	`vfwsub_wf_register_vector;
								operation_vector_o	=	`vfwsub_wf_operation_vector;
							end
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
					
				`vwadd_w:
					case	(instruction_i[`funct3_width])
						`OPMVV:		//vwadd.wv
							begin
								system_vector_o		=	`vwadd_wv_system_vector;
								resource_vector_o	=	`vwadd_wv_resource_vector;
								register_vector_o	=	`vwadd_wv_register_vector;
								operation_vector_o	=	`vwadd_wv_operation_vector;
							end
						`OPMVX:		//vwadd.wx
							begin
								system_vector_o		=	`vwadd_wv_system_vector;
								resource_vector_o	=	`vwadd_wv_resource_vector;
								register_vector_o	=	`vwadd_wv_register_vector;
								operation_vector_o	=	`vwadd_wv_operation_vector;
							end
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
					
				`vwsub_w:
					case	(instruction_i[`funct3_width])
						`OPMVV:		//vwsub.wv
							begin
								system_vector_o		=	`vwsub_wv_system_vector;
								resource_vector_o	=	`vwsub_wv_resource_vector;
								register_vector_o	=	`vwsub_wv_register_vector;
								operation_vector_o	=	`vwsub_wv_operation_vector;
							end
						`OPMVX:		//vwsub.wx
							begin
								system_vector_o		=	`vwsub_wx_system_vector;
								resource_vector_o	=	`vwsub_wx_resource_vector;
								register_vector_o	=	`vwsub_wx_register_vector;
								operation_vector_o	=	`vwsub_wx_operation_vector;
							end
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
					
				`vsext_vzext_vsbc:	//vsext	&	vzext	&	vsbc	&	vfunary0
					case	(instruction_i[`funct3_width])
						`OPMVV:
							case	(instruction_i[`vs1_rs1_imm])
								`funct5_vzext_vf2:		//vzext.vf2
									begin
										system_vector_o		=	`vzext_vf2_system_vector;
										resource_vector_o	=	`vzext_vf2_resource_vector;
										register_vector_o	=	`vzext_vf2_register_vector;
										operation_vector_o	=	`vzext_vf2_operation_vector;
									end
								`funct5_vsext_vf2:		//vsext.vf2
									begin
										system_vector_o		=	`vsext_vf2_system_vector;
										resource_vector_o	=	`vsext_vf2_resource_vector;
										register_vector_o	=	`vsext_vf2_register_vector;
										operation_vector_o	=	`vsext_vf2_operation_vector;
									end
								`funct5_vzext_vf4:		//vzext.vf4
									begin
										system_vector_o		=	`vzext_vf4_system_vector;
										resource_vector_o	=	`vzext_vf4_resource_vector;
										register_vector_o	=	`vzext_vf4_register_vector;
										operation_vector_o	=	`vzext_vf4_operation_vector;
									end
								`funct5_vsext_vf4:		//vsext.vf4
									begin
										system_vector_o		=	`vsext_vf4_system_vector;
										resource_vector_o	=	`vsext_vf4_resource_vector;
										register_vector_o	=	`vsext_vf4_register_vector;
										operation_vector_o	=	`vsext_vf4_operation_vector;
									end
								`funct5_vzext_vf8:		//vzext.vf8
									begin
										system_vector_o		=	`vzext_vf8_system_vector;
										resource_vector_o	=	`vzext_vf8_resource_vector;
										register_vector_o	=	`vzext_vf8_register_vector;
										operation_vector_o	=	`vzext_vf8_operation_vector;
									end
								`funct5_vsext_vf8:		//vsext.vf8
									begin
										system_vector_o		=	`vsext_vf8_system_vector;
										resource_vector_o	=	`vsext_vf8_resource_vector;
										register_vector_o	=	`vsext_vf8_register_vector;
										operation_vector_o	=	`vsext_vf8_operation_vector;
									end
								default:
									begin
										system_vector_o		=	`system_vector_default;
										resource_vector_o	=	`resource_vector_default;
										register_vector_o	=	`register_vector_default;
										operation_vector_o	=	`operation_vector_default;
									end
							endcase
						`OPIVV:		//vsbc.vvm
							begin
								system_vector_o		=	`vsbc_vvm_system_vector;
								resource_vector_o	=	`vsbc_vvm_resource_vector;
								register_vector_o	=	`vsbc_vvm_register_vector;
								operation_vector_o	=	`vsbc_vvm_operation_vector;
							end
						`OPIVX:		//vsbc.vxm
							begin
								system_vector_o		=	`vsbc_vxm_system_vector	;
								resource_vector_o	=	`vsbc_vxm_resource_vector;
								register_vector_o	=	`vsbc_vxm_register_vector;
								operation_vector_o	=	`vsbc_vxm_operation_vector;
							end
						`OPFVV:
							case	(instruction_i[`vs1_rs1_imm])
								`funct5_vfcvt_xu_f_v:		//vfcvt.xu.f.v
									begin
										system_vector_o		=	`vfcvt_xu_f_v_system_vector;
										resource_vector_o	=	`vfcvt_xu_f_v_resource_vector;
										register_vector_o	=	`vfcvt_xu_f_v_register_vector;
										operation_vector_o	=	`vfcvt_xu_f_v_operation_vector;
									end
							
								`funct5_vfcvt_x_f_v:		//vfcvt.x.f.v
									begin
										system_vector_o		=	`vfcvt_x_f_v_system_vector;
										resource_vector_o	=	`vfcvt_x_f_v_resource_vector;
										register_vector_o	=	`vfcvt_x_f_v_register_vector;
										operation_vector_o	=	`vfcvt_x_f_v_operation_vector;
									end
							
								`funct5_vfcvt_rtz_xu_f_v:		//vfcvt.rtz.xu.f.v
									begin
										system_vector_o		=	`vfcvt_rtz_xu_f_v_system_vector;
										resource_vector_o	=	`vfcvt_rtz_xu_f_v_resource_vector;
										register_vector_o	=	`vfcvt_rtz_xu_f_v_register_vector;
										operation_vector_o	=	`vfcvt_rtz_xu_f_v_operation_vector;
									end
							
								`funct5_vfcvt_rtz_x_f_v:		//vfcvt.rtz.x.f.v
									begin
										system_vector_o		=	`vfcvt_rtz_x_f_v_system_vector;
										resource_vector_o	=	`vfcvt_rtz_x_f_v_resource_vector;
										register_vector_o	=	`vfcvt_rtz_x_f_v_register_vector;
										operation_vector_o	=	`vfcvt_rtz_x_f_v_operation_vector;
									end
							
								`funct5_vfcvt_f_xu_v:		//vfcvt.f.xu.v
									begin
										system_vector_o		=	`vfcvt_f_xu_v_system_vector;
										resource_vector_o	=	`vfcvt_f_xu_v_resource_vector;
										register_vector_o	=	`vfcvt_f_xu_v_register_vector;
										operation_vector_o	=	`vfcvt_f_xu_v_operation_vector;
									end
							
								`funct5_vfcvt_f_x_v:		//vfcvt.f.x.v
									begin
										system_vector_o		=	`vfcvt_f_x_v_system_vector;
										resource_vector_o	=	`vfcvt_f_x_v_resource_vector;
										register_vector_o	=	`vfcvt_f_x_v_register_vector;
										operation_vector_o	=	`vfcvt_f_x_v_operation_vector;
									end
							
								`funct5_vfwcvt_xu_f_v:		//vfwcvt.xu.f.v
									begin
										system_vector_o		=	`vfwcvt_xu_f_v_system_vector;
										resource_vector_o	=	`vfwcvt_xu_f_v_resource_vector;
										register_vector_o	=	`vfwcvt_xu_f_v_register_vector;
										operation_vector_o	=	`vfwcvt_xu_f_v_operation_vector;
									end
							
								`funct5_vfwcvt_x_f_v:		//vfwcvt.x.f.v
									begin
										system_vector_o		=	`vfwcvt_x_f_v_system_vector;
										resource_vector_o	=	`vfwcvt_x_f_v_resource_vector;
										register_vector_o	=	`vfwcvt_x_f_v_register_vector;
										operation_vector_o	=	`vfwcvt_x_f_v_operation_vector;
									end
							
								`funct5_vfwcvt_rtz_xu_f_v:		//vfwcvt.rtz.xu.f.v
									begin
										system_vector_o		=	`vfwcvt_rtz_xu_f_v_system_vector;
										resource_vector_o	=	`vfwcvt_rtz_xu_f_v_resource_vector;
										register_vector_o	=	`vfwcvt_rtz_xu_f_v_register_vector;
										operation_vector_o	=	`vfwcvt_rtz_xu_f_v_operation_vector;
									end
							
								`funct5_vfwcvt_rtz_x_f_v:		//vfwcvt.rtz.x.f.v
									begin
										system_vector_o		=	`vfwcvt_rtz_x_f_v_system_vector;
										resource_vector_o	=	`vfwcvt_rtz_x_f_v_resource_vector;
										register_vector_o	=	`vfwcvt_rtz_x_f_v_register_vector;
										operation_vector_o	=	`vfwcvt_rtz_x_f_v_operation_vector;
									end
							
								`funct5_vfwcvt_f_f_v:		//vfwcvt.f.f.v
									begin
										system_vector_o		=	`vfwcvt_f_f_v_system_vector;
										resource_vector_o	=	`vfwcvt_f_f_v_resource_vector;
										register_vector_o	=	`vfwcvt_f_f_v_register_vector;
										operation_vector_o	=	`vfwcvt_f_f_v_operation_vector;
									end
							
								`funct5_vfncvt_xu_f_w:		//vfncvt.xu.f.w
									begin
										system_vector_o		=	`vfncvt_xu_f_w_system_vector;
										resource_vector_o	=	`vfncvt_xu_f_w_resource_vector;
										register_vector_o	=	`vfncvt_xu_f_w_register_vector;
										operation_vector_o	=	`vfncvt_xu_f_w_operation_vector;
									end
							
								`funct5_vfncvt_x_f_w:		//vfncvt.x.f.w
									begin
										system_vector_o		=	`vfncvt_x_f_w_system_vector;
										resource_vector_o	=	`vfncvt_x_f_w_resource_vector;
										register_vector_o	=	`vfncvt_x_f_w_register_vector;
										operation_vector_o	=	`vfncvt_x_f_w_operation_vector;
									end
							
								`funct5_vfncvt_rtz_xu_f_w:		//vfncvt.rtz.xu.f.w
									begin
										system_vector_o		=	`vfncvt_rtz_xu_f_w_system_vector;
										resource_vector_o	=	`vfncvt_rtz_xu_f_w_resource_vector;
										register_vector_o	=	`vfncvt_rtz_xu_f_w_register_vector;
										operation_vector_o	=	`vfncvt_rtz_xu_f_w_operation_vector;
									end
							
								`funct5_vfncvt_rtz_x_f_w:		//vfncvt.rtz.x.f.w
									begin
										system_vector_o		=	`vfncvt_rtz_x_f_w_system_vector;
										resource_vector_o	=	`vfncvt_rtz_x_f_w_resource_vector;
										register_vector_o	=	`vfncvt_rtz_x_f_w_register_vector;
										operation_vector_o	=	`vfncvt_rtz_x_f_w_operation_vector;
									end
							
								`funct5_vfncvt_f_xu_w:		//vfncvt.f.xu.w
									begin
										system_vector_o		=	`vfncvt_f_xu_w_system_vector;
										resource_vector_o	=	`vfncvt_f_xu_w_resource_vector;
										register_vector_o	=	`vfncvt_f_xu_w_register_vector;
										operation_vector_o	=	`vfncvt_f_xu_w_operation_vector;
									end
							
								`funct5_vfncvt_f_x_w:		//vfncvt.f.x.w
									begin
										system_vector_o		=	`vfncvt_f_x_w_system_vector;
										resource_vector_o	=	`vfncvt_f_x_w_resource_vector;
										register_vector_o	=	`vfncvt_f_x_w_register_vector;
										operation_vector_o	=	`vfncvt_f_x_w_operation_vector;
									end
							
								`funct5_vfncvt_f_f_w:		//vfncvt.f.f.w
									begin
										system_vector_o		=	`vfncvt_f_f_w_system_vector;
										resource_vector_o	=	`vfncvt_f_f_w_resource_vector;
										register_vector_o	=	`vfncvt_f_f_w_register_vector;
										operation_vector_o	=	`vfncvt_f_f_w_operation_vector;
									end
							
								`funct5_vfncvt_rod_f_f_w:		//vfncvt.rod.f.f.w
									begin
										system_vector_o		=	`vfncvt_rod_f_f_w_system_vector;
										resource_vector_o	=	`vfncvt_rod_f_f_w_resource_vector;
										register_vector_o	=	`vfncvt_rod_f_f_w_register_vector;
										operation_vector_o	=	`vfncvt_rod_f_f_w_operation_vector;
									end
							
								`funct5_vfwcvt_f_xu_v:		//vfwcvt.f.xu.v
									begin
										system_vector_o		=	`vfwcvt_f_xu_v_system_vector;
										resource_vector_o	=	`vfwcvt_f_xu_v_resource_vector;
										register_vector_o	=	`vfwcvt_f_xu_v_register_vector;
										operation_vector_o	=	`vfwcvt_f_xu_v_operation_vector;
									end
							
								`funct5_vfwcvt_f_x_v:		//vfwcvt.f.x.v
									begin
										system_vector_o		=	`vfwcvt_f_x_v_system_vector;
										resource_vector_o	=	`vfwcvt_f_x_v_resource_vector;
										register_vector_o	=	`vfwcvt_f_x_v_register_vector;
										operation_vector_o	=	`vfwcvt_f_x_v_operation_vector;
									end
									
								default:
									begin
										system_vector_o		=	`system_vector_default;
										resource_vector_o	=	`resource_vector_default;
										register_vector_o	=	`register_vector_default;
										operation_vector_o	=	`operation_vector_default;
									end
							endcase
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
					
				`vadc:		//vadc	&	vmv_x_s	&	vmv_s_x	&	vfmv_f_s	&	vfmv_s_f	&	vcpop	&	vfirst
					case	(instruction_i[`funct3_width])
						`OPIVV:		//vadc.vv
							begin
								system_vector_o		=	`vadc_vvm_system_vector;
								resource_vector_o	=	`vadc_vvm_resource_vector;
								register_vector_o	=	`vadc_vvm_register_vector;
								operation_vector_o	=	`vadc_vvm_operation_vector;
							end
						`OPIVX:		//vadc.vx
							begin
								system_vector_o		=	`vadc_vxm_system_vector;
								resource_vector_o	=	`vadc_vxm_resource_vector;
								register_vector_o	=	`vadc_vxm_register_vector;
								operation_vector_o	=	`vadc_vxm_operation_vector;
							end
						`OPIVI:		//vadc.vi
							begin
								system_vector_o		=	`vadc_vim_system_vector;
								resource_vector_o	=	`vadc_vim_resource_vector;
								register_vector_o	=	`vadc_vim_register_vector;
								operation_vector_o	=	`vadc_vim_operation_vector;
							end
						`OPMVV:
							case	(instruction_i[`vs1_rs1_imm])
								`vmv:
									if (instruction_i[`vm] == 1'b1)
										begin		// vmv.x.s
											system_vector_o		=	`vmv_x_s_system_vector;
											resource_vector_o	=	`vmv_x_s_resource_vector;
											register_vector_o	=	`vmv_x_s_register_vector;
											operation_vector_o	=	`vmv_x_s_operation_vector;
										end
										
									else
										begin
											system_vector_o		=	`system_vector_default;
											resource_vector_o	=	`resource_vector_default;
											register_vector_o	=	`register_vector_default;
											operation_vector_o	=	`operation_vector_default;
										end
								`vcpop_vs1:		//vcpop.m
									begin
										system_vector_o		=	`vcpop_m_system_vector;
										resource_vector_o	=	`vcpop_m_resource_vector;
										register_vector_o	=	`vcpop_m_register_vector;
										operation_vector_o	=	`vcpop_m_operation_vector;
									end
								`vfirst_vs1:	//vfirst.m
									begin
										system_vector_o		=	`vfirst_m_system_vector;
										resource_vector_o	=	`vfirst_m_resource_vector;
										register_vector_o	=	`vfirst_m_register_vector;
										operation_vector_o	=	`vfirst_m_operation_vector;
									end
								default:
									begin
										system_vector_o		=	`system_vector_default;
										resource_vector_o	=	`resource_vector_default;
										register_vector_o	=	`register_vector_default;
										operation_vector_o	=	`operation_vector_default;
									end
							endcase	
						`OPMVX: 	// vmv.s.x
							if (instruction_i[`vs2_sumop_lumop] == 5'b0 && instruction_i[`vm] == 1'b1)
								begin
									system_vector_o		=	`vmv_s_x_system_vector;
									resource_vector_o	=	`vmv_s_x_resource_vector;
									register_vector_o	=	`vmv_s_x_register_vector;
									operation_vector_o	=	`vmv_s_x_operation_vector;
								end
								
							else
								begin
									system_vector_o		=	`system_vector_default;
									resource_vector_o	=	`resource_vector_default;
									register_vector_o	=	`register_vector_default;
									operation_vector_o	=	`operation_vector_default;
								end
						`OPFVV: 	// vmv.f.s
							if (instruction_i[`vs1_rs1_imm] == 5'b0 && instruction_i[`vm] == 1'b1)
								begin
									system_vector_o		=	`vfmv_f_s_system_vector;
									resource_vector_o	=	`vfmv_f_s_resource_vector;
									register_vector_o	=	`vfmv_f_s_register_vector;
									operation_vector_o	=	`vfmv_f_s_operation_vector;
								end
							else
								begin
									system_vector_o		=	`system_vector_default;
									resource_vector_o	=	`resource_vector_default;
									register_vector_o	=	`register_vector_default;
									operation_vector_o	=	`operation_vector_default;
								end
						`OPFVF: 	// vmv.s.f
							if (instruction_i[`vs2_sumop_lumop] == 5'b0 && instruction_i[`vm] == 1'b1)
								begin
									system_vector_o		=	`vfmv_s_f_system_vector;
									resource_vector_o	=	`vfmv_s_f_resource_vector;
									register_vector_o	=	`vfmv_s_f_register_vector;
									operation_vector_o	=	`vfmv_s_f_operation_vector;
								end
							else
								begin
									system_vector_o		=	`system_vector_default;
									resource_vector_o	=	`resource_vector_default;
									register_vector_o	=	`register_vector_default;
									operation_vector_o	=	`operation_vector_default;
								end
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
					
				`vmadc:
					case	(instruction_i[`funct3_width])
						`OPIVV:		
							if	(instruction_i[`vm	==	1'b1])		//vmadc.vvm
								begin
									system_vector_o		=	`vmadc_vvm_system_vector;
									resource_vector_o	=	`vmadc_vvm_resource_vector;
									register_vector_o	=	`vmadc_vvm_register_vector;
									operation_vector_o	=	`vmadc_vvm_operation_vector;
								end
							else									//vmadc.vv
								begin
									system_vector_o		=	`vmadc_vv_system_vector;
									resource_vector_o	=	`vmadc_vv_resource_vector;
									register_vector_o	=	`vmadc_vv_register_vector;
									operation_vector_o	=	`vmadc_vv_operation_vector;
								end
						`OPIVX:		
							if	(instruction_i[`vm	==	1'b1])		//vmadc.vxm
								begin
									system_vector_o		=	`vmadc_vxm_system_vector;
									resource_vector_o	=	`vmadc_vxm_resource_vector;
									register_vector_o	=	`vmadc_vxm_register_vector;
									operation_vector_o	=	`vmadc_vxm_operation_vector;
								end
							else									//vmadc.vx
								begin
									system_vector_o		=	`vmadc_vx_system_vector;
									resource_vector_o	=	`vmadc_vx_resource_vector;
									register_vector_o	=	`vmadc_vx_register_vector;
									operation_vector_o	=	`vmadc_vx_operation_vector;
								end
						`OPIVI:		
							if	(instruction_i[`vm	==	1'b1])		//vmadc.vim
								begin
									system_vector_o		=	`vmadc_vim_system_vector;
									resource_vector_o	=	`vmadc_vim_resource_vector;
									register_vector_o	=	`vmadc_vim_register_vector;
									operation_vector_o	=	`vmadc_vim_operation_vector;
								end
							else									//vmadc.vi
								begin
									system_vector_o		=	`vmadc_vi_system_vector;
									resource_vector_o	=	`vmadc_vi_resource_vector;
									register_vector_o	=	`vmadc_vi_register_vector;
									operation_vector_o	=	`vmadc_vi_operation_vector;
								end
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
					
				`vmsbc:		//vmsbc	&	vfunary1
					case	(instruction_i[`funct3_width])
						`OPIVV:
							if	(instruction_i[`vm])		//vmsbc.vvm
								begin
									system_vector_o		=	`vmsbc_vvm_system_vector;
									resource_vector_o	=	`vmsbc_vvm_resource_vector;
									register_vector_o	=	`vmsbc_vvm_register_vector;
									operation_vector_o	=	`vmsbc_vvm_operation_vector;
								end
							else							//vmsbc.vv
								begin
									system_vector_o		=	`vmsbc_vv_system_vector;
									resource_vector_o	=	`vmsbc_vv_resource_vector;
									register_vector_o	=	`vmsbc_vv_register_vector;
									operation_vector_o	=	`vmsbc_vv_operation_vector;
								end
						`OPIVX:
							if	(instruction_i[`vm])		//vmsbc.vxm
								begin
									system_vector_o		=	`vmsbc_vxm_system_vector;
									resource_vector_o	=	`vmsbc_vxm_resource_vector;
									register_vector_o	=	`vmsbc_vxm_register_vector;
									operation_vector_o	=	`vmsbc_vxm_operation_vector;
								end
							else							//vmsbc.vx
								begin
									system_vector_o		=	`vmsbc_vx_system_vector;
									resource_vector_o	=	`vmsbc_vx_resource_vector;
									register_vector_o	=	`vmsbc_vx_register_vector;
									operation_vector_o	=	`vmsbc_vx_operation_vector;
								end
						`OPFVV:
							case(instruction_i[`vs1_rs1_imm])
								`funct5_vfsqrt_v:	//vfsqrt.v
									begin
										system_vector_o		=	`vfsqrt_v_system_vector;
										resource_vector_o	=	`vfsqrt_v_resource_vector;
										register_vector_o	=	`vfsqrt_v_register_vector;
										operation_vector_o	=	`vfsqrt_v_operation_vector;
									end
								
								`funct5_vfrsqrt7_v:	//vfrsqrt7.v
									begin
										system_vector_o		=	`vfrsqrt7_v_system_vector;
										resource_vector_o	=	`vfrsqrt7_v_resource_vector;
										register_vector_o	=	`vfrsqrt7_v_register_vector;
										operation_vector_o	=	`vfrsqrt7_v_operation_vector;
									end
									
								`funct5_vfrec7_v:	//vfrec7.v
									begin
										system_vector_o		=	`vfrec7_v_system_vector;
										resource_vector_o	=	`vfrec7_v_resource_vector;
										register_vector_o	=	`vfrec7_v_register_vector;
										operation_vector_o	=	`vfrec7_v_operation_vector;
									end
									
								`funct5_vfclass_v:	//vfclass.v
									begin
										system_vector_o		=	`vfclass_v_system_vector;
										resource_vector_o	=	`vfclass_v_resource_vector;
										register_vector_o	=	`vfclass_v_register_vector;
										operation_vector_o	=	`vfclass_v_operation_vector;
									end
									
								default:
									begin
										system_vector_o		=	`system_vector_default;
										resource_vector_o	=	`resource_vector_default;
										register_vector_o	=	`register_vector_default;
										operation_vector_o	=	`operation_vector_default;
									end	
							endcase
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
					
				`vand:		//vand	&	vaadd	&	vfsgnjn
					case	(instruction_i[`funct3_width])
						`OPIVV:		//vand.vv
							begin
								system_vector_o		=	`vand_vv_system_vector;
								resource_vector_o	=	`vand_vv_resource_vector;
								register_vector_o	=	`vand_vv_register_vector;
								operation_vector_o	=	`vand_vv_operation_vector;
							end
						`OPIVX:		//vand.vx
							begin
								system_vector_o		=	`vand_vx_system_vector;
								resource_vector_o	=	`vand_vx_resource_vector;
								register_vector_o	=	`vand_vx_register_vector;
								operation_vector_o	=	`vand_vx_operation_vector;
							end
						`OPIVI:		//vand.vi
							begin
								system_vector_o		=	`vand_vi_system_vector;
								resource_vector_o	=	`vand_vi_resource_vector;
								register_vector_o	=	`vand_vi_register_vector;
								operation_vector_o	=	`vand_vi_operation_vector;
							end
						`OPMVV:		//	vaadd.vv
							begin
								system_vector_o		=	`vaadd_vv_system_vector;
								resource_vector_o	=	`vaadd_vv_resource_vector;
								register_vector_o	=	`vaadd_vv_register_vector;
								operation_vector_o	=	`vaadd_vv_operation_vector;
							end
						`OPMVX:		//	vaadd.vx
							begin
								system_vector_o		=	`vaadd_vx_system_vector;
								resource_vector_o	=	`vaadd_vx_resource_vector;
								register_vector_o	=	`vaadd_vx_register_vector;
								operation_vector_o	=	`vaadd_vx_operation_vector;
							end
						`OPFVV:		//vfsgnjn.vv
							begin
								system_vector_o		=	`vfsgnjn_vv_system_vector;
								resource_vector_o	=	`vfsgnjn_vv_resource_vector;
								register_vector_o	=	`vfsgnjn_vv_register_vector;
								operation_vector_o	=	`vfsgnjn_vv_operation_vector;
							end
						`OPFVF:		//vfsgnjn.vf
							begin
								system_vector_o		=	`vfsgnjn_vf_system_vector;
								resource_vector_o	=	`vfsgnjn_vf_resource_vector;
								register_vector_o	=	`vfsgnjn_vf_register_vector;
								operation_vector_o	=	`vfsgnjn_vf_operation_vector;
							end
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
					
				`vor:		//vor	&	vasubu	&	vfsgnjx
					case	(instruction_i[`funct3_width])
						`OPIVV:		//vor.vv
							begin
								system_vector_o		=	`vor_vv_system_vector;   
								resource_vector_o	=	`vor_vv_resource_vector; 	
								register_vector_o	=	`vor_vv_register_vector; 
								operation_vector_o	=	`vor_vv_operation_vector;
							end
						`OPIVX:		//vor.vx
							begin
								system_vector_o		=	`vor_vx_system_vector;   
								resource_vector_o	=	`vor_vx_resource_vector; 
								register_vector_o	=	`vor_vx_register_vector; 
								operation_vector_o	=	`vor_vx_operation_vector;
							end
						`OPIVI:		//vor.vi
							begin
								system_vector_o		=	`vor_vi_system_vector;   
								resource_vector_o	=	`vor_vi_resource_vector; 
								register_vector_o	=	`vor_vi_register_vector; 
								operation_vector_o	=	`vor_vi_operation_vector;
							end
						`OPMVV:		//	vasubu.vv
							begin
								system_vector_o		=	`vasubu_vv_system_vector;
								resource_vector_o	=	`vasubu_vv_resource_vector;
								register_vector_o	=	`vasubu_vv_register_vector;
								operation_vector_o	=	`vasubu_vv_operation_vector;
							end
						`OPMVX:		//	vasubu.vx
							begin
								system_vector_o		=	`vasubu_vx_system_vector;
								resource_vector_o	=	`vasubu_vx_resource_vector;
								register_vector_o	=	`vasubu_vx_register_vector;
								operation_vector_o	=	`vasubu_vx_operation_vector;
							end
						`OPFVV:		//vfsgnjx.vv
							begin
								system_vector_o		=	`vfsgnjx_vv_system_vector;   
								resource_vector_o	=	`vfsgnjx_vv_resource_vector; 	
								register_vector_o	=	`vfsgnjx_vv_register_vector; 
								operation_vector_o	=	`vfsgnjx_vv_operation_vector;
							end
						`OPFVF:		//vfsgnjx.vf
							begin
								system_vector_o		=	`vfsgnjx_vf_system_vector;   
								resource_vector_o	=	`vfsgnjx_vf_resource_vector; 
								register_vector_o	=	`vfsgnjx_vf_register_vector; 
								operation_vector_o	=	`vfsgnjx_vf_operation_vector;
							end	
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
					
				`vxor:		//vxor	&	vasub
					case	(instruction_i[`funct3_width])
						`OPIVV:		//vxor.vv
							begin
								system_vector_o		=	`vxor_vv_system_vector;
								resource_vector_o	=	`vxor_vv_resource_vector;
								register_vector_o	=	`vxor_vv_register_vector;
								operation_vector_o	=	`vxor_vv_operation_vector;
							end
						`OPIVX:		//vxor.vx
							begin
								system_vector_o		=	`vxor_vx_system_vector;
								resource_vector_o	=	`vxor_vx_resource_vector;
								register_vector_o	=	`vxor_vx_register_vector;
								operation_vector_o	=	`vxor_vx_operation_vector;
							end
						`OPIVI:		//vxor.vi
							begin
								system_vector_o		=	`vxor_vi_system_vector;
								resource_vector_o	=	`vxor_vi_resource_vector;
								register_vector_o	=	`vxor_vi_register_vector;
								operation_vector_o	=	`vxor_vi_operation_vector;
							end
						
						`OPMVV:		//	vasub.vv
							begin
								system_vector_o		=	`vasub_vv_system_vector;
								resource_vector_o	=	`vasub_vv_resource_vector;
								register_vector_o	=	`vasub_vv_register_vector;
								operation_vector_o	=	`vasub_vv_operation_vector;
							end
						`OPMVX:		//	vasub.vx
							begin
								system_vector_o		=	`vasub_vx_system_vector;
								resource_vector_o	=	`vasub_vx_resource_vector;
								register_vector_o	=	`vasub_vx_register_vector;
								operation_vector_o	=	`vasub_vx_operation_vector;
							end
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
					
				`vsll_vmul:
					case	(instruction_i[`funct3_width])
						`OPIVV:		//vsll.vv
							begin
								system_vector_o		=	`vsll_vv_system_vector;
								resource_vector_o	=	`vsll_vv_resource_vector;
								register_vector_o	=	`vsll_vv_register_vector;
								operation_vector_o	=	`vsll_vv_operation_vector;
							end
						`OPIVX:		//vsll.vx
							begin
								system_vector_o		=	`vsll_vx_system_vector;
								resource_vector_o	=	`vsll_vx_resource_vector;
								register_vector_o	=	`vsll_vx_register_vector;
								operation_vector_o	=	`vsll_vx_operation_vector;
							end
						`OPIVI:		//vsll.vi
							begin
								system_vector_o		=	`vsll_vi_system_vector;
								resource_vector_o	=	`vsll_vi_resource_vector;
								register_vector_o	=	`vsll_vi_register_vector;
								operation_vector_o	=	`vsll_vi_operation_vector;
							end
						`OPMVV:		//vmul.vv
							begin
								system_vector_o		=	`vmul_vv_system_vector;
								resource_vector_o	=	`vmul_vv_resource_vector;
								register_vector_o	=	`vmul_vv_register_vector;
								operation_vector_o	=	`vmul_vv_operation_vector;
							end
						`OPMVX:		//vmul.vx
							begin
								system_vector_o		=	`vmul_vx_system_vector;
								resource_vector_o	=	`vmul_vx_resource_vector;
								register_vector_o	=	`vmul_vx_register_vector;
								operation_vector_o	=	`vmul_vx_operation_vector;
							end
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
					
				`vsrl:		//vsrl	&	vfmadd
					case	(instruction_i[`funct3_width])
						`OPIVV:		//vsrl.vv
							begin
								system_vector_o		=	`vsrl_vv_system_vector;	
								resource_vector_o	=	`vsrl_vv_resource_vector;
								register_vector_o	=	`vsrl_vv_register_vector;
								operation_vector_o	=	`vsrl_vv_operation_vector;
							end
						`OPIVX:		//vsrl.vx
							begin
								system_vector_o		=	`vsrl_vx_system_vector;	
								resource_vector_o	=	`vsrl_vx_resource_vector;
								register_vector_o	=	`vsrl_vx_register_vector;
								operation_vector_o	=	`vsrl_vx_operation_vector;
							end
						`OPIVI:		//vsrl.vi
							begin
								system_vector_o		=	`vsrl_vi_system_vector;	
								resource_vector_o	=	`vsrl_vi_resource_vector;
								register_vector_o	=	`vsrl_vi_register_vector;
								operation_vector_o	=	`vsrl_vi_operation_vector;
							end
						`OPFVV:		//vfmadd.vv
							begin
								system_vector_o		=	`vfmadd_vv_system_vector;	
								resource_vector_o	=	`vfmadd_vv_resource_vector;
								register_vector_o	=	`vfmadd_vv_register_vector;
								operation_vector_o	=	`vfmadd_vv_operation_vector;
							end
						`OPFVF:		//vfmadd.vf
							begin
								system_vector_o		=	`vfmadd_vf_system_vector;	
								resource_vector_o	=	`vfmadd_vf_resource_vector;
								register_vector_o	=	`vfmadd_vf_register_vector;
								operation_vector_o	=	`vfmadd_vf_operation_vector;
							end
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
					
				`vsra_vmadd:
					case	(instruction_i[`funct3_width])
						`OPIVV:		//vsra.vv
							begin
								system_vector_o		=	`vsra_vv_system_vector;
								resource_vector_o	=	`vsra_vv_resource_vector;
								register_vector_o	=	`vsra_vv_register_vector;
								operation_vector_o	=	`vsra_vv_operation_vector;
							end
						`OPIVX:		//vsra.vx
							begin
								system_vector_o		=	`vsra_vx_system_vector;
								resource_vector_o	=	`vsra_vx_resource_vector;
								register_vector_o	=	`vsra_vx_register_vector;
								operation_vector_o	=	`vsra_vx_operation_vector;
							end
						`OPIVI:		//vsra.vi
							begin
								system_vector_o		=	`vsra_vi_system_vector;
								resource_vector_o	=	`vsra_vi_resource_vector;
								register_vector_o	=	`vsra_vi_register_vector;
								operation_vector_o	=	`vsra_vi_operation_vector;
							end
						`OPMVV:		//vmadd.vv
							begin
								system_vector_o		=	`vmadd_vv_system_vector;
								resource_vector_o	=	`vmadd_vv_resource_vector;
								register_vector_o	=	`vmadd_vv_register_vector;
								operation_vector_o	=	`vmadd_vv_operation_vector;
							end
						`OPMVX:		//vmadd.vx
							begin
								system_vector_o		=	`vmadd_vx_system_vector;
								resource_vector_o	=	`vmadd_vx_resource_vector;
								register_vector_o	=	`vmadd_vx_register_vector;
								operation_vector_o	=	`vmadd_vx_operation_vector;
							end
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
					
				`vnsrl:		//vnsrl	&	vfmacc
					case	(instruction_i[`funct3_width])
						`OPIVV:		//vnsrl.wv
							begin
								system_vector_o		=	`vnsrl_wv_system_vector;
								resource_vector_o	=	`vnsrl_wv_resource_vector;
								register_vector_o	=	`vnsrl_wv_register_vector;
								operation_vector_o	=	`vnsrl_wv_operation_vector;
							end
							
						`OPIVX:		//vnsrl.wx
							begin
								system_vector_o		=	`vnsrl_wx_system_vector;
								resource_vector_o	=	`vnsrl_wx_resource_vector;
								register_vector_o	=	`vnsrl_wx_register_vector;
								operation_vector_o	=	`vnsrl_wx_operation_vector;
							end
							
						`OPIVI:		//vnsrl.wi
							begin
								system_vector_o		=	`vnsrl_wi_system_vector;
								resource_vector_o	=	`vnsrl_wi_resource_vector;
								register_vector_o	=	`vnsrl_wi_register_vector;
								operation_vector_o	=	`vnsrl_wi_operation_vector;
							end
						`OPFVV:		//vfmacc.vv
							begin
								system_vector_o		=	`vfmacc_vv_system_vector;
								resource_vector_o	=	`vfmacc_vv_resource_vector;
								register_vector_o	=	`vfmacc_vv_register_vector;
								operation_vector_o	=	`vfmacc_vv_operation_vector;
							end
						`OPFVF:		//vfmacc.vf
							begin
								system_vector_o		=	`vfmacc_vf_system_vector;
								resource_vector_o	=	`vfmacc_vf_resource_vector;
								register_vector_o	=	`vfmacc_vf_register_vector;
								operation_vector_o	=	`vfmacc_vf_operation_vector;
							end
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
					
				`vnsra_vmacc:	//vnsra	&	vmacc	&	vfnmacc
					if(instruction_i[`vm] == 0)	//vnsra
						case	(instruction_i[`funct3_width])
							`OPIVV:		//vnsra.wv
								begin
									system_vector_o		=	`vnsra_wv_system_vector;
									resource_vector_o	=	`vnsra_wv_resource_vector;
									register_vector_o	=	`vnsra_wv_register_vector;
									operation_vector_o	=	`vnsra_wv_operation_vector;
								end
								
							`OPIVX:		//vnsra.wx
								begin
									system_vector_o		=	`vnsra_wx_system_vector;
									resource_vector_o	=	`vnsra_wx_resource_vector;
									register_vector_o	=	`vnsra_wx_register_vector;
									operation_vector_o	=	`vnsra_wx_operation_vector;
								end
								
							`OPIVI:		//vnsra.wi
								begin
									system_vector_o		=	`vnsra_wi_system_vector;
									resource_vector_o	=	`vnsra_wi_resource_vector;
									register_vector_o	=	`vnsra_wi_register_vector;
									operation_vector_o	=	`vnsra_wi_operation_vector;
								end
							default:
								begin
									system_vector_o		=	`system_vector_default;
									resource_vector_o	=	`resource_vector_default;
									register_vector_o	=	`register_vector_default;
									operation_vector_o	=	`operation_vector_default;
								end
						endcase
					else		//vmacc
						case	(instruction_i[`funct3_width])
							`OPMVV:		//vmacc.vv
								begin
									system_vector_o		=	`vmacc_vv_system_vector;
									resource_vector_o	=	`vmacc_vv_resource_vector;
									register_vector_o	=	`vmacc_vv_register_vector;
									operation_vector_o	=	`vmacc_vv_operation_vector;
								end
								
							`OPMVX:		//vmacc.vx
								begin
									system_vector_o		=	`vmacc_vx_system_vector;
									resource_vector_o	=	`vmacc_vx_resource_vector;
									register_vector_o	=	`vmacc_vx_register_vector;
									operation_vector_o	=	`vmacc_vx_operation_vector;
								end
								
							`OPFVV:		//vfnmacc.vv
								begin
									system_vector_o		=	`vfnmacc_vv_system_vector;
									resource_vector_o	=	`vfnmacc_vv_resource_vector;
									register_vector_o	=	`vfnmacc_vv_register_vector;
									operation_vector_o	=	`vfnmacc_vv_operation_vector;
								end
								
							`OPFVF:		//vfnmacc.vf
								begin
									system_vector_o		=	`vfnmacc_vf_system_vector;
									resource_vector_o	=	`vfnmacc_vf_resource_vector;
									register_vector_o	=	`vfnmacc_vf_register_vector;
									operation_vector_o	=	`vfnmacc_vf_operation_vector;
								end
								
							default
								begin
									system_vector_o		=	`system_vector_default;
									resource_vector_o	=	`resource_vector_default;
									register_vector_o	=	`register_vector_default;
									operation_vector_o	=	`operation_vector_default;
								end
						endcase
				`vmseq:		//vmseq	&	vmfeq	&	vmandn
					case	(instruction_i[`funct3_width])
						`OPIVV:		//vmseq.vv
							begin
								system_vector_o		=	`vmseq_vv_system_vector;
								resource_vector_o	=	`vmseq_vv_resource_vector;
								register_vector_o	=	`vmseq_vv_register_vector;
								operation_vector_o	=	`vmseq_vv_operation_vector;
							end
							
						`OPIVX:		//vmseq.vx
							begin
								system_vector_o		=	`vmseq_vx_system_vector;
								resource_vector_o	=	`vmseq_vx_resource_vector;
								register_vector_o	=	`vmseq_vx_register_vector;
								operation_vector_o	=	`vmseq_vx_operation_vector;
							end
							
						`OPIVI:		//vmseq.vi
							begin
								system_vector_o		=	`vmseq_vi_system_vector;
								resource_vector_o	=	`vmseq_vi_resource_vector;
								register_vector_o	=	`vmseq_vi_register_vector;
								operation_vector_o	=	`vmseq_vi_operation_vector;
							end
						`OPFVV:		//vmfeq.vv
							begin
								system_vector_o		=	`vmfeq_vv_system_vector;
								resource_vector_o	=	`vmfeq_vv_resource_vector;
								register_vector_o	=	`vmfeq_vv_register_vector;
								operation_vector_o	=	`vmfeq_vv_operation_vector;
							end
							
						`OPFVF:		//vmfeq.vf
							begin
								system_vector_o		=	`vmfeq_vf_system_vector;
								resource_vector_o	=	`vmfeq_vf_resource_vector;
								register_vector_o	=	`vmfeq_vf_register_vector;
								operation_vector_o	=	`vmfeq_vf_operation_vector;
							end
							
						`OPMVV:		//vmandn.mm
							begin
								system_vector_o		=	`vmandn_mm_system_vector;
								resource_vector_o	=	`vmandn_mm_resource_vector;
								register_vector_o	=	`vmandn_mm_register_vector;
								operation_vector_o	=	`vmandn_mm_operation_vector;
							end
							
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
					
				`vmsne:		//vmsne	&	vmfle	&	vmand
					case	(instruction_i[`funct3_width])
						`OPIVV:		//vmsne.vv
							begin
								system_vector_o		=	`vmsne_vv_system_vector;
								resource_vector_o	=	`vmsne_vv_resource_vector;
								register_vector_o	=	`vmsne_vv_register_vector;
								operation_vector_o	=	`vmsne_vv_operation_vector;
							end
							
						`OPIVX:		//vmsne.vx
							begin
								system_vector_o		=	`vmsne_vx_system_vector;
								resource_vector_o	=	`vmsne_vx_resource_vector;
								register_vector_o	=	`vmsne_vx_register_vector;
								operation_vector_o	=	`vmsne_vx_operation_vector;
							end
							
						`OPIVI:		//vmsne.vi
							begin
								system_vector_o		=	`vmsne_vi_system_vector;
								resource_vector_o	=	`vmsne_vi_resource_vector;
								register_vector_o	=	`vmsne_vi_register_vector;
								operation_vector_o	=	`vmsne_vi_operation_vector;
							end
						`OPFVV:		//vmfle.vv
							begin
								system_vector_o		=	`vmfle_vv_system_vector;
								resource_vector_o	=	`vmfle_vv_resource_vector;
								register_vector_o	=	`vmfle_vv_register_vector;
								operation_vector_o	=	`vmfle_vv_operation_vector;
							end
							
						`OPFVF:		//vmfle.vf
							begin
								system_vector_o		=	`vmfle_vf_system_vector;
								resource_vector_o	=	`vmfle_vf_resource_vector;
								register_vector_o	=	`vmfle_vf_register_vector;
								operation_vector_o	=	`vmfle_vf_operation_vector;
							end
							
						`OPMVV:		//vmand.mm
							begin
								system_vector_o		=	`vmand_mm_system_vector;
								resource_vector_o	=	`vmand_mm_resource_vector;
								register_vector_o	=	`vmand_mm_register_vector;
								operation_vector_o	=	`vmand_mm_operation_vector;
							end
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
					
				`vmsltu:	//vmsltu	&	vmor
					case	(instruction_i[`funct3_width])
						`OPIVV:		//vmsltu.vv
							begin
								system_vector_o		=	`vmsltu_vv_system_vector;
								resource_vector_o	=	`vmsltu_vv_resource_vector;
								register_vector_o	=	`vmsltu_vv_register_vector;
								operation_vector_o	=	`vmsltu_vv_operation_vector;
							end
						`OPIVX:		//vmsltu.vx
							begin
								system_vector_o		=	`vmsltu_vx_system_vector;
								resource_vector_o	=	`vmsltu_vx_resource_vector;
								register_vector_o	=	`vmsltu_vx_register_vector;
								operation_vector_o	=	`vmsltu_vx_operation_vector;
							end
						`OPMVV:		//vmor.mm
							begin
								system_vector_o		=	`vmor_mm_system_vector;
								resource_vector_o	=	`vmor_mm_resource_vector;
								register_vector_o	=	`vmor_mm_register_vector;
								operation_vector_o	=	`vmor_mm_operation_vector;
							end
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
				
				`vmslt:		//vmslt	&	vmflt	&	vmxor
					case	(instruction_i[`funct3_width])
						`OPIVV:		//vmslt.vv
							begin
								system_vector_o		=	`vmslt_vv_system_vector;
								resource_vector_o	=	`vmslt_vv_resource_vector;
								register_vector_o	=	`vmslt_vv_register_vector;
								operation_vector_o	=	`vmslt_vv_operation_vector;
							end
							
						`OPIVX:		//vmslt.vx
							begin
								system_vector_o		=	`vmslt_vx_system_vector;
								resource_vector_o	=	`vmslt_vx_resource_vector;
								register_vector_o	=	`vmslt_vx_register_vector;
								operation_vector_o	=	`vmslt_vx_operation_vector;
							end
						`OPFVV:		//vmflt.vv
							begin
								system_vector_o		=	`vmflt_vv_system_vector;
								resource_vector_o	=	`vmflt_vv_resource_vector;
								register_vector_o	=	`vmflt_vv_register_vector;
								operation_vector_o	=	`vmflt_vv_operation_vector;
							end
							
						`OPFVF:		//vmflt.vf
							begin
								system_vector_o		=	`vmflt_vf_system_vector;
								resource_vector_o	=	`vmflt_vf_resource_vector;
								register_vector_o	=	`vmflt_vf_register_vector;
								operation_vector_o	=	`vmflt_vf_operation_vector;
							end
							
						`OPMVV:		//vmxor.mm
							begin
								system_vector_o		=	`vmxor_mm_system_vector;
								resource_vector_o	=	`vmxor_mm_resource_vector;
								register_vector_o	=	`vmxor_mm_register_vector;
								operation_vector_o	=	`vmxor_mm_operation_vector;
							end	
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
					
				`vmsleu:	//vmsleu	&	vmfne	&	vmorn
					case	(instruction_i[`funct3_width])
						`OPIVV:		//vmsleu.vv
							begin
								system_vector_o		=	`vmsleu_vv_system_vector;
								resource_vector_o	=	`vmsleu_vv_resource_vector;
								register_vector_o	=	`vmsleu_vv_register_vector;
								operation_vector_o	=	`vmsleu_vv_operation_vector;
							end
							
						`OPIVX:		//vmsleu.vx
							begin
								system_vector_o		=	`vmsleu_vx_system_vector;
								resource_vector_o	=	`vmsleu_vx_resource_vector;
								register_vector_o	=	`vmsleu_vx_register_vector;
								operation_vector_o	=	`vmsleu_vx_operation_vector;
							end
						
						`OPIVI:		//vmsleu.vi
							begin
								system_vector_o		=	`vmsleu_vi_system_vector;
								resource_vector_o	=	`vmsleu_vi_resource_vector;
								register_vector_o	=	`vmsleu_vi_register_vector;
								operation_vector_o	=	`vmsleu_vi_operation_vector;
							end
						`OPFVV:		//vmfne.vv
							begin
								system_vector_o		=	`vmfne_vv_system_vector;
								resource_vector_o	=	`vmfne_vv_resource_vector;
								register_vector_o	=	`vmfne_vv_register_vector;
								operation_vector_o	=	`vmfne_vv_operation_vector;
							end
						`OPFVF:		//vmfne.vf
							begin
								system_vector_o		=	`vmfne_vf_system_vector;
								resource_vector_o	=	`vmfne_vf_resource_vector;
								register_vector_o	=	`vmfne_vf_register_vector;
								operation_vector_o	=	`vmfne_vf_operation_vector;
							end
						`OPMVV:		//vmorn.mm
							begin
								system_vector_o		=	`vmorn_mm_system_vector;
								resource_vector_o	=	`vmorn_mm_resource_vector;
								register_vector_o	=	`vmorn_mm_register_vector;
								operation_vector_o	=	`vmorn_mm_operation_vector;
							end	
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
					
				`vmsle:		//vmsle	&	vmfgt	&	vmnand
					case	(instruction_i[`funct3_width])
						`OPIVV:		//vmsle.vv
							begin
								system_vector_o		=	`vmsle_vv_system_vector;
								resource_vector_o	=	`vmsle_vv_resource_vector;
								register_vector_o	=	`vmsle_vv_register_vector;
								operation_vector_o	=	`vmsle_vv_operation_vector;
							end
							
						`OPIVX:		//vmsle.vx
							begin
								system_vector_o		=	`vmsle_vx_system_vector;
								resource_vector_o	=	`vmsle_vx_resource_vector;
								register_vector_o	=	`vmsle_vx_register_vector;
								operation_vector_o	=	`vmsle_vx_operation_vector;
							end
						
						`OPIVI:		//vmsle.vi
							begin
								system_vector_o		=	`vmsle_vi_system_vector;
								resource_vector_o	=	`vmsle_vi_resource_vector;
								register_vector_o	=	`vmsle_vi_register_vector;
								operation_vector_o	=	`vmsle_vi_operation_vector;
							end
						`OPFVF:		//vmfgt.vx
							begin
								system_vector_o		=	`vmsle_vx_system_vector;
								resource_vector_o	=	`vmsle_vx_resource_vector;
								register_vector_o	=	`vmsle_vx_register_vector;
								operation_vector_o	=	`vmsle_vx_operation_vector;
							end
						
						`OPMVV:		//vmnand.mm
							begin
								system_vector_o		=	`vmnand_mm_system_vector;
								resource_vector_o	=	`vmnand_mm_resource_vector;
								register_vector_o	=	`vmnand_mm_register_vector;
								operation_vector_o	=	`vmnand_mm_operation_vector;
							end	
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
					
				`vmsgtu:	//vmsgtu	&	vmnor
					case	(instruction_i[`funct3_width])
						`OPIVX:		//vmsgtu.vx
							begin
								system_vector_o		=	`vmsgtu_vx_system_vector;
								resource_vector_o	=	`vmsgtu_vx_resource_vector;
								register_vector_o	=	`vmsgtu_vx_register_vector;
								operation_vector_o	=	`vmsgtu_vx_operation_vector;
							end
						
						`OPIVI:		//vmsgtu.vi
							begin
								system_vector_o		=	`vmsgtu_vi_system_vector;
								resource_vector_o	=	`vmsgtu_vi_resource_vector;
								register_vector_o	=	`vmsgtu_vi_register_vector;
								operation_vector_o	=	`vmsgtu_vi_operation_vector;
							end
						`OPMVV:		//vmnor.mm
							begin
								system_vector_o		=	`vmnor_mm_system_vector;
								resource_vector_o	=	`vmnor_mm_resource_vector;
								register_vector_o	=	`vmnor_mm_register_vector;
								operation_vector_o	=	`vmnor_mm_operation_vector;
							end	
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
					
				`vmsgt:		//vmsgt	&	vmfge	&	vmxnor
					case	(instruction_i[`funct3_width])
						`OPIVX:		//vmsgtu.vx
							begin
								system_vector_o		=	`vmsgt_vx_system_vector;
								resource_vector_o	=	`vmsgt_vx_resource_vector;
								register_vector_o	=	`vmsgt_vx_register_vector;
								operation_vector_o	=	`vmsgt_vx_operation_vector;
							end
						
						`OPIVI:		//vmsgtu.vi
							begin
								system_vector_o		=	`vmsgt_vi_system_vector;
								resource_vector_o	=	`vmsgt_vi_resource_vector;
								register_vector_o	=	`vmsgt_vi_register_vector;
								operation_vector_o	=	`vmsgt_vi_operation_vector;
							end
						`OPFVF:		//vmfge.vf
							begin
								system_vector_o		=	`vmfge_vf_system_vector;
								resource_vector_o	=	`vmfge_vf_resource_vector;
								register_vector_o	=	`vmfge_vf_register_vector;
								operation_vector_o	=	`vmfge_vf_operation_vector;
							end
						
						`OPMVV:		//vmxnor.mm
							begin
								system_vector_o		=	`vmxnor_mm_system_vector;
								resource_vector_o	=	`vmxnor_mm_resource_vector;
								register_vector_o	=	`vmxnor_mm_register_vector;
								operation_vector_o	=	`vmxnor_mm_operation_vector;
							end	
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
					
				`vminu:		//vminu	&	vfmin	&	vredminu
					case	(instruction_i[`funct3_width])
						`OPIVV:		//vminu.vv
							begin
								system_vector_o		=	`vminu_vv_system_vector;
								resource_vector_o	=	`vminu_vv_resource_vector;
								register_vector_o	=	`vminu_vv_register_vector;
								operation_vector_o	=	`vminu_vv_operation_vector;
							end
						
						`OPIVX:		//vminu.vx
							begin
								system_vector_o		=	`vminu_vx_system_vector;
								resource_vector_o	=	`vminu_vx_resource_vector;
								register_vector_o	=	`vminu_vx_register_vector;
								operation_vector_o	=	`vminu_vx_operation_vector;
							end
						`OPFVV:		//vfmin.vv
							begin
								system_vector_o		=	`vfmin_vv_system_vector;
								resource_vector_o	=	`vfmin_vv_resource_vector;
								register_vector_o	=	`vfmin_vv_register_vector;
								operation_vector_o	=	`vfmin_vv_operation_vector;
							end
						
						`OPFVF:		//vfmin.vf
							begin
								system_vector_o		=	`vfmin_vf_system_vector;
								resource_vector_o	=	`vfmin_vf_resource_vector;
								register_vector_o	=	`vfmin_vf_register_vector;
								operation_vector_o	=	`vfmin_vf_operation_vector;
							end
						`OPMVV: 	// vredminu.vs
							begin
								system_vector_o		=	`vredminu_vs_system_vector;
								resource_vector_o	=	`vredminu_vs_resource_vector;
								register_vector_o	=	`vredminu_vs_register_vector;
								operation_vector_o	=	`vredminu_vs_operation_vector;
							end
						
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
					
				`vmin:		//vmin	&	vredmin	&	vfredmin
					case	(instruction_i[`funct3_width])
						`OPIVV:		//vmin.vv
							begin
								system_vector_o		=	`vmin_vv_system_vector;
								resource_vector_o	=	`vmin_vv_resource_vector;
								register_vector_o	=	`vmin_vv_register_vector;
								operation_vector_o	=	`vmin_vv_operation_vector;
							end
						
						`OPIVX:		//vmin.vx
							begin
								system_vector_o		=	`vmin_vx_system_vector;
								resource_vector_o	=	`vmin_vx_resource_vector;
								register_vector_o	=	`vmin_vx_register_vector;
								operation_vector_o	=	`vmin_vx_operation_vector;
							end
						
						`OPMVV: 	// vredmin.vs
							begin
								system_vector_o		=	`vredmin_vs_system_vector;
								resource_vector_o	=	`vredmin_vs_resource_vector;
								register_vector_o	=	`vredmin_vs_register_vector;
								operation_vector_o	=	`vredmin_vs_operation_vector;
							end
						
						`OPFVV:		// vfredmin.vs
							begin
								system_vector_o		=	`vfredmin_vs_system_vector;
								resource_vector_o	=	`vfredmin_vs_resource_vector;
								register_vector_o	=	`vfredmin_vs_register_vector;
								operation_vector_o	=	`vfredmin_vs_operation_vector;
							end
						
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
					
				`vmaxu:		//vmaxu	&	vredmaxu	&	vfmax
					case	(instruction_i[`funct3_width])
						`OPIVV:		//vmaxu.vv
							begin
								system_vector_o		=	`vmaxu_vv_system_vector;
								resource_vector_o	=	`vmaxu_vv_resource_vector;
								register_vector_o	=	`vmaxu_vv_register_vector;
								operation_vector_o	=	`vmaxu_vv_operation_vector;
							end
						
						`OPIVX:		//vmaxu.vx
							begin
								system_vector_o		=	`vmaxu_vx_system_vector;
								resource_vector_o	=	`vmaxu_vx_resource_vector;
								register_vector_o	=	`vmaxu_vx_register_vector;
								operation_vector_o	=	`vmaxu_vx_operation_vector;
							end
						`OPFVV:		//vfmax.vv
							begin
								system_vector_o		=	`vfmax_vv_system_vector;
								resource_vector_o	=	`vfmax_vv_resource_vector;
								register_vector_o	=	`vfmax_vv_register_vector;
								operation_vector_o	=	`vfmax_vv_operation_vector;
							end
						
						`OPFVF:		//vfmax.vf
							begin
								system_vector_o		=	`vfmax_vf_system_vector;
								resource_vector_o	=	`vfmax_vf_resource_vector;
								register_vector_o	=	`vfmax_vf_register_vector;
								operation_vector_o	=	`vfmax_vf_operation_vector;
							end	
						`OPMVV: 	// vredmaxu.vs
							begin
								system_vector_o		=	`vredmaxu_vs_system_vector;
								resource_vector_o	=	`vredmaxu_vs_resource_vector;
								register_vector_o	=	`vredmaxu_vs_register_vector;
								operation_vector_o	=	`vredmaxu_vs_operation_vector;
							end
							
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
					
				`vmax:		//vmax	&	vredmax	&	vfredmax
					case	(instruction_i[`funct3_width])
						`OPIVV:		//vmax.vv
							begin
								system_vector_o		=	`vmax_vv_system_vector;
								resource_vector_o	=	`vmax_vv_resource_vector;
								register_vector_o	=	`vmax_vv_register_vector;
								operation_vector_o	=	`vmax_vv_operation_vector;
							end
						
						`OPIVX:		//vmax.vx
							begin
								system_vector_o		=	`vmax_vx_system_vector;
								resource_vector_o	=	`vmax_vx_resource_vector;
								register_vector_o	=	`vmax_vx_register_vector;
								operation_vector_o	=	`vmax_vx_operation_vector;
							end
							
						`OPMVV: 	// vredmax.vs
							begin
								system_vector_o		=	`vredmax_vs_system_vector;
								resource_vector_o	=	`vredmax_vs_resource_vector;
								register_vector_o	=	`vredmax_vs_register_vector;
								operation_vector_o	=	`vredmax_vs_operation_vector;
							end
						
						`OPFVV:		// vfredmax.vs
							begin
								system_vector_o		=	`vfredmax_vs_system_vector;
								resource_vector_o	=	`vfredmax_vs_resource_vector;
								register_vector_o	=	`vfredmax_vs_register_vector;
								operation_vector_o	=	`vfredmax_vs_operation_vector;
							end
						
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
					
				`vmulh:		//vmulh	&	vsmul	&	vmvx	&	vfrsub
					case	(instruction_i[`funct3_width])
						`OPMVV:		//vmulh.vv
							begin
								system_vector_o		=	`vmulh_vv_system_vector;
								resource_vector_o	=	`vmulh_vv_resource_vector;
								register_vector_o	=	`vmulh_vv_register_vector;
								operation_vector_o	=	`vmulh_vv_operation_vector;
							end
						`OPMVX:		//vmulh.vx
							begin
								system_vector_o		=	`vmulh_vx_system_vector;
								resource_vector_o	=	`vmulh_vx_resource_vector;
								register_vector_o	=	`vmulh_vx_register_vector;
								operation_vector_o	=	`vmulh_vx_operation_vector;
							end
						`OPIVV:		//	vsmul.vv
							begin
								system_vector_o		=	`vsmul_vv_system_vector;
								resource_vector_o	=	`vsmul_vv_resource_vector;
								register_vector_o	=	`vsmul_vv_register_vector;
								operation_vector_o	=	`vsmul_vv_operation_vector;
							end
						`OPIVX:		//	vsmul.vx
							begin
								system_vector_o		=	`vsmul_vx_system_vector;
								resource_vector_o	=	`vsmul_vx_resource_vector;
								register_vector_o	=	`vsmul_vx_register_vector;
								operation_vector_o	=	`vsmul_vx_operation_vector;
							end	
						`OPIVI: 	// vmv1.r, vmv2.r, vmv4.r, vmv8.r
							if (instruction_i[19:18] == 2'b0 && instruction_i[`vm] == 1'b1)
								begin
									system_vector_o		=	`vmvx_r_system_vector;
									resource_vector_o	=	`vmvx_r_resource_vector;
									register_vector_o	=	`vmvx_r_register_vector;
									operation_vector_o	=	`vmvx_r_operation_vector;
								end
								
							else
								begin
									system_vector_o		=	`system_vector_default;
									resource_vector_o	=	`resource_vector_default;
									register_vector_o	=	`register_vector_default;
									operation_vector_o	=	`operation_vector_default;
								end
						`OPFVF:		//vfrsub.vf
							begin
								system_vector_o		=	`vfrsub_vf_system_vector;
								resource_vector_o	=	`vfrsub_vf_resource_vector;
								register_vector_o	=	`vfrsub_vf_register_vector;
								operation_vector_o	=	`vfrsub_vf_operation_vector;
							end	
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
					
				`vmulhu:	//vmulhu	&	vfmul
					case	(instruction_i[`funct3_width])
						`OPMVV:		//vmulhu.vv
							begin
								system_vector_o		=	`vmulhu_vv_system_vector;
								resource_vector_o	=	`vmulhu_vv_resource_vector;
								register_vector_o	=	`vmulhu_vv_register_vector;
								operation_vector_o	=	`vmulhu_vv_operation_vector;
							end
						`OPMVX:		//vmulhu.vx
							begin
								system_vector_o		=	`vmulhu_vx_system_vector;
								resource_vector_o	=	`vmulhu_vx_resource_vector;
								register_vector_o	=	`vmulhu_vx_register_vector;
								operation_vector_o	=	`vmulhu_vx_operation_vector;
							end
						`OPFVV:		//vfmul.vv
							begin
								system_vector_o		=	`vfmul_vv_system_vector;
								resource_vector_o	=	`vfmul_vv_resource_vector;
								register_vector_o	=	`vfmul_vv_register_vector;
								operation_vector_o	=	`vfmul_vv_operation_vector;
							end
						
						`OPFVF:		//vfmul.vf
							begin
								system_vector_o		=	`vfmul_vf_system_vector;
								resource_vector_o	=	`vfmul_vf_resource_vector;
								register_vector_o	=	`vfmul_vf_register_vector;
								operation_vector_o	=	`vfmul_vf_operation_vector;
							end	
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
					
				`vmulhsu:
					case	(instruction_i[`funct3_width])
						`OPMVV:		//vmulhsu.vv
							begin
								system_vector_o		=	`vmulhsu_vv_system_vector;
								resource_vector_o	=	`vmulhsu_vv_resource_vector;
								register_vector_o	=	`vmulhsu_vv_register_vector;
								operation_vector_o	=	`vmulhsu_vv_operation_vector;
							end
						`OPMVX:		//vmulhsu.vx
							begin
								system_vector_o		=	`vmulhsu_vx_system_vector;
								resource_vector_o	=	`vmulhsu_vx_resource_vector;
								register_vector_o	=	`vmulhsu_vx_register_vector;
								operation_vector_o	=	`vmulhsu_vx_operation_vector;
							end
							
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
					
				`vdivu:		//vdivu & vsaddu	&	vfdiv
					case	(instruction_i[`funct3_width])
						`OPMVV:		//vdivu.vv
							begin
								system_vector_o		=	`vdivu_vv_system_vector;
								resource_vector_o	=	`vdivu_vv_resource_vector;
								register_vector_o	=	`vdivu_vv_register_vector;
								operation_vector_o	=	`vdivu_vv_operation_vector;
							end
						
						`OPMVX:		//vdivu.vx
							begin
								system_vector_o		=	`vdivu_vx_system_vector;
								resource_vector_o	=	`vdivu_vx_resource_vector;
								register_vector_o	=	`vdivu_vx_register_vector;
								operation_vector_o	=	`vdivu_vx_operation_vector;
							end
						`OPIVV:		//	vsaddu.vv
							begin
								system_vector_o		=	`vsaddu_vv_system_vector;
								resource_vector_o	=	`vsaddu_vv_resource_vector;
								register_vector_o	=	`vsaddu_vv_register_vector;
								operation_vector_o	=	`vsaddu_vv_operation_vector;
							end
						`OPIVX:		//	vsaddu.vx
							begin
								system_vector_o		=	`vsaddu_vx_system_vector;
								resource_vector_o	=	`vsaddu_vx_resource_vector;
								register_vector_o	=	`vsaddu_vx_register_vector;
								operation_vector_o	=	`vsaddu_vx_operation_vector;
							end
						`OPIVI:		//	vsaddu.vi
							begin
								system_vector_o		=	`vsaddu_vi_system_vector;
								resource_vector_o	=	`vsaddu_vi_resource_vector;
								register_vector_o	=	`vsaddu_vi_register_vector;
								operation_vector_o	=	`vsaddu_vi_operation_vector;
							end	
						`OPFVV:		//vfdiv.vv
							begin
								system_vector_o		=	`vfdiv_vv_system_vector;
								resource_vector_o	=	`vfdiv_vv_resource_vector;
								register_vector_o	=	`vfdiv_vv_register_vector;
								operation_vector_o	=	`vfdiv_vv_operation_vector;
							end
						`OPFVF:		//vfdiv.vf
							begin
								system_vector_o		=	`vfdiv_vf_system_vector;
								resource_vector_o	=	`vfdiv_vf_resource_vector;
								register_vector_o	=	`vfdiv_vf_register_vector;
								operation_vector_o	=	`vfdiv_vf_operation_vector;
							end
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
					
				`vdiv:		//vdiv	&	vsadd	&	vfrdiv
					case	(instruction_i[`funct3_width])
						`OPMVV:		//vdiv.vv
							begin
								system_vector_o		=	`vdiv_vv_system_vector;
								resource_vector_o	=	`vdiv_vv_resource_vector;
								register_vector_o	=	`vdiv_vv_register_vector;
								operation_vector_o	=	`vdiv_vv_operation_vector;
							end
						
						`OPMVX:		//vdiv.vx
							begin
								system_vector_o		=	`vdiv_vx_system_vector;
								resource_vector_o	=	`vdiv_vx_resource_vector;
								register_vector_o	=	`vdiv_vx_register_vector;
								operation_vector_o	=	`vdiv_vx_operation_vector;
							end
						`OPIVV:		//	vsadd.vv
							begin
								system_vector_o		=	`vsadd_vv_system_vector;
								resource_vector_o	=	`vsadd_vv_resource_vector;
								register_vector_o	=	`vsadd_vv_register_vector;
								operation_vector_o	=	`vsadd_vv_operation_vector;
							end
						`OPIVX:		//	vsadd.vx
							begin
								system_vector_o		=	`vsadd_vx_system_vector;
								resource_vector_o	=	`vsadd_vx_resource_vector;
								register_vector_o	=	`vsadd_vx_register_vector;
								operation_vector_o	=	`vsadd_vx_operation_vector;
							end
						`OPIVI:		//	vsadd.vi
							begin
								system_vector_o		=	`vsadd_vi_system_vector;
								resource_vector_o	=	`vsadd_vi_resource_vector;
								register_vector_o	=	`vsadd_vi_register_vector;
								operation_vector_o	=	`vsadd_vi_operation_vector;
							end	
						`OPFVF:		//vfrdiv.vf
							begin
								system_vector_o		=	`vfrdiv_vf_system_vector;
								resource_vector_o	=	`vfrdiv_vf_resource_vector;
								register_vector_o	=	`vfrdiv_vf_register_vector;
								operation_vector_o	=	`vfrdiv_vf_operation_vector;
							end
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
					
				`vremu:		//vremu	&	vssubu
					case	(instruction_i[`funct3_width])
						`OPMVV:		//vremu.vv
							begin
								system_vector_o		=	`vremu_vv_system_vector;
								resource_vector_o	=	`vremu_vv_resource_vector;
								register_vector_o	=	`vremu_vv_register_vector;
								operation_vector_o	=	`vremu_vv_operation_vector;
							end
						`OPMVX:		//vremu.vx
							begin
								system_vector_o		=	`vremu_vx_system_vector	;
								resource_vector_o	=	`vremu_vx_resource_vector;
								register_vector_o	=	`vremu_vx_register_vector;
								operation_vector_o	=	`vremu_vx_operation_vector;
							end
						`OPIVV:		//	vssubu.vv
							begin
								system_vector_o		=	`vssubu_vv_system_vector;
								resource_vector_o	=	`vssubu_vv_resource_vector;
								register_vector_o	=	`vssubu_vv_register_vector;
								operation_vector_o	=	`vssubu_vv_operation_vector;
							end
						`OPIVX:		//	vssubu.vx
							begin
								system_vector_o		=	`vssubu_vx_system_vector;
								resource_vector_o	=	`vssubu_vx_resource_vector;
								register_vector_o	=	`vssubu_vx_register_vector;
								operation_vector_o	=	`vssubu_vx_operation_vector;
							end
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end	
					endcase
					
				`vrem:		//	vrem	&	vssub
					case	(instruction_i[`funct3_width])
						`OPMVV:		//vrem.vv
							begin
								system_vector_o		=	`vrem_vv_system_vector;
								resource_vector_o	=	`vrem_vv_resource_vector;
								register_vector_o	=	`vrem_vv_register_vector;
								operation_vector_o	=	`vrem_vv_operation_vector;
							end
						
						`OPMVX:		//vrem.vx
							begin
								system_vector_o		=	`vrem_vx_system_vector;
								resource_vector_o	=	`vrem_vx_resource_vector;
								register_vector_o	=	`vrem_vx_register_vector;
								operation_vector_o	=	`vrem_vx_operation_vector;
							end
						`OPIVV:		//	vssub.vv
							begin
								system_vector_o		=	`vssub_vv_system_vector;
								resource_vector_o	=	`vssub_vv_resource_vector;
								register_vector_o	=	`vssub_vv_register_vector;
								operation_vector_o	=	`vssub_vv_operation_vector;
							end
						`OPIVX:		//	vssub.vx
							begin
								system_vector_o		=	`vssub_vx_system_vector;
								resource_vector_o	=	`vssub_vx_resource_vector;
								register_vector_o	=	`vssub_vx_register_vector;
								operation_vector_o	=	`vssub_vx_operation_vector;
							end	
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
					
				`vwmul:
					case	(instruction_i[`funct3_width])
						`OPMVV:		//vwmul.vv
							begin
								system_vector_o		=	`vwmul_vv_system_vector;
								resource_vector_o	=	`vwmul_vv_resource_vector;
								register_vector_o	=	`vwmul_vv_register_vector;
								operation_vector_o	=	`vwmul_vv_operation_vector;
							end
						`OPMVX:		//vwmul.vx
							begin
								system_vector_o		=	`vwmul_vx_system_vector;
								resource_vector_o	=	`vwmul_vx_resource_vector;
								register_vector_o	=	`vwmul_vx_register_vector;
								operation_vector_o	=	`vwmul_vx_operation_vector;
							end
							
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
					
				`vwmulu:	//vwmulu	&	vfwmul
					case	(instruction_i[`funct3_width])
						`OPMVV:		//vwmulu.vv
							begin
								system_vector_o		=	`vwmulu_vv_system_vector;
								resource_vector_o	=	`vwmulu_vv_resource_vector;
								register_vector_o	=	`vwmulu_vv_register_vector;
								operation_vector_o	=	`vwmulu_vv_operation_vector;
							end
						`OPMVX:		//vwmulu.vx
							begin
								system_vector_o		=	`vwmulu_vx_system_vector;
								resource_vector_o	=	`vwmulu_vx_resource_vector;
								register_vector_o	=	`vwmulu_vx_register_vector;
								operation_vector_o	=	`vwmulu_vx_operation_vector;
							end
						`OPFVV:		//vfwmul.vv
							begin
								system_vector_o		=	`vfwmul_vv_system_vector;
								resource_vector_o	=	`vfwmul_vv_resource_vector;
								register_vector_o	=	`vfwmul_vv_register_vector;
								operation_vector_o	=	`vfwmul_vv_operation_vector;
							end
						
						`OPFVF:		//vfwmul.vf
							begin
								system_vector_o		=	`vfwmul_vf_system_vector;
								resource_vector_o	=	`vfwmul_vf_resource_vector;
								register_vector_o	=	`vfwmul_vf_register_vector;
								operation_vector_o	=	`vfwmul_vf_operation_vector;
							end	
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
					
				`vwmulsu:
					case	(instruction_i[`funct3_width])
						`OPMVV:		//vwmulsu.vv
							begin
								system_vector_o		=	`vwmulsu_vv_system_vector;
								resource_vector_o	=	`vwmulsu_vv_resource_vector;
								register_vector_o	=	`vwmulsu_vv_register_vector;
								operation_vector_o	=	`vwmulsu_vv_operation_vector;
							end
						`OPMVX:		//vwmulsu.vx
							begin
								system_vector_o		=	`vwmulsu_vx_system_vector;
								resource_vector_o	=	`vwmulsu_vx_resource_vector;
								register_vector_o	=	`vwmulsu_vx_register_vector;
								operation_vector_o	=	`vwmulsu_vx_operation_vector;
							end
							
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
				`vnmsac:		//vnmsac	&	vnclip	&	vfnmsac
					case	(instruction_i[`funct3_width])
						`OPMVV:		//vnmsac.vv
							begin
								system_vector_o		=	`vnmsac_vv_system_vector;
								resource_vector_o	=	`vnmsac_vv_resource_vector;
								register_vector_o	=	`vnmsac_vv_register_vector;
								operation_vector_o	=	`vnmsac_vv_operation_vector;
							end
						`OPMVX:		//vnmsac.vx
							begin
								system_vector_o		=	`vnmsac_vx_system_vector;
								resource_vector_o	=	`vnmsac_vx_resource_vector;
								register_vector_o	=	`vnmsac_vx_register_vector;
								operation_vector_o	=	`vnmsac_vx_operation_vector;
							end
						`OPIVV:		//	vnclip.wv
							begin
								system_vector_o		=	`vnclip_wv_system_vector;
								resource_vector_o	=	`vnclip_wv_resource_vector;
								register_vector_o	=	`vnclip_wv_register_vector;
								operation_vector_o	=	`vnclip_wv_operation_vector;
							end
						`OPIVX:		//	vnclip.wx
							begin
								system_vector_o		=	`vnclip_wx_system_vector;
								resource_vector_o	=	`vnclip_wx_resource_vector;
								register_vector_o	=	`vnclip_wx_register_vector;
								operation_vector_o	=	`vnclip_wx_operation_vector;
							end
						`OPIVI:		//	vnclip.wi
							begin
								system_vector_o		=	`vnclip_wi_system_vector;
								resource_vector_o	=	`vnclip_wi_resource_vector;
								register_vector_o	=	`vnclip_wi_register_vector;
								operation_vector_o	=	`vnclip_wi_operation_vector;
							end	
						`OPFVV:		//vfnmsac.vv
							begin
								system_vector_o		=	`vfnmsac_vv_system_vector;
								resource_vector_o	=	`vfnmsac_vv_resource_vector;
								register_vector_o	=	`vfnmsac_vv_register_vector;
								operation_vector_o	=	`vfnmsac_vv_operation_vector;
							end
						
						`OPFVF:		//vfnmsac.vf
							begin
								system_vector_o		=	`vfnmsac_vf_system_vector;
								resource_vector_o	=	`vfnmsac_vf_resource_vector;
								register_vector_o	=	`vfnmsac_vf_register_vector;
								operation_vector_o	=	`vfnmsac_vf_operation_vector;
							end
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
					
				`vnmsub:		//vnmsub	&	vssra	&	vfnmsub
					case	(instruction_i[`funct3_width])
						`OPMVV:		//vnmsub.vv
							begin
								system_vector_o		=	`vnmsub_vv_system_vector;
								resource_vector_o	=	`vnmsub_vv_resource_vector;
								register_vector_o	=	`vnmsub_vv_register_vector;
								operation_vector_o	=	`vnmsub_vv_operation_vector;
							end
						`OPMVX:		//vnmsub.vx
							begin
								system_vector_o		=	`vnmsub_vx_system_vector;
								resource_vector_o	=	`vnmsub_vx_resource_vector;
								register_vector_o	=	`vnmsub_vx_register_vector;
								operation_vector_o	=	`vnmsub_vx_operation_vector;
							end
						`OPIVV:		//	vssra.vv
							begin
								system_vector_o		=	`vssra_vv_system_vector;
								resource_vector_o	=	`vssra_vv_resource_vector;
								register_vector_o	=	`vssra_vv_register_vector;
								operation_vector_o	=	`vssra_vv_operation_vector;
							end
						`OPIVX:		//	vssra.vx
							begin
								system_vector_o		=	`vssra_vx_system_vector;
								resource_vector_o	=	`vssra_vx_resource_vector;
								register_vector_o	=	`vssra_vx_register_vector;
								operation_vector_o	=	`vssra_vx_operation_vector;
							end
						`OPIVI:		//	vssra.vi
							begin
								system_vector_o		=	`vssra_vi_system_vector;
								resource_vector_o	=	`vssra_vi_resource_vector;
								register_vector_o	=	`vssra_vi_register_vector;
								operation_vector_o	=	`vssra_vi_operation_vector;
							end	
						`OPFVV:		//vfnmsub.vv
							begin
								system_vector_o		=	`vfnmsub_vv_system_vector;
								resource_vector_o	=	`vfnmsub_vv_resource_vector;
								register_vector_o	=	`vfnmsub_vv_register_vector;
								operation_vector_o	=	`vfnmsub_vv_operation_vector;
							end
						`OPFVF:		//vfnmsub.vf
							begin
								system_vector_o		=	`vfnmsub_vf_system_vector;
								resource_vector_o	=	`vfnmsub_vf_resource_vector;
								register_vector_o	=	`vfnmsub_vf_register_vector;
								operation_vector_o	=	`vfnmsub_vf_operation_vector;
							end
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
					
				`vwmaccu:		//vwmaccu	&	vfwmacc
					case	(instruction_i[`funct3_width])
						`OPMVV:		//vwmaccu.vv
							begin
								system_vector_o		=	`vwmaccu_vv_system_vector;
								resource_vector_o	=	`vwmaccu_vv_resource_vector;
								register_vector_o	=	`vwmaccu_vv_register_vector;
								operation_vector_o	=	`vwmaccu_vv_operation_vector;
							end
						`OPMVX:		//vwmaccu.vx
							begin
								system_vector_o		=	`vwmaccu_vx_system_vector;
								resource_vector_o	=	`vwmaccu_vx_resource_vector;
								register_vector_o	=	`vwmaccu_vx_register_vector;
								operation_vector_o	=	`vwmaccu_vx_operation_vector;
							end
						`OPFVV:		//vfwmacc.vv
							begin
								system_vector_o		=	`vfwmacc_vv_system_vector;
								resource_vector_o	=	`vfwmacc_vv_resource_vector;
								register_vector_o	=	`vfwmacc_vv_register_vector;
								operation_vector_o	=	`vfwmacc_vv_operation_vector;
							end
						
						`OPFVF:		//vfwmacc.vf
							begin
								system_vector_o		=	`vfwmacc_vf_system_vector;
								resource_vector_o	=	`vfwmacc_vf_resource_vector;
								register_vector_o	=	`vfwmacc_vf_register_vector;
								operation_vector_o	=	`vfwmacc_vf_operation_vector;
							end	
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
					
				`vwmacc:		//vwmacc	&	vfwnmacc
					case	(instruction_i[`funct3_width])
						`OPMVV:		//vwmacc.vv
							begin
								system_vector_o		=	`vwmacc_vv_system_vector;
								resource_vector_o	=	`vwmacc_vv_resource_vector;
								register_vector_o	=	`vwmacc_vv_register_vector;
								operation_vector_o	=	`vwmacc_vv_operation_vector;
							end
						`OPMVX:		//vwmacc.vx
							begin
								system_vector_o		=	`vwmacc_vv_system_vector;
								resource_vector_o	=	`vwmacc_vv_resource_vector;
								register_vector_o	=	`vwmacc_vv_register_vector;
								operation_vector_o	=	`vwmacc_vv_operation_vector;
							end
						`OPFVV:		//vfwnmacc.vv
							begin
								system_vector_o		=	`vfwnmacc_vv_system_vector;
								resource_vector_o	=	`vfwnmacc_vv_resource_vector;
								register_vector_o	=	`vfwnmacc_vv_register_vector;
								operation_vector_o	=	`vfwnmacc_vv_operation_vector;
							end
						`OPFVF:		//vfwnmacc.vf
							begin
								system_vector_o		=	`vfwnmacc_vf_system_vector;
								resource_vector_o	=	`vfwnmacc_vf_resource_vector;
								register_vector_o	=	`vfwnmacc_vf_register_vector;
								operation_vector_o	=	`vfwnmacc_vf_operation_vector;
							end	
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
					
				`vwmaccsu:		//vwmaccsu	&	vfwnmsac
					case	(instruction_i[`funct3_width])
						`OPMVV:		//vwmaccsu.vv
							begin
								system_vector_o		=	`vwmaccsu_vv_system_vector;
								resource_vector_o	=	`vwmaccsu_vv_resource_vector;
								register_vector_o	=	`vwmaccsu_vv_register_vector;
								operation_vector_o	=	`vwmaccsu_vv_operation_vector;
							end
						`OPMVX:		//vwmaccsu.vx
							begin
								system_vector_o		=	`vwmaccsu_vx_system_vector;
								resource_vector_o	=	`vwmaccsu_vx_resource_vector;
								register_vector_o	=	`vwmaccsu_vx_register_vector;
								operation_vector_o	=	`vwmaccsu_vx_operation_vector;
							end
						`OPFVV:		//vfwnmsac.vv
							begin
								system_vector_o		=	`vfwnmsac_vv_system_vector;
								resource_vector_o	=	`vfwnmsac_vv_resource_vector;
								register_vector_o	=	`vfwnmsac_vv_register_vector;
								operation_vector_o	=	`vfwnmsac_vv_operation_vector;
							end
						`OPFVF:		//vfwnmsac.vf
							begin
								system_vector_o		=	`vfwnmsac_vf_system_vector;
								resource_vector_o	=	`vfwnmsac_vf_resource_vector;
								register_vector_o	=	`vfwnmsac_vf_register_vector;
								operation_vector_o	=	`vfwnmsac_vf_operation_vector;
							end	
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
					
				`vwmaccus:
					case	(instruction_i[`funct3_width])
						`OPMVX:		//vwmaccus.vx
							begin
								system_vector_o		=	`vwmaccus_vx_system_vector;
								resource_vector_o	=	`vwmaccus_vx_resource_vector;
								register_vector_o	=	`vwmaccus_vx_register_vector;
								operation_vector_o	=	`vwmaccus_vx_operation_vector;
							end
						`OPFVV:		//vfwmsac.vv
							begin
								system_vector_o		=	`vfwmsac_vv_system_vector;
								resource_vector_o	=	`vfwmsac_vv_resource_vector;
								register_vector_o	=	`vfwmsac_vv_register_vector;
								operation_vector_o	=	`vfwmsac_vv_operation_vector;
							end
						`OPFVF:		//vfwmsac.vf
							begin
								system_vector_o		=	`vfwmsac_vf_system_vector;
								resource_vector_o	=	`vfwmsac_vf_resource_vector;
								register_vector_o	=	`vfwmsac_vf_register_vector;
								operation_vector_o	=	`vfwmsac_vf_operation_vector;
							end	
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
					
				`vmerge_vmv:	//vmerge	&	vmv	&	vcompress	&	vfmerge	&	vfvmv
					if(instruction_i[`vm] == 0) 
						case	(instruction_i[`funct3_width])
							`OPIVV:		//vmerge.vvm
								begin
									system_vector_o		=	`vmerge_vvm_system_vector;
									resource_vector_o	=	`vmerge_vvm_resource_vector;
									register_vector_o	=	`vmerge_vvm_register_vector;
									operation_vector_o	=	`vmerge_vvm_operation_vector;
								end
							`OPIVX:		//vmerge.vxm
								begin
									system_vector_o		=	`vmerge_vxm_system_vector;
									resource_vector_o	=	`vmerge_vxm_resource_vector;
									register_vector_o	=	`vmerge_vxm_register_vector;
									operation_vector_o	=	`vmerge_vxm_operation_vector;
								end
							`OPIVI:		//vmerge.vim
								begin
									system_vector_o		=	`vmerge_vim_system_vector;
									resource_vector_o	=	`vmerge_vim_resource_vector;
									register_vector_o	=	`vmerge_vim_register_vector;
									operation_vector_o	=	`vmerge_vim_operation_vector;
								end
							`OPFVF:		//vfmerge.vfm
								begin
									system_vector_o		=	`vfmerge_vfm_system_vector;
									resource_vector_o	=	`vfmerge_vfm_resource_vector;
									register_vector_o	=	`vfmerge_vfm_register_vector;
									operation_vector_o	=	`vfmerge_vfm_operation_vector;
								end
							default:
								begin
									system_vector_o		=	`system_vector_default;
									resource_vector_o	=	`resource_vector_default;
									register_vector_o	=	`register_vector_default;
									operation_vector_o	=	`operation_vector_default;
								end
						endcase
					else
						case	(instruction_i[`funct3_width])
							`OPIVV:		//vmv.v.v
								begin
									system_vector_o		=	`vmv_v_v_system_vector;
									resource_vector_o	=	`vmv_v_v_resource_vector;
									register_vector_o	=	`vmv_v_v_register_vector;
									operation_vector_o	=	`vmv_v_v_operation_vector;
								end
							`OPIVX:		//vmv.v.x
								begin
									system_vector_o		=	`vmv_v_x_system_vector;
									resource_vector_o	=	`vmv_v_x_resource_vector;
									register_vector_o	=	`vmv_v_x_register_vector;
									operation_vector_o	=	`vmv_v_x_operation_vector;
								end
							`OPIVI:		//vmv.v.i
								begin
									system_vector_o		=	`vmv_v_i_system_vector;
									resource_vector_o	=	`vmv_v_i_resource_vector;
									register_vector_o	=	`vmv_v_i_register_vector;
									operation_vector_o	=	`vmv_v_i_operation_vector;
								end
							`OPMVV: 	// vcompress.vm
								begin
									system_vector_o		=	`vcompress_vm_system_vector;
									resource_vector_o	=	`vcompress_vm_resource_vector;
									register_vector_o	=	`vcompress_vm_register_vector;
									operation_vector_o	=	`vcompress_vm_operation_vector;
								end
							`OPFVF:		//vfmv.v.f
									begin
										system_vector_o		=	`vfmv_v_f_system_vector;
										resource_vector_o	=	`vfmv_v_f_resource_vector;
										register_vector_o	=	`vfmv_v_f_register_vector;
										operation_vector_o	=	`vfmv_v_f_operation_vector;
									end
							default:
								begin
									system_vector_o		=	`system_vector_default;
									resource_vector_o	=	`resource_vector_default;
									register_vector_o	=	`register_vector_default;
									operation_vector_o	=	`operation_vector_default;
								end
						endcase
				`vredand:		//vredand	&	vfredsum
					case (instruction_i[`funct3_width])
						`OPMVV:		//vredand.vs
							begin
								system_vector_o		=	`vredand_vs_system_vector;
								resource_vector_o	=	`vredand_vs_resource_vector;
								register_vector_o	=	`vredand_vs_register_vector;
								operation_vector_o	=	`vredand_vs_operation_vector;
							end
						`OPFVV:		//vfredsum.vs
							begin
								system_vector_o		=	`vfredusum_vs_system_vector;
								resource_vector_o	=	`vfredusum_vs_resource_vector;
								register_vector_o	=	`vfredusum_vs_register_vector;
								operation_vector_o	=	`vfredusum_vs_operation_vector;
							end
							
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;	
							end
					endcase
					
				`vslideup:		//vslideup	&	vslide1up	&	vfslide1up	&	vrgatheri16
					case (instruction_i[`funct3_width])
						`OPIVV:		// vrgatheri16.vv
							begin
								system_vector_o		= `vrgatheri16_vv_system_vector;	
								resource_vector_o	= `vrgatheri16_vv_resource_vector;
								register_vector_o	= `vrgatheri16_vv_register_vector; 
								operation_vector_o	= `vrgatheri16_vv_operation_vector;
							end
						
						`OPIVX:		// vslideup.vx
							begin
								system_vector_o		= `vslideup_vx_system_vector;	
								resource_vector_o	= `vslideup_vx_resource_vector;	
								register_vector_o	= `vslideup_vx_register_vector; 
								operation_vector_o	= `vslideup_vx_operation_vector;
							end
						
						`OPIVI: 	// vslideup.vi
							begin
								system_vector_o		= `vslideup_vi_system_vector;	
								resource_vector_o	= `vslideup_vi_resource_vector;
								register_vector_o	= `vslideup_vi_register_vector; 
								operation_vector_o	= `vslideup_vi_operation_vector;
							end
							
						`OPMVX: 	// vslide1up.vx
							begin
								system_vector_o		= `vslide1up_vx_system_vector;	
								resource_vector_o	= `vslide1up_vx_resource_vector;
								register_vector_o	= `vslide1up_vx_register_vector; 
								operation_vector_o	= `vslide1up_vx_operation_vector;
							end
						
						`OPFVF: 	// vfslide1up.vf
							begin
								system_vector_o		= `vfslide1up_vf_system_vector;	
								resource_vector_o	= `vfslide1up_vf_resource_vector;
								register_vector_o	= `vfslide1up_vf_register_vector;
								operation_vector_o	= `vfslide1up_vf_operation_vector;
							end
						
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;	
							end
							
					endcase
					
				`vslidedown:	//vslidedown	&	vslide1down	&	vfslide1down
					case (instruction_i[`funct3_width])
						`OPIVX:		// vslidedown.vx
							begin
								system_vector_o		= `vslidedown_vx_system_vector;	
								resource_vector_o	= `vslidedown_vx_resource_vector;	
								register_vector_o	= `vslidedown_vx_register_vector; 
								operation_vector_o	= `vslidedown_vx_operation_vector;
							end
						
						`OPIVI: 	// vslidedown.vi
							begin
								system_vector_o		= `vslidedown_vi_system_vector;	
								resource_vector_o	= `vslidedown_vi_resource_vector;
								register_vector_o	= `vslidedown_vi_register_vector; 
								operation_vector_o	= `vslidedown_vi_operation_vector;
							end
						
						`OPMVX: 	// vslide1down.vx
							begin
								system_vector_o		= `vslide1down_vx_system_vector;	
								resource_vector_o	= `vslide1down_vx_resource_vector;
								register_vector_o	= `vslide1down_vx_register_vector;
								operation_vector_o	= `vslide1down_vx_operation_vector;
							end
						
						`OPFVF: 	// vfslide1down.vf
							begin
								system_vector_o		= `vfslide1down_vf_system_vector;	
								resource_vector_o	= `vfslide1down_vf_resource_vector;
								register_vector_o	= `vfslide1down_vf_register_vector; 
								operation_vector_o	= `vfslide1down_vf_operation_vector;
							end
					
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;	
							end
					endcase
					
				`vrgather:
					case (instruction_i[`funct3_width])
						`OPIVV:		//vrgather.vv
							begin
								system_vector_o		= `vrgather_vv_system_vector;
							    resource_vector_o	= `vrgather_vv_resource_vector;
							    register_vector_o	= `vrgather_vv_register_vector;
							    operation_vector_o	= `vrgather_vv_operation_vector;
							end
							   
						`OPIVX:		//vrgather.vx
							begin
								system_vector_o		= `vrgather_vx_system_vector;
							    resource_vector_o	= `vrgather_vx_resource_vector;
							    register_vector_o	= `vrgather_vx_register_vector;
							    operation_vector_o	= `vrgather_vx_operation_vector;
							end
							
						`OPIVI:		//vrgather.vi
							begin
								system_vector_o		= `vrgather_vi_system_vector;
								resource_vector_o	= `vrgather_vi_resource_vector;
								register_vector_o	= `vrgather_vi_register_vector;
								operation_vector_o	= `vrgather_vi_operation_vector;
							end
							
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;	
							end
					endcase  
				`vfmsac:		//vfmsac	&	vnclipu
					case	(instruction_i[`funct3_width])
						`OPFVV:		//vfmsac.vv
							begin
								system_vector_o		=	`vfmsac_vv_system_vector;
								resource_vector_o	=	`vfmsac_vv_resource_vector;
								register_vector_o	=	`vfmsac_vv_register_vector;
								operation_vector_o	=	`vfmsac_vv_operation_vector;
							end
							
						`OPFVF:		//vfmsac.vf
							begin
								system_vector_o		=	`vfmsac_vf_system_vector;
								resource_vector_o	=	`vfmsac_vf_resource_vector;
								register_vector_o	=	`vfmsac_vf_register_vector;
								operation_vector_o	=	`vfmsac_vf_operation_vector;
							end
						`OPIVV:		//	vnclipu.wv
							begin
								system_vector_o		=	`vnclipu_wv_system_vector;
								resource_vector_o	=	`vnclipu_wv_resource_vector;
								register_vector_o	=	`vnclipu_wv_register_vector;
								operation_vector_o	=	`vnclipu_wv_operation_vector;
							end
						`OPIVX:		//	vnclipu.wx
							begin
								system_vector_o		=	`vnclipu_wx_system_vector;
								resource_vector_o	=	`vnclipu_wx_resource_vector;
								register_vector_o	=	`vnclipu_wx_register_vector;
								operation_vector_o	=	`vnclipu_wx_operation_vector;
							end
						`OPIVI:		//	vnclipu.wi
							begin
								system_vector_o		=	`vnclipu_wi_system_vector;
								resource_vector_o	=	`vnclipu_wi_resource_vector;
								register_vector_o	=	`vnclipu_wi_register_vector;
								operation_vector_o	=	`vnclipu_wi_operation_vector;
							end
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
					
				`vfmsub:		//vfmsub	&	vssrl
					case	(instruction_i[`funct3_width])
						`OPFVV:		//vfmsub.vv
							begin
								system_vector_o		=	`vfmsub_vv_system_vector;
								resource_vector_o	=	`vfmsub_vv_resource_vector;
								register_vector_o	=	`vfmsub_vv_register_vector;
								operation_vector_o	=	`vfmsub_vv_operation_vector;
							end
							
						`OPFVF:		//vfmsub.vf
							begin
								system_vector_o		=	`vfmsub_vf_system_vector;
								resource_vector_o	=	`vfmsub_vf_resource_vector;
								register_vector_o	=	`vfmsub_vf_register_vector;
								operation_vector_o	=	`vfmsub_vf_operation_vector;
							end
						`OPIVV:		//	vssrl.vv
							begin
								system_vector_o		=	`vssrl_vv_system_vector;
								resource_vector_o	=	`vssrl_vv_resource_vector;
								register_vector_o	=	`vssrl_vv_register_vector;
								operation_vector_o	=	`vssrl_vv_operation_vector;
							end
						`OPIVX:		//	vssrl.vx
							begin
								system_vector_o		=	`vssrl_vx_system_vector;
								resource_vector_o	=	`vssrl_vx_resource_vector;
								register_vector_o	=	`vssrl_vx_register_vector;
								operation_vector_o	=	`vssrl_vx_operation_vector;
							end
						`OPIVI:		//	vssrl.vi
							begin
								system_vector_o		=	`vssrl_vi_system_vector;
								resource_vector_o	=	`vssrl_vi_resource_vector;
								register_vector_o	=	`vssrl_vi_register_vector;
								operation_vector_o	=	`vssrl_vi_operation_vector;
							end
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
					
				`vfsgnj:	//vfsgnj	&	vaaddu
					case	(instruction_i[`funct3_width])
						`OPFVV:		//vfsgnj.vv
							begin
								system_vector_o		=	`vfsgnj_vv_system_vector;
								resource_vector_o	=	`vfsgnj_vv_resource_vector;
								register_vector_o	=	`vfsgnj_vv_register_vector;
								operation_vector_o	=	`vfsgnj_vv_operation_vector;
							end
							
						`OPFVF:		//vfsgnj.vf
							begin
								system_vector_o		=	`vfsgnj_vf_system_vector;
								resource_vector_o	=	`vfsgnj_vf_resource_vector;
								register_vector_o	=	`vfsgnj_vf_register_vector;
								operation_vector_o	=	`vfsgnj_vf_operation_vector;
							end
						`OPMVV:		//	vaaddu.vv
							begin
								system_vector_o		=	`vaaddu_vv_system_vector;
								resource_vector_o	=	`vaaddu_vv_resource_vector;
								register_vector_o	=	`vaaddu_vv_register_vector;
								operation_vector_o	=	`vaaddu_vv_operation_vector;
							end
						`OPMVX:		//	vaaddu.vx
							begin
								system_vector_o		=	`vaaddu_vx_system_vector;
								resource_vector_o	=	`vaaddu_vx_resource_vector;
								register_vector_o	=	`vaaddu_vx_register_vector;
								operation_vector_o	=	`vaaddu_vx_operation_vector;
							end
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
				
				`vmsbf, `vmsif, `vmsof, `viota, `vid:
					case	(instruction_i[`vs1_rs1_imm])
						`vmsbf_vs1:		//vmsbf.m
							begin
								system_vector_o		=	`vmsbf_m_system_vector;
								resource_vector_o	=	`vmsbf_m_resource_vector;
								register_vector_o	=	`vmsbf_m_register_vector;
								operation_vector_o	=	`vmsbf_m_operation_vector;
							end
							
						`vmsif_vs1:		//vmsif.m
							begin
								system_vector_o		=	`vmsif_m_system_vector;
								resource_vector_o	=	`vmsif_m_resource_vector;
								register_vector_o	=	`vmsif_m_register_vector;
								operation_vector_o	=	`vmsif_m_operation_vector;
							end
						
						`vmsof_vs1:		//vmsof.m
							begin
								system_vector_o		=	`vmsof_m_system_vector;
								resource_vector_o	=	`vmsof_m_resource_vector;
								register_vector_o	=	`vmsof_m_register_vector;
								operation_vector_o	=	`vmsof_m_operation_vector;
							end
							
						`viota_vs1:		//viota.m
							begin
								system_vector_o		=	`viota_m_system_vector;
								resource_vector_o	=	`viota_m_resource_vector;
								register_vector_o	=	`viota_m_register_vector;
								operation_vector_o	=	`viota_m_operation_vector;
							end
							
						`vid_vs1:
							begin
								if(instruction_i[`vs2_sumop_lumop] == `vid_vs2)		//vid.v
									begin
										system_vector_o		=	`vid_v_system_vector;
										resource_vector_o	=	`vid_v_resource_vector;
										register_vector_o	=	`vid_v_register_vector;
										operation_vector_o	=	`vid_v_operation_vector;
									end
								else
									begin
										system_vector_o		=	`system_vector_default;
										resource_vector_o	=	`resource_vector_default;
										register_vector_o	=	`register_vector_default;
										operation_vector_o	=	`operation_vector_default;
									end
							end							
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
				default:
					begin
						system_vector_o		=	`system_vector_default;
						resource_vector_o	=	`resource_vector_default;
						register_vector_o	=	`register_vector_default;
						operation_vector_o	=	`operation_vector_default;	
					end
			endcase
		
		`op_load:
			case	(instruction_i[`mop])
				`unit_stride:
					case	(instruction_i[`vs2_sumop_lumop])
						`unit_stride_load_store:
							case	(instruction_i[`nf])
								`nf_1:
									case	(instruction_i[`funct3_width])
										`w8:		//vle8.v	&	vlseg1e8.v
											begin
												system_vector_o		=	`vle8_v_system_vector;
												resource_vector_o	=	`vle8_v_resource_vector;
												register_vector_o	=	`vle8_v_register_vector;
												operation_vector_o	=	`vle8_v_operation_vector;
											end
										`w16:		//vle16.v	&	vlseg1e16.v
											begin
												system_vector_o		=	`vle16_v_system_vector;
												resource_vector_o	=	`vle16_v_resource_vector;
												register_vector_o	=	`vle16_v_register_vector;
												operation_vector_o	=	`vle16_v_operation_vector;
											end
										`w32:		//vle32.v	&	vlseg1e32.v
											begin
												system_vector_o		=	`vle32_v_system_vector;
												resource_vector_o	=	`vle32_v_resource_vector;
												register_vector_o	=	`vle32_v_register_vector;
												operation_vector_o	=	`vle32_v_operation_vector;
											end
										`w64:		//vle64.v	&	vlseg1e64.v
											begin
												system_vector_o		=	`vle64_v_system_vector;
												resource_vector_o	=	`vle64_v_resource_vector;
												register_vector_o	=	`vle64_v_register_vector;
												operation_vector_o	=	`vle64_v_operation_vector;
											end
										default:
											begin
												system_vector_o		=	`system_vector_default;
												resource_vector_o	=	`resource_vector_default;
												register_vector_o	=	`register_vector_default;
												operation_vector_o	=	`operation_vector_default;
											end
									endcase
								`nf_2:
									case	(instruction_i[`funct3_width])
										`w8:		//vlseg2e8.v
											begin
												system_vector_o		=	`vlseg2e8_v_system_vector;
												resource_vector_o	=	`vlseg2e8_v_resource_vector;
												register_vector_o	=	`vlseg2e8_v_register_vector;
												operation_vector_o	=	`vlseg2e8_v_operation_vector;
											end
										`w16:		//vlseg2e16.v
											begin
												system_vector_o		=	`vlseg2e16_v_system_vector;
												resource_vector_o	=	`vlseg2e16_v_resource_vector;
												register_vector_o	=	`vlseg2e16_v_register_vector;
												operation_vector_o	=	`vlseg2e16_v_operation_vector;
											end
										`w32:		//vlseg2e32.v
											begin
												system_vector_o		=	`vlseg2e32_v_system_vector;
												resource_vector_o	=	`vlseg2e32_v_resource_vector;
												register_vector_o	=	`vlseg2e32_v_register_vector;
												operation_vector_o	=	`vlseg2e32_v_operation_vector;
											end
										`w64:		//vlseg2e64.v
											begin
												system_vector_o		=	`vlseg2e64_v_system_vector;
												resource_vector_o	=	`vlseg2e64_v_resource_vector;
												register_vector_o	=	`vlseg2e64_v_register_vector;
												operation_vector_o	=	`vlseg2e64_v_operation_vector;
											end
										default:
											begin
												system_vector_o		=	`system_vector_default;
												resource_vector_o	=	`resource_vector_default;
												register_vector_o	=	`register_vector_default;
												operation_vector_o	=	`operation_vector_default;
											end
									endcase
								`nf_3:
									case	(instruction_i[`funct3_width])
										`w8:		//vlseg3e8.v
											begin
												system_vector_o		=	`vlseg3e8_v_system_vector;
												resource_vector_o	=	`vlseg3e8_v_resource_vector;
												register_vector_o	=	`vlseg3e8_v_register_vector;
												operation_vector_o	=	`vlseg3e8_v_operation_vector;
											end
										`w16:		//vlseg3e16.v
											begin
												system_vector_o		=	`vlseg3e16_v_system_vector;
												resource_vector_o	=	`vlseg3e16_v_resource_vector;
												register_vector_o	=	`vlseg3e16_v_register_vector;
												operation_vector_o	=	`vlseg3e16_v_operation_vector;
											end
										`w32:		//vlseg3e32.v
											begin
												system_vector_o		=	`vlseg3e32_v_system_vector;
												resource_vector_o	=	`vlseg3e32_v_resource_vector;
												register_vector_o	=	`vlseg3e32_v_register_vector;
												operation_vector_o	=	`vlseg3e32_v_operation_vector;
											end
										`w64:		//vlseg3e64.v
											begin
												system_vector_o		=	`vlseg3e64_v_system_vector;
												resource_vector_o	=	`vlseg3e64_v_resource_vector;
												register_vector_o	=	`vlseg3e64_v_register_vector;
												operation_vector_o	=	`vlseg3e64_v_operation_vector;
											end
										default:
											begin
												system_vector_o		=	`system_vector_default;
												resource_vector_o	=	`resource_vector_default;
												register_vector_o	=	`register_vector_default;
												operation_vector_o	=	`operation_vector_default;
											end
									endcase
								`nf_4:
									case	(instruction_i[`funct3_width])
										`w8:		//vlseg4e8.v
											begin
												system_vector_o		=	`vlseg4e8_v_system_vector;
												resource_vector_o	=	`vlseg4e8_v_resource_vector;
												register_vector_o	=	`vlseg4e8_v_register_vector;
												operation_vector_o	=	`vlseg4e8_v_operation_vector;
											end
										`w16:		//vlseg4e16.v
											begin
												system_vector_o		=	`vlseg4e16_v_system_vector;
												resource_vector_o	=	`vlseg4e16_v_resource_vector;
												register_vector_o	=	`vlseg4e16_v_register_vector;
												operation_vector_o	=	`vlseg4e16_v_operation_vector;
											end
										`w32:		//vlseg4e32.v
											begin
												system_vector_o		=	`vlseg4e32_v_system_vector;
												resource_vector_o	=	`vlseg4e32_v_resource_vector;
												register_vector_o	=	`vlseg4e32_v_register_vector;
												operation_vector_o	=	`vlseg4e32_v_operation_vector;
											end
										`w64:		//vlseg4e64.v
											begin
												system_vector_o		=	`vlseg4e64_v_system_vector;
												resource_vector_o	=	`vlseg4e64_v_resource_vector;
												register_vector_o	=	`vlseg4e64_v_register_vector;
												operation_vector_o	=	`vlseg4e64_v_operation_vector;
											end
										default:
											begin
												system_vector_o		=	`system_vector_default;
												resource_vector_o	=	`resource_vector_default;
												register_vector_o	=	`register_vector_default;
												operation_vector_o	=	`operation_vector_default;
											end
									endcase
								`nf_5:
									case	(instruction_i[`funct3_width])
										`w8:		//vlseg5e8.v
											begin
												system_vector_o		=	`vlseg5e8_v_system_vector;
												resource_vector_o	=	`vlseg5e8_v_resource_vector;
												register_vector_o	=	`vlseg5e8_v_register_vector;
												operation_vector_o	=	`vlseg5e8_v_operation_vector;
											end
										`w16:		//vlseg5e16.v
											begin
												system_vector_o		=	`vlseg5e16_v_system_vector;
												resource_vector_o	=	`vlseg5e16_v_resource_vector;
												register_vector_o	=	`vlseg5e16_v_register_vector;
												operation_vector_o	=	`vlseg5e16_v_operation_vector;
											end
										`w32:		//vlseg5e32.v
											begin
												system_vector_o		=	`vlseg5e32_v_system_vector;
												resource_vector_o	=	`vlseg5e32_v_resource_vector;
												register_vector_o	=	`vlseg5e32_v_register_vector;
												operation_vector_o	=	`vlseg5e32_v_operation_vector;
											end
										`w64:		//vlseg5e64.v
											begin
												system_vector_o		=	`vlseg5e64_v_system_vector;
												resource_vector_o	=	`vlseg5e64_v_resource_vector;
												register_vector_o	=	`vlseg5e64_v_register_vector;
												operation_vector_o	=	`vlseg5e64_v_operation_vector;
											end
										default:
											begin
												system_vector_o		=	`system_vector_default;
												resource_vector_o	=	`resource_vector_default;
												register_vector_o	=	`register_vector_default;
												operation_vector_o	=	`operation_vector_default;
											end
									endcase
								`nf_6:
									case	(instruction_i[`funct3_width])
										`w8:		//vlseg6e8.v
											begin
												system_vector_o		=	`vlseg6e8_v_system_vector;
												resource_vector_o	=	`vlseg6e8_v_resource_vector;
												register_vector_o	=	`vlseg6e8_v_register_vector;
												operation_vector_o	=	`vlseg6e8_v_operation_vector;
											end
										`w16:		//vlseg6e16.v
											begin
												system_vector_o		=	`vlseg6e16_v_system_vector;
												resource_vector_o	=	`vlseg6e16_v_resource_vector;
												register_vector_o	=	`vlseg6e16_v_register_vector;
												operation_vector_o	=	`vlseg6e16_v_operation_vector;
											end
										`w32:		//vlseg6e32.v
											begin
												system_vector_o		=	`vlseg6e32_v_system_vector;
												resource_vector_o	=	`vlseg6e32_v_resource_vector;
												register_vector_o	=	`vlseg6e32_v_register_vector;
												operation_vector_o	=	`vlseg6e32_v_operation_vector;
											end
										`w64:		//vlseg6e64.v
											begin
												system_vector_o		=	`vlseg6e64_v_system_vector;
												resource_vector_o	=	`vlseg6e64_v_resource_vector;
												register_vector_o	=	`vlseg6e64_v_register_vector;
												operation_vector_o	=	`vlseg6e64_v_operation_vector;
											end
										default:
											begin
												system_vector_o		=	`system_vector_default;
												resource_vector_o	=	`resource_vector_default;
												register_vector_o	=	`register_vector_default;
												operation_vector_o	=	`operation_vector_default;
											end
									endcase
								`nf_7:
									case	(instruction_i[`funct3_width])
										`w8:		//vlseg7e8.v
											begin
												system_vector_o		=	`vlseg7e8_v_system_vector;
												resource_vector_o	=	`vlseg7e8_v_resource_vector;
												register_vector_o	=	`vlseg7e8_v_register_vector;
												operation_vector_o	=	`vlseg7e8_v_operation_vector;
											end
										`w16:		//vlseg7e16.v
											begin
												system_vector_o		=	`vlseg7e16_v_system_vector;
												resource_vector_o	=	`vlseg7e16_v_resource_vector;
												register_vector_o	=	`vlseg7e16_v_register_vector;
												operation_vector_o	=	`vlseg7e16_v_operation_vector;
											end
										`w32:		//vlseg7e32.v
											begin
												system_vector_o		=	`vlseg7e32_v_system_vector;
												resource_vector_o	=	`vlseg7e32_v_resource_vector;
												register_vector_o	=	`vlseg7e32_v_register_vector;
												operation_vector_o	=	`vlseg7e32_v_operation_vector;
											end
										`w64:		//vlseg7e64.v
											begin
												system_vector_o		=	`vlseg7e64_v_system_vector;
												resource_vector_o	=	`vlseg7e64_v_resource_vector;
												register_vector_o	=	`vlseg7e64_v_register_vector;
												operation_vector_o	=	`vlseg7e64_v_operation_vector;
											end
										default:
											begin
												system_vector_o		=	`system_vector_default;
												resource_vector_o	=	`resource_vector_default;
												register_vector_o	=	`register_vector_default;
												operation_vector_o	=	`operation_vector_default;
											end
									endcase
								`nf_8:
									case	(instruction_i[`funct3_width])
										`w8:		//vlseg8e8.v
											begin
												system_vector_o		=	`vlseg8e8_v_system_vector;
												resource_vector_o	=	`vlseg8e8_v_resource_vector;
												register_vector_o	=	`vlseg8e8_v_register_vector;
												operation_vector_o	=	`vlseg8e8_v_operation_vector;
											end
										`w16:		//vlseg8e16.v
											begin
												system_vector_o		=	`vlseg8e16_v_system_vector;
												resource_vector_o	=	`vlseg8e16_v_resource_vector;
												register_vector_o	=	`vlseg8e16_v_register_vector;
												operation_vector_o	=	`vlseg8e16_v_operation_vector;
											end
										`w32:		//vlseg8e32.v
											begin
												system_vector_o		=	`vlseg8e32_v_system_vector;
												resource_vector_o	=	`vlseg8e32_v_resource_vector;
												register_vector_o	=	`vlseg8e32_v_register_vector;
												operation_vector_o	=	`vlseg8e32_v_operation_vector;
											end
										`w64:		//vlseg8e64.v
											begin
												system_vector_o		=	`vlseg8e64_v_system_vector;
												resource_vector_o	=	`vlseg8e64_v_resource_vector;
												register_vector_o	=	`vlseg8e64_v_register_vector;
												operation_vector_o	=	`vlseg8e64_v_operation_vector;
											end
										default:
											begin
												system_vector_o		=	`system_vector_default;
												resource_vector_o	=	`resource_vector_default;
												register_vector_o	=	`register_vector_default;
												operation_vector_o	=	`operation_vector_default;
											end
									endcase
								default:
									begin
										system_vector_o		=	`system_vector_default;
										resource_vector_o	=	`resource_vector_default;
										register_vector_o	=	`register_vector_default;
										operation_vector_o	=	`operation_vector_default;
									end
							endcase
						`unit_stride_fault_only_first_load:
							if	(instruction_i[`nf]	>	3'b0)
								case	(instruction_i[`nf])
									`nf_2:
									begin
										case	(instruction_i[`funct3_width])
											`w8:		//vlseg2e8ff.v
											begin
												system_vector_o		=	`vlseg2e8ff_v_system_vector	;
												resource_vector_o	=	`vlseg2e8ff_v_resource_vector;
												register_vector_o	=	`vlseg2e8ff_v_register_vector;
												operation_vector_o	=	`vlseg2e8ff_v_operation_vector;
											end
											`w16:	//vlseg2e16ff.v
											begin
												system_vector_o		=	`vlseg2e16ff_v_system_vector	;
												resource_vector_o	=	`vlseg2e16ff_v_resource_vector;
												register_vector_o	=	`vlseg2e16ff_v_register_vector;
												operation_vector_o	=	`vlseg2e16ff_v_operation_vector;
											end
											`w32:	//vlseg2e32ff.v
											begin
												system_vector_o		=	`vlseg2e32ff_v_system_vector	;
												resource_vector_o	=	`vlseg2e32ff_v_resource_vector;
												register_vector_o	=	`vlseg2e32ff_v_register_vector;
												operation_vector_o	=	`vlseg2e32ff_v_operation_vector;
											end
											`w64:	//vlseg2e64ff.v
											begin
												system_vector_o		=	`vlseg2e64ff_v_system_vector	;
												resource_vector_o	=	`vlseg2e64ff_v_resource_vector;
												register_vector_o	=	`vlseg2e64ff_v_register_vector;
												operation_vector_o	=	`vlseg2e64ff_v_operation_vector;
											end
											default:
											begin
												system_vector_o		=	`system_vector_default;
												resource_vector_o	=	`resource_vector_default;
												register_vector_o	=	`register_vector_default;
												operation_vector_o	=	`operation_vector_default;
											end
										endcase
									end
									`nf_3:
									begin
										case	(instruction_i[`funct3_width])
											`w8:		//vlseg3e8ff.v
											begin
												system_vector_o		=	`vlseg3e8ff_v_system_vector	;
												resource_vector_o	=	`vlseg3e8ff_v_resource_vector;
												register_vector_o	=	`vlseg3e8ff_v_register_vector;
												operation_vector_o	=	`vlseg3e8ff_v_operation_vector;
											end
											`w16:	//vlseg3e16ff.v
											begin
												system_vector_o		=	`vlseg3e16ff_v_system_vector	;
												resource_vector_o	=	`vlseg3e16ff_v_resource_vector;
												register_vector_o	=	`vlseg3e16ff_v_register_vector;
												operation_vector_o	=	`vlseg3e16ff_v_operation_vector;
											end
											`w32:	//vlseg3e32ff.v
											begin
												system_vector_o		=	`vlseg3e32ff_v_system_vector	;
												resource_vector_o	=	`vlseg3e32ff_v_resource_vector;
												register_vector_o	=	`vlseg3e32ff_v_register_vector;
												operation_vector_o	=	`vlseg3e32ff_v_operation_vector;
											end
											`w64:	//vlseg3e64ff.v
											begin
												system_vector_o		=	`vlseg3e64ff_v_system_vector	;
												resource_vector_o	=	`vlseg3e64ff_v_resource_vector;
												register_vector_o	=	`vlseg3e64ff_v_register_vector;
												operation_vector_o	=	`vlseg3e64ff_v_operation_vector;
											end
											default:
											begin
												system_vector_o		=	`system_vector_default;
												resource_vector_o	=	`resource_vector_default;
												register_vector_o	=	`register_vector_default;
												operation_vector_o	=	`operation_vector_default;
											end
										endcase
									end
									`nf_4:
									begin
										case	(instruction_i[`funct3_width])
											`w8:		//vlseg4e8ff.v
											begin
												system_vector_o		=	`vlseg4e8ff_v_system_vector	;
												resource_vector_o	=	`vlseg4e8ff_v_resource_vector;
												register_vector_o	=	`vlseg4e8ff_v_register_vector;
												operation_vector_o	=	`vlseg4e8ff_v_operation_vector;
											end
											`w16:	//vlseg4e16ff.v
											begin
												system_vector_o		=	`vlseg4e16ff_v_system_vector	;
												resource_vector_o	=	`vlseg4e16ff_v_resource_vector;
												register_vector_o	=	`vlseg4e16ff_v_register_vector;
												operation_vector_o	=	`vlseg4e16ff_v_operation_vector;
											end
											`w32:	//vlseg4e32ff.v
											begin
												system_vector_o		=	`vlseg4e32ff_v_system_vector	;
												resource_vector_o	=	`vlseg4e32ff_v_resource_vector;
												register_vector_o	=	`vlseg4e32ff_v_register_vector;
												operation_vector_o	=	`vlseg4e32ff_v_operation_vector;
											end
											`w64:	//vlseg4e64ff.v
											begin
												system_vector_o		=	`vlseg4e64ff_v_system_vector	;
												resource_vector_o	=	`vlseg4e64ff_v_resource_vector;
												register_vector_o	=	`vlseg4e64ff_v_register_vector;
												operation_vector_o	=	`vlseg4e64ff_v_operation_vector;
											end
											default:
											begin
												system_vector_o		=	`system_vector_default;
												resource_vector_o	=	`resource_vector_default;
												register_vector_o	=	`register_vector_default;
												operation_vector_o	=	`operation_vector_default;
											end
										endcase
									end
									`nf_5:
									begin
										case	(instruction_i[`funct3_width])
											`w8:		//vlseg5e8ff.v
											begin
												system_vector_o		=	`vlseg5e8ff_v_system_vector	;
												resource_vector_o	=	`vlseg5e8ff_v_resource_vector;
												register_vector_o	=	`vlseg5e8ff_v_register_vector;
												operation_vector_o	=	`vlseg5e8ff_v_operation_vector;
											end
											`w16:	//vlseg5e16ff.v
											begin
												system_vector_o		=	`vlseg5e16ff_v_system_vector	;
												resource_vector_o	=	`vlseg5e16ff_v_resource_vector;
												register_vector_o	=	`vlseg5e16ff_v_register_vector;
												operation_vector_o	=	`vlseg5e16ff_v_operation_vector;
											end
											`w32:	//vlseg5e32ff.v
											begin
												system_vector_o		=	`vlseg5e32ff_v_system_vector	;
												resource_vector_o	=	`vlseg5e32ff_v_resource_vector;
												register_vector_o	=	`vlseg5e32ff_v_register_vector;
												operation_vector_o	=	`vlseg5e32ff_v_operation_vector;
											end
											`w64:	//vlseg5e64ff.v
											begin
												system_vector_o		=	`vlseg5e64ff_v_system_vector	;
												resource_vector_o	=	`vlseg5e64ff_v_resource_vector;
												register_vector_o	=	`vlseg5e64ff_v_register_vector;
												operation_vector_o	=	`vlseg5e64ff_v_operation_vector;
											end
											default:
											begin
												system_vector_o		=	`system_vector_default;
												resource_vector_o	=	`resource_vector_default;
												register_vector_o	=	`register_vector_default;
												operation_vector_o	=	`operation_vector_default;
											end
										endcase
									end
									`nf_6:
									begin
										case	(instruction_i[`funct3_width])
											`w8:		//vlseg6e8ff.v
											begin
												system_vector_o		=	`vlseg6e8ff_v_system_vector	;
												resource_vector_o	=	`vlseg6e8ff_v_resource_vector;
												register_vector_o	=	`vlseg6e8ff_v_register_vector;
												operation_vector_o	=	`vlseg6e8ff_v_operation_vector;
											end
											`w16:	//vlseg6e16ff.v
											begin
												system_vector_o		=	`vlseg6e16ff_v_system_vector	;
												resource_vector_o	=	`vlseg6e16ff_v_resource_vector;
												register_vector_o	=	`vlseg6e16ff_v_register_vector;
												operation_vector_o	=	`vlseg6e16ff_v_operation_vector;
											end
											`w32:	//vlseg6e32ff.v
											begin
												system_vector_o		=	`vlseg6e32ff_v_system_vector	;
												resource_vector_o	=	`vlseg6e32ff_v_resource_vector;
												register_vector_o	=	`vlseg6e32ff_v_register_vector;
												operation_vector_o	=	`vlseg6e32ff_v_operation_vector;
											end
											`w64:	//vlseg6e64ff.v
											begin
												system_vector_o		=	`vlseg6e64ff_v_system_vector	;
												resource_vector_o	=	`vlseg6e64ff_v_resource_vector;
												register_vector_o	=	`vlseg6e64ff_v_register_vector;
												operation_vector_o	=	`vlseg6e64ff_v_operation_vector;
											end
											default:
											begin
												system_vector_o		=	`system_vector_default;
												resource_vector_o	=	`resource_vector_default;
												register_vector_o	=	`register_vector_default;
												operation_vector_o	=	`operation_vector_default;
											end
										endcase
									end
									`nf_7:
									begin
										case	(instruction_i[`funct3_width])
											`w8:		//vlseg7e8ff.v
											begin
												system_vector_o		=	`vlseg7e8ff_v_system_vector	;
												resource_vector_o	=	`vlseg7e8ff_v_resource_vector;
												register_vector_o	=	`vlseg7e8ff_v_register_vector;
												operation_vector_o	=	`vlseg7e8ff_v_operation_vector;
											end
											`w16:	//vlseg7e16ff.v
											begin
												system_vector_o		=	`vlseg7e16ff_v_system_vector	;
												resource_vector_o	=	`vlseg7e16ff_v_resource_vector;
												register_vector_o	=	`vlseg7e16ff_v_register_vector;
												operation_vector_o	=	`vlseg7e16ff_v_operation_vector;
											end
											`w32:	//vlseg7e32ff.v
											begin
												system_vector_o		=	`vlseg7e32ff_v_system_vector	;
												resource_vector_o	=	`vlseg7e32ff_v_resource_vector;
												register_vector_o	=	`vlseg7e32ff_v_register_vector;
												operation_vector_o	=	`vlseg7e32ff_v_operation_vector;
											end
											`w64:	//vlseg7e64ff.v
											begin
												system_vector_o		=	`vlseg7e64ff_v_system_vector	;
												resource_vector_o	=	`vlseg7e64ff_v_resource_vector;
												register_vector_o	=	`vlseg7e64ff_v_register_vector;
												operation_vector_o	=	`vlseg7e64ff_v_operation_vector;
											end
											default:
											begin
												system_vector_o		=	`system_vector_default;
												resource_vector_o	=	`resource_vector_default;
												register_vector_o	=	`register_vector_default;
												operation_vector_o	=	`operation_vector_default;
											end
										endcase
									end
									`nf_8:
									begin
										case	(instruction_i[`funct3_width])
											`w8:		//vlseg8e8ff.v
											begin
												system_vector_o		=	`vlseg8e8ff_v_system_vector	;
												resource_vector_o	=	`vlseg8e8ff_v_resource_vector;
												register_vector_o	=	`vlseg8e8ff_v_register_vector;
												operation_vector_o	=	`vlseg8e8ff_v_operation_vector;
											end
											`w16:	//vlseg8e16ff.v
											begin
												system_vector_o		=	`vlseg8e16ff_v_system_vector	;
												resource_vector_o	=	`vlseg8e16ff_v_resource_vector;
												register_vector_o	=	`vlseg8e16ff_v_register_vector;
												operation_vector_o	=	`vlseg8e16ff_v_operation_vector;
											end
											`w32:	//vlseg8e32ff.v
											begin
												system_vector_o		=	`vlseg8e32ff_v_system_vector	;
												resource_vector_o	=	`vlseg8e32ff_v_resource_vector;
												register_vector_o	=	`vlseg8e32ff_v_register_vector;
												operation_vector_o	=	`vlseg8e32ff_v_operation_vector;
											end
											`w64:	//vlseg8e64ff.v
											begin
												system_vector_o		=	`vlseg8e64ff_v_system_vector	;
												resource_vector_o	=	`vlseg8e64ff_v_resource_vector;
												register_vector_o	=	`vlseg8e64ff_v_register_vector;
												operation_vector_o	=	`vlseg8e64ff_v_operation_vector;
											end
											default:
											begin
												system_vector_o		=	`system_vector_default;
												resource_vector_o	=	`resource_vector_default;
												register_vector_o	=	`register_vector_default;
												operation_vector_o	=	`operation_vector_default;
											end
										endcase
									end
									default:
									begin
										system_vector_o		=	`system_vector_default;
										resource_vector_o	=	`resource_vector_default;
										register_vector_o	=	`register_vector_default;
										operation_vector_o	=	`operation_vector_default;
									end
								endcase
							else
								case	(instruction_i[`funct3_width])
									`w8:		//vle8ff.v
									begin
										system_vector_o		=	`vle8ff_v_system_vector	;
										resource_vector_o	=	`vle8ff_v_resource_vector;
										register_vector_o	=	`vle8ff_v_register_vector;
										operation_vector_o	=	`vle8ff_v_operation_vector;
									end
									`w16:	//vle16ff.v
									begin
										system_vector_o		=	`vle16ff_v_system_vector	;
										resource_vector_o	=	`vle16ff_v_resource_vector;
										register_vector_o	=	`vle16ff_v_register_vector;
										operation_vector_o	=	`vle16ff_v_operation_vector;
									end
									`w32:	//vle32ff.v
									begin
										system_vector_o		=	`vle32ff_v_system_vector	;
										resource_vector_o	=	`vle32ff_v_resource_vector;
										register_vector_o	=	`vle32ff_v_register_vector;
										operation_vector_o	=	`vle32ff_v_operation_vector;
									end
									`w64:	//vle64ff.v
									begin
										system_vector_o		=	`vle64ff_v_system_vector	;
										resource_vector_o	=	`vle64ff_v_resource_vector;
										register_vector_o	=	`vle64ff_v_register_vector;
										operation_vector_o	=	`vle64ff_v_operation_vector;
									end
									default:
									begin
										system_vector_o		=	`system_vector_default;
										resource_vector_o	=	`resource_vector_default;
										register_vector_o	=	`register_vector_default;
										operation_vector_o	=	`operation_vector_default;
									end
								endcase
						`unit_stride_whole_register_load_store:
							if(instruction_i[`vm] == 1)
								case	(instruction_i[`nf])
									`nf_1:
										case	(instruction_i[`funct3_width])
											`w8:		//vl1re8.v
												begin
													system_vector_o		=	`vl1re8_v_system_vector;
													resource_vector_o	=	`vl1re8_v_resource_vector;
													register_vector_o	=	`vl1re8_v_register_vector;
													operation_vector_o	=	`vl1re8_v_operation_vector;
												end
												
											`w16:		//vl1re16.v
												begin
													system_vector_o		=	`vl1re16_v_system_vector;
													resource_vector_o	=	`vl1re16_v_resource_vector;
													register_vector_o	=	`vl1re16_v_register_vector;
													operation_vector_o	=	`vl1re16_v_operation_vector;
												end
												
											`w32:		//vl1re32.v
												begin
													system_vector_o		=	`vl1re32_v_system_vector;
													resource_vector_o	=	`vl1re32_v_resource_vector;
													register_vector_o	=	`vl1re32_v_register_vector;
													operation_vector_o	=	`vl1re32_v_operation_vector;
												end
												
											`w64:		//vl1re64.v
												begin
													system_vector_o		=	`vl1re64_v_system_vector;
													resource_vector_o	=	`vl1re64_v_resource_vector;
													register_vector_o	=	`vl1re64_v_register_vector;
													operation_vector_o	=	`vl1re64_v_operation_vector;
												end
											default:
												begin
													system_vector_o		=	`system_vector_default;
													resource_vector_o	=	`resource_vector_default;
													register_vector_o	=	`register_vector_default;
													operation_vector_o	=	`operation_vector_default;
												end
										endcase
									default:
										begin
											system_vector_o		=	`system_vector_default;
											resource_vector_o	=	`resource_vector_default;
											register_vector_o	=	`register_vector_default;
											operation_vector_o	=	`operation_vector_default;
										end
								endcase
							else
								begin
									system_vector_o		=	`system_vector_default;
									resource_vector_o	=	`resource_vector_default;
									register_vector_o	=	`register_vector_default;
									operation_vector_o	=	`operation_vector_default;
								end
						`unit_stride_mask_load_store:
							if(instruction_i[`funct3_width] == `w8 && instruction_i[`vm] == 1)
								begin		//vlm.v
									system_vector_o		=	`vlm_v_system_vector;	
									resource_vector_o	=	`vlm_v_resource_vector;
									register_vector_o	=	`vlm_v_register_vector;
									operation_vector_o	=	`vlm_v_operation_vector;
								end
							else
								begin
									system_vector_o		=	`system_vector_default;
									resource_vector_o	=	`resource_vector_default;
									register_vector_o	=	`register_vector_default;
									operation_vector_o	=	`operation_vector_default;
								end
						default:
						begin
							system_vector_o		=	`system_vector_default;
							resource_vector_o	=	`resource_vector_default;
							register_vector_o	=	`register_vector_default;
							operation_vector_o	=	`operation_vector_default;
						end
					endcase
				`indexed_ordered:
					case	(instruction_i[`nf])
						`nf_1:
							case	(instruction_i[`funct3_width])
								`w8:		//vloxei8.v	&	vloxseg1ei8.v
									begin
										system_vector_o		=	`vloxei8_v_system_vector;
										resource_vector_o	=	`vloxei8_v_resource_vector;
										register_vector_o	=	`vloxei8_v_register_vector;
										operation_vector_o	=	`vloxei8_v_operation_vector;
									end
								`w16:		//vloxei16.v	&	vloxseg1ei8.v
									begin
										system_vector_o		=	`vloxei16_v_system_vector;
										resource_vector_o	=	`vloxei16_v_resource_vector;
										register_vector_o	=	`vloxei16_v_register_vector;
										operation_vector_o	=	`vloxei16_v_operation_vector;
									end
								`w32:		//vloxei32.v	&	vloxseg1ei8.v
									begin
										system_vector_o		=	`vloxei32_v_system_vector;
										resource_vector_o	=	`vloxei32_v_resource_vector;
										register_vector_o	=	`vloxei32_v_register_vector;
										operation_vector_o	=	`vloxei32_v_operation_vector;
									end
								`w64:		//vloxei64.v	&	vloxseg1ei8.v
									begin
										system_vector_o		=	`vloxei64_v_system_vector;
										resource_vector_o	=	`vloxei64_v_resource_vector;
										register_vector_o	=	`vloxei64_v_register_vector;
										operation_vector_o	=	`vloxei64_v_operation_vector;
									end
								default:
									begin
										system_vector_o		=	`system_vector_default;
										resource_vector_o	=	`resource_vector_default;
										register_vector_o	=	`register_vector_default;
										operation_vector_o	=	`operation_vector_default;
									end
							endcase
					
						`nf_2:
							case	(instruction_i[`funct3_width])
								`w8:		//vloxseg2ei8.v
									begin
										system_vector_o		=	`vloxseg2ei8_v_system_vector;
										resource_vector_o	=	`vloxseg2ei8_v_resource_vector;
										register_vector_o	=	`vloxseg2ei8_v_register_vector;
										operation_vector_o	=	`vloxseg2ei8_v_operation_vector;
									end
								`w16:		//vloxseg2ei16.v
									begin
										system_vector_o		=	`vloxseg2ei16_v_system_vector;
										resource_vector_o	=	`vloxseg2ei16_v_resource_vector;
										register_vector_o	=	`vloxseg2ei16_v_register_vector;
										operation_vector_o	=	`vloxseg2ei16_v_operation_vector;
									end
								`w32:		//vloxseg2ei32.v
									begin
										system_vector_o		=	`vloxseg2ei32_v_system_vector;
										resource_vector_o	=	`vloxseg2ei32_v_resource_vector;
										register_vector_o	=	`vloxseg2ei32_v_register_vector;
										operation_vector_o	=	`vloxseg2ei32_v_operation_vector;
									end
								`w64:		//vloxseg2ei64.v
									begin
										system_vector_o		=	`vloxseg2ei64_v_system_vector;
										resource_vector_o	=	`vloxseg2ei64_v_resource_vector;
										register_vector_o	=	`vloxseg2ei64_v_register_vector;
										operation_vector_o	=	`vloxseg2ei64_v_operation_vector;
									end
								default:
									begin
										system_vector_o		=	`system_vector_default;
										resource_vector_o	=	`resource_vector_default;
										register_vector_o	=	`register_vector_default;
										operation_vector_o	=	`operation_vector_default;
									end
							endcase
					
						`nf_3:
							case	(instruction_i[`funct3_width])
								`w8:		//vloxseg3ei8.v
									begin
										system_vector_o		=	`vloxseg3ei8_v_system_vector;
										resource_vector_o	=	`vloxseg3ei8_v_resource_vector;
										register_vector_o	=	`vloxseg3ei8_v_register_vector;
										operation_vector_o	=	`vloxseg3ei8_v_operation_vector;
									end
								`w16:		//vloxseg3ei16.v
									begin
										system_vector_o		=	`vloxseg3ei16_v_system_vector;
										resource_vector_o	=	`vloxseg3ei16_v_resource_vector;
										register_vector_o	=	`vloxseg3ei16_v_register_vector;
										operation_vector_o	=	`vloxseg3ei16_v_operation_vector;
									end
								`w32:		//vloxseg3ei32.v
									begin
										system_vector_o		=	`vloxseg3ei32_v_system_vector;
										resource_vector_o	=	`vloxseg3ei32_v_resource_vector;
										register_vector_o	=	`vloxseg3ei32_v_register_vector;
										operation_vector_o	=	`vloxseg3ei32_v_operation_vector;
									end
								`w64:		//vloxseg3ei64.v
									begin
										system_vector_o		=	`vloxseg3ei64_v_system_vector;
										resource_vector_o	=	`vloxseg3ei64_v_resource_vector;
										register_vector_o	=	`vloxseg3ei64_v_register_vector;
										operation_vector_o	=	`vloxseg3ei64_v_operation_vector;
									end
								default:
									begin
										system_vector_o		=	`system_vector_default;
										resource_vector_o	=	`resource_vector_default;
										register_vector_o	=	`register_vector_default;
										operation_vector_o	=	`operation_vector_default;
									end
							endcase
					
						`nf_4:
							case	(instruction_i[`funct3_width])
								`w8:		//vloxseg4ei8.v
									begin
										system_vector_o		=	`vloxseg4ei8_v_system_vector;
										resource_vector_o	=	`vloxseg4ei8_v_resource_vector;
										register_vector_o	=	`vloxseg4ei8_v_register_vector;
										operation_vector_o	=	`vloxseg4ei8_v_operation_vector;
									end
								`w16:		//vloxseg4ei16.v
									begin
										system_vector_o		=	`vloxseg4ei16_v_system_vector;
										resource_vector_o	=	`vloxseg4ei16_v_resource_vector;
										register_vector_o	=	`vloxseg4ei16_v_register_vector;
										operation_vector_o	=	`vloxseg4ei16_v_operation_vector;
									end
								`w32:		//vloxseg4ei32.v
									begin
										system_vector_o		=	`vloxseg4ei32_v_system_vector;
										resource_vector_o	=	`vloxseg4ei32_v_resource_vector;
										register_vector_o	=	`vloxseg4ei32_v_register_vector;
										operation_vector_o	=	`vloxseg4ei32_v_operation_vector;
									end
								`w64:		//vloxseg4ei64.v
									begin
										system_vector_o		=	`vloxseg4ei64_v_system_vector;
										resource_vector_o	=	`vloxseg4ei64_v_resource_vector;
										register_vector_o	=	`vloxseg4ei64_v_register_vector;
										operation_vector_o	=	`vloxseg4ei64_v_operation_vector;
									end
								default:
									begin
										system_vector_o		=	`system_vector_default;
										resource_vector_o	=	`resource_vector_default;
										register_vector_o	=	`register_vector_default;
										operation_vector_o	=	`operation_vector_default;
									end
							endcase
							
						`nf_5:
							case	(instruction_i[`funct3_width])
								`w8:		//vloxseg5ei8.v
									begin
										system_vector_o		=	`vloxseg5ei8_v_system_vector;
										resource_vector_o	=	`vloxseg5ei8_v_resource_vector;
										register_vector_o	=	`vloxseg5ei8_v_register_vector;
										operation_vector_o	=	`vloxseg5ei8_v_operation_vector;
									end
								`w16:		//vloxseg5ei16.v
									begin
										system_vector_o		=	`vloxseg5ei16_v_system_vector;
										resource_vector_o	=	`vloxseg5ei16_v_resource_vector;
										register_vector_o	=	`vloxseg5ei16_v_register_vector;
										operation_vector_o	=	`vloxseg5ei16_v_operation_vector;
									end
								`w32:		//vloxseg5ei32.v
									begin
										system_vector_o		=	`vloxseg5ei32_v_system_vector;
										resource_vector_o	=	`vloxseg5ei32_v_resource_vector;
										register_vector_o	=	`vloxseg5ei32_v_register_vector;
										operation_vector_o	=	`vloxseg5ei32_v_operation_vector;
									end
								`w64:		//vloxseg5ei64.v
									begin
										system_vector_o		=	`vloxseg5ei64_v_system_vector;
										resource_vector_o	=	`vloxseg5ei64_v_resource_vector;
										register_vector_o	=	`vloxseg5ei64_v_register_vector;
										operation_vector_o	=	`vloxseg5ei64_v_operation_vector;
									end
								default:
									begin
										system_vector_o		=	`system_vector_default;
										resource_vector_o	=	`resource_vector_default;
										register_vector_o	=	`register_vector_default;
										operation_vector_o	=	`operation_vector_default;
									end
							endcase
						
						`nf_6:
							case	(instruction_i[`funct3_width])
								`w8:		//vloxseg6ei8.v
									begin
										system_vector_o		=	`vloxseg6ei8_v_system_vector;
										resource_vector_o	=	`vloxseg6ei8_v_resource_vector;
										register_vector_o	=	`vloxseg6ei8_v_register_vector;
										operation_vector_o	=	`vloxseg6ei8_v_operation_vector;
									end
								`w16:		//vloxseg6ei16.v
									begin
										system_vector_o		=	`vloxseg6ei16_v_system_vector;
										resource_vector_o	=	`vloxseg6ei16_v_resource_vector;
										register_vector_o	=	`vloxseg6ei16_v_register_vector;
										operation_vector_o	=	`vloxseg6ei16_v_operation_vector;
									end
								`w32:		//vloxseg6ei32.v
									begin
										system_vector_o		=	`vloxseg6ei32_v_system_vector;
										resource_vector_o	=	`vloxseg6ei32_v_resource_vector;
										register_vector_o	=	`vloxseg6ei32_v_register_vector;
										operation_vector_o	=	`vloxseg6ei32_v_operation_vector;
									end
								`w64:		//vloxseg6ei64.v
									begin
										system_vector_o		=	`vloxseg6ei64_v_system_vector;
										resource_vector_o	=	`vloxseg6ei64_v_resource_vector;
										register_vector_o	=	`vloxseg6ei64_v_register_vector;
										operation_vector_o	=	`vloxseg6ei64_v_operation_vector;
									end
								default:
									begin
										system_vector_o		=	`system_vector_default;
										resource_vector_o	=	`resource_vector_default;
										register_vector_o	=	`register_vector_default;
										operation_vector_o	=	`operation_vector_default;
									end
							endcase
							
						
						`nf_7:
							case	(instruction_i[`funct3_width])
								`w8:		//vloxseg7ei8.v
									begin
										system_vector_o		=	`vloxseg7ei8_v_system_vector;
										resource_vector_o	=	`vloxseg7ei8_v_resource_vector;
										register_vector_o	=	`vloxseg7ei8_v_register_vector;
										operation_vector_o	=	`vloxseg7ei8_v_operation_vector;
									end
								`w16:		//vloxseg7ei16.v
									begin
										system_vector_o		=	`vloxseg7ei16_v_system_vector;
										resource_vector_o	=	`vloxseg7ei16_v_resource_vector;
										register_vector_o	=	`vloxseg7ei16_v_register_vector;
										operation_vector_o	=	`vloxseg7ei16_v_operation_vector;
									end
								`w32:		//vloxseg7ei32.v
									begin
										system_vector_o		=	`vloxseg7ei32_v_system_vector;
										resource_vector_o	=	`vloxseg7ei32_v_resource_vector;
										register_vector_o	=	`vloxseg7ei32_v_register_vector;
										operation_vector_o	=	`vloxseg7ei32_v_operation_vector;
									end
								`w64:		//vloxseg7ei64.v
									begin
										system_vector_o		=	`vloxseg7ei64_v_system_vector;
										resource_vector_o	=	`vloxseg7ei64_v_resource_vector;
										register_vector_o	=	`vloxseg7ei64_v_register_vector;
										operation_vector_o	=	`vloxseg7ei64_v_operation_vector;
									end
								default:
									begin
										system_vector_o		=	`system_vector_default;
										resource_vector_o	=	`resource_vector_default;
										register_vector_o	=	`register_vector_default;
										operation_vector_o	=	`operation_vector_default;
									end
							endcase
							
						`nf_8:
							case	(instruction_i[`funct3_width])
								`w8:		//vloxseg8ei8.v
									begin
										system_vector_o		=	`vloxseg8ei8_v_system_vector;
										resource_vector_o	=	`vloxseg8ei8_v_resource_vector;
										register_vector_o	=	`vloxseg8ei8_v_register_vector;
										operation_vector_o	=	`vloxseg8ei8_v_operation_vector;
									end
								`w16:		//vloxseg8ei16.v
									begin
										system_vector_o		=	`vloxseg8ei16_v_system_vector;
										resource_vector_o	=	`vloxseg8ei16_v_resource_vector;
										register_vector_o	=	`vloxseg8ei16_v_register_vector;
										operation_vector_o	=	`vloxseg8ei16_v_operation_vector;
									end
								`w32:		//vloxseg8ei32.v
									begin
										system_vector_o		=	`vloxseg8ei32_v_system_vector;
										resource_vector_o	=	`vloxseg8ei32_v_resource_vector;
										register_vector_o	=	`vloxseg8ei32_v_register_vector;
										operation_vector_o	=	`vloxseg8ei32_v_operation_vector;
									end
								`w64:		//vloxseg8ei64.v
									begin
										system_vector_o		=	`vloxseg8ei64_v_system_vector;
										resource_vector_o	=	`vloxseg8ei64_v_resource_vector;
										register_vector_o	=	`vloxseg8ei64_v_register_vector;
										operation_vector_o	=	`vloxseg8ei64_v_operation_vector;
									end
								default:
									begin
										system_vector_o		=	`system_vector_default;
										resource_vector_o	=	`resource_vector_default;
										register_vector_o	=	`register_vector_default;
										operation_vector_o	=	`operation_vector_default;
									end
							endcase
						default:
								begin
									system_vector_o		=	`system_vector_default;
									resource_vector_o	=	`resource_vector_default;
									register_vector_o	=	`register_vector_default;
									operation_vector_o	=	`operation_vector_default;
								end
					endcase
				`indexed_unordered:
					case	(instruction_i[`nf])
						`nf_1:
							case	(instruction_i[`funct3_width])
								`w8:		//vluxei8.v	&	vluxseg1ei8.v
									begin
										system_vector_o		=	`vluxei8_v_system_vector;
										resource_vector_o	=	`vluxei8_v_resource_vector;
										register_vector_o	=	`vluxei8_v_register_vector;
										operation_vector_o	=	`vluxei8_v_operation_vector;
									end
								`w16:		//vluxei16.v	&	vluxseg1ei8.v
									begin
										system_vector_o		=	`vluxei16_v_system_vector;
										resource_vector_o	=	`vluxei16_v_resource_vector;
										register_vector_o	=	`vluxei16_v_register_vector;
										operation_vector_o	=	`vluxei16_v_operation_vector;
									end
								`w32:		//vluxei32.v	&	vluxseg1ei8.v
									begin
										system_vector_o		=	`vluxei32_v_system_vector;
										resource_vector_o	=	`vluxei32_v_resource_vector;
										register_vector_o	=	`vluxei32_v_register_vector;
										operation_vector_o	=	`vluxei32_v_operation_vector;
									end
								`w64:		//vluxei64.v	&	vluxseg1ei8.v
									begin
										system_vector_o		=	`vluxei64_v_system_vector;
										resource_vector_o	=	`vluxei64_v_resource_vector;
										register_vector_o	=	`vluxei64_v_register_vector;
										operation_vector_o	=	`vluxei64_v_operation_vector;
									end
								default:
									begin
										system_vector_o		=	`system_vector_default;
										resource_vector_o	=	`resource_vector_default;
										register_vector_o	=	`register_vector_default;
										operation_vector_o	=	`operation_vector_default;
									end
							endcase
						
						`nf_2:
							case	(instruction_i[`funct3_width])
								`w8:		//vluxseg2ei8.v
									begin
										system_vector_o		=	`vluxseg2ei8_v_system_vector;
										resource_vector_o	=	`vluxseg2ei8_v_resource_vector;
										register_vector_o	=	`vluxseg2ei8_v_register_vector;
										operation_vector_o	=	`vluxseg2ei8_v_operation_vector;
									end
								`w16:		//vluxseg2ei16.v
									begin
										system_vector_o		=	`vluxseg2ei16_v_system_vector;
										resource_vector_o	=	`vluxseg2ei16_v_resource_vector;
										register_vector_o	=	`vluxseg2ei16_v_register_vector;
										operation_vector_o	=	`vluxseg2ei16_v_operation_vector;
									end
								`w32:		//vluxseg2ei32.v
									begin
										system_vector_o		=	`vluxseg2ei32_v_system_vector;
										resource_vector_o	=	`vluxseg2ei32_v_resource_vector;
										register_vector_o	=	`vluxseg2ei32_v_register_vector;
										operation_vector_o	=	`vluxseg2ei32_v_operation_vector;
									end
								`w64:		//vluxseg2ei64.v
									begin
										system_vector_o		=	`vluxseg2ei64_v_system_vector;
										resource_vector_o	=	`vluxseg2ei64_v_resource_vector;
										register_vector_o	=	`vluxseg2ei64_v_register_vector;
										operation_vector_o	=	`vluxseg2ei64_v_operation_vector;
									end
								default:
									begin
										system_vector_o		=	`system_vector_default;
										resource_vector_o	=	`resource_vector_default;
										register_vector_o	=	`register_vector_default;
										operation_vector_o	=	`operation_vector_default;
									end
							endcase
						
						`nf_3:
							case	(instruction_i[`funct3_width])
								`w8:		//vluxseg3ei8.v
									begin
										system_vector_o		=	`vluxseg3ei8_v_system_vector;
										resource_vector_o	=	`vluxseg3ei8_v_resource_vector;
										register_vector_o	=	`vluxseg3ei8_v_register_vector;
										operation_vector_o	=	`vluxseg3ei8_v_operation_vector;
									end
								`w16:		//vluxseg3ei16.v
									begin
										system_vector_o		=	`vluxseg3ei16_v_system_vector;
										resource_vector_o	=	`vluxseg3ei16_v_resource_vector;
										register_vector_o	=	`vluxseg3ei16_v_register_vector;
										operation_vector_o	=	`vluxseg3ei16_v_operation_vector;
									end
								`w32:		//vluxseg3ei32.v
									begin
										system_vector_o		=	`vluxseg3ei32_v_system_vector;
										resource_vector_o	=	`vluxseg3ei32_v_resource_vector;
										register_vector_o	=	`vluxseg3ei32_v_register_vector;
										operation_vector_o	=	`vluxseg3ei32_v_operation_vector;
									end
								`w64:		//vluxseg3ei64.v
									begin
										system_vector_o		=	`vluxseg3ei64_v_system_vector;
										resource_vector_o	=	`vluxseg3ei64_v_resource_vector;
										register_vector_o	=	`vluxseg3ei64_v_register_vector;
										operation_vector_o	=	`vluxseg3ei64_v_operation_vector;
									end
								default:
									begin
										system_vector_o		=	`system_vector_default;
										resource_vector_o	=	`resource_vector_default;
										register_vector_o	=	`register_vector_default;
										operation_vector_o	=	`operation_vector_default;
									end
							endcase
						
						`nf_4:
							case	(instruction_i[`funct3_width])
								`w8:		//vluxseg4ei8.v
									begin
										system_vector_o		=	`vluxseg4ei8_v_system_vector;
										resource_vector_o	=	`vluxseg4ei8_v_resource_vector;
										register_vector_o	=	`vluxseg4ei8_v_register_vector;
										operation_vector_o	=	`vluxseg4ei8_v_operation_vector;
									end
								`w16:		//vluxseg4ei16.v
									begin
										system_vector_o		=	`vluxseg4ei16_v_system_vector;
										resource_vector_o	=	`vluxseg4ei16_v_resource_vector;
										register_vector_o	=	`vluxseg4ei16_v_register_vector;
										operation_vector_o	=	`vluxseg4ei16_v_operation_vector;
									end
								`w32:		//vluxseg4ei32.v
									begin
										system_vector_o		=	`vluxseg4ei32_v_system_vector;
										resource_vector_o	=	`vluxseg4ei32_v_resource_vector;
										register_vector_o	=	`vluxseg4ei32_v_register_vector;
										operation_vector_o	=	`vluxseg4ei32_v_operation_vector;
									end
								`w64:		//vluxseg4ei64.v
									begin
										system_vector_o		=	`vluxseg4ei64_v_system_vector;
										resource_vector_o	=	`vluxseg4ei64_v_resource_vector;
										register_vector_o	=	`vluxseg4ei64_v_register_vector;
										operation_vector_o	=	`vluxseg4ei64_v_operation_vector;
									end
								default:
									begin
										system_vector_o		=	`system_vector_default;
										resource_vector_o	=	`resource_vector_default;
										register_vector_o	=	`register_vector_default;
										operation_vector_o	=	`operation_vector_default;
									end
							endcase
						
						`nf_5:
							case	(instruction_i[`funct3_width])
								`w8:		//vluxseg5ei8.v
									begin
										system_vector_o		=	`vluxseg5ei8_v_system_vector;
										resource_vector_o	=	`vluxseg5ei8_v_resource_vector;
										register_vector_o	=	`vluxseg5ei8_v_register_vector;
										operation_vector_o	=	`vluxseg5ei8_v_operation_vector;
									end
								`w16:		//vluxseg5ei16.v
									begin
										system_vector_o		=	`vluxseg5ei16_v_system_vector;
										resource_vector_o	=	`vluxseg5ei16_v_resource_vector;
										register_vector_o	=	`vluxseg5ei16_v_register_vector;
										operation_vector_o	=	`vluxseg5ei16_v_operation_vector;
									end
								`w32:		//vluxseg5ei32.v
									begin
										system_vector_o		=	`vluxseg5ei32_v_system_vector;
										resource_vector_o	=	`vluxseg5ei32_v_resource_vector;
										register_vector_o	=	`vluxseg5ei32_v_register_vector;
										operation_vector_o	=	`vluxseg5ei32_v_operation_vector;
									end
								`w64:		//vluxseg5ei64.v
									begin
										system_vector_o		=	`vluxseg5ei64_v_system_vector;
										resource_vector_o	=	`vluxseg5ei64_v_resource_vector;
										register_vector_o	=	`vluxseg5ei64_v_register_vector;
										operation_vector_o	=	`vluxseg5ei64_v_operation_vector;
									end
								default:
									begin
										system_vector_o		=	`system_vector_default;
										resource_vector_o	=	`resource_vector_default;
										register_vector_o	=	`register_vector_default;
										operation_vector_o	=	`operation_vector_default;
									end
							endcase
						
						`nf_6:
							case	(instruction_i[`funct3_width])
								`w8:		//vluxseg6ei8.v
									begin
										system_vector_o		=	`vluxseg6ei8_v_system_vector;
										resource_vector_o	=	`vluxseg6ei8_v_resource_vector;
										register_vector_o	=	`vluxseg6ei8_v_register_vector;
										operation_vector_o	=	`vluxseg6ei8_v_operation_vector;
									end
								`w16:		//vluxseg6ei16.v
									begin
										system_vector_o		=	`vluxseg6ei16_v_system_vector;
										resource_vector_o	=	`vluxseg6ei16_v_resource_vector;
										register_vector_o	=	`vluxseg6ei16_v_register_vector;
										operation_vector_o	=	`vluxseg6ei16_v_operation_vector;
									end
								`w32:		//vluxseg6ei32.v
									begin
										system_vector_o		=	`vluxseg6ei32_v_system_vector;
										resource_vector_o	=	`vluxseg6ei32_v_resource_vector;
										register_vector_o	=	`vluxseg6ei32_v_register_vector;
										operation_vector_o	=	`vluxseg6ei32_v_operation_vector;
									end
								`w64:		//vluxseg6ei64.v
									begin
										system_vector_o		=	`vluxseg6ei64_v_system_vector;
										resource_vector_o	=	`vluxseg6ei64_v_resource_vector;
										register_vector_o	=	`vluxseg6ei64_v_register_vector;
										operation_vector_o	=	`vluxseg6ei64_v_operation_vector;
									end
								default:
									begin
										system_vector_o		=	`system_vector_default;
										resource_vector_o	=	`resource_vector_default;
										register_vector_o	=	`register_vector_default;
										operation_vector_o	=	`operation_vector_default;
									end
							endcase
						
						`nf_7:
							case	(instruction_i[`funct3_width])
								`w8:		//vluxseg7ei8.v
									begin
										system_vector_o		=	`vluxseg7ei8_v_system_vector;
										resource_vector_o	=	`vluxseg7ei8_v_resource_vector;
										register_vector_o	=	`vluxseg7ei8_v_register_vector;
										operation_vector_o	=	`vluxseg7ei8_v_operation_vector;
									end
								`w16:		//vluxseg7ei16.v
									begin
										system_vector_o		=	`vluxseg7ei16_v_system_vector;
										resource_vector_o	=	`vluxseg7ei16_v_resource_vector;
										register_vector_o	=	`vluxseg7ei16_v_register_vector;
										operation_vector_o	=	`vluxseg7ei16_v_operation_vector;
									end
								`w32:		//vluxseg7ei32.v
									begin
										system_vector_o		=	`vluxseg7ei32_v_system_vector;
										resource_vector_o	=	`vluxseg7ei32_v_resource_vector;
										register_vector_o	=	`vluxseg7ei32_v_register_vector;
										operation_vector_o	=	`vluxseg7ei32_v_operation_vector;
									end
								`w64:		//vluxseg7ei64.v
									begin
										system_vector_o		=	`vluxseg7ei64_v_system_vector;
										resource_vector_o	=	`vluxseg7ei64_v_resource_vector;
										register_vector_o	=	`vluxseg7ei64_v_register_vector;
										operation_vector_o	=	`vluxseg7ei64_v_operation_vector;
									end
								default:
									begin
										system_vector_o		=	`system_vector_default;
										resource_vector_o	=	`resource_vector_default;
										register_vector_o	=	`register_vector_default;
										operation_vector_o	=	`operation_vector_default;
									end
							endcase
						
						`nf_8:
							case	(instruction_i[`funct3_width])
								`w8:		//vluxseg8ei8.v
									begin
										system_vector_o		=	`vluxseg8ei8_v_system_vector;
										resource_vector_o	=	`vluxseg8ei8_v_resource_vector;
										register_vector_o	=	`vluxseg8ei8_v_register_vector;
										operation_vector_o	=	`vluxseg8ei8_v_operation_vector;
									end
								`w16:		//vluxseg8ei16.v
									begin
										system_vector_o		=	`vluxseg8ei16_v_system_vector;
										resource_vector_o	=	`vluxseg8ei16_v_resource_vector;
										register_vector_o	=	`vluxseg8ei16_v_register_vector;
										operation_vector_o	=	`vluxseg8ei16_v_operation_vector;
									end
								`w32:		//vluxseg8ei32.v
									begin
										system_vector_o		=	`vluxseg8ei32_v_system_vector;
										resource_vector_o	=	`vluxseg8ei32_v_resource_vector;
										register_vector_o	=	`vluxseg8ei32_v_register_vector;
										operation_vector_o	=	`vluxseg8ei32_v_operation_vector;
									end
								`w64:		//vluxseg8ei64.v
									begin
										system_vector_o		=	`vluxseg8ei64_v_system_vector;
										resource_vector_o	=	`vluxseg8ei64_v_resource_vector;
										register_vector_o	=	`vluxseg8ei64_v_register_vector;
										operation_vector_o	=	`vluxseg8ei64_v_operation_vector;
									end
								default:
									begin
										system_vector_o		=	`system_vector_default;
										resource_vector_o	=	`resource_vector_default;
										register_vector_o	=	`register_vector_default;
										operation_vector_o	=	`operation_vector_default;
									end
							endcase
						
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
				`strided:
					if(instruction_i[`nf] > 0)		//Segment, Strided Load
						case (instruction_i[`nf])
							`nf_2:	
								case (instruction_i[`funct3_width])
									`w8:		//vlseg2e8.v
										begin
											system_vector_o		=	`vlseg2e8_v_system_vector;
											resource_vector_o	=	`vlseg2e8_v_resource_vector;	
											register_vector_o	=	`vlseg2e8_v_register_vector;
											operation_vector_o	=	`vlseg2e8_v_operation_vector;
										end
										
									`w16:		//vlseg2e16.v
										begin
											system_vector_o		=	`vlseg2e16_v_system_vector;
											resource_vector_o	=	`vlseg2e16_v_resource_vector;	
											register_vector_o	=	`vlseg2e16_v_register_vector;
											operation_vector_o	=	`vlseg2e16_v_operation_vector;
										end
										
									`w32:		//vlseg2e32.v
										begin
											system_vector_o		=	`vlseg2e32_v_system_vector;
											resource_vector_o	=	`vlseg2e32_v_resource_vector;	
											register_vector_o	=	`vlseg2e32_v_register_vector;
											operation_vector_o	=	`vlseg2e32_v_operation_vector;
										end
										
									`w64:		//vlseg2e64.v
										begin
											system_vector_o		=	`vlseg2e64_v_system_vector;
											resource_vector_o	=	`vlseg2e64_v_resource_vector;	
											register_vector_o	=	`vlseg2e64_v_register_vector;
											operation_vector_o	=	`vlseg2e64_v_operation_vector;
										end
									default:
										begin
											system_vector_o		=	`system_vector_default;
											resource_vector_o	=	`resource_vector_default;
											register_vector_o	=	`register_vector_default;
											operation_vector_o	=	`operation_vector_default;
										end	
								endcase
							`nf_3:
								case (instruction_i[`funct3_width])
									`w8:		//vlseg3e8.v
										begin
											system_vector_o		=	`vlseg3e8_v_system_vector;
											resource_vector_o	=	`vlseg3e8_v_resource_vector;	
											register_vector_o	=	`vlseg3e8_v_register_vector;
											operation_vector_o	=	`vlseg3e8_v_operation_vector;
										end
										
									`w16:		//vlseg3e16.v
										begin
											system_vector_o		=	`vlseg3e16_v_system_vector;
											resource_vector_o	=	`vlseg3e16_v_resource_vector;	
											register_vector_o	=	`vlseg3e16_v_register_vector;
											operation_vector_o	=	`vlseg3e16_v_operation_vector;
										end
										
									`w32:		//vlseg3e32.v
										begin
											system_vector_o		=	`vlseg3e32_v_system_vector;
											resource_vector_o	=	`vlseg3e32_v_resource_vector;	
											register_vector_o	=	`vlseg3e32_v_register_vector;
											operation_vector_o	=	`vlseg3e32_v_operation_vector;
										end
										
									`w64:		//vlseg3e64.v
										begin
											system_vector_o		=	`vlseg3e64_v_system_vector;
											resource_vector_o	=	`vlseg3e64_v_resource_vector;	
											register_vector_o	=	`vlseg3e64_v_register_vector;
											operation_vector_o	=	`vlseg3e64_v_operation_vector;
										end
									default:
										begin
											system_vector_o		=	`system_vector_default;
											resource_vector_o	=	`resource_vector_default;
											register_vector_o	=	`register_vector_default;
											operation_vector_o	=	`operation_vector_default;
										end	
								endcase
							`nf_4:
								case (instruction_i[`funct3_width])
									`w8:		//vlsseg4e8.v
										begin
											system_vector_o		=	`vlseg4e8_v_system_vector;
											resource_vector_o	=	`vlseg4e8_v_resource_vector;	
											register_vector_o	=	`vlseg4e8_v_register_vector;
											operation_vector_o	=	`vlseg4e8_v_operation_vector;
										end
										
									`w16:		//vlseg4e16.v
										begin
											system_vector_o		=	`vlseg4e16_v_system_vector;
											resource_vector_o	=	`vlseg4e16_v_resource_vector;	
											register_vector_o	=	`vlseg4e16_v_register_vector;
											operation_vector_o	=	`vlseg4e16_v_operation_vector;
										end
										
									`w32:		//vlseg4e32.v
										begin
											system_vector_o		=	`vlseg4e32_v_system_vector;
											resource_vector_o	=	`vlseg4e32_v_resource_vector;	
											register_vector_o	=	`vlseg4e32_v_register_vector;
											operation_vector_o	=	`vlseg4e32_v_operation_vector;
										end
										
									`w64:		//vlseg4e64.v
										begin
											system_vector_o		=	`vlseg4e64_v_system_vector;
											resource_vector_o	=	`vlseg4e64_v_resource_vector;	
											register_vector_o	=	`vlseg4e64_v_register_vector;
											operation_vector_o	=	`vlseg4e64_v_operation_vector;
										end
									default:
										begin
											system_vector_o		=	`system_vector_default;
											resource_vector_o	=	`resource_vector_default;
											register_vector_o	=	`register_vector_default;
											operation_vector_o	=	`operation_vector_default;
										end	
								endcase
							`nf_5:
								case (instruction_i[`funct3_width])
									`w8:		//vlseg5e8.v
										begin
											system_vector_o		=	`vlseg5e8_v_system_vector;
											resource_vector_o	=	`vlseg5e8_v_resource_vector;	
											register_vector_o	=	`vlseg5e8_v_register_vector;
											operation_vector_o	=	`vlseg5e8_v_operation_vector;
										end
										
									`w16:		//vlseg5e16.v
										begin
											system_vector_o		=	`vlseg5e16_v_system_vector;
											resource_vector_o	=	`vlseg5e16_v_resource_vector;	
											register_vector_o	=	`vlseg5e16_v_register_vector;
											operation_vector_o	=	`vlseg5e16_v_operation_vector;
										end
										
									`w32:		//vlseg5e32.v
										begin
											system_vector_o		=	`vlseg5e32_v_system_vector;
											resource_vector_o	=	`vlseg5e32_v_resource_vector;	
											register_vector_o	=	`vlseg5e32_v_register_vector;
											operation_vector_o	=	`vlseg5e32_v_operation_vector;
										end
										
									`w64:		//vlseg5e64.v
										begin
											system_vector_o		=	`vlseg5e64_v_system_vector;
											resource_vector_o	=	`vlseg5e64_v_resource_vector;	
											register_vector_o	=	`vlseg5e64_v_register_vector;
											operation_vector_o	=	`vlseg5e64_v_operation_vector;
										end
									default:
										begin
											system_vector_o		=	`system_vector_default;
											resource_vector_o	=	`resource_vector_default;
											register_vector_o	=	`register_vector_default;
											operation_vector_o	=	`operation_vector_default;
										end	
								endcase
							`nf_6:
								case (instruction_i[`funct3_width])
									`w8:		//vlseg6e8.v
										begin
											system_vector_o		=	`vlseg6e8_v_system_vector;
											resource_vector_o	=	`vlseg6e8_v_resource_vector;	
											register_vector_o	=	`vlseg6e8_v_register_vector;
											operation_vector_o	=	`vlseg6e8_v_operation_vector;
										end
										
									`w16:		//vlseg6e16.v
										begin
											system_vector_o		=	`vlseg6e16_v_system_vector;
											resource_vector_o	=	`vlseg6e16_v_resource_vector;	
											register_vector_o	=	`vlseg6e16_v_register_vector;
											operation_vector_o	=	`vlseg6e16_v_operation_vector;
										end
										
									`w32:		//vlseg6e32.v
										begin
											system_vector_o		=	`vlseg6e32_v_system_vector;
											resource_vector_o	=	`vlseg6e32_v_resource_vector;	
											register_vector_o	=	`vlseg6e32_v_register_vector;
											operation_vector_o	=	`vlseg6e32_v_operation_vector;
										end
										
									`w64:		//vlseg6e64.v
										begin
											system_vector_o		=	`vlseg6e64_v_system_vector;
											resource_vector_o	=	`vlseg6e64_v_resource_vector;	
											register_vector_o	=	`vlseg6e64_v_register_vector;
											operation_vector_o	=	`vlseg6e64_v_operation_vector;
										end
									default:
										begin
											system_vector_o		=	`system_vector_default;
											resource_vector_o	=	`resource_vector_default;
											register_vector_o	=	`register_vector_default;
											operation_vector_o	=	`operation_vector_default;
										end	
								endcase
							`nf_7:
								case (instruction_i[`funct3_width])
									`w8:		//vlseg7e8.v
										begin
											system_vector_o		=	`vlseg7e8_v_system_vector;
											resource_vector_o	=	`vlseg7e8_v_resource_vector;	
											register_vector_o	=	`vlseg7e8_v_register_vector;
											operation_vector_o	=	`vlseg7e8_v_operation_vector;
										end
										
									`w16:		//vlseg7e16.v
										begin
											system_vector_o		=	`vlseg7e16_v_system_vector;
											resource_vector_o	=	`vlseg7e16_v_resource_vector;	
											register_vector_o	=	`vlseg7e16_v_register_vector;
											operation_vector_o	=	`vlseg7e16_v_operation_vector;
										end
										
									`w32:		//vlseg7e32.v
										begin
											system_vector_o		=	`vlseg7e32_v_system_vector;
											resource_vector_o	=	`vlseg7e32_v_resource_vector;	
											register_vector_o	=	`vlseg7e32_v_register_vector;
											operation_vector_o	=	`vlseg7e32_v_operation_vector;
										end
										
									`w64:		//vlseg7e64.v
										begin
											system_vector_o		=	`vlseg7e64_v_system_vector;
											resource_vector_o	=	`vlseg7e64_v_resource_vector;	
											register_vector_o	=	`vlseg7e64_v_register_vector;
											operation_vector_o	=	`vlseg7e64_v_operation_vector;
										end
									default:
										begin
											system_vector_o		=	`system_vector_default;
											resource_vector_o	=	`resource_vector_default;
											register_vector_o	=	`register_vector_default;
											operation_vector_o	=	`operation_vector_default;
										end	
								endcase
							`nf_8:
								case (instruction_i[`funct3_width])
									`w8:		//vlseg8e8.v
										begin
											system_vector_o		=	`vlseg8e8_v_system_vector;
											resource_vector_o	=	`vlseg8e8_v_resource_vector;	
											register_vector_o	=	`vlseg8e8_v_register_vector;
											operation_vector_o	=	`vlseg8e8_v_operation_vector;
										end
										
									`w16:		//vlseg8e16.v
										begin
											system_vector_o		=	`vlseg8e16_v_system_vector;
											resource_vector_o	=	`vlseg8e16_v_resource_vector;	
											register_vector_o	=	`vlseg8e16_v_register_vector;
											operation_vector_o	=	`vlseg8e16_v_operation_vector;
										end
										
									`w32:		//vlseg8e32.v
										begin
											system_vector_o		=	`vlseg8e32_v_system_vector;
											resource_vector_o	=	`vlseg8e32_v_resource_vector;	
											register_vector_o	=	`vlseg8e32_v_register_vector;
											operation_vector_o	=	`vlseg8e32_v_operation_vector;
										end
										
									`w64:		//vlseg8e64.v
										begin
											system_vector_o		=	`vlseg8e64_v_system_vector;
											resource_vector_o	=	`vlseg8e64_v_resource_vector;	
											register_vector_o	=	`vlseg8e64_v_register_vector;
											operation_vector_o	=	`vlseg8e64_v_operation_vector;
										end
									default:
										begin
											system_vector_o		=	`system_vector_default;
											resource_vector_o	=	`resource_vector_default;
											register_vector_o	=	`register_vector_default;
											operation_vector_o	=	`operation_vector_default;
										end	
								endcase
							default:
								begin
									system_vector_o		=	`system_vector_default;
									resource_vector_o	=	`resource_vector_default;
									register_vector_o	=	`register_vector_default;
									operation_vector_o	=	`operation_vector_default;
								end
						endcase
					else		//Strided Load
						case	(instruction_i[`funct3_width])
							`w8:		//vlse8.v, vlseg1e8.v
								begin
									system_vector_o		=	`vlse8_v_system_vector;
									resource_vector_o	=	`vlse8_v_resource_vector;
									register_vector_o	=	`vlse8_v_register_vector;
									operation_vector_o	=	`vlse8_v_operation_vector;
								end
								
							`w16:		//vlse16.v, vlseg1e16.v
								begin
									system_vector_o		=	`vlse16_v_system_vector;
									resource_vector_o	=	`vlse16_v_resource_vector;
									register_vector_o	=	`vlse16_v_register_vector;
									operation_vector_o	=	`vlse16_v_operation_vector;
								end
								
							`w32:		//vlse32.v, vlseg1e32.v
								begin
									system_vector_o		=	`vlse32_v_system_vector;
									resource_vector_o	=	`vlse32_v_resource_vector;
									register_vector_o	=	`vlse32_v_register_vector;
									operation_vector_o	=	`vlse32_v_operation_vector;
								end
								
							`w64:		//vlse64.v, vlseg1e64.v
								begin
									system_vector_o		=	`vlse64_v_system_vector;
									resource_vector_o	=	`vlse64_v_resource_vector;
									register_vector_o	=	`vlse64_v_register_vector;
									operation_vector_o	=	`vlse64_v_operation_vector;
								end
							default:
								begin
									system_vector_o		=	`system_vector_default;
									resource_vector_o	=	`resource_vector_default;
									register_vector_o	=	`register_vector_default;
									operation_vector_o	=	`operation_vector_default;
								end
						endcase 
				default:
				begin
					system_vector_o		=	`system_vector_default;
					resource_vector_o	=	`resource_vector_default;
					register_vector_o	=	`register_vector_default;
					operation_vector_o	=	`operation_vector_default;
				end
			endcase
		`op_store:
			case	(instruction_i[`mop])
				`unit_stride:
					case	(instruction_i[`vs2_sumop_lumop])
						`unit_stride_load_store:
							case	(instruction_i[`nf])
								`nf_1:
									case	(instruction_i[`funct3_width])
										`w8:		//vse8.v	&	vsseg1e8.v
											begin
												system_vector_o		=	`vse8_v_system_vector;
												resource_vector_o	=	`vse8_v_resource_vector;
												register_vector_o	=	`vse8_v_register_vector;
												operation_vector_o	=	`vse8_v_operation_vector;
											end
										`w16:		//vse16.v	&	vsseg1e16.v
											begin
												system_vector_o		=	`vse16_v_system_vector;
												resource_vector_o	=	`vse16_v_resource_vector;
												register_vector_o	=	`vse16_v_register_vector;
												operation_vector_o	=	`vse16_v_operation_vector;
											end
										`w32:		//vse32.v	&	vsseg1e32.v
											begin
												system_vector_o		=	`vse32_v_system_vector;
												resource_vector_o	=	`vse32_v_resource_vector;
												register_vector_o	=	`vse32_v_register_vector;
												operation_vector_o	=	`vse32_v_operation_vector;
											end
										`w64:		//vse64.v	&	vsseg1e64.v
											begin
												system_vector_o		=	`vse64_v_system_vector;
												resource_vector_o	=	`vse64_v_resource_vector;
												register_vector_o	=	`vse64_v_register_vector;
												operation_vector_o	=	`vse64_v_operation_vector;
											end
										default:
											begin
												system_vector_o		=	`system_vector_default;
												resource_vector_o	=	`resource_vector_default;
												register_vector_o	=	`register_vector_default;
												operation_vector_o	=	`operation_vector_default;
											end
									endcase
									
								`nf_2:
									case	(instruction_i[`funct3_width])
										`w8:		//vsseg2e8.v
											begin
												system_vector_o		=	`vsseg2e8_v_system_vector;
												resource_vector_o	=	`vsseg2e8_v_resource_vector;
												register_vector_o	=	`vsseg2e8_v_register_vector;
												operation_vector_o	=	`vsseg2e8_v_operation_vector;
											end
										`w16:		//vsseg2e16.v
											begin
												system_vector_o		=	`vsseg2e16_v_system_vector;
												resource_vector_o	=	`vsseg2e16_v_resource_vector;
												register_vector_o	=	`vsseg2e16_v_register_vector;
												operation_vector_o	=	`vsseg2e16_v_operation_vector;
											end
										`w32:		//vsseg2e32.v
											begin
												system_vector_o		=	`vsseg2e32_v_system_vector;
												resource_vector_o	=	`vsseg2e32_v_resource_vector;
												register_vector_o	=	`vsseg2e32_v_register_vector;
												operation_vector_o	=	`vsseg2e32_v_operation_vector;
											end
										`w64:		//vsseg2e64.v
											begin
												system_vector_o		=	`vsseg2e64_v_system_vector;
												resource_vector_o	=	`vsseg2e64_v_resource_vector;
												register_vector_o	=	`vsseg2e64_v_register_vector;
												operation_vector_o	=	`vsseg2e64_v_operation_vector;
											end
										default:
											begin
												system_vector_o		=	`system_vector_default;
												resource_vector_o	=	`resource_vector_default;
												register_vector_o	=	`register_vector_default;
												operation_vector_o	=	`operation_vector_default;
											end
									endcase
									
								`nf_3:
									case	(instruction_i[`funct3_width])
										`w8:		//vsseg3e8.v
											begin
												system_vector_o		=	`vsseg3e8_v_system_vector;
												resource_vector_o	=	`vsseg3e8_v_resource_vector;
												register_vector_o	=	`vsseg3e8_v_register_vector;
												operation_vector_o	=	`vsseg3e8_v_operation_vector;
											end
										`w16:		//vsseg3e16.v
											begin
												system_vector_o		=	`vsseg3e16_v_system_vector;
												resource_vector_o	=	`vsseg3e16_v_resource_vector;
												register_vector_o	=	`vsseg3e16_v_register_vector;
												operation_vector_o	=	`vsseg3e16_v_operation_vector;
											end
										`w32:		//vsseg3e32.v
											begin
												system_vector_o		=	`vsseg3e32_v_system_vector;
												resource_vector_o	=	`vsseg3e32_v_resource_vector;
												register_vector_o	=	`vsseg3e32_v_register_vector;
												operation_vector_o	=	`vsseg3e32_v_operation_vector;
											end
										`w64:		//vsseg3e64.v
											begin
												system_vector_o		=	`vsseg3e64_v_system_vector;
												resource_vector_o	=	`vsseg3e64_v_resource_vector;
												register_vector_o	=	`vsseg3e64_v_register_vector;
												operation_vector_o	=	`vsseg3e64_v_operation_vector;
											end
										default:
											begin
												system_vector_o		=	`system_vector_default;
												resource_vector_o	=	`resource_vector_default;
												register_vector_o	=	`register_vector_default;
												operation_vector_o	=	`operation_vector_default;
											end
									endcase
									
								`nf_4:
									case	(instruction_i[`funct3_width])
										`w8:		//vsseg4e8.v
											begin
												system_vector_o		=	`vsseg4e8_v_system_vector;
												resource_vector_o	=	`vsseg4e8_v_resource_vector;
												register_vector_o	=	`vsseg4e8_v_register_vector;
												operation_vector_o	=	`vsseg4e8_v_operation_vector;
											end
										`w16:		//vsseg4e16.v
											begin
												system_vector_o		=	`vsseg4e16_v_system_vector;
												resource_vector_o	=	`vsseg4e16_v_resource_vector;
												register_vector_o	=	`vsseg4e16_v_register_vector;
												operation_vector_o	=	`vsseg4e16_v_operation_vector;
											end
										`w32:		//vsseg4e32.v
											begin
												system_vector_o		=	`vsseg4e32_v_system_vector;
												resource_vector_o	=	`vsseg4e32_v_resource_vector;
												register_vector_o	=	`vsseg4e32_v_register_vector;
												operation_vector_o	=	`vsseg4e32_v_operation_vector;
											end
										`w64:		//vsseg4e64.v
											begin
												system_vector_o		=	`vsseg4e64_v_system_vector;
												resource_vector_o	=	`vsseg4e64_v_resource_vector;
												register_vector_o	=	`vsseg4e64_v_register_vector;
												operation_vector_o	=	`vsseg4e64_v_operation_vector;
											end
										default:
											begin
												system_vector_o		=	`system_vector_default;
												resource_vector_o	=	`resource_vector_default;
												register_vector_o	=	`register_vector_default;
												operation_vector_o	=	`operation_vector_default;
											end
									endcase
								
								`nf_5:
									case	(instruction_i[`funct3_width])
										`w8:		//vsseg5e8.v
											begin
												system_vector_o		=	`vsseg5e8_v_system_vector;
												resource_vector_o	=	`vsseg5e8_v_resource_vector;
												register_vector_o	=	`vsseg5e8_v_register_vector;
												operation_vector_o	=	`vsseg5e8_v_operation_vector;
											end
										`w16:		//vsseg5e16.v
											begin
												system_vector_o		=	`vsseg5e16_v_system_vector;
												resource_vector_o	=	`vsseg5e16_v_resource_vector;
												register_vector_o	=	`vsseg5e16_v_register_vector;
												operation_vector_o	=	`vsseg5e16_v_operation_vector;
											end
										`w32:		//vsseg5e32.v
											begin
												system_vector_o		=	`vsseg5e32_v_system_vector;
												resource_vector_o	=	`vsseg5e32_v_resource_vector;
												register_vector_o	=	`vsseg5e32_v_register_vector;
												operation_vector_o	=	`vsseg5e32_v_operation_vector;
											end
										`w64:		//vsseg5e64.v
											begin
												system_vector_o		=	`vsseg5e64_v_system_vector;
												resource_vector_o	=	`vsseg5e64_v_resource_vector;
												register_vector_o	=	`vsseg5e64_v_register_vector;
												operation_vector_o	=	`vsseg5e64_v_operation_vector;
											end
										default:
											begin
												system_vector_o		=	`system_vector_default;
												resource_vector_o	=	`resource_vector_default;
												register_vector_o	=	`register_vector_default;
												operation_vector_o	=	`operation_vector_default;
											end
									endcase
									
								`nf_6:
									case	(instruction_i[`funct3_width])
										`w8:		//vsseg6e8.v
											begin
												system_vector_o		=	`vsseg6e8_v_system_vector;
												resource_vector_o	=	`vsseg6e8_v_resource_vector;
												register_vector_o	=	`vsseg6e8_v_register_vector;
												operation_vector_o	=	`vsseg6e8_v_operation_vector;
											end
										`w16:		//vsseg6e16.v
											begin
												system_vector_o		=	`vsseg6e16_v_system_vector;
												resource_vector_o	=	`vsseg6e16_v_resource_vector;
												register_vector_o	=	`vsseg6e16_v_register_vector;
												operation_vector_o	=	`vsseg6e16_v_operation_vector;
											end
										`w32:		//vsseg6e32.v
											begin
												system_vector_o		=	`vsseg6e32_v_system_vector;
												resource_vector_o	=	`vsseg6e32_v_resource_vector;
												register_vector_o	=	`vsseg6e32_v_register_vector;
												operation_vector_o	=	`vsseg6e32_v_operation_vector;
											end
										`w64:		//vsseg6e64.v
											begin
												system_vector_o		=	`vsseg6e64_v_system_vector;
												resource_vector_o	=	`vsseg6e64_v_resource_vector;
												register_vector_o	=	`vsseg6e64_v_register_vector;
												operation_vector_o	=	`vsseg6e64_v_operation_vector;
											end
										default:
											begin
												system_vector_o		=	`system_vector_default;
												resource_vector_o	=	`resource_vector_default;
												register_vector_o	=	`register_vector_default;
												operation_vector_o	=	`operation_vector_default;
											end
									endcase
									
								`nf_7:
									case	(instruction_i[`funct3_width])
										`w8:		//vsseg7e8.v
											begin
												system_vector_o		=	`vsseg7e8_v_system_vector;
												resource_vector_o	=	`vsseg7e8_v_resource_vector;
												register_vector_o	=	`vsseg7e8_v_register_vector;
												operation_vector_o	=	`vsseg7e8_v_operation_vector;
											end
										`w16:		//vsseg7e16.v
											begin
												system_vector_o		=	`vsseg7e16_v_system_vector;
												resource_vector_o	=	`vsseg7e16_v_resource_vector;
												register_vector_o	=	`vsseg7e16_v_register_vector;
												operation_vector_o	=	`vsseg7e16_v_operation_vector;
											end
										`w32:		//vsseg7e32.v
											begin
												system_vector_o		=	`vsseg7e32_v_system_vector;
												resource_vector_o	=	`vsseg7e32_v_resource_vector;
												register_vector_o	=	`vsseg7e32_v_register_vector;
												operation_vector_o	=	`vsseg7e32_v_operation_vector;
											end
										`w64:		//vsseg7e64.v
											begin
												system_vector_o		=	`vsseg7e64_v_system_vector;
												resource_vector_o	=	`vsseg7e64_v_resource_vector;
												register_vector_o	=	`vsseg7e64_v_register_vector;
												operation_vector_o	=	`vsseg7e64_v_operation_vector;
											end
										default:
											begin
												system_vector_o		=	`system_vector_default;
												resource_vector_o	=	`resource_vector_default;
												register_vector_o	=	`register_vector_default;
												operation_vector_o	=	`operation_vector_default;
											end
									endcase
									
								`nf_8:
									case	(instruction_i[`funct3_width])
										`w8:		//vsseg8e8.v
											begin
												system_vector_o		=	`vsseg8e8_v_system_vector;
												resource_vector_o	=	`vsseg8e8_v_resource_vector;
												register_vector_o	=	`vsseg8e8_v_register_vector;
												operation_vector_o	=	`vsseg8e8_v_operation_vector;
											end
										`w16:		//vsseg8e16.v
											begin
												system_vector_o		=	`vsseg8e16_v_system_vector;
												resource_vector_o	=	`vsseg8e16_v_resource_vector;
												register_vector_o	=	`vsseg8e16_v_register_vector;
												operation_vector_o	=	`vsseg8e16_v_operation_vector;
											end
										`w32:		//vsseg8e32.v
											begin
												system_vector_o		=	`vsseg8e32_v_system_vector;
												resource_vector_o	=	`vsseg8e32_v_resource_vector;
												register_vector_o	=	`vsseg8e32_v_register_vector;
												operation_vector_o	=	`vsseg8e32_v_operation_vector;
											end
										`w64:		//vsseg8e64.v
											begin
												system_vector_o		=	`vsseg8e64_v_system_vector;
												resource_vector_o	=	`vsseg8e64_v_resource_vector;
												register_vector_o	=	`vsseg8e64_v_register_vector;
												operation_vector_o	=	`vsseg8e64_v_operation_vector;
											end
										default:
											begin
												system_vector_o		=	`system_vector_default;
												resource_vector_o	=	`resource_vector_default;
												register_vector_o	=	`register_vector_default;
												operation_vector_o	=	`operation_vector_default;
											end
									endcase
								default:
									begin
										system_vector_o		=	`system_vector_default;
										resource_vector_o	=	`resource_vector_default;
										register_vector_o	=	`register_vector_default;
										operation_vector_o	=	`operation_vector_default;
									end
							endcase
						`unit_stride_whole_register_load_store:
							if	(instruction_i[`mew] == 1'b0 && instruction_i[`vm] == 1'b0 && instruction_i[`funct3_width] == 3'b0)
								case	(instruction_i[`nf])
										`nf_1:		//vs1r.v
											begin
												system_vector_o		=	`vs1r_v_system_vector;
												resource_vector_o	=	`vs1r_v_resource_vector;
												register_vector_o	=	`vs1r_v_register_vector;
												operation_vector_o	=	`vs1r_v_operation_vector;
											end
										`nf_2:		//vsseg8e16.v
											begin
												system_vector_o		=	`vs2r_v_system_vector;
												resource_vector_o	=	`vs2r_v_resource_vector;
												register_vector_o	=	`vs2r_v_register_vector;
												operation_vector_o	=	`vs2r_v_operation_vector;
											end
										`nf_4:		//vsseg8e32.v
											begin
												system_vector_o		=	`vs4r_v_system_vector;
												resource_vector_o	=	`vs4r_v_resource_vector;
												register_vector_o	=	`vs4r_v_register_vector;
												operation_vector_o	=	`vs4r_v_operation_vector;
											end
										`nf_8:		//vsseg8e64.v
											begin
												system_vector_o		=	`vs8r_v_system_vector;
												resource_vector_o	=	`vs8r_v_resource_vector;
												register_vector_o	=	`vs8r_v_register_vector;
												operation_vector_o	=	`vs8r_v_operation_vector;
											end
										default:
											begin
												system_vector_o		=	`system_vector_default;
												resource_vector_o	=	`resource_vector_default;
												register_vector_o	=	`register_vector_default;
												operation_vector_o	=	`operation_vector_default;
											end
									endcase
							else
										begin
											system_vector_o		=	`system_vector_default;
											resource_vector_o	=	`resource_vector_default;
											register_vector_o	=	`register_vector_default;
											operation_vector_o	=	`operation_vector_default;
										end
						`unit_stride_mask_load_store:
							if(instruction_i[`funct3_width] == 4'b1000 &&	instruction_i[`vm] == 1'b1)
								begin
									system_vector_o		=	`vsm_v_system_vector;
									resource_vector_o	=	`vsm_v_resource_vector;
									register_vector_o	=	`vsm_v_register_vector;
									operation_vector_o	=	`vsm_v_operation_vector;
								end
							else
								begin
									system_vector_o		=	`system_vector_default;
									resource_vector_o	=	`resource_vector_default;
									register_vector_o	=	`register_vector_default;
									operation_vector_o	=	`operation_vector_default;
								end
						default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
					endcase
				`indexed_unordered:
					if	(instruction_i[`nf]	>	0)
						case	(instruction_i[`nf])
							`nf_2:
								case	(instruction_i[`funct3_width])
									`w8:	//vsuxseg2ei8.v
									begin
										system_vector_o		=	`vsuxseg2ei8_v_system_vector;
										resource_vector_o	=	`vsuxseg2ei8_v_resource_vector;
										register_vector_o	=	`vsuxseg2ei8_v_register_vector;
										operation_vector_o	=	`vsuxseg2ei8_v_operation_vector;
									end
									`w16:	//vsuxseg2ei16.v
									begin
										system_vector_o		=	`vsuxseg2ei16_v_system_vector;
										resource_vector_o	=	`vsuxseg2ei16_v_resource_vector;
										register_vector_o	=	`vsuxseg2ei16_v_register_vector;
										operation_vector_o	=	`vsuxseg2ei16_v_operation_vector;
									end
									`w32:	//vsuxseg2ei32.v
									begin
										system_vector_o		=	`vsuxseg2ei32_v_system_vector;
										resource_vector_o	=	`vsuxseg2ei32_v_resource_vector;
										register_vector_o	=	`vsuxseg2ei32_v_register_vector;
										operation_vector_o	=	`vsuxseg2ei32_v_operation_vector;
									end
									`w64:	//vsuxseg2ei64.v
									begin
										system_vector_o		=	`vsuxseg2ei64_v_system_vector;
										resource_vector_o	=	`vsuxseg2ei64_v_resource_vector;
										register_vector_o	=	`vsuxseg2ei64_v_register_vector;
										operation_vector_o	=	`vsuxseg2ei64_v_operation_vector;
									end
									default:
									begin
										system_vector_o		=	`system_vector_default;
										resource_vector_o	=	`resource_vector_default;
										register_vector_o	=	`register_vector_default;
										operation_vector_o	=	`operation_vector_default;
									end
								endcase
							`nf_3:
								case	(instruction_i[`funct3_width])
									`w8:	//vsuxseg3ei8.v
									begin
										system_vector_o		=	`vsuxseg3ei8_v_system_vector;
										resource_vector_o	=	`vsuxseg3ei8_v_resource_vector;
										register_vector_o	=	`vsuxseg3ei8_v_register_vector;
										operation_vector_o	=	`vsuxseg3ei8_v_operation_vector;
									end
									`w16:	//vsuxseg3ei16.v
									begin
										system_vector_o		=	`vsuxseg3ei16_v_system_vector;
										resource_vector_o	=	`vsuxseg3ei16_v_resource_vector;
										register_vector_o	=	`vsuxseg3ei16_v_register_vector;
										operation_vector_o	=	`vsuxseg3ei16_v_operation_vector;
									end
									`w32:	//vsuxseg3ei32.v
									begin
										system_vector_o		=	`vsuxseg3ei32_v_system_vector;
										resource_vector_o	=	`vsuxseg3ei32_v_resource_vector;
										register_vector_o	=	`vsuxseg3ei32_v_register_vector;
										operation_vector_o	=	`vsuxseg3ei32_v_operation_vector;
									end
									`w64:	//vsuxseg3i64.v
									begin
										system_vector_o		=	`vsuxseg3ei64_v_system_vector;
										resource_vector_o	=	`vsuxseg3ei64_v_resource_vector;
										register_vector_o	=	`vsuxseg3ei64_v_register_vector;
										operation_vector_o	=	`vsuxseg3ei64_v_operation_vector;
									end
									default:
									begin
										system_vector_o		=	`system_vector_default;
										resource_vector_o	=	`resource_vector_default;
										register_vector_o	=	`register_vector_default;
										operation_vector_o	=	`operation_vector_default;
									end
								endcase
							`nf_4:
								case	(instruction_i[`funct3_width])
									`w8:	//vsuxseg4ei8.v
									begin
										system_vector_o		=	`vsuxseg4ei8_v_system_vector;
										resource_vector_o	=	`vsuxseg4ei8_v_resource_vector;
										register_vector_o	=	`vsuxseg4ei8_v_register_vector;
										operation_vector_o	=	`vsuxseg4ei8_v_operation_vector;
									end
									`w16:	//vsuxseg4ei16.v
									begin
										system_vector_o		=	`vsuxseg4ei16_v_system_vector;
										resource_vector_o	=	`vsuxseg4ei16_v_resource_vector;
										register_vector_o	=	`vsuxseg4ei16_v_register_vector;
										operation_vector_o	=	`vsuxseg4ei16_v_operation_vector;
									end
									`w32:	//vsuxseg4i32.v
									begin
										system_vector_o		=	`vsuxseg4ei32_v_system_vector;
										resource_vector_o	=	`vsuxseg4ei32_v_resource_vector;
										register_vector_o	=	`vsuxseg4ei32_v_register_vector;
										operation_vector_o	=	`vsuxseg4ei32_v_operation_vector;
									end
									`w64:	//vsuxseg4ei64.v
									begin
										system_vector_o		=	`vsuxseg4ei64_v_system_vector;
										resource_vector_o	=	`vsuxseg4ei64_v_resource_vector;
										register_vector_o	=	`vsuxseg4ei64_v_register_vector;
										operation_vector_o	=	`vsuxseg4ei64_v_operation_vector;
									end
									default:
									begin
										system_vector_o		=	`system_vector_default;
										resource_vector_o	=	`resource_vector_default;
										register_vector_o	=	`register_vector_default;
										operation_vector_o	=	`operation_vector_default;
									end
								endcase
							`nf_5:
								case	(instruction_i[`funct3_width])
									`w8:	//vsuxseg5ei8.v
									begin
										system_vector_o		=	`vsuxseg5ei8_v_system_vector;
										resource_vector_o	=	`vsuxseg5ei8_v_resource_vector;
										register_vector_o	=	`vsuxseg5ei8_v_register_vector;
										operation_vector_o	=	`vsuxseg5ei8_v_operation_vector;
									end
									`w16:	//vsuxseg5ei16.v
									begin
										system_vector_o		=	`vsuxseg5ei16_v_system_vector;
										resource_vector_o	=	`vsuxseg5ei16_v_resource_vector;
										register_vector_o	=	`vsuxseg5ei16_v_register_vector;
										operation_vector_o	=	`vsuxseg5ei16_v_operation_vector;
									end
									`w32:	//vsuxseg5ei32.v
									begin
										system_vector_o		=	`vsuxseg5ei32_v_system_vector;
										resource_vector_o	=	`vsuxseg5ei32_v_resource_vector;
										register_vector_o	=	`vsuxseg5ei32_v_register_vector;
										operation_vector_o	=	`vsuxseg5ei32_v_operation_vector;
									end
									`w64:	//vsuxseg5ei64.v
									begin
										system_vector_o		=	`vsuxseg5ei64_v_system_vector;
										resource_vector_o	=	`vsuxseg5ei64_v_resource_vector;
										register_vector_o	=	`vsuxseg5ei64_v_register_vector;
										operation_vector_o	=	`vsuxseg5ei64_v_operation_vector;
									end
									default:
									begin
										system_vector_o		=	`system_vector_default;
										resource_vector_o	=	`resource_vector_default;
										register_vector_o	=	`register_vector_default;
										operation_vector_o	=	`operation_vector_default;
									end
								endcase
							`nf_6:
								case	(instruction_i[`funct3_width])
									`w8:	//vsuxseg6ei8.v
									begin
										system_vector_o		=	`vsuxseg6ei8_v_system_vector;
										resource_vector_o	=	`vsuxseg6ei8_v_resource_vector;
										register_vector_o	=	`vsuxseg6ei8_v_register_vector;
										operation_vector_o	=	`vsuxseg6ei8_v_operation_vector;
									end
									`w16:	//vsuxseg6ei16.v
									begin
										system_vector_o		=	`vsuxseg6ei16_v_system_vector;
										resource_vector_o	=	`vsuxseg6ei16_v_resource_vector;
										register_vector_o	=	`vsuxseg6ei16_v_register_vector;
										operation_vector_o	=	`vsuxseg6ei16_v_operation_vector;
									end
									`w32:	//vsuxseg6ei32.v
									begin
										system_vector_o		=	`vsuxseg6ei32_v_system_vector;
										resource_vector_o	=	`vsuxseg6ei32_v_resource_vector;
										register_vector_o	=	`vsuxseg6ei32_v_register_vector;
										operation_vector_o	=	`vsuxseg6ei32_v_operation_vector;
									end
									`w64:	//vsuxseg6ei64.v
									begin
										system_vector_o		=	`vsuxseg6ei64_v_system_vector;
										resource_vector_o	=	`vsuxseg6ei64_v_resource_vector;
										register_vector_o	=	`vsuxseg6ei64_v_register_vector;
										operation_vector_o	=	`vsuxseg6ei64_v_operation_vector;
									end
									default:
									begin
										system_vector_o		=	`system_vector_default;
										resource_vector_o	=	`resource_vector_default;
										register_vector_o	=	`register_vector_default;
										operation_vector_o	=	`operation_vector_default;
									end
								endcase
							`nf_7:
								case	(instruction_i[`funct3_width])
									`w8:	//vsuxseg7ei8.v
									begin
										system_vector_o		=	`vsuxseg7ei8_v_system_vector;
										resource_vector_o	=	`vsuxseg7ei8_v_resource_vector;
										register_vector_o	=	`vsuxseg7ei8_v_register_vector;
										operation_vector_o	=	`vsuxseg7ei8_v_operation_vector;
									end
									`w16:	//vsuxseg7ei16.v
									begin
										system_vector_o		=	`vsuxseg7ei16_v_system_vector;
										resource_vector_o	=	`vsuxseg7ei16_v_resource_vector;
										register_vector_o	=	`vsuxseg7ei16_v_register_vector;
										operation_vector_o	=	`vsuxseg7ei16_v_operation_vector;
									end
									`w32:	//vsuxseg7ei32.v
									begin
										system_vector_o		=	`vsuxseg7ei32_v_system_vector;
										resource_vector_o	=	`vsuxseg7ei32_v_resource_vector;
										register_vector_o	=	`vsuxseg7ei32_v_register_vector;
										operation_vector_o	=	`vsuxseg7ei32_v_operation_vector;
									end
									`w64:	//vsuxseg7ei64.v
									begin
										system_vector_o		=	`vsuxseg7ei64_v_system_vector;
										resource_vector_o	=	`vsuxseg7ei64_v_resource_vector;
										register_vector_o	=	`vsuxseg7ei64_v_register_vector;
										operation_vector_o	=	`vsuxseg7ei64_v_operation_vector;
									end
									default:
									begin
										system_vector_o		=	`system_vector_default;
										resource_vector_o	=	`resource_vector_default;
										register_vector_o	=	`register_vector_default;
										operation_vector_o	=	`operation_vector_default;
									end
								endcase
							`nf_8:
								case	(instruction_i[`funct3_width])
									`w8:	//vsuxseg8ei8.v
									begin
										system_vector_o		=	`vsuxseg8ei8_v_system_vector;
										resource_vector_o	=	`vsuxseg8ei8_v_resource_vector;
										register_vector_o	=	`vsuxseg8ei8_v_register_vector;
										operation_vector_o	=	`vsuxseg8ei8_v_operation_vector;
									end
									`w16:	//vsuxseg8ei16.v
									begin
										system_vector_o		=	`vsuxseg8ei16_v_system_vector;
										resource_vector_o	=	`vsuxseg8ei16_v_resource_vector;
										register_vector_o	=	`vsuxseg8ei16_v_register_vector;
										operation_vector_o	=	`vsuxseg8ei16_v_operation_vector;
									end
									`w32:	//vsuxseg8ei32.v
									begin
										system_vector_o		=	`vsuxseg8ei32_v_system_vector;
										resource_vector_o	=	`vsuxseg8ei32_v_resource_vector;
										register_vector_o	=	`vsuxseg8ei32_v_register_vector;
										operation_vector_o	=	`vsuxseg8ei32_v_operation_vector;
									end
									`w64:	//vsuxseg8ei64.v
									begin
										system_vector_o		=	`vsuxseg8ei64_v_system_vector;
										resource_vector_o	=	`vsuxseg8ei64_v_resource_vector;
										register_vector_o	=	`vsuxseg8ei64_v_register_vector;
										operation_vector_o	=	`vsuxseg8ei64_v_operation_vector;
									end
									default:
									begin
										system_vector_o		=	`system_vector_default;
										resource_vector_o	=	`resource_vector_default;
										register_vector_o	=	`register_vector_default;
										operation_vector_o	=	`operation_vector_default;
									end
								endcase
							default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
						endcase
					else
						case	(instruction_i[`funct3_width])
							`w8:	//vsuxei8.v	,	vsuxseg1ei8.v
							begin
								system_vector_o		=	`vsuxei8_v_system_vector;
								resource_vector_o	=	`vsuxei8_v_resource_vector;
								register_vector_o	=	`vsuxei8_v_register_vector;
								operation_vector_o	=	`vsuxei8_v_operation_vector;
							end
							`w16:	//vsuxei16.v,	vsuxseg1ei16.v
							begin
								system_vector_o		=	`vsuxei16_v_system_vector;
								resource_vector_o	=	`vsuxei16_v_resource_vector;
								register_vector_o	=	`vsuxei16_v_register_vector;
								operation_vector_o	=	`vsuxei16_v_operation_vector;
							end
							`w32:	//vsuxei32.v,	vsuxseg1ei32.v
							begin
								system_vector_o		=	`vsuxei32_v_system_vector;
								resource_vector_o	=	`vsuxei32_v_resource_vector;
								register_vector_o	=	`vsuxei32_v_register_vector;
								operation_vector_o	=	`vsuxei32_v_operation_vector;
							end
							`w64:	//vsuxei64.v,	vsuxseg1ei64.v
							begin
								system_vector_o		=	`vsuxei64_v_system_vector;
								resource_vector_o	=	`vsuxei64_v_resource_vector;
								register_vector_o	=	`vsuxei64_v_register_vector;
								operation_vector_o	=	`vsuxei64_v_operation_vector;
							end
							default:
								begin
									system_vector_o		=	`system_vector_default;
									resource_vector_o	=	`resource_vector_default;
									register_vector_o	=	`register_vector_default;
									operation_vector_o	=	`operation_vector_default;
								end
						endcase
				`indexed_ordered:
					if	(instruction_i[`nf]	>	0)
						case	(instruction_i[`nf])
							`nf_2:
								case	(instruction_i[`funct3_width])
									`w8:	//vsoxseg2ei8.v
									begin
										system_vector_o		=	`vsoxseg2ei8_v_system_vector;
										resource_vector_o	=	`vsoxseg2ei8_v_resource_vector;
										register_vector_o	=	`vsoxseg2ei8_v_register_vector;
										operation_vector_o	=	`vsoxseg2ei8_v_operation_vector;
									end
									`w16:	//vsoxseg2ei16.v
									begin
										system_vector_o		=	`vsoxseg2ei16_v_system_vector;
										resource_vector_o	=	`vsoxseg2ei16_v_resource_vector;
										register_vector_o	=	`vsoxseg2ei16_v_register_vector;
										operation_vector_o	=	`vsoxseg2ei16_v_operation_vector;
									end
									`w32:	//vsoxseg2ei32.v
									begin
										system_vector_o		=	`vsoxseg2ei32_v_system_vector;
										resource_vector_o	=	`vsoxseg2ei32_v_resource_vector;
										register_vector_o	=	`vsoxseg2ei32_v_register_vector;
										operation_vector_o	=	`vsoxseg2ei32_v_operation_vector;
									end
									`w64:	//vsoxseg2ei64.v
									begin
										system_vector_o		=	`vsoxseg2ei64_v_system_vector;
										resource_vector_o	=	`vsoxseg2ei64_v_resource_vector;
										register_vector_o	=	`vsoxseg2ei64_v_register_vector;
										operation_vector_o	=	`vsoxseg2ei64_v_operation_vector;
									end
									default:
									begin
										system_vector_o		=	`system_vector_default;
										resource_vector_o	=	`resource_vector_default;
										register_vector_o	=	`register_vector_default;
										operation_vector_o	=	`operation_vector_default;
									end
								endcase
							`nf_3:
								case	(instruction_i[`funct3_width])
									`w8:	//vsoxseg3ei8.v
									begin
										system_vector_o		=	`vsoxseg3ei8_v_system_vector;
										resource_vector_o	=	`vsoxseg3ei8_v_resource_vector;
										register_vector_o	=	`vsoxseg3ei8_v_register_vector;
										operation_vector_o	=	`vsoxseg3ei8_v_operation_vector;
									end
									`w16:	//vsoxseg3ei16.v
									begin
										system_vector_o		=	`vsoxseg3ei16_v_system_vector;
										resource_vector_o	=	`vsoxseg3ei16_v_resource_vector;
										register_vector_o	=	`vsoxseg3ei16_v_register_vector;
										operation_vector_o	=	`vsoxseg3ei16_v_operation_vector;
									end
									`w32:	//vsoxseg3ei32.v
									begin
										system_vector_o		=	`vsoxseg3ei32_v_system_vector;
										resource_vector_o	=	`vsoxseg3ei32_v_resource_vector;
										register_vector_o	=	`vsoxseg3ei32_v_register_vector;
										operation_vector_o	=	`vsoxseg3ei32_v_operation_vector;
									end
									`w64:	//vsoxseg3i64.v
									begin
										system_vector_o		=	`vsoxseg3ei64_v_system_vector;
										resource_vector_o	=	`vsoxseg3ei64_v_resource_vector;
										register_vector_o	=	`vsoxseg3ei64_v_register_vector;
										operation_vector_o	=	`vsoxseg3ei64_v_operation_vector;
									end
									default:
									begin
										system_vector_o		=	`system_vector_default;
										resource_vector_o	=	`resource_vector_default;
										register_vector_o	=	`register_vector_default;
										operation_vector_o	=	`operation_vector_default;
									end
								endcase
							`nf_4:
								case	(instruction_i[`funct3_width])
									`w8:	//vsoxseg4ei8.v
									begin
										system_vector_o		=	`vsoxseg4ei8_v_system_vector;
										resource_vector_o	=	`vsoxseg4ei8_v_resource_vector;
										register_vector_o	=	`vsoxseg4ei8_v_register_vector;
										operation_vector_o	=	`vsoxseg4ei8_v_operation_vector;
									end
									`w16:	//vsoxseg4ei16.v
									begin
										system_vector_o		=	`vsoxseg4ei16_v_system_vector;
										resource_vector_o	=	`vsoxseg4ei16_v_resource_vector;
										register_vector_o	=	`vsoxseg4ei16_v_register_vector;
										operation_vector_o	=	`vsoxseg4ei16_v_operation_vector;
									end
									`w32:	//vsoxseg4i32.v
									begin
										system_vector_o		=	`vsoxseg4ei32_v_system_vector;
										resource_vector_o	=	`vsoxseg4ei32_v_resource_vector;
										register_vector_o	=	`vsoxseg4ei32_v_register_vector;
										operation_vector_o	=	`vsoxseg4ei32_v_operation_vector;
									end
									`w64:	//vsoxseg4ei64.v
									begin
										system_vector_o		=	`vsoxseg4ei64_v_system_vector;
										resource_vector_o	=	`vsoxseg4ei64_v_resource_vector;
										register_vector_o	=	`vsoxseg4ei64_v_register_vector;
										operation_vector_o	=	`vsoxseg4ei64_v_operation_vector;
									end
									default:
									begin
										system_vector_o		=	`system_vector_default;
										resource_vector_o	=	`resource_vector_default;
										register_vector_o	=	`register_vector_default;
										operation_vector_o	=	`operation_vector_default;
									end
								endcase
							`nf_5:
								case	(instruction_i[`funct3_width])
									`w8:	//vsoxseg5ei8.v
									begin
										system_vector_o		=	`vsoxseg5ei8_v_system_vector;
										resource_vector_o	=	`vsoxseg5ei8_v_resource_vector;
										register_vector_o	=	`vsoxseg5ei8_v_register_vector;
										operation_vector_o	=	`vsoxseg5ei8_v_operation_vector;
									end
									`w16:	//vsoxseg5ei16.v
									begin
										system_vector_o		=	`vsoxseg5ei16_v_system_vector;
										resource_vector_o	=	`vsoxseg5ei16_v_resource_vector;
										register_vector_o	=	`vsoxseg5ei16_v_register_vector;
										operation_vector_o	=	`vsoxseg5ei16_v_operation_vector;
									end
									`w32:	//vsoxseg5ei32.v
									begin
										system_vector_o		=	`vsoxseg5ei32_v_system_vector;
										resource_vector_o	=	`vsoxseg5ei32_v_resource_vector;
										register_vector_o	=	`vsoxseg5ei32_v_register_vector;
										operation_vector_o	=	`vsoxseg5ei32_v_operation_vector;
									end
									`w64:	//vsoxseg5ei64.v
									begin
										system_vector_o		=	`vsoxseg5ei64_v_system_vector;
										resource_vector_o	=	`vsoxseg5ei64_v_resource_vector;
										register_vector_o	=	`vsoxseg5ei64_v_register_vector;
										operation_vector_o	=	`vsoxseg5ei64_v_operation_vector;
									end
									default:
									begin
										system_vector_o		=	`system_vector_default;
										resource_vector_o	=	`resource_vector_default;
										register_vector_o	=	`register_vector_default;
										operation_vector_o	=	`operation_vector_default;
									end
								endcase
							`nf_6:
								case	(instruction_i[`funct3_width])
									`w8:	//vsoxseg6ei8.v
									begin
										system_vector_o		=	`vsoxseg6ei8_v_system_vector;
										resource_vector_o	=	`vsoxseg6ei8_v_resource_vector;
										register_vector_o	=	`vsoxseg6ei8_v_register_vector;
										operation_vector_o	=	`vsoxseg6ei8_v_operation_vector;
									end
									`w16:	//vsoxseg6ei16.v
									begin
										system_vector_o		=	`vsoxseg6ei16_v_system_vector;
										resource_vector_o	=	`vsoxseg6ei16_v_resource_vector;
										register_vector_o	=	`vsoxseg6ei16_v_register_vector;
										operation_vector_o	=	`vsoxseg6ei16_v_operation_vector;
									end
									`w32:	//vsoxseg6ei32.v
									begin
										system_vector_o		=	`vsoxseg6ei32_v_system_vector;
										resource_vector_o	=	`vsoxseg6ei32_v_resource_vector;
										register_vector_o	=	`vsoxseg6ei32_v_register_vector;
										operation_vector_o	=	`vsoxseg6ei32_v_operation_vector;
									end
									`w64:	//vsoxseg6ei64.v
									begin
										system_vector_o		=	`vsoxseg6ei64_v_system_vector;
										resource_vector_o	=	`vsoxseg6ei64_v_resource_vector;
										register_vector_o	=	`vsoxseg6ei64_v_register_vector;
										operation_vector_o	=	`vsoxseg6ei64_v_operation_vector;
									end
									default:
									begin
										system_vector_o		=	`system_vector_default;
										resource_vector_o	=	`resource_vector_default;
										register_vector_o	=	`register_vector_default;
										operation_vector_o	=	`operation_vector_default;
									end
								endcase
							`nf_7:
								case	(instruction_i[`funct3_width])
									`w8:	//vsoxseg7ei8.v
									begin
										system_vector_o		=	`vsoxseg7ei8_v_system_vector;
										resource_vector_o	=	`vsoxseg7ei8_v_resource_vector;
										register_vector_o	=	`vsoxseg7ei8_v_register_vector;
										operation_vector_o	=	`vsoxseg7ei8_v_operation_vector;
									end
									`w16:	//vsoxseg7ei16.v
									begin
										system_vector_o		=	`vsoxseg7ei16_v_system_vector;
										resource_vector_o	=	`vsoxseg7ei16_v_resource_vector;
										register_vector_o	=	`vsoxseg7ei16_v_register_vector;
										operation_vector_o	=	`vsoxseg7ei16_v_operation_vector;
									end
									`w32:	//vsoxseg7ei32.v
									begin
										system_vector_o		=	`vsoxseg7ei32_v_system_vector;
										resource_vector_o	=	`vsoxseg7ei32_v_resource_vector;
										register_vector_o	=	`vsoxseg7ei32_v_register_vector;
										operation_vector_o	=	`vsoxseg7ei32_v_operation_vector;
									end
									`w64:	//vsoxseg7ei64.v
									begin
										system_vector_o		=	`vsoxseg7ei64_v_system_vector;
										resource_vector_o	=	`vsoxseg7ei64_v_resource_vector;
										register_vector_o	=	`vsoxseg7ei64_v_register_vector;
										operation_vector_o	=	`vsoxseg7ei64_v_operation_vector;
									end
									default:
									begin
										system_vector_o		=	`system_vector_default;
										resource_vector_o	=	`resource_vector_default;
										register_vector_o	=	`register_vector_default;
										operation_vector_o	=	`operation_vector_default;
									end
								endcase
							`nf_8:
								case	(instruction_i[`funct3_width])
									`w8:	//vsoxseg8ei8.v
									begin
										system_vector_o		=	`vsoxseg8ei8_v_system_vector;
										resource_vector_o	=	`vsoxseg8ei8_v_resource_vector;
										register_vector_o	=	`vsoxseg8ei8_v_register_vector;
										operation_vector_o	=	`vsoxseg8ei8_v_operation_vector;
									end
									`w16:	//vsoxseg8ei16.v
									begin
										system_vector_o		=	`vsoxseg8ei16_v_system_vector;
										resource_vector_o	=	`vsoxseg8ei16_v_resource_vector;
										register_vector_o	=	`vsoxseg8ei16_v_register_vector;
										operation_vector_o	=	`vsoxseg8ei16_v_operation_vector;
									end
									`w32:	//vsoxseg8ei32.v
									begin
										system_vector_o		=	`vsoxseg8ei32_v_system_vector;
										resource_vector_o	=	`vsoxseg8ei32_v_resource_vector;
										register_vector_o	=	`vsoxseg8ei32_v_register_vector;
										operation_vector_o	=	`vsoxseg8ei32_v_operation_vector;
									end
									`w64:	//vsoxseg8ei64.v
									begin
										system_vector_o		=	`vsoxseg8ei64_v_system_vector;
										resource_vector_o	=	`vsoxseg8ei64_v_resource_vector;
										register_vector_o	=	`vsoxseg8ei64_v_register_vector;
										operation_vector_o	=	`vsoxseg8ei64_v_operation_vector;
									end
									default:
									begin
										system_vector_o		=	`system_vector_default;
										resource_vector_o	=	`resource_vector_default;
										register_vector_o	=	`register_vector_default;
										operation_vector_o	=	`operation_vector_default;
									end
								endcase
							default:
							begin
								system_vector_o		=	`system_vector_default;
								resource_vector_o	=	`resource_vector_default;
								register_vector_o	=	`register_vector_default;
								operation_vector_o	=	`operation_vector_default;
							end
						endcase
					else
						case	(instruction_i[`funct3_width])
							`w8:	//vsuxei8.v	,	vsoxseg1ei8.v
							begin
								system_vector_o		=	`vsuxei8_v_system_vector;
								resource_vector_o	=	`vsuxei8_v_resource_vector;
								register_vector_o	=	`vsuxei8_v_register_vector;
								operation_vector_o	=	`vsuxei8_v_operation_vector;
							end
							`w16:	//vsuxei16.v,	vsoxseg1ei16.v
							begin
								system_vector_o		=	`vsuxei16_v_system_vector;
								resource_vector_o	=	`vsuxei16_v_resource_vector;
								register_vector_o	=	`vsuxei16_v_register_vector;
								operation_vector_o	=	`vsuxei16_v_operation_vector;
							end
							`w32:	//vsuxei32.v,	vsoxseg1ei32.v
							begin
								system_vector_o		=	`vsuxei32_v_system_vector;
								resource_vector_o	=	`vsuxei32_v_resource_vector;
								register_vector_o	=	`vsuxei32_v_register_vector;
								operation_vector_o	=	`vsuxei32_v_operation_vector;
							end
							`w64:	//vsuxei64.v,	vsoxseg1ei64.v
							begin
								system_vector_o		=	`vsuxei64_v_system_vector;
								resource_vector_o	=	`vsuxei64_v_resource_vector;
								register_vector_o	=	`vsuxei64_v_register_vector;
								operation_vector_o	=	`vsuxei64_v_operation_vector;
							end
							default:
								begin
									system_vector_o		=	`system_vector_default;
									resource_vector_o	=	`resource_vector_default;
									register_vector_o	=	`register_vector_default;
									operation_vector_o	=	`operation_vector_default;
								end
						endcase
				`strided:
					if(instruction_i[`nf] > 0)		//Segment, Strided Store
						case (instruction_i[`nf])
							`nf_2:	
								case (instruction_i[`funct3_width])
									`w8:		//vsseg2e8.v
										begin
											system_vector_o		=	`vsseg2e8_v_system_vector;
											resource_vector_o	=	`vsseg2e8_v_resource_vector;	
											register_vector_o	=	`vsseg2e8_v_register_vector;
											operation_vector_o	=	`vsseg2e8_v_operation_vector;
										end
										
									`w16:		//vsseg2e16.v
										begin
											system_vector_o		=	`vsseg2e16_v_system_vector;
											resource_vector_o	=	`vsseg2e16_v_resource_vector;	
											register_vector_o	=	`vsseg2e16_v_register_vector;
											operation_vector_o	=	`vsseg2e16_v_operation_vector;
										end
										
									`w32:		//vsseg2e32.v
										begin
											system_vector_o		=	`vsseg2e32_v_system_vector;
											resource_vector_o	=	`vsseg2e32_v_resource_vector;	
											register_vector_o	=	`vsseg2e32_v_register_vector;
											operation_vector_o	=	`vsseg2e32_v_operation_vector;
										end
										
									`w64:		//vsseg2e64.v
										begin
											system_vector_o		=	`vsseg2e64_v_system_vector;
											resource_vector_o	=	`vsseg2e64_v_resource_vector;	
											register_vector_o	=	`vsseg2e64_v_register_vector;
											operation_vector_o	=	`vsseg2e64_v_operation_vector;
										end
									default:
										begin
											system_vector_o		=	`system_vector_default;
											resource_vector_o	=	`resource_vector_default;
											register_vector_o	=	`register_vector_default;
											operation_vector_o	=	`operation_vector_default;
										end	
								endcase
							`nf_3:
								case (instruction_i[`funct3_width])
									`w8:		//vsseg3e8.v
										begin
											system_vector_o		=	`vsseg3e8_v_system_vector;
											resource_vector_o	=	`vsseg3e8_v_resource_vector;	
											register_vector_o	=	`vsseg3e8_v_register_vector;
											operation_vector_o	=	`vsseg3e8_v_operation_vector;
										end
										
									`w16:		//vsseg3e16.v
										begin
											system_vector_o		=	`vsseg3e16_v_system_vector;
											resource_vector_o	=	`vsseg3e16_v_resource_vector;	
											register_vector_o	=	`vsseg3e16_v_register_vector;
											operation_vector_o	=	`vsseg3e16_v_operation_vector;
										end
										
									`w32:		//vsseg3e32.v
										begin
											system_vector_o		=	`vsseg3e32_v_system_vector;
											resource_vector_o	=	`vsseg3e32_v_resource_vector;	
											register_vector_o	=	`vsseg3e32_v_register_vector;
											operation_vector_o	=	`vsseg3e32_v_operation_vector;
										end
										
									`w64:		//vsseg3e64.v
										begin
											system_vector_o		=	`vsseg3e64_v_system_vector;
											resource_vector_o	=	`vsseg3e64_v_resource_vector;	
											register_vector_o	=	`vsseg3e64_v_register_vector;
											operation_vector_o	=	`vsseg3e64_v_operation_vector;
										end
									default:
										begin
											system_vector_o		=	`system_vector_default;
											resource_vector_o	=	`resource_vector_default;
											register_vector_o	=	`register_vector_default;
											operation_vector_o	=	`operation_vector_default;
										end	
								endcase
							`nf_4:
								case (instruction_i[`funct3_width])
									`w8:		//vsseg4e8.v
										begin
											system_vector_o		=	`vsseg4e8_v_system_vector;
											resource_vector_o	=	`vsseg4e8_v_resource_vector;	
											register_vector_o	=	`vsseg4e8_v_register_vector;
											operation_vector_o	=	`vsseg4e8_v_operation_vector;
										end
										
									`w16:		//vsseg4e16.v
										begin
											system_vector_o		=	`vsseg4e16_v_system_vector;
											resource_vector_o	=	`vsseg4e16_v_resource_vector;	
											register_vector_o	=	`vsseg4e16_v_register_vector;
											operation_vector_o	=	`vsseg4e16_v_operation_vector;
										end
										
									`w32:		//vsseg4e32.v
										begin
											system_vector_o		=	`vsseg4e32_v_system_vector;
											resource_vector_o	=	`vsseg4e32_v_resource_vector;	
											register_vector_o	=	`vsseg4e32_v_register_vector;
											operation_vector_o	=	`vsseg4e32_v_operation_vector;
										end
										
									`w64:		//vsseg4e64.v
										begin
											system_vector_o		=	`vsseg4e64_v_system_vector;
											resource_vector_o	=	`vsseg4e64_v_resource_vector;	
											register_vector_o	=	`vsseg4e64_v_register_vector;
											operation_vector_o	=	`vsseg4e64_v_operation_vector;
										end
									default:
										begin
											system_vector_o		=	`system_vector_default;
											resource_vector_o	=	`resource_vector_default;
											register_vector_o	=	`register_vector_default;
											operation_vector_o	=	`operation_vector_default;
										end	
								endcase
							`nf_5:
								case (instruction_i[`funct3_width])
									`w8:		//vsseg5e8.v
										begin
											system_vector_o		=	`vsseg5e8_v_system_vector;
											resource_vector_o	=	`vsseg5e8_v_resource_vector;	
											register_vector_o	=	`vsseg5e8_v_register_vector;
											operation_vector_o	=	`vsseg5e8_v_operation_vector;
										end
										
									`w16:		//vsseg5e16.v
										begin
											system_vector_o		=	`vsseg5e16_v_system_vector;
											resource_vector_o	=	`vsseg5e16_v_resource_vector;	
											register_vector_o	=	`vsseg5e16_v_register_vector;
											operation_vector_o	=	`vsseg5e16_v_operation_vector;
										end
										
									`w32:		//vsseg5e32.v
										begin
											system_vector_o		=	`vsseg5e32_v_system_vector;
											resource_vector_o	=	`vsseg5e32_v_resource_vector;	
											register_vector_o	=	`vsseg5e32_v_register_vector;
											operation_vector_o	=	`vsseg5e32_v_operation_vector;
										end
										
									`w64:		//vsseg5e64.v
										begin
											system_vector_o		=	`vsseg5e64_v_system_vector;
											resource_vector_o	=	`vsseg5e64_v_resource_vector;	
											register_vector_o	=	`vsseg5e64_v_register_vector;
											operation_vector_o	=	`vsseg5e64_v_operation_vector;
										end
									default:
										begin
											system_vector_o		=	`system_vector_default;
											resource_vector_o	=	`resource_vector_default;
											register_vector_o	=	`register_vector_default;
											operation_vector_o	=	`operation_vector_default;
										end	
								endcase
							`nf_6:
								case (instruction_i[`funct3_width])
									`w8:		//vsseg6e8.v
										begin
											system_vector_o		=	`vsseg6e8_v_system_vector;
											resource_vector_o	=	`vsseg6e8_v_resource_vector;	
											register_vector_o	=	`vsseg6e8_v_register_vector;
											operation_vector_o	=	`vsseg6e8_v_operation_vector;
										end
										
									`w16:		//vsseg6e16.v
										begin
											system_vector_o		=	`vsseg6e16_v_system_vector;
											resource_vector_o	=	`vsseg6e16_v_resource_vector;	
											register_vector_o	=	`vsseg6e16_v_register_vector;
											operation_vector_o	=	`vsseg6e16_v_operation_vector;
										end
										
									`w32:		//vsseg6e32.v
										begin
											system_vector_o		=	`vsseg6e32_v_system_vector;
											resource_vector_o	=	`vsseg6e32_v_resource_vector;	
											register_vector_o	=	`vsseg6e32_v_register_vector;
											operation_vector_o	=	`vsseg6e32_v_operation_vector;
										end
										
									`w64:		//vsseg6e64.v
										begin
											system_vector_o		=	`vsseg6e64_v_system_vector;
											resource_vector_o	=	`vsseg6e64_v_resource_vector;	
											register_vector_o	=	`vsseg6e64_v_register_vector;
											operation_vector_o	=	`vsseg6e64_v_operation_vector;
										end
									default:
										begin
											system_vector_o		=	`system_vector_default;
											resource_vector_o	=	`resource_vector_default;
											register_vector_o	=	`register_vector_default;
											operation_vector_o	=	`operation_vector_default;
										end	
								endcase
							`nf_7:
								case (instruction_i[`funct3_width])
									`w8:		//vsseg7e8.v
										begin
											system_vector_o		=	`vsseg7e8_v_system_vector;
											resource_vector_o	=	`vsseg7e8_v_resource_vector;	
											register_vector_o	=	`vsseg7e8_v_register_vector;
											operation_vector_o	=	`vsseg7e8_v_operation_vector;
										end
										
									`w16:		//vsseg7e16.v
										begin
											system_vector_o		=	`vsseg7e16_v_system_vector;
											resource_vector_o	=	`vsseg7e16_v_resource_vector;	
											register_vector_o	=	`vsseg7e16_v_register_vector;
											operation_vector_o	=	`vsseg7e16_v_operation_vector;
										end
										
									`w32:		//vsseg7e32.v
										begin
											system_vector_o		=	`vsseg7e32_v_system_vector;
											resource_vector_o	=	`vsseg7e32_v_resource_vector;	
											register_vector_o	=	`vsseg7e32_v_register_vector;
											operation_vector_o	=	`vsseg7e32_v_operation_vector;
										end
										
									`w64:		//vsseg7e64.v
										begin
											system_vector_o		=	`vsseg7e64_v_system_vector;
											resource_vector_o	=	`vsseg7e64_v_resource_vector;	
											register_vector_o	=	`vsseg7e64_v_register_vector;
											operation_vector_o	=	`vsseg7e64_v_operation_vector;
										end
									default:
										begin
											system_vector_o		=	`system_vector_default;
											resource_vector_o	=	`resource_vector_default;
											register_vector_o	=	`register_vector_default;
											operation_vector_o	=	`operation_vector_default;
										end	
								endcase
							`nf_8:
								case (instruction_i[`funct3_width])
									`w8:		//vsseg8e8.v
										begin
											system_vector_o		=	`vsseg8e8_v_system_vector;
											resource_vector_o	=	`vsseg8e8_v_resource_vector;	
											register_vector_o	=	`vsseg8e8_v_register_vector;
											operation_vector_o	=	`vsseg8e8_v_operation_vector;
										end
										
									`w16:		//vsseg8e16.v
										begin
											system_vector_o		=	`vsseg8e16_v_system_vector;
											resource_vector_o	=	`vsseg8e16_v_resource_vector;	
											register_vector_o	=	`vsseg8e16_v_register_vector;
											operation_vector_o	=	`vsseg8e16_v_operation_vector;
										end
										
									`w32:		//vsseg8e32.v
										begin
											system_vector_o		=	`vsseg8e32_v_system_vector;
											resource_vector_o	=	`vsseg8e32_v_resource_vector;	
											register_vector_o	=	`vsseg8e32_v_register_vector;
											operation_vector_o	=	`vsseg8e32_v_operation_vector;
										end
										
									`w64:		//vsseg8e64.v
										begin
											system_vector_o		=	`vsseg8e64_v_system_vector;
											resource_vector_o	=	`vsseg8e64_v_resource_vector;	
											register_vector_o	=	`vsseg8e64_v_register_vector;
											operation_vector_o	=	`vsseg8e64_v_operation_vector;
										end
									default:
										begin
											system_vector_o		=	`system_vector_default;
											resource_vector_o	=	`resource_vector_default;
											register_vector_o	=	`register_vector_default;
											operation_vector_o	=	`operation_vector_default;
										end	
								endcase
							default:
								begin
									system_vector_o		=	`system_vector_default;
									resource_vector_o	=	`resource_vector_default;
									register_vector_o	=	`register_vector_default;
									operation_vector_o	=	`operation_vector_default;
								end
						endcase
					else							//Strided Store
						case	(instruction_i[`funct3_width])
							`w8:		//vsse8.v, vsseg1e8.v
								begin
									system_vector_o		=	`vsse8_v_system_vector;
									resource_vector_o	=	`vsse8_v_resource_vector;
									register_vector_o	=	`vsse8_v_register_vector;
									operation_vector_o	=	`vsse8_v_operation_vector;
								end
								
							`w16:		//vsse16.v, vsseg1e16.v
								begin
									system_vector_o		=	`vsse16_v_system_vector;
									resource_vector_o	=	`vsse16_v_resource_vector;
									register_vector_o	=	`vsse16_v_register_vector;
									operation_vector_o	=	`vsse16_v_operation_vector;
								end
								
							`w32:		//vsse32.v, vsseg1e32.v
								begin
									system_vector_o		=	`vsse32_v_system_vector;
									resource_vector_o	=	`vsse32_v_resource_vector;
									register_vector_o	=	`vsse32_v_register_vector;
									operation_vector_o	=	`vsse32_v_operation_vector;
								end
								
							`w64:		//vsse64.v, vsseg1e64.v
								begin
									system_vector_o		=	`vsse64_v_system_vector;
									resource_vector_o	=	`vsse64_v_resource_vector;
									register_vector_o	=	`vsse64_v_register_vector;
									operation_vector_o	=	`vsse64_v_operation_vector;
								end
							default:
								begin
									system_vector_o		=	`system_vector_default;
									resource_vector_o	=	`resource_vector_default;
									register_vector_o	=	`register_vector_default;
									operation_vector_o	=	`operation_vector_default;
								end
						endcase 
				default:
					begin
						system_vector_o		=	`system_vector_default;
						resource_vector_o	=	`resource_vector_default;
						register_vector_o	=	`register_vector_default;
						operation_vector_o	=	`operation_vector_default;
					end
			endcase
		default:
			begin
				system_vector_o		=	`system_vector_default;
				resource_vector_o	=	`resource_vector_default;
				register_vector_o	=	`register_vector_default;
				operation_vector_o	=	`operation_vector_default;
			end
	endcase
endmodule
