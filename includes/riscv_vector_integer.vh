// Reference: https://github.com/jdcasanasr/lagarto_v/tree/main/doc

/*	Resource Vectors
		System Vector
			BIT 5 	-> 	Cache Sync Atomic Operation (AMO)
			BIT 4 	-> 	System Operation (SYS)
			BIT 3 	-> 	Halt Operation (HALT)
			BIT 2 	-> 	Memory Sync Fence Operation (FENCE)
			BIT 1 	-> 	Memory Load Operation (L)
			BIT 0 	-> 	Memory Store Operation (S)
			
		Resource Vector
			BIT 21 	-> 	Vector Conversion Unit (VFCONF)
			BIT 20 	-> 	Vector Floating-Point Classification Unit (VFCLASS)
			BIT 19 	-> 	Vector Floating-Point Comparison Unit (VFCMP)
			BIT 18	-> 	Vector Floating Point Square-Root Unit (VFSQRT)
			BIT 17 	-> 	Vector Floating-Point Division Unit (VFDIV)
			BIT 16 	-> 	Vector Floating-Point Multiplication Unit (VFMUL)
			BIT 15 	-> 	Vector Floating-Point Addition Unit (VFADD)
			BIT 14 	-> 	Vector Merge Unit (VMERGE)
			BIT 13 	-> 	Vector Division Unit (VDIV)
			BIT 12 	-> 	Vector Multiplication Unit (VMUL)
			BIT 11 	-> 	Vector Comparison Unit (VCMP)
			BIT 10 	-> 	Vector Shift Unit (VSHFT)
			BIT 9 	-> 	Vector Logic Unit (VLOGIC)
			BIT 8	-> 	Vector Sign/Zero Extension Unit (VSZEXT)
			BIT 7 	-> 	Vector Add Unit (VADD)
			BIT 6 	-> 	Scalar Sign/Zero-Extension Unit (IMM)
			BIT 5 	-> 	Branch Unit (BR)
			BIT 4 	-> 	Scalar Set-On-Less-Than Unit (SLT)
			BIT 3	-> 	Scalar Shift Unit (SHFT)
			BIT 2 	-> 	Scalar Logic Unit (LOGIC)
			BIT 1 	-> 	Scalar Multiplication Unit (MUL)
			BIT 0 	-> 	Scalar Addition Unit (ADD)
			
		Register Vector
			BIT 6 	-> 	Vector v0 Register is Needed to Perform the Operation (VMASK)
			BIT 5 	-> 	Vector vs1 Register Field is Present in the Instruction Format (VS1)
			BIT 4 	-> 	Vector vs2 Register Field is Present in the Instruction Format (VS2)
			BIT 3	-> 	Vector vd Register Field is Present in the Instruction Format (VD)
			BIT 2 	-> 	Scalar rs1 Register Field is Present in the Instruction Format (RS1)
			BIT 1 	-> 	Scalar rs2 Register Field is Present in the Instruction Format (RS2)
			BIT 0 	-> 	Scalar rd Register Field is Present in the Instruction Format (RD)
			
		Operation Vector
			BIT 28 	-> 	Vector Instruction Returns the High Part of the Operation (VHL)
			BIT 27	-> 	Vector Instruction Field vs2 is Needed for Decoding (VS2)
			BIT 26	-> 	Vector Instruction Field vs1 is Needed for Decoding (VS1)
			BIT 25 	-> 	Vector Instruction Field funct6 is Needed for Decoding (F6)
			BIT 24	-> 	Vector Instruction Field vm is Needed for Decoding (VM)
			BIT 23	-> 	Vector Operand vs2's Elements are Signed (VSB)
			BIT 22	-> 	Vector Operand vs1's Elements are Signed (VSA)
			BIT 21 	-> 	Vector Memory Operation (VMEM)
			BIT 20 	-> 	Vector Fixed-Point Operation (VFXP)
			BIT 19 	-> 	Vector Floating-Point Operation (VFP)
			BIT 18	-> 	Vector Integer Operation (VINT)
			BIT 17 	-> 	Vector Operation (VEC)
			BIT 16 	-> 	Floating-Point Operation (FP)
			BIT 15 	-> 	Exception-Handling Operation (EH)
			BIT 14 	-> 	Scalar Memory Operation (MEM)
			BIT 13 	-> 	Scalar Integer Operation (INT)
			BIT 12 	-> 	opcode/funct7 is Needed for Decoding (OP/F7)
			BIT 11 	-> 	f3 is Needed for Decoding (F3)
			BIT 10 	-> 	Reserved (R)
			BIT 9 	-> 	Reserved (R)
			BIT 8	-> 	Relative-to-PC Address-Calculation Operation (PC)
			BIT 7 	-> 	Scalar rs2 is Signed (SB)
			BIT 6 	-> 	Scalar rs1 is Signed (SA)
			BIT 5 	-> 	Word's High-Part Operation (HL)
			BIT 4 	-> 	One-Word Operation (W)
			BIT 3	-> 	Atomic Memory Sync (Wait-for-Pipeline) Instruction (WP)
			BIT 2 	-> 	Conditional Branch Operation (BR)
			BIT 1 	-> 	Jump-Register Operation (JR)
			BIT 0 	-> 	Jump Operation (J)
*/
//case function 5		
`define		funct5_vzext_vf2		5'b00110
`define		funct5_vsext_vf2		5'b00111
`define		funct5_vzext_vf4		5'b00100
`define		funct5_vsext_vf4		5'b00101
`define		funct5_vzext_vf8		5'b00010
`define		funct5_vsext_vf8		5'b00011

