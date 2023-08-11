`define vsew_8b     2'b00
`define vsew_16b    2'b01
`define vsew_32b    2'b10
`define vsew_64b    2'b11

module vector_addition_unit
(
    input                   request_i,

    input 		[127:0] 	vs2_i,
	input 		[127:0]     vs1_i,
	
	input 		[15:0] 	    vmask_i,
	
	input 		[1:0] 	    vsew_i,

    input				    reversed_i,
	input 				    add_sub_i,
	input				    compute_carry_i,
	input 				    with_carry_borrow_i,

	output reg 	[127:0] 	vd_o
);

    reg [7:0] vmask_effective_0;
    reg [7:0] vmask_effective_1;

	wire [127:0] vd_o_w;

    // Drive Output Port With Computed Carry
    // Values Or An Add/Sub Operation's Result
	always @ (*)
        if (request_i)
            if (compute_carry_i)
                case (vsew_i)
                    `vsew_8b     : vd_o = {{112{1'b0}}, vd_o_w[71:64],   vd_o_w[7:0]};
                    `vsew_16b    : vd_o = {{120{1'b0}}, vd_o_w[67:64],   vd_o_w[3:0]};
                    `vsew_32b    : vd_o = {{124{1'b0}}, vd_o_w[65:64],   vd_o_w[1:0]};
                    `vsew_64b    : vd_o = {{126{1'b0}}, vd_o_w[64],      vd_o_w[0]};
                endcase

            else
		        vd_o = vd_o_w;
                
        else    
            vd_o = 128'b0;

    // Choose Effective Mask Values For Each
    // vector_adder_64b Instance, According
    // To SEW Setting
    always @ (*)
        case (vsew_i)
            2'b00 :
                begin
                    vmask_effective_0 = vmask_i[7:0];
                    vmask_effective_1 = vmask_i[15:8];
                end

            2'b01 :
                begin
                    vmask_effective_0 = {{4{1'b0}}, vmask_i[3:0]};
                    vmask_effective_1 = {{4{1'b0}}, vmask_i[7:4]};
                end

            2'b10 :
                begin
                    vmask_effective_0 = {{6{1'b0}}, vmask_i[1:0]};
                    vmask_effective_1 = {{6{1'b0}}, vmask_i[3:2]};
                end

            2'b11 :
                begin
                    vmask_effective_0 = {{7{1'b0}}, vmask_i[0]};
                    vmask_effective_1 = {{7{1'b0}}, vmask_i[1]};
                end
        endcase

    vector_adder_64b vector_adder_64b_instance_0
    (
        .vs2_i                  (vs2_i[63:0]),
        .vs1_i                  (vs1_i[63:0]),

        .vmask_i                (vmask_effective_0),

        .vsew_i                 (vsew_i),

        .reversed_i             (reversed_i),
        .add_sub_i              (add_sub_i),
        .compute_carry_i        (compute_carry_i),
        .with_carry_borrow_i    (with_carry_borrow_i),

        .vd_o                   (vd_o_w[63:0]),
        .carry_o                ()
    );

    vector_adder_64b vector_adder_64b_instance_1
    (
        .vs2_i                  (vs2_i[127:64]),
        .vs1_i                  (vs1_i[127:64]),

        .vmask_i                (vmask_effective_1),

        .vsew_i                 (vsew_i),

        .reversed_i             (reversed_i),
        .add_sub_i              (add_sub_i),
        .compute_carry_i        (compute_carry_i),
        .with_carry_borrow_i    (with_carry_borrow_i),

        .vd_o                   (vd_o_w[127:64]),
        .carry_o                ()
    );

endmodule