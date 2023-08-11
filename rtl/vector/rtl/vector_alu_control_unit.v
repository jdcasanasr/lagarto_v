`include "riscv_vector_integer.vh"

`define using_vadd 		15'b00000001
`define using_vlog 		15'b00000100
`define using_vshft 	15'b00001000
`define using_vmul 		15'b00100000
`define	using_vmul_add	15'b00100001
`define	using_vdiv		15'b01000000
`define	usign_maxmin	15'b00010000

module vector_alu_control_unit
(
	input 		[14:0] 	resource_vector_i,
	input 		[5:0] 	funct6_i,
	
	// {with_carry_borrow_i, compute_carry_i, add_sub_i, reverse_i}
	output reg 	[3:0] 	vadd_control_vector_o,
	
	// 2'01 = AND, 2'b10 = OR, 2'b11 = XOR
	output reg 	[1:0] 	vlog_control_vector_o,
	
	// 2'01 = SLL, 2'b10 = SRL, 2'b11 = SRA
	output reg 	[1:0] 	vshft_control_vector_o,
	
	// {vd_high_low_part_i, vs1_signed_unsigned_i, vs2_signed_unsigned_i}
	output reg 	[2:0]	vmul_control_vector_o,
	
	// {}
	output reg 	[2:0]	vmul_add_control_vector_o,
	
	// {remainder_division_vdiv, signed_unsigned_vdiv}
	output reg 	[1:0]	vdiv_control_vector_o,
	
	// {maximum_minimum_vmaxmin, signed_unsigned_vmaxmin}
	output reg 	[1:0]	vmaxmin_control_vector_o
);

	always @ (*)
		case (resource_vector_i)
			`using_vadd :
				begin
					case(funct6_i)
						`vadd 				: vadd_control_vector_o = 4'b0000;
						`vsub 				: vadd_control_vector_o = 4'b0010;
						`vrsub 				: vadd_control_vector_o = 4'b0011;
						`vadc 				: vadd_control_vector_o = 4'b1000;
						`vmadc 				: vadd_control_vector_o = 4'b0100;
						`vsext_vzext_vsbc 	: vadd_control_vector_o = 4'b1010;
						`vmsbc 				: vadd_control_vector_o = 4'b0110;
						
						default 			: vadd_control_vector_o = 4'b0000;
					endcase
				
					vlog_control_vector_o 		=	2'b0;
					vshft_control_vector_o 		=	2'b0;
					vmul_control_vector_o 		=	3'b0;
					vmul_add_control_vector_o	=	3'b0;
					vdiv_control_vector_o		=	2'b0;
					vmaxmin_control_vector_o	=	2'b0;
				end
				
			`using_vlog :
				begin
					case (funct6_i)
						`vand 	: vlog_control_vector_o = 2'b01;
						`vor 	: vlog_control_vector_o = 2'b10;
						`vxor 	: vlog_control_vector_o = 2'b11;
						
						default : vlog_control_vector_o = 2'b00;
					endcase
				
					vadd_control_vector_o 		=	4'b0;
					vshft_control_vector_o 		=	2'b0;
					vmul_control_vector_o 		=	3'b0;
					vmul_add_control_vector_o	=	3'b0;
					vdiv_control_vector_o		=	2'b0;
					vmaxmin_control_vector_o	=	2'b0;
				end
				
			`using_vshft :
				begin
					case (funct6_i)
						`vsll_vmul 	: vshft_control_vector_o = 2'b01;
						`vsrl		: vshft_control_vector_o = 2'b10;
						`vsra_vmadd : vshft_control_vector_o = 2'b11;
						
						default 	: vshft_control_vector_o = 2'b00;
					endcase
					
					vadd_control_vector_o 		=	4'b0;
					vlog_control_vector_o 		=	2'b0;
					vmul_control_vector_o 		=	3'b0;
					vmul_add_control_vector_o	=	3'b0;
					vdiv_control_vector_o		=	2'b0;
					vmaxmin_control_vector_o	=	2'b0;
				end
				
			`using_vmul :
				begin
					case (funct6_i)
						`vmul 		: vmul_control_vector_o = 3'b011;
						`vmulh		: vmul_control_vector_o = 3'b111;
						`vmulhu 	: vmul_control_vector_o = 3'b100;
				        `vmulhsu 	: vmul_control_vector_o = 3'b101;
						
						default 	: vmul_control_vector_o = 3'b000;
					endcase
					vadd_control_vector_o 		= 	4'b0;
					vlog_control_vector_o 		= 	2'b0;
					vshft_control_vector_o 		= 	2'b0;
					vmul_add_control_vector_o	=	3'b0;
					vdiv_control_vector_o		=	2'b0;
					vmaxmin_control_vector_o	=	2'b0;
				end
			`using_vdiv:
				begin
					case	(funct6_i)
						`vdivu		:	vdiv_control_vector_o	=	2'b11;
						`vdiv		:	vdiv_control_vector_o	=	2'b10;
						`vremu		:	vdiv_control_vector_o	=	2'b01;
						`vrem		:	vdiv_control_vector_o	=	2'b00;
						default		:	vdiv_control_vector_o	=	2'b0;
					endcase
					vadd_control_vector_o 		= 	4'b0;
					vlog_control_vector_o 		= 	2'b0;
					vshft_control_vector_o 		= 	2'b0;
					vmul_control_vector_o		=	3'b0;
					vmul_add_control_vector_o	=	3'b0;
					vmaxmin_control_vector_o	=	2'b0;
				end
			`usign_maxmin:
				begin
					case	(funct6_i)
						`vminu		:	vmaxmin_control_vector_o	=	2'b01;
						`vmin		:	vmaxmin_control_vector_o	=	2'b00;
						`vmaxu		:	vmaxmin_control_vector_o	=	2'b11;
						`vmax		:	vmaxmin_control_vector_o	=	2'b10;
						default		:	vmaxmin_control_vector_o	=	2'b0;
					endcase
					vadd_control_vector_o 		= 	4'b0;
					vlog_control_vector_o 		= 	2'b0;
					vshft_control_vector_o 		= 	2'b0;
					vmul_control_vector_o		=	3'b0;
					vmul_add_control_vector_o	=	3'b0;
					vdiv_control_vector_o		=	2'b0;
				end
			default 	:
				begin
					vadd_control_vector_o 	= 4'b0;
					vlog_control_vector_o 	= 2'b0;
					vshft_control_vector_o 	= 2'b0;
					vmul_control_vector_o 	= 3'b0;
				end
		endcase

endmodule
