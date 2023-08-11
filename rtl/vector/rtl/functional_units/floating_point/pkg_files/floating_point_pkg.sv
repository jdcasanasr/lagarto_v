package	floating_point_pkg;
	
	typedef	bit	[127:0]	fp_vec_t;
	
	localparam	NUM_OPERATION	=	4;
	localparam	OPERATION_BITS	=	$clog2(NUM_OPERATION);
	
	typedef enum	bit	[OPERATION_BITS-1:0]
	{
		FP_add,
		FP_sub,
		FP_mul,
		FP_div
	}	fp_operation_t;
	
	typedef	enum	bit	
	{
		FP_single,
		FP_double
	}	fp_precision_t;
	
	typedef	struct	packed
	{
		fp_operation_t	op_t;
		fp_precision_t	pr_t;
	}	fp_op_info_t;
	
	function	fp_vec_t	get_random_sfp_vec();
		automatic	fp_vec_t	vec;
		automatic	bit			sign_a,sign_b,sign_c,sign_d;
		automatic	bit	[7:0]	exp_a,exp_b,exp_c,exp_d;
		automatic	bit	[22:0]	mnt_a,mnt_b,mnt_c,mnt_d;
		//random sign
		sign_a	=	$urandom_range(1,0);
		sign_b	=	$urandom_range(1,0);
		sign_c	=	$urandom_range(1,0);
		sign_d	=	$urandom_range(1,0);
		//random exponent
		exp_a	=	$urandom_range(254,0);
		exp_b	=	$urandom_range(254,0);
		exp_c	=	$urandom_range(254,0);
		exp_d	=	$urandom_range(254,0);
		//random mantissa
		mnt_a	=	$urandom;
		mnt_b	=	$urandom;
		mnt_c	=	$urandom;
		mnt_d	=	$urandom;
		//output vector construction
		vec		=	{sign_a,exp_a,mnt_a,sign_b,exp_b,mnt_b,sign_c,exp_c,mnt_c,sign_d,exp_d,mnt_d};
		//value return
		return vec;
	endfunction

	function	fp_vec_t	get_random_dfp_vec();
		automatic	fp_vec_t	vec;
		automatic	bit			sign_a,sign_b;
		automatic	bit	[10:0]	exp_a,exp_b;
		automatic	bit	[51:0]	mnt_a,mnt_b;
		//random sign
		sign_a	=	$urandom_range(1,0);
		sign_b	=	$urandom_range(1,0);
		//random exponent
		exp_a	=	$urandom_range(2048,0);
		exp_b	=	$urandom_range(2048,0);
		//random mantissa
		mnt_a	=	{$urandom,$urandom};
		mnt_b	=	{$urandom,$urandom};
		//output vector construction
		vec		=	{sign_a,exp_a,mnt_a,sign_b,exp_b,mnt_b};
		//value return
		return vec;
	endfunction
	
	function	fp_op_info_t	get_random_fp();
		automatic	fp_op_info_t				info;
		automatic	bit							aux1;
		automatic	bit	[OPERATION_BITS-1:0]	aux2;
		aux1	=	$urandom;
		aux2	=	$urandom;
		case	({aux1,aux2})
			3'b000:	begin
				info.op_t	=	FP_add;
				info.pr_t	=	FP_single;
			end
			3'b100:	begin
				info.op_t	=	FP_add;
				info.pr_t	=	FP_double;
			end
			3'b001:	begin
				info.op_t	=	FP_sub;
				info.pr_t	=	FP_single;
			end
			3'b101:	begin
				info.op_t	=	FP_sub;
				info.pr_t	=	FP_double;
			end
			3'b010:	begin
				info.op_t	=	FP_mul;
				info.pr_t	=	FP_single;
			end
			3'b110:	begin
				info.op_t	=	FP_mul;
				info.pr_t	=	FP_double;
			end
			3'b011:	begin
				info.op_t	=	FP_div;
				info.pr_t	=	FP_single;
			end
			3'b111:	begin
				info.op_t	=	FP_div;
				info.pr_t	=	FP_double;
			end
		endcase
		return	info;
	endfunction
	
endpackage	:	floating_point_pkg