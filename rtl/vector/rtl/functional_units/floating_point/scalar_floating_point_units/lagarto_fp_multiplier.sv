/*******************************************************************************************************************/
/*| TITLE      |  LAGARTO FPU: Floating-point Multiplication (4 stages)                                           |*/
/*|------------|--------------------------------------------------------------------------------------------------|*/
/*| FILE       |  lagarto_fp_multiplier.sv                                                                        |*/
/*|------------|--------------------------------------------------------------------------------------------------|*/
/*| LANGUAGE   |  System Verilog                                                                                  |*/
/*|------------|--------------------------------------------------------------------------------------------------|*/
/*| PROJECT    |  LAGARTO : https://www.proyectos.cic.ipn.mx/index.php/lagarto                                    |*/
/*|            |  BSC Projects (add here new projects)                                                            |*/
/*|------------|--------------------------------------------------------------------------------------------------|*/
/*| REVISION   |  0.1 - MIPS FPU implementation Jun 2015                                                          |*/
/*|            |  0.2 - RISCV FPU Update - November 2021                                                          |*/
/*|            |                                                                                                  |*/
/*|---------------------------------------------------------------------------------------------------------------|*/
/*| AUTHOR(S)                                   | E-MAIL(S)                                                       |*/
/*|---------------------------------------------|-----------------------------------------------------------------|*/
/*| (CR) Cristóbal Ramírez Lazo                 | cristobal.ramirez@bsc.es, cristobal.ramirez.lazo@gmail.com      |*/
/*|---------------------------------------------|-----------------------------------------------------------------|*/
/*| COLABORATOR(S)                              | E-MAIL(S)                                                       |*/
/*|---------------------------------------------|-----------------------------------------------------------------|*/
/*|                                             |                                                                 |*/
/*|                                             |                                                                 |*/
/*|---------------------------------------------------------------------------------------------------------------|*/
/*| Copyright (c) 2021                                                                                            |*/
/*|     Centro de Investigación en Computación - IPN, Mexico,                                                     |*/
/*|     Barcelona Supercomputing Center - BSC, Spain.                                                             |*/
/*| All rights reserved. See LICENCE for license details.                                                         |*/
/*******************************************************************************************************************/

import lagarto_fpu_pkg::*;

module lagarto_fp_multiplier #(
  /*Future implementations will support parameterizable width*/
  parameter int unsigned WIDTH        = 64 
) (
  input logic                               clk_i,
  input logic                               rstn_i,
  input logic                               flush_i,

  // Input signals
  input  logic                              op_valid_i,
  input lagarto_fpu_pkg::fp_operation_t     op_i,
  input lagarto_fpu_pkg::fp_fmt             fmt_i,
  input lagarto_fpu_pkg::fp_rounding_mode   rnd_mode_i,
  input logic [WIDTH-1:0]                   operand_a_i,
  input logic [WIDTH-1:0]                   operand_b_i,
  input lagarto_fpu_pkg::fp_tag_id          tag_id_i,

  // Output signals
  output logic                              op_ready_o,
  output logic [WIDTH-1:0]                  result_o,
  output lagarto_fpu_pkg::fp_status_flags   status_o,
  output lagarto_fpu_pkg::fp_tag_id         tag_id_o,
  output logic                              busy_o,
  output logic	[1:0]						cycle_counter
);

logic	stg1_start_op;
logic	stg2_start_op;
logic	stg3_start_op;

reg		stg1_op_valid;
reg		stg2_op_valid;
reg		stg3_op_valid;

// TODO: he empezado a definir structuras, pero falta ponerlo en todo el código.
fp_info inst_info;
fp_status_flags status_flags;

assign inst_info.valid_op = op_valid_i;
assign inst_info.op = op_i;
assign inst_info.rm = rnd_mode_i;
assign inst_info.tag_id = tag_id_i;
assign inst_info.operand_a = operand_a_i;
assign inst_info.operand_b = operand_b_i;

lagarto_fp_multiplier_operand_check  fp_multiplier_operand_check(
  .op_valid_i           (inst_info.valid_op),
  .operand_a_i          (inst_info.operand_a),
  .operand_b_i          (inst_info.operand_b),
  .invalid_operation_o  (status_flags.NV),
  .is_snan_o            (inst_info.is_snan),
  .is_qnan_o            (inst_info.is_qnan),
  .is_zero_o             (inst_info.is_zero),
  .is_inf_o             (inst_info.is_inf)
);

