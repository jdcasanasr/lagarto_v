
import lagarto_fpu_pkg::*;

module classifier_SFP (
  input		sfp_encoding_t	sfp_operand_i,
  output	fp_class_t		fp_class_o
);

fp_class_t fp_class;

logic exp_zero, exp_max;
assign exp_max = &sfp_operand_i.exp; // if all bits are 1s
assign exp_zero = ~(|sfp_operand_i.exp); // if all bits are 0s

logic mnt_zero;
assign mnt_zero = ~(|sfp_operand_i.mnt); // if all bits are 0s

always_comb begin
    if (exp_max) begin
        if (mnt_zero) begin // infinity
            if (sfp_operand_i.sign) begin
                fp_class = NEG_INFINITY;
            end else begin
                fp_class = POS_INFINITY;
            end
        end else begin  // NaN
            if (sfp_operand_i.sign) begin
                fp_class = QNAN;
            end else begin
                fp_class = SNAN;
            end
        end
    end else if (exp_zero) begin
        if (mnt_zero) begin // absolute zero
            if (sfp_operand_i.sign) begin
                fp_class = NEG_ZERO;
            end else begin
                fp_class = POS_ZERO;
            end
        end else begin  // subnormal number
            if (sfp_operand_i.sign) begin
                fp_class = NEG_SUBNORMAL;
            end else begin
                fp_class = POS_SUBNORMAL;
            end
        end
    end else begin  // normalized number
        if (sfp_operand_i.sign) begin
            fp_class = NEG_NORMAL;
        end else begin
            fp_class = POS_NORMAL;
        end
    end
end

assign fp_class_o = fp_class;

endmodule