//case function 6 integer
`define		vadd						6'b000000
`define		vsub						6'b000010
`define		vrsub						6'b000011
`define		vwaddu						6'b110000
`define		vwsubu						6'b110010
`define		vwadd						6'b110001
`define		vwsub						6'b110011
`define		vwaddu_w					6'b110100
`define		vwsubu_w					6'b110110
`define		vwadd_w						6'b110101
`define		vwsub_w						6'b110111
`define		vsext_vzext_vsbc			6'b010010
`define		vadc						6'b010000
`define		vmadc						6'b010001
`define		vmsbc						6'b010011
`define		vand						6'b001001
`define		vor							6'b001010
`define		vxor						6'b001011
`define		vsll_vmul					6'b100101
`define		vsrl						6'b101000
`define		vsra_vmadd					6'b101001
`define		vnsrl						6'b101100
`define		vnsra_vmacc					6'b101101
`define		vmseq						6'b011000
`define		vmsne						6'b011001
`define		vmsltu						6'b011010
`define		vmslt						6'b011011
`define		vmsleu						6'b011100
`define		vmsle						6'b011101
`define		vmsgtu						6'b011110
`define		vmsgt						6'b011111
`define		vminu						6'b000100
`define		vmin						6'b000101
`define		vmaxu						6'b000110
`define		vmax						6'b000111
`define		vmulh						6'b100111
`define		vmulhu						6'b100100
`define		vmulhsu						6'b100110
`define		vdivu						6'b100000
`define		vdiv						6'b100001
`define		vremu						6'b100010
`define		vrem						6'b100011
`define		vwmul						6'b111011
`define		vwmulu						6'b111000
`define		vwmulsu						6'b111010
`define		vnmsac						6'b101111
`define		vnmsub						6'b101011
`define		vwmaccu						6'b111100
`define		vwmacc						6'b111101
`define		vwmaccsu					6'b111111
`define		vwmaccus					6'b111110
`define		vmerge_vmv					6'b010111

// data vectors
	//system vector