// This FP status flags are set in the last stage, in the meantime are set to zero
assign status_flags.DZ = 1'b0;
assign status_flags.OF = 1'b0;
assign status_flags.UF = 1'b0;
assign status_flags.NX = 1'b0;

assign inst_info.is_nan = inst_info.is_snan || inst_info.is_qnan;
assign inst_info.is_boxed = 1'b0;

logic [10:0]exponent_a, exponent_b;
logic [51:0] mantissa_a, mantissa_b;
logic sign_a, sign_b;

// Separación en signo, exponente y mantissa
assign exponent_a = operand_a_i[62:52];
assign exponent_b = operand_b_i[62:52];
assign mantissa_a = operand_a_i[51:0];
assign mantissa_b = operand_b_i[51:0];
assign sign_a=operand_a_i[63];
assign sign_b=operand_b_i[63];

logic sign;
assign sign = sign_a ^ sign_b;

logic operand_a_subnormal;
logic operand_b_subnormal;
//Verificar que los datos estén normalizados
//Basta con checar el exponente , si es zero significa que la mantissa no es cero , de lo contrario en la primera
//etapa lo hubiese marcado como zero 
assign operand_a_subnormal = ~(|exponent_a);
assign operand_b_subnormal = ~(|exponent_b);

logic subnormal_input;
assign subnormal_input = operand_a_subnormal | operand_b_subnormal;

logic [11:0] exponent, exponent1;
assign exponent = {1'b0,exponent_a} + {1'b0,exponent_b};
assign exponent1 = subnormal_input ? exponent - 12'b001111111110 : exponent - 12'b001111111111; // -bias

logic tiny;
assign tiny = exponent1[11]; // Si se prende este bit significa que el numero es muy pequeño y el resultado será 0

//----------------------------------------------------------------------------------------------------------
// Cuando multiplicamos un normalizado por un desnormalizado    
logic result_subnormal;
assign result_subnormal = operand_b_subnormal ^ operand_a_subnormal; // Solo si uno es subnormal puede ser un resultado valido

//----------------------------------------------------------------------------------------------------------

logic [52:0] mul_a, mul_b;
assign mul_a = {~operand_a_subnormal,mantissa_a};
assign mul_b = {~operand_b_subnormal,mantissa_b};

logic [105:0] result_mul;
logic         result_mul_valid;

