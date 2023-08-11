package vector_addition_unit_pkg;

    // Define A Custom Vector Type
	typedef bit [127:0] vector_t;

	// Operations' Definitions
	// {reversed_i_w, add_sub_i_w, compute_carry_i_w, with_carry_borrow_i_w}
	typedef enum bit [3:0] 
	{
		vadd 	= 4'b0000, 	// Vector Addition
		vsub 	= 4'b0100,	// Vector Subtraction
		vrsub 	= 4'b1100, 	// Vector Reverse Subtraction
		vadc 	= 4'b0001, 	// Vector Add-With-Carry
		vmadc_m = 4'b0011, 	// Vector Carry-Compute With Input Carry
		vmadc 	= 4'b0010, 	// Vector Carry-Compute Without Input Carry
		vsbc 	= 4'b0101, 	// Vector Subtract-With-Borrow
		vmsbc_m = 4'b0111, 	// Vector Borrow-Compute With Input Borrow
		vmsbc	= 4'b0110 	// Vector Borrow-Compute Without Input Borrow
	} operation_t;
	
	// SEW's Definitions
	typedef enum bit [1:0]
	{
		vsew_8b 	= 2'b00, 	//	SEW = 8
		vsew_16b 	= 2'b01, 	//	SEW = 16
		vsew_32b 	= 2'b10, 	//	SEW = 32
		vsew_64b 	= 2'b11 	//	SEW = 64
	} vsew_t;

    // Generate a Constrained, Random Operation
	function operation_t get_random_operation ();
		automatic bit [3:0] random_operation = $urandom;
		
		case (random_operation)
			4'b0000 : return vadd;
			4'b0100 : return vsub;
			4'b1100 : return vrsub;
			4'b0001 : return vadc;
			4'b0011 : return vmadc_m;
			4'b0010 : return vmadc;
			4'b0101 : return vsbc;
		    4'b0111 : return vmsbc_m;
		    4'b0110 : return vmsbc;
		
			default : return vadd;
		endcase
	endfunction

    // Generate a Constrained, Random SEW Value
	function vsew_t get_random_vsew ();
		automatic bit [1:0] random_vsew = $urandom;
	
		case (random_vsew)
			2'b00 : return vsew_8b; 
			2'b01 : return vsew_16b;
			2'b10 : return vsew_32b;
			2'b11 : return vsew_64b;
		endcase
	endfunction

	// Generate a Constrained, Random Vector,
	// According to SEW Settings
	function vector_t get_random_vector ();
		automatic vector_t random_vector = {$urandom, $urandom, $urandom, $urandom};		

		return random_vector;
	endfunction

    // Perform The Selected Operations 
	// Between Two Vectors
	function vector_t perform_operation (vector_t vs2, vector_t vs1, vector_t vmask, vsew_t vsew, operation_t operation);
		vector_t 			vector_result;

		bit [8:0] 	vmadc_8b 	[15:0];
		bit [16:0] 	vmadc_16b 	[7:0];
		bit [32:0] 	vmadc_32b 	[3:0];
		bit [64:0] 	vmadc_64b 	[1:0];

		bit [8:0] 	vmsbc_8b 	[15:0];
		bit [16:0] 	vmsbc_16b 	[7:0];
		bit [32:0] 	vmsbc_32b 	[3:0];
		bit [64:0] 	vmsbc_64b 	[1:0];
	
		case (operation)
			vadd 	:
				case (vsew)
					vsew_8b 	:
						begin
							vector_result[7:0] 		= vs2[7:0] 		+ vs1[7:0];
							vector_result[15:8] 	= vs2[15:8] 	+ vs1[15:8];
							vector_result[23:16] 	= vs2[23:16] 	+ vs1[23:16];
							vector_result[31:24] 	= vs2[31:24] 	+ vs1[31:24];
							vector_result[39:32] 	= vs2[39:32] 	+ vs1[39:32];
							vector_result[47:40] 	= vs2[47:40] 	+ vs1[47:40];
							vector_result[55:48] 	= vs2[55:48] 	+ vs1[55:48];
							vector_result[63:56] 	= vs2[63:56] 	+ vs1[63:56];
							vector_result[71:64] 	= vs2[71:64] 	+ vs1[71:64];
							vector_result[79:72] 	= vs2[79:72] 	+ vs1[79:72];
							vector_result[87:80] 	= vs2[87:80] 	+ vs1[87:80];
							vector_result[95:88] 	= vs2[95:88] 	+ vs1[95:88];
							vector_result[103:96] 	= vs2[103:96] 	+ vs1[103:96];
							vector_result[111:104] 	= vs2[111:104] 	+ vs1[111:104];
							vector_result[119:112] 	= vs2[119:112] 	+ vs1[119:112];
							vector_result[127:120] 	= vs2[127:120] 	+ vs1[127:120];
						end
					
					vsew_16b 	:
						begin
							vector_result[15:0] 	= vs2[15:0] 	+ vs1[15:0];
							vector_result[31:16] 	= vs2[31:16] 	+ vs1[31:16];
							vector_result[47:32] 	= vs2[47:32] 	+ vs1[47:32];
							vector_result[63:48] 	= vs2[63:48] 	+ vs1[63:48];
							vector_result[79:64] 	= vs2[79:64] 	+ vs1[79:64];
							vector_result[95:80] 	= vs2[95:80] 	+ vs1[95:80];
							vector_result[111:96] 	= vs2[111:96] 	+ vs1[111:96];
							vector_result[127:112] 	= vs2[127:112] 	+ vs1[127:112];
						end
					
					vsew_32b 	:
						begin
							vector_result[31:0] 	= vs2[31:0] 	+ vs1[31:0];
							vector_result[63:32] 	= vs2[63:32] 	+ vs1[63:32];
							vector_result[95:64] 	= vs2[95:64] 	+ vs1[95:64];
							vector_result[127:96] 	= vs2[127:96] 	+ vs1[127:96];
						end
					
					vsew_64b 	:
						begin
							vector_result[63:0] 	= vs2[63:0] 	+ vs1[63:0];
							vector_result[127:64] 	= vs2[127:64] 	+ vs1[127:64];
						end
					
					default 	: vector_result = '0;
				endcase
			
			vsub 	:
				case (vsew)
					vsew_8b 	:
						begin
							vector_result[7:0] 		= vs2[7:0] 		- vs1[7:0];
							vector_result[15:8] 	= vs2[15:8] 	- vs1[15:8];
							vector_result[23:16] 	= vs2[23:16] 	- vs1[23:16];
							vector_result[31:24] 	= vs2[31:24] 	- vs1[31:24];
							vector_result[39:32] 	= vs2[39:32] 	- vs1[39:32];
							vector_result[47:40] 	= vs2[47:40] 	- vs1[47:40];
							vector_result[55:48] 	= vs2[55:48] 	- vs1[55:48];
							vector_result[63:56] 	= vs2[63:56] 	- vs1[63:56];
							vector_result[71:64] 	= vs2[71:64] 	- vs1[71:64];
							vector_result[79:72] 	= vs2[79:72] 	- vs1[79:72];
							vector_result[87:80] 	= vs2[87:80] 	- vs1[87:80];
							vector_result[95:88] 	= vs2[95:88] 	- vs1[95:88];
							vector_result[103:96] 	= vs2[103:96] 	- vs1[103:96];
							vector_result[111:104] 	= vs2[111:104] 	- vs1[111:104];
							vector_result[119:112] 	= vs2[119:112] 	- vs1[119:112];
							vector_result[127:120] 	= vs2[127:120] 	- vs1[127:120];
						end
					
					vsew_16b 	:
						begin
							vector_result[15:0] 	= vs2[15:0] 	- vs1[15:0];
							vector_result[31:16] 	= vs2[31:16] 	- vs1[31:16];
							vector_result[47:32] 	= vs2[47:32] 	- vs1[47:32];
							vector_result[63:48] 	= vs2[63:48] 	- vs1[63:48];
							vector_result[79:64] 	= vs2[79:64] 	- vs1[79:64];
							vector_result[95:80] 	= vs2[95:80] 	- vs1[95:80];
							vector_result[111:96] 	= vs2[111:96] 	- vs1[111:96];
							vector_result[127:112] 	= vs2[127:112] 	- vs1[127:112];
						end
					
					vsew_32b 	:
						begin
							vector_result[31:0] 	= vs2[31:0] 	- vs1[31:0];
							vector_result[63:32] 	= vs2[63:32] 	- vs1[63:32];
							vector_result[95:64] 	= vs2[95:64] 	- vs1[95:64];
							vector_result[127:96] 	= vs2[127:96] 	- vs1[127:96];
						end
					
					vsew_64b 	:
						begin
							vector_result[63:0] 	= vs2[63:0] 	- vs1[63:0];
							vector_result[127:64] 	= vs2[127:64] 	- vs1[127:64];
						end
					
					default 	: vector_result = '0;
				endcase
			
			vrsub 	:
				case (vsew)
					vsew_8b 	:
						begin
							vector_result[7:0] 		= vs1[7:0] 		- vs2[7:0];
							vector_result[15:8] 	= vs1[15:8] 	- vs2[15:8];
							vector_result[23:16] 	= vs1[23:16] 	- vs2[23:16];
							vector_result[31:24] 	= vs1[31:24] 	- vs2[31:24];
							vector_result[39:32] 	= vs1[39:32] 	- vs2[39:32];
							vector_result[47:40] 	= vs1[47:40] 	- vs2[47:40];
							vector_result[55:48] 	= vs1[55:48] 	- vs2[55:48];
							vector_result[63:56] 	= vs1[63:56] 	- vs2[63:56];
							vector_result[71:64] 	= vs1[71:64] 	- vs2[71:64];
							vector_result[79:72] 	= vs1[79:72] 	- vs2[79:72];
							vector_result[87:80] 	= vs1[87:80] 	- vs2[87:80];
							vector_result[95:88] 	= vs1[95:88] 	- vs2[95:88];
							vector_result[103:96] 	= vs1[103:96] 	- vs2[103:96];
							vector_result[111:104] 	= vs1[111:104] 	- vs2[111:104];
							vector_result[119:112] 	= vs1[119:112] 	- vs2[119:112];
							vector_result[127:120] 	= vs1[127:120] 	- vs2[127:120];
						end
					
					vsew_16b 	:
						begin
							vector_result[15:0] 	= vs1[15:0] 	- vs2[15:0];
							vector_result[31:16] 	= vs1[31:16] 	- vs2[31:16];
							vector_result[47:32] 	= vs1[47:32] 	- vs2[47:32];
							vector_result[63:48] 	= vs1[63:48] 	- vs2[63:48];
							vector_result[79:64] 	= vs1[79:64] 	- vs2[79:64];
							vector_result[95:80] 	= vs1[95:80] 	- vs2[95:80];
							vector_result[111:96] 	= vs1[111:96] 	- vs2[111:96];
							vector_result[127:112] 	= vs1[127:112] 	- vs2[127:112];
						end
					
					vsew_32b 	:
						begin
							vector_result[31:0] 	= vs1[31:0] 	- vs2[31:0];
							vector_result[63:32] 	= vs1[63:32] 	- vs2[63:32];
							vector_result[95:64] 	= vs1[95:64] 	- vs2[95:64];
							vector_result[127:96] 	= vs1[127:96] 	- vs2[127:96];
						end
					
					vsew_64b 	:
						begin
							vector_result[63:0] 	= vs1[63:0] 	- vs2[63:0];
							vector_result[127:64] 	= vs1[127:64] 	- vs2[127:64];
						end
					
					default 	: vector_result = '0;
				endcase
			
			vadc 	:
				case (vsew)
					vsew_8b 	:
						begin
							vector_result[7:0] 		= vs2[7:0] 		+ vs1[7:0] 		+ vmask[0];
							vector_result[15:8] 	= vs2[15:8] 	+ vs1[15:8] 	+ vmask[1];
							vector_result[23:16] 	= vs2[23:16] 	+ vs1[23:16] 	+ vmask[2];
							vector_result[31:24] 	= vs2[31:24] 	+ vs1[31:24] 	+ vmask[3];
							vector_result[39:32] 	= vs2[39:32] 	+ vs1[39:32] 	+ vmask[4];
							vector_result[47:40] 	= vs2[47:40] 	+ vs1[47:40] 	+ vmask[5];
							vector_result[55:48] 	= vs2[55:48] 	+ vs1[55:48] 	+ vmask[6];
							vector_result[63:56] 	= vs2[63:56] 	+ vs1[63:56] 	+ vmask[7];
							vector_result[71:64] 	= vs2[71:64] 	+ vs1[71:64] 	+ vmask[8];
							vector_result[79:72] 	= vs2[79:72] 	+ vs1[79:72] 	+ vmask[9];
							vector_result[87:80] 	= vs2[87:80] 	+ vs1[87:80] 	+ vmask[10];
							vector_result[95:88] 	= vs2[95:88] 	+ vs1[95:88] 	+ vmask[11];
							vector_result[103:96] 	= vs2[103:96] 	+ vs1[103:96] 	+ vmask[12];
							vector_result[111:104] 	= vs2[111:104] 	+ vs1[111:104] 	+ vmask[13];
							vector_result[119:112] 	= vs2[119:112] 	+ vs1[119:112] 	+ vmask[14];
							vector_result[127:120] 	= vs2[127:120] 	+ vs1[127:120] 	+ vmask[15];
						end
					
					vsew_16b 	:
						begin
							vector_result[15:0] 	= vs2[15:0] 	+ vs1[15:0] 	+ vmask[0];
							vector_result[31:16] 	= vs2[31:16] 	+ vs1[31:16] 	+ vmask[1];
							vector_result[47:32] 	= vs2[47:32] 	+ vs1[47:32] 	+ vmask[2];
							vector_result[63:48] 	= vs2[63:48] 	+ vs1[63:48] 	+ vmask[3];
							vector_result[79:64] 	= vs2[79:64] 	+ vs1[79:64] 	+ vmask[4];
							vector_result[95:80] 	= vs2[95:80] 	+ vs1[95:80] 	+ vmask[5];
							vector_result[111:96] 	= vs2[111:96] 	+ vs1[111:96] 	+ vmask[6];
							vector_result[127:112] 	= vs2[127:112] 	+ vs1[127:112] 	+ vmask[7];
						end
					
					vsew_32b 	:
						begin
							vector_result[31:0] 	= vs2[31:0] 	+ vs1[31:0] 	+ vmask[0];
							vector_result[63:32] 	= vs2[63:32] 	+ vs1[63:32] 	+ vmask[1];
							vector_result[95:64] 	= vs2[95:64] 	+ vs1[95:64] 	+ vmask[2];
							vector_result[127:96] 	= vs2[127:96] 	+ vs1[127:96]	+ vmask[3];
						end
					
					vsew_64b 	:
						begin
							vector_result[63:0] 	= vs2[63:0] 	+ vs1[63:0] 	+ vmask[0];
							vector_result[127:64] 	= vs2[127:64] 	+ vs1[127:64] 	+ vmask[1];
						end
					
					default 	: vector_result = '0;
				endcase

			vsbc 	:
				case (vsew)
					vsew_8b 	:
						begin
							vector_result[7:0] 		= vs2[7:0] 		- vs1[7:0] 		- vmask[0];
							vector_result[15:8] 	= vs2[15:8] 	- vs1[15:8] 	- vmask[1];
							vector_result[23:16] 	= vs2[23:16] 	- vs1[23:16]	- vmask[2];
							vector_result[31:24] 	= vs2[31:24] 	- vs1[31:24]	- vmask[3];
							vector_result[39:32] 	= vs2[39:32] 	- vs1[39:32]	- vmask[4];
							vector_result[47:40] 	= vs2[47:40] 	- vs1[47:40]	- vmask[5];
							vector_result[55:48] 	= vs2[55:48] 	- vs1[55:48]	- vmask[6];
							vector_result[63:56] 	= vs2[63:56] 	- vs1[63:56]	- vmask[7];
							vector_result[71:64] 	= vs2[71:64] 	- vs1[71:64]	- vmask[8];
							vector_result[79:72] 	= vs2[79:72] 	- vs1[79:72]	- vmask[9];
							vector_result[87:80] 	= vs2[87:80] 	- vs1[87:80]	- vmask[10];
							vector_result[95:88] 	= vs2[95:88] 	- vs1[95:88]	- vmask[11];
							vector_result[103:96] 	= vs2[103:96] 	- vs1[103:96]	- vmask[12];
							vector_result[111:104] 	= vs2[111:104] 	- vs1[111:104]	- vmask[13];
							vector_result[119:112] 	= vs2[119:112] 	- vs1[119:112]	- vmask[14];
							vector_result[127:120] 	= vs2[127:120] 	- vs1[127:120]	- vmask[15];
						end
					
					vsew_16b 	:
						begin
							vector_result[15:0] 	= vs2[15:0] 	- vs1[15:0]		- vmask[0];
							vector_result[31:16] 	= vs2[31:16] 	- vs1[31:16]	- vmask[1];
							vector_result[47:32] 	= vs2[47:32] 	- vs1[47:32]	- vmask[2];
							vector_result[63:48] 	= vs2[63:48] 	- vs1[63:48]	- vmask[3];
							vector_result[79:64] 	= vs2[79:64] 	- vs1[79:64]	- vmask[4];
							vector_result[95:80] 	= vs2[95:80] 	- vs1[95:80]	- vmask[5];
							vector_result[111:96] 	= vs2[111:96] 	- vs1[111:96]	- vmask[6];
							vector_result[127:112] 	= vs2[127:112] 	- vs1[127:112]	- vmask[7];
						end
					
					vsew_32b 	:
						begin
							vector_result[31:0] 	= vs2[31:0] 	- vs1[31:0]		- vmask[0];
							vector_result[63:32] 	= vs2[63:32] 	- vs1[63:32]	- vmask[1];
							vector_result[95:64] 	= vs2[95:64] 	- vs1[95:64]	- vmask[2];
							vector_result[127:96] 	= vs2[127:96] 	- vs1[127:96]	- vmask[3];
						end
					
					vsew_64b 	:
						begin
							vector_result[63:0] 	= vs2[63:0] 	- vs1[63:0]		- vmask[0];
							vector_result[127:64] 	= vs2[127:64] 	- vs1[127:64]	- vmask[1];
						end
					
					default 	: vector_result = '0;
				endcase

			vmadc 	:
				case (vsew)
					vsew_8b 	:
						begin
							vmadc_8b[0] 	= vs2[7:0] 		+ vs1[7:0];
							vmadc_8b[1] 	= vs2[15:8] 	+ vs1[15:8];
							vmadc_8b[2] 	= vs2[23:16] 	+ vs1[23:16];
							vmadc_8b[3] 	= vs2[31:24] 	+ vs1[31:24];
							vmadc_8b[4] 	= vs2[39:32] 	+ vs1[39:32];
							vmadc_8b[5] 	= vs2[47:40] 	+ vs1[47:40];
							vmadc_8b[6] 	= vs2[55:48] 	+ vs1[55:48];
							vmadc_8b[7] 	= vs2[63:56] 	+ vs1[63:56];
							vmadc_8b[8] 	= vs2[71:64] 	+ vs1[71:64];
							vmadc_8b[9] 	= vs2[79:72] 	+ vs1[79:72];
							vmadc_8b[10] 	= vs2[87:80] 	+ vs1[87:80];
							vmadc_8b[11] 	= vs2[95:88] 	+ vs1[95:88];
							vmadc_8b[12] 	= vs2[103:96] 	+ vs1[103:96];
							vmadc_8b[13] 	= vs2[111:104] 	+ vs1[111:104];
							vmadc_8b[14] 	= vs2[119:112] 	+ vs1[119:112];
							vmadc_8b[15] 	= vs2[127:120] 	+ vs1[127:120];

							vector_result 	= {	{112{1'b0}}, 		vmadc_8b[15][8], 	vmadc_8b[14][8], 	vmadc_8b[13][8],
												vmadc_8b[12][8], 	vmadc_8b[11][8], 	vmadc_8b[10][8], 	vmadc_8b[9][8],
												vmadc_8b[8][8], 	vmadc_8b[7][8], 	vmadc_8b[6][8], 	vmadc_8b[5][8],
												vmadc_8b[4][8], 	vmadc_8b[3][8], 	vmadc_8b[2][8], 	vmadc_8b[1][8],
												vmadc_8b[0][8]};
						end
					
					vsew_16b 	:
						begin
							vmadc_16b[0] 	= vs2[15:0] 	+ vs1[15:0];
							vmadc_16b[1] 	= vs2[31:16] 	+ vs1[31:16];
							vmadc_16b[2] 	= vs2[47:32] 	+ vs1[47:32];
							vmadc_16b[3] 	= vs2[63:48] 	+ vs1[63:48];
							vmadc_16b[4] 	= vs2[79:64] 	+ vs1[79:64];
							vmadc_16b[5] 	= vs2[95:80] 	+ vs1[95:80];
							vmadc_16b[6] 	= vs2[111:96] 	+ vs1[111:96];
							vmadc_16b[7] 	= vs2[127:112] 	+ vs1[127:112];

							vector_result 	= {	{120{1'b0}}, 		vmadc_16b[7][16], 	vmadc_16b[6][16], 	vmadc_16b[5][16],
												vmadc_16b[4][16], 	vmadc_16b[3][16], 	vmadc_16b[2][16], 	vmadc_16b[1][16],
												vmadc_16b[0][16]};
						end
					
					vsew_32b 	:
						begin
							vmadc_32b[0] 	= vs2[31:0] 	+ vs1[31:0];
							vmadc_32b[1] 	= vs2[63:32] 	+ vs1[63:32];
							vmadc_32b[2] 	= vs2[95:64] 	+ vs1[95:64];
							vmadc_32b[3] 	= vs2[127:96] 	+ vs1[127:96];

							vector_result 	= {	{124{1'b0}}, 		vmadc_32b[3][32], 	vmadc_32b[2][32], 	vmadc_32b[1][32],
												vmadc_32b[0][32]};
						end
					
					vsew_64b 	:
						begin
							vmadc_64b[0] 	= vs2[63:0] 	+ vs1[63:0];
							vmadc_64b[1] 	= vs2[127:64] 	+ vs1[127:64];

							vector_result 	= {	{126{1'b0}}, 		vmadc_64b[1][64], 	vmadc_64b[0][64]};
						end
					
					default 	: vector_result = '0;
				endcase

			vmadc_m :
				case (vsew)
					vsew_8b 	:
						begin
							vmadc_8b[0] 	= vs2[7:0] 		+ vs1[7:0] 		+ vmask[0];
							vmadc_8b[1] 	= vs2[15:8] 	+ vs1[15:8]		+ vmask[1];
							vmadc_8b[2] 	= vs2[23:16] 	+ vs1[23:16]	+ vmask[2];
							vmadc_8b[3] 	= vs2[31:24] 	+ vs1[31:24]	+ vmask[3];
							vmadc_8b[4] 	= vs2[39:32] 	+ vs1[39:32]	+ vmask[4];
							vmadc_8b[5] 	= vs2[47:40] 	+ vs1[47:40]	+ vmask[5];
							vmadc_8b[6] 	= vs2[55:48] 	+ vs1[55:48]	+ vmask[6];
							vmadc_8b[7] 	= vs2[63:56] 	+ vs1[63:56]	+ vmask[7];
							vmadc_8b[8] 	= vs2[71:64] 	+ vs1[71:64]	+ vmask[8];
							vmadc_8b[9] 	= vs2[79:72] 	+ vs1[79:72]	+ vmask[9];
							vmadc_8b[10] 	= vs2[87:80] 	+ vs1[87:80]	+ vmask[10];
							vmadc_8b[11] 	= vs2[95:88] 	+ vs1[95:88]	+ vmask[11];
							vmadc_8b[12] 	= vs2[103:96] 	+ vs1[103:96]	+ vmask[12];
							vmadc_8b[13] 	= vs2[111:104] 	+ vs1[111:104]	+ vmask[13];
							vmadc_8b[14] 	= vs2[119:112] 	+ vs1[119:112]	+ vmask[14];
							vmadc_8b[15] 	= vs2[127:120] 	+ vs1[127:120]	+ vmask[15];

							vector_result 	= {	{112{1'b0}}, 		vmadc_8b[15][8], 	vmadc_8b[14][8], 	vmadc_8b[13][8],
												vmadc_8b[12][8], 	vmadc_8b[11][8], 	vmadc_8b[10][8], 	vmadc_8b[9][8],
												vmadc_8b[8][8], 	vmadc_8b[7][8], 	vmadc_8b[6][8], 	vmadc_8b[5][8],
												vmadc_8b[4][8], 	vmadc_8b[3][8], 	vmadc_8b[2][8], 	vmadc_8b[1][8],
												vmadc_8b[0][8]};
						end
					
					vsew_16b 	:
						begin
							vmadc_16b[0] 	= vs2[15:0] 	+ vs1[15:0] 	+ vmask[0];
							vmadc_16b[1] 	= vs2[31:16] 	+ vs1[31:16]	+ vmask[1];
							vmadc_16b[2] 	= vs2[47:32] 	+ vs1[47:32]	+ vmask[2];
							vmadc_16b[3] 	= vs2[63:48] 	+ vs1[63:48]	+ vmask[3];
							vmadc_16b[4] 	= vs2[79:64] 	+ vs1[79:64]	+ vmask[4];
							vmadc_16b[5] 	= vs2[95:80] 	+ vs1[95:80]	+ vmask[5];
							vmadc_16b[6] 	= vs2[111:96] 	+ vs1[111:96]	+ vmask[6];
							vmadc_16b[7] 	= vs2[127:112] 	+ vs1[127:112]	+ vmask[7];

							vector_result 	= {	{120{1'b0}}, 		vmadc_16b[7][16], 	vmadc_16b[6][16], 	vmadc_16b[5][16],
												vmadc_16b[4][16], 	vmadc_16b[3][16], 	vmadc_16b[2][16], 	vmadc_16b[1][16],
												vmadc_16b[0][16]};
						end
					
					vsew_32b 	:
						begin
							vmadc_32b[0] 	= vs2[31:0] 	+ vs1[31:0] 	+ vmask[0];
							vmadc_32b[1] 	= vs2[63:32] 	+ vs1[63:32]	+ vmask[1];
							vmadc_32b[2] 	= vs2[95:64] 	+ vs1[95:64]	+ vmask[2];
							vmadc_32b[3] 	= vs2[127:96] 	+ vs1[127:96]	+ vmask[3];

							vector_result 	= {	{124{1'b0}}, 		vmadc_32b[3][32], 	vmadc_32b[2][32], 	vmadc_32b[1][32],
												vmadc_32b[0][32]};
						end
					
					vsew_64b 	:
						begin
							vmadc_64b[0] 	= vs2[63:0] 	+ vs1[63:0] 	+ vmask[0];
							vmadc_64b[1] 	= vs2[127:64] 	+ vs1[127:64] 	+ vmask[1];

							vector_result 	= {	{126{1'b0}}, 		vmadc_64b[1][64], 	vmadc_64b[0][64]};
						end
					
					default 	: vector_result = '0;
				endcase

			vmsbc 	:
				case (vsew)
					vsew_8b 	:
						begin
							vmsbc_8b[0] 	= vs2[7:0] 		- vs1[7:0];
							vmsbc_8b[1] 	= vs2[15:8] 	- vs1[15:8];
							vmsbc_8b[2] 	= vs2[23:16] 	- vs1[23:16];
							vmsbc_8b[3] 	= vs2[31:24] 	- vs1[31:24];
							vmsbc_8b[4] 	= vs2[39:32] 	- vs1[39:32];
							vmsbc_8b[5] 	= vs2[47:40] 	- vs1[47:40];
							vmsbc_8b[6] 	= vs2[55:48] 	- vs1[55:48];
							vmsbc_8b[7] 	= vs2[63:56] 	- vs1[63:56];
							vmsbc_8b[8] 	= vs2[71:64] 	- vs1[71:64];
							vmsbc_8b[9] 	= vs2[79:72] 	- vs1[79:72];
							vmsbc_8b[10] 	= vs2[87:80] 	- vs1[87:80];
							vmsbc_8b[11] 	= vs2[95:88] 	- vs1[95:88];
							vmsbc_8b[12] 	= vs2[103:96] 	- vs1[103:96];
							vmsbc_8b[13] 	= vs2[111:104] 	- vs1[111:104];
							vmsbc_8b[14] 	= vs2[119:112] 	- vs1[119:112];
							vmsbc_8b[15] 	= vs2[127:120] 	- vs1[127:120];

							vector_result 	= {	{112{1'b0}}, 		vmsbc_8b[15][8], 	vmsbc_8b[14][8], 	vmsbc_8b[13][8],
												vmsbc_8b[12][8], 	vmsbc_8b[11][8], 	vmsbc_8b[10][8], 	vmsbc_8b[9][8],
												vmsbc_8b[8][8], 	vmsbc_8b[7][8], 	vmsbc_8b[6][8], 	vmsbc_8b[5][8],
												vmsbc_8b[4][8], 	vmsbc_8b[3][8], 	vmsbc_8b[2][8], 	vmsbc_8b[1][8],
												vmsbc_8b[0][8]};
						end
					
					vsew_16b 	:
						begin
							vmsbc_16b[0] 	= vs2[15:0] 	- vs1[15:0];
							vmsbc_16b[1] 	= vs2[31:16] 	- vs1[31:16];
							vmsbc_16b[2] 	= vs2[47:32] 	- vs1[47:32];
							vmsbc_16b[3] 	= vs2[63:48] 	- vs1[63:48];
							vmsbc_16b[4] 	= vs2[79:64] 	- vs1[79:64];
							vmsbc_16b[5] 	= vs2[95:80] 	- vs1[95:80];
							vmsbc_16b[6] 	= vs2[111:96] 	- vs1[111:96];
							vmsbc_16b[7] 	= vs2[127:112] 	- vs1[127:112];

							vector_result 	= {	{120{1'b0}}, 		vmsbc_16b[7][16], 	vmsbc_16b[6][16], 	vmsbc_16b[5][16],
												vmsbc_16b[4][16], 	vmsbc_16b[3][16], 	vmsbc_16b[2][16], 	vmsbc_16b[1][16],
												vmsbc_16b[0][16]};
						end
					
					vsew_32b 	:
						begin
							vmsbc_32b[0] 	= vs2[31:0] 	- vs1[31:0];
							vmsbc_32b[1] 	= vs2[63:32] 	- vs1[63:32];
							vmsbc_32b[2] 	= vs2[95:64] 	- vs1[95:64];
							vmsbc_32b[3] 	= vs2[127:96] 	- vs1[127:96];

							vector_result 	= {	{124{1'b0}}, 		vmsbc_32b[3][32], 	vmsbc_32b[2][32], 	vmsbc_32b[1][32],
												vmsbc_32b[0][32]};
						end
					
					vsew_64b 	:
						begin
							vmsbc_64b[0] 	= vs2[63:0] 	- vs1[63:0];
							vmsbc_64b[1] 	= vs2[127:64] 	- vs1[127:64];

							vector_result 	= {	{126{1'b0}}, 		vmsbc_64b[1][64], 	vmsbc_64b[0][64]};
						end
					
					default 	: vector_result = '0;
				endcase

			vmsbc_m :
				case (vsew)
					vsew_8b 	:
						begin
							vmsbc_8b[0] 	= vs2[7:0] 		- vs1[7:0] 		- vmask[0];
							vmsbc_8b[1] 	= vs2[15:8] 	- vs1[15:8]		- vmask[1];
							vmsbc_8b[2] 	= vs2[23:16] 	- vs1[23:16]	- vmask[2];
							vmsbc_8b[3] 	= vs2[31:24] 	- vs1[31:24]	- vmask[3];
							vmsbc_8b[4] 	= vs2[39:32] 	- vs1[39:32]	- vmask[4];
							vmsbc_8b[5] 	= vs2[47:40] 	- vs1[47:40]	- vmask[5];
							vmsbc_8b[6] 	= vs2[55:48] 	- vs1[55:48]	- vmask[6];
							vmsbc_8b[7] 	= vs2[63:56] 	- vs1[63:56]	- vmask[7];
							vmsbc_8b[8] 	= vs2[71:64] 	- vs1[71:64]	- vmask[8];
							vmsbc_8b[9] 	= vs2[79:72] 	- vs1[79:72]	- vmask[9];
							vmsbc_8b[10] 	= vs2[87:80] 	- vs1[87:80]	- vmask[10];
							vmsbc_8b[11] 	= vs2[95:88] 	- vs1[95:88]	- vmask[11];
							vmsbc_8b[12] 	= vs2[103:96] 	- vs1[103:96]	- vmask[12];
							vmsbc_8b[13] 	= vs2[111:104] 	- vs1[111:104]	- vmask[13];
							vmsbc_8b[14] 	= vs2[119:112] 	- vs1[119:112]	- vmask[14];
							vmsbc_8b[15] 	= vs2[127:120] 	- vs1[127:120]	- vmask[15];

							vector_result 	= {	{112{1'b0}}, 		vmsbc_8b[15][8], 	vmsbc_8b[14][8], 	vmsbc_8b[13][8],
												vmsbc_8b[12][8], 	vmsbc_8b[11][8], 	vmsbc_8b[10][8], 	vmsbc_8b[9][8],
												vmsbc_8b[8][8], 	vmsbc_8b[7][8], 	vmsbc_8b[6][8], 	vmsbc_8b[5][8],
												vmsbc_8b[4][8], 	vmsbc_8b[3][8], 	vmsbc_8b[2][8], 	vmsbc_8b[1][8],
												vmsbc_8b[0][8]};
						end
					
					vsew_16b 	:
						begin
							vmsbc_16b[0] 	= vs2[15:0] 	- vs1[15:0] 	- vmask[0];
							vmsbc_16b[1] 	= vs2[31:16] 	- vs1[31:16]	- vmask[1];
							vmsbc_16b[2] 	= vs2[47:32] 	- vs1[47:32]	- vmask[2];
							vmsbc_16b[3] 	= vs2[63:48] 	- vs1[63:48]	- vmask[3];
							vmsbc_16b[4] 	= vs2[79:64] 	- vs1[79:64]	- vmask[4];
							vmsbc_16b[5] 	= vs2[95:80] 	- vs1[95:80]	- vmask[5];
							vmsbc_16b[6] 	= vs2[111:96] 	- vs1[111:96]	- vmask[6];
							vmsbc_16b[7] 	= vs2[127:112] 	- vs1[127:112]	- vmask[7];

							vector_result 	= {	{120{1'b0}}, 		vmsbc_16b[7][16], 	vmsbc_16b[6][16], 	vmsbc_16b[5][16],
												vmsbc_16b[4][16], 	vmsbc_16b[3][16], 	vmsbc_16b[2][16], 	vmsbc_16b[1][16],
												vmsbc_16b[0][16]};
						end
					
					vsew_32b 	:
						begin
							vmsbc_32b[0] 	= vs2[31:0] 	- vs1[31:0] 	- vmask[0];
							vmsbc_32b[1] 	= vs2[63:32] 	- vs1[63:32]	- vmask[1];
							vmsbc_32b[2] 	= vs2[95:64] 	- vs1[95:64]	- vmask[2];
							vmsbc_32b[3] 	= vs2[127:96] 	- vs1[127:96]	- vmask[3];

							vector_result 	= {	{124{1'b0}}, 		vmsbc_32b[3][32], 	vmsbc_32b[2][32], 	vmsbc_32b[1][32],
												vmsbc_32b[0][32]};
						end
					
					vsew_64b 	:
						begin
							vmsbc_64b[0] 	= vs2[63:0] 	- vs1[63:0] 	- vmask[0];
							vmsbc_64b[1] 	= vs2[127:64] 	- vs1[127:64]	- vmask[1];

							vector_result 	= {	{126{1'b0}}, 		vmsbc_64b[1][64], 	vmsbc_64b[0][64]};
						end
					
					default 	: vector_result = '0;
				endcase

			default : vector_result = '0;
		endcase
		
		return vector_result;
	endfunction

endpackage