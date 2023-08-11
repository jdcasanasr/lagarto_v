import lagarto_fpu_pkg::*;

module f2d_unit (
  input		unit_input_t	unit_input_i,
  output	unit_output_t	unit_output_o
);
localparam	ZEROS_WIDTH		=	$clog2(64);
localparam	ZEROS_EFFECTIVE	=	$clog2(SFP_MANTISSA_BITS);

sfp_encoding_t					op;
fp_t							result;
fp_class_t						sfp_class;
fp_status_flags					status;
wire	[ZEROS_WIDTH-1:0]		zeros_w;
wire	[ZEROS_EFFECTIVE-1:0]	zeros_effective;

assign status = '0;

// I am assuming that for a sfp the number is encoded in the 32 lower bits of the operand
assign op.sign = unit_input_i.operand_a[31];
assign op.exp = unit_input_i.operand_a[30:23];
assign op.mnt = unit_input_i.operand_a[22:0];

classifier_SFP	SFP_class
(
	.sfp_operand_i	(op),
	.fp_class_o		(sfp_class)
);

leading_zeroes_counter	zeros_count	(
	.input_vector	({41'b0,op.mnt}),
	.count_vector	(zeros_w)
);

assign	zeros_effective	=	zeros_w-41;

always	@	(*)
begin
	case	(sfp_class)
		POS_INFINITY,NEG_INFINITY	:	begin
			result.sign	=	op.sign;
			result.exp	=	{DFP_EXPONENT_BITS{1'b1}};
			result.mnt	=	{DFP_MANTISSA_BITS{1'b0}};
		end
		POS_ZERO,NEG_ZERO			:	begin
			result.sign	=	op.sign;
			result.exp	=	{DFP_EXPONENT_BITS{1'b0}};
			result.mnt	=	{DFP_MANTISSA_BITS{1'b0}};
		end
		SNAN,QNAN					:	begin
			result.sign	=	op.sign;
			result.exp	=	{DFP_EXPONENT_BITS{1'b1}};
			result.mnt	=	op.mnt;
		end
		POS_SUBNORMAL,NEG_SUBNORMAL	:	begin
			result.sign	=	op.sign;
			result.exp	=	8'b0+(896-zeros_effective);
			result.mnt	=	{op.mnt[SFP_MANTISSA_BITS-1:0],29'b0}<<zeros_effective+1;
		end
		POS_NORMAL,NEG_NORMAL		:	begin
			result.sign	=	op.sign;
			result.exp	=	{3'b0, op.exp} + 896;
			result.mnt	=	{op.mnt, 29'b0};
		end
	endcase
end
/*
// The sign remains the same
assign result.sign = op.sign;

// The exponent of the sfp is added with 896 (1023-127) in order to compensate the new bias in dfp
assign result.exp = {{(DFP_EXPONENT_BITS-SFP_EXPONENT_BITS){1'b0}}, op.exp} + 896;

// The mantissa of the sfp goes to the MSBs of the dfp and the rest is filled with 0s
assign result.mnt = {op.mnt, {(DFP_MANTISSA_BITS-SFP_MANTISSA_BITS){1'b0}}};
*/
assign unit_output_o.tag_id = '0;
assign unit_output_o.status = status;
assign unit_output_o.op_ready = unit_input_i.op_valid;
assign unit_output_o.busy = '0;
assign unit_output_o.result = {result.sign, result.exp, result.mnt};

endmodule