`define		vadd_vv_system_vector		6'b000000
`define		vadd_vx_system_vector		6'b000000
`define		vadd_vi_system_vector		6'b000000
`define		vsub_vv_system_vector		6'b000000
`define		vsub_vx_system_vector		6'b000000
`define		vrsub_vx_system_vector		6'b000000
`define		vrsub_vi_system_vector		6'b000000
`define		vwaddu_vv_system_vector		6'b000000
`define		vwaddu_vx_system_vector		6'b000000
`define		vwsubu_vv_system_vector		6'b000000
`define		vwsubu_vx_system_vector		6'b000000
`define		vwadd_vv_system_vector		6'b000000
`define		vwadd_vx_system_vector		6'b000000
`define		vwsub_vv_system_vector		6'b000000
`define		vwsub_vx_system_vector		6'b000000
`define		vwaddu_wv_system_vector		6'b000000
`define		vwaddu_wx_system_vector		6'b000000
`define		vwsubu_wv_system_vector		6'b000000
`define		vwsubu_wx_system_vector		6'b000000
`define		vwadd_wv_system_vector		6'b000000
`define		vwadd_wx_system_vector		6'b000000
`define		vwsub_wv_system_vector		6'b000000
`define		vwsub_wx_system_vector		6'b000000
`define		vzext_vf2_system_vector		6'b000000
`define		vsext_vf2_system_vector		6'b000000
`define		vzext_vf4_system_vector		6'b000000
`define		vsext_vf4_system_vector		6'b000000
`define		vzext_vf8_system_vector		6'b000000
`define		vsext_vf8_system_vector		6'b000000
`define		vadc_vvm_system_vector		6'b000000
`define		vadc_vxm_system_vector		6'b000000
`define		vadc_vim_system_vector		6'b000000
`define		vmadc_vvm_system_vector		6'b000000
`define		vmadc_vxm_system_vector		6'b000000
`define		vmadc_vim_system_vector		6'b000000
`define		vmadc_vv_system_vector		6'b000000
`define		vmadc_vx_system_vector		6'b000000
`define		vmadc_vi_system_vector		6'b000000
`define		vsbc_vvm_system_vector		6'b000000
`define		vsbc_vxm_system_vector		6'b000000
`define		vmsbc_vvm_system_vector		6'b000000
`define		vmsbc_vxm_system_vector		6'b000000
`define		vmsbc_vv_system_vector		6'b000000
`define		vmsbc_vx_system_vector		6'b000000
`define		vand_vv_system_vector		6'b000000
`define		vand_vx_system_vector		6'b000000
`define		vand_vi_system_vector		6'b000000
`define		vor_vv_system_vector		6'b000000
`define		vor_vx_system_vector		6'b000000
`define		vor_vi_system_vector		6'b000000
`define		vxor_vv_system_vector		6'b000000
`define		vxor_vx_system_vector		6'b000000
`define		vxor_vi_system_vector		6'b000000
`define		vsll_vv_system_vector		6'b000000
`define		vsll_vx_system_vector		6'b000000
`define		vsll_vi_system_vector		6'b000000
`define		vsrl_vv_system_vector		6'b000000
`define		vsrl_vx_system_vector		6'b000000
`define		vsrl_vi_system_vector		6'b000000
`define		vsra_vv_system_vector		6'b000000
`define		vsra_vx_system_vector		6'b000000
`define		vsra_vi_system_vector		6'b000000
`define		vnsrl_wv_system_vector		6'b000000
`define		vnsrl_wx_system_vector		6'b000000
`define		vnsrl_wi_system_vector		6'b000000
`define		vnsra_wv_system_vector		6'b000000
`define		vnsra_wx_system_vector		6'b000000
`define		vnsra_wi_system_vector		6'b000000
`define		vmseq_vv_system_vector		6'b000000
`define		vmseq_vx_system_vector		6'b000000
`define		vmseq_vi_system_vector		6'b000000
`define		vmsne_vv_system_vector		6'b000000
`define		vmsne_vx_system_vector		6'b000000
`define		vmsne_vi_system_vector		6'b000000
`define		vmsltu_vv_system_vector		6'b000000
`define		vmsltu_vx_system_vector		6'b000000
`define		vmslt_vv_system_vector		6'b000000
`define		vmslt_vx_system_vector		6'b000000
`define		vmsleu_vv_system_vector		6'b000000
`define		vmsleu_vx_system_vector		6'b000000
`define		vmsleu_vi_system_vector		6'b000000
`define		vmsle_vv_system_vector		6'b000000
`define		vmsle_vx_system_vector		6'b000000
`define		vmsle_vi_system_vector		6'b000000
`define		vmsgtu_vx_system_vector		6'b000000
`define		vmsgtu_vi_system_vector		6'b000000
`define		vmsgt_vx_system_vector		6'b000000
`define		vmsgt_vi_system_vector		6'b000000
`define		vminu_vv_system_vector		6'b000000
`define		vminu_vx_system_vector		6'b000000
`define		vmin_vv_system_vector		6'b000000
`define		vmin_vx_system_vector		6'b000000
`define		vmaxu_vv_system_vector		6'b000000
`define		vmaxu_vx_system_vector		6'b000000
`define		vmax_vv_system_vector		6'b000000
`define		vmax_vx_system_vector		6'b000000
`define		vmul_vv_system_vector		6'b000000
`define		vmul_vx_system_vector		6'b000000
`define		vmulh_vv_system_vector		6'b000000
`define		vmulh_vx_system_vector		6'b000000
`define		vmulhu_vv_system_vector		6'b000000
`define		vmulhu_vx_system_vector		6'b000000
`define		vmulhsu_vv_system_vector	6'b000000
`define		vmulhsu_vx_system_vector	6'b000000
`define		vdivu_vv_system_vector		6'b000000
`define		vdivu_vx_system_vector		6'b000000
`define		vdiv_vv_system_vector		6'b000000
`define		vdiv_vx_system_vector		6'b000000
`define		vremu_vv_system_vector		6'b000000
`define		vremu_vx_system_vector		6'b000000
`define		vrem_vv_system_vector		6'b000000
`define		vrem_vx_system_vector		6'b000000
`define		vwmul_vv_system_vector		6'b000000
`define		vwmul_vx_system_vector		6'b000000
`define		vwmulu_vv_system_vector		6'b000000
`define		vwmulu_vx_system_vector		6'b000000
`define		vwmulsu_vv_system_vector	6'b000000
`define		vwmulsu_vx_system_vector	6'b000000
`define		vmacc_vv_system_vector		6'b000000
`define		vmacc_vx_system_vector		6'b000000
`define		vnmsac_vv_system_vector		6'b000000
`define		vnmsac_vx_system_vector		6'b000000
`define		vmadd_vv_system_vector		6'b000000
`define		vmadd_vx_system_vector		6'b000000
`define		vnmsub_vv_system_vector		6'b000000
`define		vnmsub_vx_system_vector		6'b000000
`define		vwmaccu_vv_system_vector	6'b000000
`define		vwmaccu_vx_system_vector	6'b000000
`define		vwmacc_vv_system_vector		6'b000000
`define		vwmacc_vx_system_vector		6'b000000
`define		vwmaccsu_vv_system_vector	6'b000000
`define		vwmaccsu_vx_system_vector	6'b000000
`define		vwmaccus_vx_system_vector	6'b000000
`define		vmerge_vvm_system_vector	6'b000000
`define		vmerge_vxm_system_vector	6'b000000
`define		vmerge_vim_system_vector	6'b000000
`define		vmv_v_v_system_vector		6'b000000
`define		vmv_v_x_system_vector		6'b000000
`define		vmv_v_i_system_vector		6'b000000

	//resource vector
`define		vadd_vv_resource_vector		22'b000000010000000
`define		vadd_vx_resource_vector		22'b000000010000000
`define		vadd_vi_resource_vector		22'b000000011000000
`define		vsub_vv_resource_vector		22'b000000010000000
`define		vsub_vx_resource_vector		22'b000000010000000
`define		vrsub_vx_resource_vector	22'b000000010000000
`define		vrsub_vi_resource_vector	22'b000000011000000
`define		vwaddu_vv_resource_vector	22'b000000010000000
`define		vwaddu_vx_resource_vector	22'b000000010000000
`define		vwsubu_vv_resource_vector	22'b000000010000000
`define		vwsubu_vx_resource_vector	22'b000000010000000
`define		vwadd_vv_resource_vector	22'b000000010000000
`define		vwadd_vx_resource_vector	22'b000000010000000
`define		vwsub_vv_resource_vector	22'b000000010000000
`define		vwsub_vx_resource_vector	22'b000000010000000
`define		vwaddu_wv_resource_vector	22'b000000010000000
`define		vwaddu_wx_resource_vector	22'b000000010000000
`define		vwsubu_wv_resource_vector	22'b000000010000000
`define		vwsubu_wx_resource_vector	22'b000000010000000
`define		vwadd_wv_resource_vector	22'b000000010000000
`define		vwadd_wx_resource_vector	22'b000000010000000
`define		vwsub_wv_resource_vector	22'b000000010000000
`define		vwsub_wx_resource_vector	22'b000000010000000
`define		vzext_vf2_resource_vector	22'b000000100000000
`define		vsext_vf2_resource_vector	22'b000000100000000
`define		vzext_vf4_resource_vector	22'b000000100000000
`define		vsext_vf4_resource_vector	22'b000000100000000
`define		vzext_vf8_resource_vector	22'b000000100000000
`define		vsext_vf8_resource_vector	22'b000000100000000
`define		vadc_vvm_resource_vector	22'b000000010000000
`define		vadc_vxm_resource_vector	22'b000000010000000
`define		vadc_vim_resource_vector	22'b000000011000000
`define		vmadc_vvm_resource_vector	22'b000000010000000
`define		vmadc_vxm_resource_vector	22'b000000010000000
`define		vmadc_vim_resource_vector	22'b000000011000000
`define		vmadc_vv_resource_vector	22'b000000010000000
`define		vmadc_vx_resource_vector	22'b000000010000000
`define		vmadc_vi_resource_vector	22'b000000011000000
`define		vsbc_vvm_resource_vector	22'b000000010000000
`define		vsbc_vxm_resource_vector	22'b000000010000000
`define		vmsbc_vvm_resource_vector	22'b000000010000000
`define		vmsbc_vxm_resource_vector	22'b000000010000000
`define		vmsbc_vv_resource_vector	22'b000000010000000
`define		vmsbc_vx_resource_vector	22'b000000010000000
`define		vand_vv_resource_vector		22'b000001000000000
`define		vand_vx_resource_vector		22'b000001000000000
`define		vand_vi_resource_vector		22'b000001001000000
`define		vor_vv_resource_vector		22'b000001000000000
`define		vor_vx_resource_vector		22'b000001000000000
`define		vor_vi_resource_vector		22'b000001001000000
`define		vxor_vv_resource_vector		22'b000001000000000
`define		vxor_vx_resource_vector		22'b000001000000000
`define		vxor_vi_resource_vector		22'b000001001000000
`define		vsll_vv_resource_vector		22'b000010000000000
`define		vsll_vx_resource_vector		22'b000010000000000
`define		vsll_vi_resource_vector		22'b000010001000000
`define		vsrl_vv_resource_vector		22'b000010000000000
`define		vsrl_vx_resource_vector		22'b000010000000000
`define		vsrl_vi_resource_vector		22'b000010001000000
`define		vsra_vv_resource_vector		22'b000010000000000
`define		vsra_vx_resource_vector		22'b000010000000000
`define		vsra_vi_resource_vector		22'b000010001000000
`define		vnsrl_wv_resource_vector	22'b000010000000000
`define		vnsrl_wx_resource_vector	22'b000010000000000
`define		vnsrl_wi_resource_vector	22'b000010001000000
`define		vnsra_wv_resource_vector	22'b000010000000000
`define		vnsra_wx_resource_vector	22'b000010000000000
`define		vnsra_wi_resource_vector	22'b000010001000000
`define		vmseq_vv_resource_vector	22'b000100000000000
`define		vmseq_vx_resource_vector	22'b000100000000000
`define		vmseq_vi_resource_vector	22'b000100001000000
`define		vmsne_vv_resource_vector	22'b000100000000000
`define		vmsne_vx_resource_vector	22'b000100000000000
`define		vmsne_vi_resource_vector	22'b000100001000000
`define		vmsltu_vv_resource_vector	22'b000100000000000
`define		vmsltu_vx_resource_vector	22'b000100000000000
`define		vmslt_vv_resource_vector	22'b000100000000000
`define		vmslt_vx_resource_vector	22'b000100000000000
`define		vmsleu_vv_resource_vector	22'b000100000000000
`define		vmsleu_vx_resource_vector	22'b000100000000000
`define		vmsleu_vi_resource_vector	22'b000100001000000
`define		vmsle_vv_resource_vector	22'b000100000000000
`define		vmsle_vx_resource_vector	22'b000100000000000
`define		vmsle_vi_resource_vector	22'b000100001000000
`define		vmsgtu_vx_resource_vector	22'b000100000000000
`define		vmsgtu_vi_resource_vector	22'b000100001000000
`define		vmsgt_vx_resource_vector	22'b000100000000000
`define		vmsgt_vi_resource_vector	22'b000100001000000
`define		vminu_vv_resource_vector	22'b000100000000000
`define		vminu_vx_resource_vector	22'b000100000000000
`define		vmin_vv_resource_vector		22'b000100000000000
`define		vmin_vx_resource_vector		22'b000100000000000
`define		vmaxu_vv_resource_vector	22'b000100000000000
`define		vmaxu_vx_resource_vector	22'b000100000000000
`define		vmax_vv_resource_vector		22'b000100000000000
`define		vmax_vx_resource_vector		22'b000100000000000
`define		vmul_vv_resource_vector		22'b001000000000000
`define		vmul_vx_resource_vector		22'b001000000000000
`define		vmulh_vv_resource_vector	22'b001000000000000
`define		vmulh_vx_resource_vector	22'b001000000000000
`define		vmulhu_vv_resource_vector	22'b001000000000000
`define		vmulhu_vx_resource_vector	22'b001000000000000
`define		vmulhsu_vv_resource_vector	22'b001000000000000
`define		vmulhsu_vx_resource_vector	22'b001000000000000
`define		vdivu_vv_resource_vector	22'b010000000000000
`define		vdivu_vx_resource_vector	22'b010000000000000
`define		vdiv_vv_resource_vector		22'b010000000000000
`define		vdiv_vx_resource_vector		22'b010000000000000
`define		vremu_vv_resource_vector	22'b010000000000000
`define		vremu_vx_resource_vector	22'b010000000000000
`define		vrem_vv_resource_vector		22'b010000000000000
`define		vrem_vx_resource_vector		22'b010000000000000
`define		vwmul_vv_resource_vector	22'b001000000000000
`define		vwmul_vx_resource_vector	22'b001000000000000
`define		vwmulu_vv_resource_vector	22'b001000000000000
`define		vwmulu_vx_resource_vector	22'b001000000000000
`define		vwmulsu_vv_resource_vector	22'b001000000000000
`define		vwmulsu_vx_resource_vector	22'b001000000000000
`define		vmacc_vv_resource_vector	22'b001000010000000
`define		vmacc_vx_resource_vector	22'b001000010000000
`define		vnmsac_vv_resource_vector	22'b001000010000000
`define		vnmsac_vx_resource_vector	22'b001000010000000
`define		vmadd_vv_resource_vector	22'b001000010000000
`define		vmadd_vx_resource_vector	22'b001000010000000
`define		vnmsub_vv_resource_vector	22'b001000010000000
`define		vnmsub_vx_resource_vector	22'b001000010000000
`define		vwmaccu_vv_resource_vector	22'b001000010000000
`define		vwmaccu_vx_resource_vector	22'b001000010000000
`define		vwmacc_vv_resource_vector	22'b001000010000000
`define		vwmacc_vx_resource_vector	22'b001000010000000
`define		vwmaccsu_vv_resource_vector	22'b001000010000000
`define		vwmaccsu_vx_resource_vector	22'b001000010000000
`define		vwmaccus_vx_resource_vector	22'b001000010000000
`define		vmerge_vvm_resource_vector	22'b100000000000000
`define		vmerge_vxm_resource_vector	22'b100000000000000
`define		vmerge_vim_resource_vector	22'b100000001000000
`define		vmv_v_v_resource_vector		22'b000000000000000
`define		vmv_v_x_resource_vector		22'b000000000000000
`define		vmv_v_i_resource_vector		22'b000000001000000

	//register vector