lagarto_fp_mantissa_mult mantissa_mult(
    .clk_i          (clk_i),
    .rstn_i         (rstn_i),
    .lock_i         (1'b0),
    .flush_i        (flush_i),
    .op_valid_i     (inst_info.valid_op),
    .src1_i         (mul_a),
    .src2_i         (mul_b),

    .result_valid_o (result_mul_valid),
    .result_data_o  (result_mul)
);

//----------------------------------------------------------------------------------
//      Stage 1 - Register
// ---------------------------------------------------------------------------------

logic           stg1_sign;
logic           stg1_result_subnormal;
logic           stg1_tiny;
logic [11:0]    stg1_exponent;

fp_status_flags stg1_status_flags;
fp_info         stg1_inst_info;

always @(posedge clk_i,negedge rstn_i) begin
  if (!rstn_i) begin
	  stg1_start_op			<= '0;
      stg1_sign             <= '0;
      stg1_result_subnormal <= '0;
      stg1_tiny             <= '0;
      stg1_exponent         <= '0;
      stg1_status_flags     <= '0;
      stg1_inst_info        <= '0;
	  stg1_op_valid			<= '0;
  end else	if(inst_info.valid_op) begin
	  stg1_start_op			<= '1;
      stg1_sign             <= sign;
      stg1_result_subnormal <= result_subnormal;
      stg1_tiny             <= tiny;
      stg1_exponent         <= exponent1;
      stg1_status_flags     <= status_flags;
      stg1_inst_info        <= inst_info;
	  stg1_op_valid			<= inst_info.valid_op; 
  end	else	begin
	  stg1_start_op			<= '0;
	  stg1_sign             <= '0;
      stg1_result_subnormal <= '0;
      stg1_tiny             <= '0;
      stg1_exponent         <= '0;
      stg1_status_flags     <= '0;
      stg1_inst_info        <= '0;
	  stg1_op_valid			<= '0;
  end
end

logic [5:0] numZeros; // Auxiliar
logic NoZero;
lagarto_fp_lzc fp_multiplier_lzc(
  clk_i,
  result_mul[104:41],
  numZeros,
  NoZero
);

logic [10:0] shift_left_valid;
assign shift_left_valid = stg1_exponent > {5'b00000, numZeros} ? {5'b00000,numZeros} : stg1_exponent[10:0] ;

//----------------------------------------------------------------------------------
//      Stage 2 - Register
// ---------------------------------------------------------------------------------
fp_status_flags stg2_status_flags;
fp_info         stg2_inst_info;

logic stg2_sign;
logic stg2_result_subnormal;
logic stg2_tiny;
logic [11:0] stg2_exponent;
logic [5:0]stg2_shift_left_valid;
logic [105:0]stg2_result_mul;

always @(posedge clk_i,negedge rstn_i) begin
  if (!rstn_i) begin
	stg2_start_op			<= '0;
    stg2_sign               <= '0;
    stg2_result_subnormal   <= '0;
    stg2_tiny               <= '0;
    stg2_exponent           <= '0;
    stg2_shift_left_valid   <= '0;
    stg2_result_mul         <= '0;
    stg2_status_flags       <= '0;
    stg2_inst_info          <= '0;
	stg2_op_valid			<= '0;
  end else	if(stg1_op_valid) begin
	stg2_start_op			<= '1;
    stg2_sign               <= stg1_sign;
    stg2_result_subnormal   <= stg1_result_subnormal;
    stg2_tiny               <= stg1_tiny;
    stg2_exponent           <= stg1_exponent;
    stg2_shift_left_valid   <= shift_left_valid[5:0];
    stg2_result_mul         <= result_mul[105:0];
    stg2_status_flags       <= stg1_status_flags;
    stg2_inst_info          <= stg1_inst_info;
	stg2_op_valid			<= stg1_op_valid;
  end	else	begin
		stg2_start_op			<= '0;
		stg2_sign               <= '0;
		stg2_result_subnormal   <= '0;
		stg2_tiny               <= '0;
		stg2_exponent           <= '0;
		stg2_shift_left_valid   <= '0;
		stg2_result_mul         <= '0;
		stg2_status_flags       <= '0;
		stg2_inst_info          <= '0;
		stg2_op_valid			<= '0;
  end
end
//--------------------------------------------------------------------------
logic [11:0] exponent2;
logic [105:0] product_1;

always_comb begin
  case({stg2_result_mul[105], stg2_tiny, stg2_result_subnormal})
  3'b100: begin                               // PostNormalización
        product_1 =  stg2_result_mul[105:0] >> 1'b1;
        exponent2 =  stg2_exponent + 12'b000000000001;
        end
  3'b010: begin                               // Resultado muy pequeño con exponente menor a 0
        product_1 = 106'b0;
        exponent2 = 12'b0;
        end 
  3'b001: begin                           
        product_1 = stg2_result_mul[105:0] << stg2_shift_left_valid[5:0];
        exponent2 = stg2_exponent - {1'b0,stg2_shift_left_valid[5:0]};
        end
  default: begin                           
        product_1 = stg2_result_mul[105:0];
        exponent2 = stg2_exponent;
        end
  endcase   
end


wire [54:0] product;
assign product={product_1[104:52],product_1[51],product_1[50]};

//----------------------------------------------------------------------------------
//      Stage 3 - Register
// ---------------------------------------------------------------------------------
fp_status_flags stg3_status_flags;
fp_info         stg3_inst_info;

reg [54:0] stg3_mantissa;
reg [11:0] stg3_exponent;
reg stg3_sign;

always @(posedge clk_i, negedge rstn_i) begin
  if(!rstn_i) begin
	stg3_start_op		   <= '0;
    stg3_mantissa          <= '0;
    stg3_exponent          <= '0;
    stg3_sign              <= '0;
    stg3_status_flags      <= '0;
    stg3_inst_info         <= '0;
	stg3_op_valid		   <= '0;
  end else 	if(stg2_op_valid) begin
	stg3_start_op		   <= '1;
    stg3_mantissa          <= product;
    stg3_exponent          <= exponent2;
    stg3_sign              <= stg2_sign;
    stg3_status_flags      <= stg2_status_flags;
    stg3_inst_info         <= stg2_inst_info;
	stg3_op_valid		   <= stg2_op_valid;
  end	else	begin
		stg3_start_op		   <= '0;
		stg3_mantissa          <= '0;
		stg3_exponent          <= '0;
		stg3_sign              <= '0;
		stg3_status_flags      <= '0;
		stg3_inst_info         <= '0;
		stg3_op_valid		   <= '0;
	end
end

wire overflow_after_rm;
wire sign_round;
wire [11:0] exponent_round;
wire [54:0] mantissa_round;

lagarto_fpu_rm  fp_multiplier_rm(
  stg3_inst_info.rm,
  stg3_sign,
  stg3_exponent,
  stg3_mantissa,
  sign_round,
  exponent_round,
  mantissa_round,
  overflow_after_rm
);


fp_status_flags stg3_status_flags_d;
fp_info         stg3_inst_info_d;


assign stg3_inst_info_d    = stg3_inst_info;

logic zero_int;
logic underflow_int;
logic overflow_int;
logic inexact_int;

lagarto_fpu_xcpt  fp_multiplier_xcpt(
  .exponent_i           (exponent_round),
  .mantissa_i           (mantissa_round),
  .overflow_round_i     (overflow_after_rm),
  .invalid_operation_i  (stg3_status_flags_d.NV),
  .underflow_o          (underflow_int),
  .overflow_o           (overflow_int),
  .inexact_o            (inexact_int),
  .zero_o               (zero_int)
);
  
  assign stg3_status_flags_d.DZ = 1'b0;
  assign stg3_status_flags_d.NV = stg3_status_flags.NV;
  assign stg3_status_flags_d.UF = underflow_int;
  assign stg3_status_flags_d.OF = overflow_int;
  assign stg3_status_flags_d.NX = inexact_int;

wire [63:0] in_result;
assign in_result= {sign_round,exponent_round[10:0],mantissa_round[53:2]};

logic zero_result;
assign zero_result = stg3_inst_info_d.is_zero || zero_int;

logic [63:0]out_fp;
always_comb begin
  case({stg3_status_flags_d.OF,stg3_status_flags_d.NV,zero_result})

  3'b001:   begin
            out_fp={64'b0};
          end
  3'b010:   begin
          if(stg3_inst_info_d.is_snan)
            out_fp={in_result[63],11'b11111111111,52'h0000000000001};
          else
            out_fp={in_result[63],11'b11111111111,52'h8000000000000};
          end
  3'b100:   begin
            case(stg3_inst_info_d.rm)
            3'b000:  begin //round_neaEXst_even
                  if(~sign_round) // Si es overflow con signo positivo se EXdondea a +infinito
                      out_fp={1'b0,11'b11111111111,52'h0000000000000};
                  else        // de lo contrario a -infinito
                      out_fp={1'b1,11'b11111111111,52'h0000000000000};
                  end
            3'b001:  begin // round_to_zero
                  if(~sign_round) // Si es overflow con signo positivo se EXdondea a el número positivo más grande EXpEXsentable
                      out_fp={1'b0,11'b11111111110,52'hFFFFFFFFFFFFF};
                  else         // de lo contrario al número negativo más grande
                      out_fp={1'b1,11'b11111111110,52'hFFFFFFFFFFFFF};
                  end   
            3'b010:  begin // round_up
                  if(~sign_round) // Si es overflow con signo positivo se EXdondea a +infinito
                      out_fp={1'b0,11'b11111111111,52'h0000000000000};
                  else         // de lo contrario al número negativo más grande
                      out_fp={1'b1,11'b11111111110,52'hFFFFFFFFFFFFF};
                  end   
            3'b011:  begin // round_down
                  if(~sign_round) // Si es overflow con signo positivo se EXdondea a el número positivo más grande EXpEXsentable
                      out_fp={1'b0,11'b11111111110,52'hFFFFFFFFFFFFF};
                  else         // de lo contrario a -infinito
                      out_fp={1'b1,11'b11111111111,52'h0000000000000};
                  end
            default: begin
                      out_fp=in_result;
                      //$fatal (1,"Not supported RM\n");
                  end
            endcase
          end
  default:  begin
          out_fp=in_result;
          end
  endcase
end

//----------------------------------------------------------------------------------
//      Output
// ---------------------------------------------------------------------------------

always	@	(*)	begin
	if	(stg1_op_valid)	begin
		cycle_counter	=	3;
	end	else	if	(stg2_op_valid)	begin
		cycle_counter	=	2;
	end	else	if	(stg3_op_valid)	begin
		cycle_counter	=	1;
	end	else	begin
		cycle_counter	=	0;
	end
end

assign result_o   = out_fp;
assign op_ready_o = stg3_inst_info_d.valid_op;
assign status_o   = stg3_status_flags_d;
assign tag_id_o   = stg3_inst_info_d.tag_id;
assign busy_o     = op_ready_o	?	'0:((stg1_start_op	|	stg2_start_op	|	stg3_start_op)	?	'1:'0);

endmodule