`define		vadd_vv_register_vector		8'b01101000
`define		vadd_vx_register_vector		8'b00101100
`define		vadd_vi_register_vector		8'b00101000
`define		vsub_vv_register_vector		8'b01101000
`define		vsub_vx_register_vector		8'b00101100
`define		vrsub_vx_register_vector		8'b00101100
`define		vrsub_vi_register_vector		8'b00101000
`define		vwaddu_vv_register_vector	8'b01101000
`define		vwaddu_vx_register_vector	8'b00101100
`define		vwsubu_vv_register_vector	8'b01101000
`define		vwsubu_vx_register_vector	8'b00101100
`define		vwadd_vv_register_vector		8'b01101000
`define		vwadd_vx_register_vector		8'b00101100
`define		vwsub_vv_register_vector		8'b01101000
`define		vwsub_vx_register_vector		8'b00101100
`define		vwaddu_wv_register_vector	8'b01101000
`define		vwaddu_wx_register_vector	8'b00101100
`define		vwsubu_wv_register_vector	8'b01101000
`define		vwsubu_wx_register_vector	8'b00101100
`define		vwadd_wv_register_vector		8'b01101000
`define		vwadd_wx_register_vector		8'b00101100
`define		vwsub_wv_register_vector		8'b01101000
`define		vwsub_wx_register_vector		8'b00101100
`define		vzext_vf2_register_vector	8'b00101000
`define		vsext_vf2_register_vector	8'b00101000
`define		vzext_vf4_register_vector	8'b00101000
`define		vsext_vf4_register_vector	8'b00101000
`define		vzext_vf8_register_vector	8'b00101000
`define		vsext_vf8_register_vector	8'b00101000
`define		vadc_vvm_register_vector		8'b11101000
`define		vadc_vxm_register_vector		8'b10101100
`define		vadc_vim_register_vector		8'b10101000
`define		vmadc_vvm_register_vector	8'b11101000
`define		vmadc_vxm_register_vector	8'b10101100
`define		vmadc_vim_register_vector	8'b10101000
`define		vmadc_vv_register_vector		8'b01101000
`define		vmadc_vx_register_vector		8'b00101100
`define		vmadc_vi_register_vector		8'b00101000
`define		vsbc_vvm_register_vector		8'b11101000
`define		vsbc_vxm_register_vector		8'b10101100
`define		vmsbc_vvm_register_vector	8'b11101000
`define		vmsbc_vxm_register_vector	8'b10101100
`define		vmsbc_vv_register_vector		8'b01101000
`define		vmsbc_vx_register_vector		8'b00101100
`define		vand_vv_register_vector		8'b01101000
`define		vand_vx_register_vector		8'b00101100
`define		vand_vi_register_vector		8'b00101000
`define		vor_vv_register_vector		8'b01101000
`define		vor_vx_register_vector		8'b00101100
`define		vor_vi_register_vector		8'b00101000
`define		vxor_vv_register_vector		8'b01101000
`define		vxor_vx_register_vector		8'b00101100
`define		vxor_vi_register_vector		8'b00101000
`define		vsll_vv_register_vector		8'b01101000
`define		vsll_vx_register_vector		8'b00101100
`define		vsll_vi_register_vector		8'b00101000
`define		vsrl_vv_register_vector		8'b01101000
`define		vsrl_vx_register_vector		8'b00101100
`define		vsrl_vi_register_vector		8'b00101000
`define		vsra_vv_register_vector		8'b01101000
`define		vsra_vx_register_vector		8'b00101100
`define		vsra_vi_register_vector		8'b00101000
`define		vnsrl_wv_register_vector		8'b01101000
`define		vnsrl_wx_register_vector		8'b00101100
`define		vnsrl_wi_register_vector		8'b00101000
`define		vnsra_wv_register_vector		8'b01101000
`define		vnsra_wx_register_vector		8'b00101100
`define		vnsra_wi_register_vector		8'b00101000
`define		vmseq_vv_register_vector		8'b01101000
`define		vmseq_vx_register_vector		8'b00101100
`define		vmseq_vi_register_vector		8'b00101000
`define		vmsne_vv_register_vector		8'b01101000
`define		vmsne_vx_register_vector		8'b00101100
`define		vmsne_vi_register_vector		8'b00101000
`define		vmsltu_vv_register_vector	8'b01101000
`define		vmsltu_vx_register_vector	8'b00101100
`define		vmslt_vv_register_vector		8'b01101000
`define		vmslt_vx_register_vector		8'b00101100
`define		vmsleu_vv_register_vector	8'b01101000
`define		vmsleu_vx_register_vector	8'b00101100
`define		vmsleu_vi_register_vector	8'b00101000
`define		vmsle_vv_register_vector		8'b01101000
`define		vmsle_vx_register_vector		8'b00101100
`define		vmsle_vi_register_vector		8'b00101000
`define		vmsgtu_vx_register_vector	8'b00101100
`define		vmsgtu_vi_register_vector	8'b00101000
`define		vmsgt_vx_register_vector		8'b00101100
`define		vmsgt_vi_register_vector		8'b00101000
`define		vminu_vv_register_vector		8'b01101000
`define		vminu_vx_register_vector		8'b00101100
`define		vmin_vv_register_vector		8'b01101000
`define		vmin_vx_register_vector		8'b00101100
`define		vmaxu_vv_register_vector		8'b01101000
`define		vmaxu_vx_register_vector		8'b00101100
`define		vmax_vv_register_vector		8'b01101000
`define		vmax_vx_register_vector		8'b00101100
`define		vmul_vv_register_vector		8'b01101000
`define		vmul_vx_register_vector		8'b00101100
`define		vmulh_vv_register_vector		8'b01101000
`define		vmulh_vx_register_vector		8'b00101100
`define		vmulhu_vv_register_vector	8'b01101000
`define		vmulhu_vx_register_vector	8'b00101100
`define		vmulhsu_vv_register_vector	8'b01101000
`define		vmulhsu_vx_register_vector	8'b00101100
`define		vdivu_vv_register_vector		8'b01101000
`define		vdivu_vx_register_vector		8'b00101100
`define		vdiv_vv_register_vector		8'b01101000
`define		vdiv_vx_register_vector		8'b00101100
`define		vremu_vv_register_vector		8'b01101000
`define		vremu_vx_register_vector		8'b00101100
`define		vrem_vv_register_vector		8'b01101000
`define		vrem_vx_register_vector		8'b00101100
`define		vwmul_vv_register_vector		8'b01101000
`define		vwmul_vx_register_vector		8'b00101100
`define		vwmulu_vv_register_vector	8'b01101000
`define		vwmulu_vx_register_vector	8'b00101100
`define		vwmulsu_vv_register_vector	8'b01101000
`define		vwmulsu_vx_register_vector	8'b00101100
`define		vmacc_vv_register_vector		8'b01111000
`define		vmacc_vx_register_vector		8'b00111100
`define		vnmsac_vv_register_vector	8'b01111000
`define		vnmsac_vx_register_vector	8'b00111100
`define		vmadd_vv_register_vector		8'b01111000
`define		vmadd_vx_register_vector		8'b00111100
`define		vnmsub_vv_register_vector	8'b01111000
`define		vnmsub_vx_register_vector	8'b00111100
`define		vwmaccu_vv_register_vector	8'b01111000
`define		vwmaccu_vx_register_vector	8'b00111100
`define		vwmacc_vv_register_vector	8'b01111000
`define		vwmacc_vx_register_vector	8'b00111100
`define		vwmaccsu_vv_register_vector	8'b01111000
`define		vwmaccsu_vx_register_vector	8'b00111100
`define		vwmaccus_vx_register_vector	8'b00111100
`define		vmerge_vvm_register_vector	8'b11101000
`define		vmerge_vxm_register_vector	8'b10101100
`define		vmerge_vim_register_vector	8'b10101000
`define		vmv_v_v_register_vector		8'b01001000
`define		vmv_v_x_register_vector		8'b00001100
`define		vmv_v_i_register_vector		8'b00001000

	//operation_vector 
`define		vadd_vv_operation_vector		29'b00011110001100001100000000000
`define		vadd_vx_operation_vector		29'b00011100001100001100001000000
`define		vadd_vi_operation_vector		29'b00011100001100001100000000000
`define		vsub_vv_operation_vector		29'b00011110001100001100000000000
`define		vsub_vx_operation_vector		29'b00011100001100001100001000000
`define		vrsub_vx_operation_vector	29'b00011100001100001100001000000
`define		vrsub_vi_operation_vector	29'b00011100001100001100000000000
`define		vwaddu_vv_operation_vector	29'b00011000001100001100000000000
`define		vwaddu_vx_operation_vector	29'b00011000001100001100000000000
`define		vwsubu_vv_operation_vector	29'b00011000001100001100000000000
`define		vwsubu_vx_operation_vector	29'b00011000001100001100000000000
`define		vwadd_vv_operation_vector	29'b00011110001100001100000000000
`define		vwadd_vx_operation_vector	29'b00011100001100001100001000000
`define		vwsub_vv_operation_vector	29'b00011110001100001100000000000
`define		vwsub_vx_operation_vector	29'b00011100001100001100001000000
`define		vwaddu_wv_operation_vector	29'b00011000001100001100000000000
`define		vwaddu_wx_operation_vector	29'b00011000001100001100000000000
`define		vwsubu_wv_operation_vector	29'b00011000001100001100000000000
`define		vwsubu_wx_operation_vector	29'b00011000001100001100000000000
`define		vwadd_wv_operation_vector	29'b00011110001100001100000000000
`define		vwadd_wx_operation_vector	29'b00011100001100001100001000000
`define		vwsub_wv_operation_vector	29'b00011110001100001100000000000
`define		vwsub_wx_operation_vector	29'b00011100001100001100001000000
`define		vzext_vf2_operation_vector	29'b00111000001100000000000000000
`define		vsext_vf2_operation_vector	29'b00111100001100000000000000000
`define		vzext_vf4_operation_vector	29'b00111000001100000000000000000
`define		vsext_vf4_operation_vector	29'b00111100001100000000000000000
`define		vzext_vf8_operation_vector	29'b00111000001100000000000000000
`define		vsext_vf8_operation_vector	29'b00111100001100000000000000000
`define		vadc_vvm_operation_vector	29'b00010110001100001100000000000
`define		vadc_vxm_operation_vector	29'b00010100001100001100001000000
`define		vadc_vim_operation_vector	29'b00010100001100001100000000000
`define		vmadc_vvm_operation_vector	29'b00010110001100001100000000000
`define		vmadc_vxm_operation_vector	29'b00010100001100001100001000000
`define		vmadc_vim_operation_vector	29'b00010100001100001100000000000
`define		vmadc_vv_operation_vector	29'b00010110001100001100000000000
`define		vmadc_vx_operation_vector	29'b00010100001100001100001000000
`define		vmadc_vi_operation_vector	29'b00010100001100001100000000000
`define		vsbc_vvm_operation_vector	29'b00010110001100001100000000000
`define		vsbc_vxm_operation_vector	29'b00010100001100001100001000000
`define		vmsbc_vvm_operation_vector	29'b00010110001100001100000000000
`define		vmsbc_vxm_operation_vector	29'b00010100001100001100001000000
`define		vmsbc_vv_operation_vector	29'b00010110001100001100000000000
`define		vmsbc_vx_operation_vector	29'b00010100001100001100001000000
`define		vand_vv_operation_vector		29'b00011000001100001100000000000
`define		vand_vx_operation_vector		29'b00011000001100001100000000000
`define		vand_vi_operation_vector		29'b00011000001100001100000000000
`define		vor_vv_operation_vector		29'b00011000001100001100000000000
`define		vor_vx_operation_vector		29'b00011000001100001100000000000
`define		vor_vi_operation_vector		29'b00011000001100001100000000000
`define		vxor_vv_operation_vector		29'b00011000001100001100000000000
`define		vxor_vx_operation_vector		29'b00011000001100001100000000000
`define		vxor_vi_operation_vector		29'b00011000001100001100000000000
`define		vsll_vv_operation_vector		29'b00011000001100001100000000000
`define		vsll_vx_operation_vector		29'b00011000001100001100000000000
`define		vsll_vi_operation_vector		29'b00011000001100001100000000000
`define		vsrl_vv_operation_vector		29'b00011000001100001100000000000
`define		vsrl_vx_operation_vector		29'b00011000001100001100000000000
`define		vsrl_vi_operation_vector		29'b00011000001100001100000000000
`define		vsra_vv_operation_vector		29'b00011000001100001100000000000
`define		vsra_vx_operation_vector		29'b00011000001100001100000000000
`define		vsra_vi_operation_vector		29'b00011000001100001100000000000
`define		vnsrl_wv_operation_vector	29'b00011000001100001100000000000
`define		vnsrl_wx_operation_vector	29'b00011000001100001100000000000
`define		vnsrl_wi_operation_vector	29'b00011000001100001100000000000
`define		vnsra_wv_operation_vector	29'b00011000001100001100000000000
`define		vnsra_wx_operation_vector	29'b00011000001100001100000000000
`define		vnsra_wi_operation_vector	29'b00011000001100001100000000000
`define		vmseq_vv_operation_vector	29'b00011000001100001100000000000
`define		vmseq_vx_operation_vector	29'b00011000001100001100000000000
`define		vmseq_vi_operation_vector	29'b00011000001100001100000000000
`define		vmsne_vv_operation_vector	29'b00011000001100001100000000000
`define		vmsne_vx_operation_vector	29'b00011000001100001100000000000
`define		vmsne_vi_operation_vector	29'b00011000001100001100000000000
`define		vmsltu_vv_operation_vector	29'b00011000001100001100000000000
`define		vmsltu_vx_operation_vector	29'b00011000001100001100000000000
`define		vmslt_vv_operation_vector	29'b00011110001100001100000000000
`define		vmslt_vx_operation_vector	29'b00011100001100001100001000000
`define		vmsleu_vv_operation_vector	29'b00011000001100001100000000000
`define		vmsleu_vx_operation_vector	29'b00011000001100001100000000000
`define		vmsleu_vi_operation_vector	29'b00011000001100001100000000000
`define		vmsle_vv_operation_vector	29'b00011110001100001100000000000
`define		vmsle_vx_operation_vector	29'b00011100001100001100001000000
`define		vmsle_vi_operation_vector	29'b00011100001100001100000000000
`define		vmsgtu_vx_operation_vector	29'b00011000001100001100000000000
`define		vmsgtu_vi_operation_vector	29'b00011000001100001100000000000
`define		vmsgt_vx_operation_vector	29'b00011100001100001100001000000
`define		vmsgt_vi_operation_vector	29'b00011100001100001100000000000
`define		vminu_vv_operation_vector	29'b00011000001100001100000000000
`define		vminu_vx_operation_vector	29'b00011000001100001100000000000
`define		vmin_vv_operation_vector		29'b00011110001100001100000000000
`define		vmin_vx_operation_vector		29'b00011100001100001100001000000
`define		vmaxu_vv_operation_vector	29'b00011000001100001100000000000
`define		vmaxu_vx_operation_vector	29'b00011000001100001100000000000
`define		vmax_vv_operation_vector	29'b00011110001100001100000000000
`define		vmax_vx_operation_vector	29'b00011100001100001100001000000
`define		vmul_vv_operation_vector	29'b00011110001100001100000000000
`define		vmul_vx_operation_vector	29'b00011100001100001100001000000
`define		vmulh_vv_operation_vector	29'b10011110001100001100000000000
`define		vmulh_vx_operation_vector	29'b10011100001100001100001000000
`define		vmulhu_vv_operation_vector	29'b10011000001100001100000000000
`define		vmulhu_vx_operation_vector	29'b10011000001100001100000000000
`define		vmulhsu_vv_operation_vector	29'b10011100001100001100000000000
`define		vmulhsu_vx_operation_vector	29'b10011100001100001100000000000
`define		vdivu_vv_operation_vector	29'b00011000001100001100000000000
`define		vdivu_vx_operation_vector	29'b00011000001100001100000000000
`define		vdiv_vv_operation_vector		29'b00011110001100001100000000000
`define		vdiv_vx_operation_vector		29'b00011100001100001100001000000
`define		vremu_vv_operation_vector	29'b00011000001100001100000000000
`define		vremu_vx_operation_vector	29'b00011000001100001100000000000
`define		vrem_vv_operation_vector		29'b00011110001100001100000000000
`define		vrem_vx_operation_vector		29'b00011100001100001100001000000
`define		vwmul_vv_operation_vector	29'b00011110001100001100000000000
`define		vwmul_vx_operation_vector	29'b00011100001100001100001000000
`define		vwmulu_vv_operation_vector	29'b00011000001100001100000000000
`define		vwmulu_vx_operation_vector	29'b00011000001100001100000000000
`define		vwmulsu_vv_operation_vector	29'b00011100001100001100000000000
`define		vwmulsu_vx_operation_vector	29'b00011100001100001100000000000
`define		vmacc_vv_operation_vector	29'b00011110001100001100000000000
`define		vmacc_vx_operation_vector	29'b00011100001100001100001000000
`define		vnmsac_vv_operation_vector	29'b00011110001100001100000000000
`define		vnmsac_vx_operation_vector	29'b00011100001100001100001000000
`define		vmadd_vv_operation_vector	29'b00011110001100001100000000000
`define		vmadd_vx_operation_vector	29'b00011100001100001100001000000
`define		vnmsub_vv_operation_vector	29'b00011110001100001100000000000
`define		vnmsub_vx_operation_vector	29'b00011100001100001100001000000
`define		vwmaccu_vv_operation_vector	29'b00011000001100001100000000000
`define		vwmaccu_vx_operation_vector	29'b00011000001100001100000000000
`define		vwmacc_vv_operation_vector	29'b00011110001100001100000000000
`define		vwmacc_vx_operation_vector	29'b00011100001100001100001000000
`define		vwmaccsu_vv_operation_vector	29'b00011010001100001100000000000
`define		vwmaccsu_vx_operation_vector	29'b00011000001100001100001000000
`define		vwmaccus_vx_operation_vector	29'b00011100001100001100000000000
`define		vmerge_vvm_operation_vector	29'b00010000001100001100000000000
`define		vmerge_vxm_operation_vector	29'b00010000001100001100000000000
`define		vmerge_vim_operation_vector	29'b00010000001100001100000000000
`define		vmv_v_v_operation_vector		29'b01010000001100001100000000000
`define		vmv_v_x_operation_vector		29'b01010000001100001100000000000
`define		vmv_v_i_operation_vector		29'b01010000001100001100000000000