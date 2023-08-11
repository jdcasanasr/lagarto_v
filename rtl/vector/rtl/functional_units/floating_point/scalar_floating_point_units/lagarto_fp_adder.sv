/*******************************************************************************************************************/
/*| TITLE      |  LAGARTO FPU: Floating-point Addition/Subtraction (6 stages)                                     |*/
/*|------------|--------------------------------------------------------------------------------------------------|*/
/*| FILE       |  lagarto_fp_adder.sv                                                                             |*/
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

module lagarto_fp_adder #(
  /*Future implementations will support parameterizable width*/
  parameter int unsigned WIDTH        = 64 
) (
  input		logic								clk_i,
  input		logic								rstn_i,
  input		logic								flush_i,

  // Input signals
  input		logic								op_valid_i,
  input		lagarto_fpu_pkg::fp_operation_t		op_i,
  input		lagarto_fpu_pkg::fp_fmt				fmt_i,
  input		lagarto_fpu_pkg::fp_rounding_mode	rnd_mode_i,
  input		logic	[WIDTH-1:0]					operand_a_i,
  input		logic	[WIDTH-1:0]					operand_b_i,
  input		lagarto_fpu_pkg::fp_tag_id			tag_id_i,

  // Output signals
  output	logic								op_ready_o,
  output	logic	[WIDTH-1:0]					result_o,
  output	lagarto_fpu_pkg::fp_status_flags	status_o,
  output	lagarto_fpu_pkg::fp_tag_id			tag_id_o,
  output	logic								busy_o,
  output	logic	[2:0]						cycle_counter
);

logic	stg1_start_op;
logic	stg2_start_op;
logic	stg3_start_op;
logic	stg4_start_op;
logic	stg5_start_op;

reg		stg1_op_valid;
reg		stg2_op_valid;
reg		stg3_op_valid;
reg		stg4_op_valid;
reg		stg5_op_valid;

// TODO: he empezado a definir structuras, pero falta ponerlo en todo el código.
lagarto_fpu_pkg::fp_info          inst_info;
lagarto_fpu_pkg::fp_status_flags  status_flags;

assign	inst_info.valid_op	=	op_valid_i;
assign	inst_info.op		=	op_i;
assign	inst_info.rm		=	rnd_mode_i;
assign	inst_info.tag_id	=	tag_id_i;
assign	inst_info.operand_a	=	operand_a_i;
assign	inst_info.operand_b	=	operand_b_i;

lagarto_fp_adder_operand_check fp_adder_operand_check (
	.fpu_op_i				(inst_info.op),
	.operand_a_i			(inst_info.operand_a),
	.operand_b_i			(inst_info.operand_b),
	.invalid_operation_o	(status_flags.NV),
	.is_snan_o				(inst_info.is_snan)
);

// This FP status flags are set in the last stage, in the meantime are set to zero
assign	status_flags.DZ		=	1'b0;
assign	status_flags.OF		=	1'b0;
assign	status_flags.UF		=	1'b0;
assign	status_flags.NX		=	1'b0;

assign	inst_info.is_nan	=	inst_info.is_snan	||	inst_info.is_qnan;
assign	inst_info.is_boxed	=	1'b0;

logic	[10:0]	exponent_a,exponent_b;
logic	[51:0]	mantissa_a,mantissa_b;
logic			sign_a;
logic			sign_b;

// Separación en signo, exponente y mantissa
assign	exponent_a	=	operand_a_i[62:52];
assign	exponent_b	=	operand_b_i[62:52];
assign	mantissa_a	=	operand_a_i[51:0];
assign	mantissa_b	=	operand_b_i[51:0];
assign	sign_a		=	operand_a_i[63];
assign	sign_b		=	operand_b_i[63];

reg		fpu_op_new;
reg		sign_a_new;
reg		sign_b_new;

always @(*) begin
	case ({inst_info.op[0],sign_a,sign_b}) //op_i : 0 suma , 1 resta; sign_a : 1 negativo 0 positivo ; sign_b: 1 negativo 0 positivo
		3'b000	:	begin
			fpu_op_new	=	1'b0;		//	0	suma
			sign_a_new	=	1'b0;
			sign_b_new	=	1'b0;
			end
		3'b011	:	begin
			fpu_op_new	=	1'b0;		//	0	suma
			sign_a_new	=	1'b1;
			sign_b_new	=	1'b1;
			end
		3'b101	:	begin
			fpu_op_new	=	1'b0;		//	0	suma
			sign_a_new	=	1'b0;
			sign_b_new	=	1'b0;
			end
		3'b110	:	begin
			fpu_op_new	=	1'b0;		//	0	suma
			sign_a_new	=	1'b1;
			sign_b_new	=	1'b1;
			end
		3'b100	:	begin
			fpu_op_new	=	1'b1;		//	1	resta
			sign_a_new	=	1'b0;
			sign_b_new	=	1'b1;
			end
		3'b111	:	begin
			fpu_op_new	=	1'b1;		//	1	resta
			sign_a_new	=	1'b1;
			sign_b_new	=	1'b0;
			end
		3'b001	:	begin
			fpu_op_new	=	1'b1;		//	1	resta
			sign_a_new	=	1'b0;
			sign_b_new	=	1'b1;
			end
		3'b010	:	begin
			fpu_op_new	=	1'b1;		//	1	resta
			sign_a_new	=	1'b1;
			sign_b_new	=	1'b0;
			end
		default	:begin
			fpu_op_new	=	1'b0;
			sign_a_new	=	1'b0;
			sign_b_new	=	1'b0;
			end
	endcase
end

wire normalized_a, normalized_b;
//Verificar que los datos estén normalizados
assign normalized_a = |exponent_a;
assign normalized_b = |exponent_b;

// Obtención de exponente mayor, mantissa mayor y signo final
reg [51:0] mantissa_bigger, mantissa_smaller;
reg [10:0] e_bigger;

wire [11:0] dif_exponent;
assign dif_exponent= {1'b0,exponent_a}-{1'b0,exponent_b};

wire equal_exponent;
assign equal_exponent= (exponent_a==exponent_b);

wire mantissa_big;
assign mantissa_big=(mantissa_a>mantissa_b) ? 1'b1: 1'b0;

reg sign, bigger_normalized, smaller_normalized;

always @(*) begin
  case (dif_exponent[11])
  1'b0: begin
          e_bigger = exponent_a;
          if (equal_exponent) begin
            if (mantissa_big) begin
              mantissa_bigger = mantissa_a;
              mantissa_smaller = mantissa_b;
              bigger_normalized = normalized_a;
              smaller_normalized = normalized_b;
              sign = sign_a_new;
            end else begin
              mantissa_bigger = mantissa_b;
              mantissa_smaller = mantissa_a;
              bigger_normalized = normalized_b;
              smaller_normalized = normalized_a;
              sign = sign_b_new;
            end
          end else begin
              mantissa_bigger = mantissa_a;
              mantissa_smaller = mantissa_b;
              bigger_normalized = normalized_a;
              smaller_normalized = normalized_b;
              sign = sign_a_new;
          end
        end
  1'b1: begin
          e_bigger = exponent_b;
          mantissa_bigger = mantissa_b;
          mantissa_smaller = mantissa_a;
          bigger_normalized = normalized_b;
          smaller_normalized = normalized_a;
          sign = sign_b_new;
        end
  endcase
end

wire [11:0] dif_exp;
assign dif_exp = dif_exponent[11] ? ~dif_exponent : dif_exponent; //solo 6 bits ya que la diferencia no debe ser mayor a 55 bits

// Dato desnormalizado
wire patch_small_normalized;
assign patch_small_normalized = ~smaller_normalized & bigger_normalized;

wire [54:0] mantissa_bigger_operation,mantissa_smaller_operation;
assign mantissa_bigger_operation = {bigger_normalized,mantissa_bigger,2'b00};
assign mantissa_smaller_operation = {smaller_normalized,mantissa_smaller,2'b00}; 

reg [11:0] dif_exp_path;
always @(*) begin
  case ({patch_small_normalized, dif_exponent[11]})
    2'b00: dif_exp_path = 12'b000000000000; // No suma nada 
    2'b01: dif_exp_path = 12'b000000000001; // Sumamos 1 al complemento a1
    2'b11: dif_exp_path = 12'b000000000000; // Si era negativo previamente se realizó el complemento a1, ahora se suma el 1, y restando el 1 da c0
    2'b10: dif_exp_path = 12'b111111111111; // Si no esta normalizado se resta 1 (complemento a2 de 000000000001)
    default : dif_exp_path = 12'b000000000000; // No suma nada 
  endcase
end

//----------------------------------------------------------------------------------
//      Stage 1 - Register
// ---------------------------------------------------------------------------------
fp_status_flags	stg1_status_flags;
fp_info        	stg1_inst_info;

logic           fpu_op_stg1;
logic [10:0]    e_bigger_stg1;
logic           sign_stg1;
logic           bigger_normalized_stg1;
logic [11:0]    dif_exp_stg1;
logic [11:0]    dif_exp_path_stg1;
logic [54:0]    mantissa_bigger_ope_stg1;
logic [54:0]    mantissa_smaller_ope_stg1;

always	@	(posedge	clk_i,negedge	rstn_i)	begin
	if(!rstn_i)begin
		stg1_start_op				<=	'0;
		fpu_op_stg1					<=	'0;
		e_bigger_stg1				<=	'0;
		sign_stg1					<=	'0;
		bigger_normalized_stg1		<=	'0;
		dif_exp_stg1				<=	'0;
		dif_exp_path_stg1			<=	'0;
		mantissa_bigger_ope_stg1	<=	'0;
		mantissa_smaller_ope_stg1	<=	'0;
		stg1_status_flags			<=	'0;
		stg1_inst_info				<=	'0;
		stg1_op_valid				<=	'0;
	end	else	if(inst_info.valid_op)	begin
		stg1_start_op				<=	'1;
		fpu_op_stg1					<=	fpu_op_new;
		e_bigger_stg1				<=	e_bigger;
		sign_stg1					<=	sign;
		bigger_normalized_stg1		<=	bigger_normalized;
		dif_exp_stg1				<=	dif_exp;
		dif_exp_path_stg1			<=	dif_exp_path;
		mantissa_bigger_ope_stg1	<=	mantissa_bigger_operation;
		mantissa_smaller_ope_stg1	<=	mantissa_smaller_operation;
		stg1_status_flags			<=	status_flags;
		stg1_inst_info				<=	inst_info;
		stg1_op_valid				<=	inst_info.valid_op;
	end	else	begin
		stg1_start_op				<=	'0;
		fpu_op_stg1					<=	'0;
		e_bigger_stg1				<=	'0;
		sign_stg1					<=	'0;
		bigger_normalized_stg1		<=	'0;
		dif_exp_stg1				<=	'0;
		dif_exp_path_stg1			<=	'0;
		mantissa_bigger_ope_stg1	<=	'0;
		mantissa_smaller_ope_stg1	<=	'0;
		stg1_status_flags			<=	'0;
		stg1_inst_info				<=	'0;
		stg1_op_valid				<=	'0;
	end
end
// ----------------------------------------------------------------------------------

wire [11:0] difference;
wire [54:0] shift_mantissa_smaller;

assign  difference = dif_exp_stg1 + dif_exp_path_stg1;

wire dif_valid;
assign dif_valid = difference > 12'b000000110110 ? 1'b0 : 1'b1;

// ahora si aplico el desplazamiento, sabiendo que tengo 2 bits extras a la derecha por si se pierden datos para posteriormente aplicar redondeo
assign shift_mantissa_smaller = dif_valid ? mantissa_smaller_ope_stg1 >> difference[5:0] : 55'b0; //difference[5:0]
// assign shift_mantissa_smaller = mantissa_smaller_ope_stg1>>difference ;

// Negar mantissa pequeña en caso de resta 
wire [54:0] shift_mantissa_smaller1;

assign shift_mantissa_smaller1 = fpu_op_stg1 ? ~shift_mantissa_smaller : shift_mantissa_smaller;
//----------------------------------------------------------------------------------
//      Stage 2 - Register
// ---------------------------------------------------------------------------------
fp_status_flags stg2_status_flags;
fp_info         stg2_inst_info;

logic fpu_op_new_stg2;
reg [54:0] mantissa_bigger_ope_stg2;
reg [54:0] shift_mantissa_smaller_stg2;
reg [10:0] e_bigger_stg2;
reg bigger_normalized_stg2;
reg sign_stg2;

always	@	(posedge	clk_i,negedge	rstn_i)	begin
	if	(!rstn_i)	begin
		stg2_start_op				<=	'0;
		fpu_op_new_stg2				<=	'0;
		mantissa_bigger_ope_stg2	<=	'0;
		shift_mantissa_smaller_stg2	<=	'0;
		e_bigger_stg2				<=	'0;
		bigger_normalized_stg2		<=	'0;
		sign_stg2					<=	'0;
		stg2_status_flags			<=	'0;
		stg2_inst_info				<=	'0;
		stg2_op_valid				<=	'0;
	end	else	if	(stg1_op_valid)	begin
		stg2_start_op				<=	'1;
		fpu_op_new_stg2				<=	fpu_op_stg1;
		mantissa_bigger_ope_stg2	<=	mantissa_bigger_ope_stg1;
		shift_mantissa_smaller_stg2	<=	shift_mantissa_smaller1;
		e_bigger_stg2				<=	e_bigger_stg1;
		bigger_normalized_stg2		<=	bigger_normalized_stg1;
		sign_stg2					<=	sign_stg1;
		stg2_status_flags			<=	stg1_status_flags;
		stg2_inst_info				<=	stg1_inst_info;
		stg2_op_valid				<=	stg1_op_valid;
	end	else	begin
		stg2_start_op				<=	'0;
		fpu_op_new_stg2				<=	'0;
		mantissa_bigger_ope_stg2	<=	'0;
		shift_mantissa_smaller_stg2	<=	'0;
		e_bigger_stg2				<=	'0;
		bigger_normalized_stg2		<=	'0;
		sign_stg2					<=	'0;
		stg2_status_flags			<=	'0;
		stg2_inst_info				<=	'0;
		stg2_op_valid				<=	'0;
	end
end
// ----------------------------------------------------------------------------------

wire [55:0] pre_sum;

assign pre_sum = mantissa_bigger_ope_stg2 + shift_mantissa_smaller_stg2 + fpu_op_new_stg2;

//----------------------------------------------------------------------------------
//      Stage 3 - Register
// ---------------------------------------------------------------------------------
fp_status_flags stg3_status_flags;
fp_info         stg3_inst_info;

reg [10:0]e_bigger_stg3;
reg [55:0] pre_sum_stg3;
reg bigger_normalized_stg3;
reg fpu_op_new_stg3;
reg sign_stg3;

always	@	(posedge	clk_i,negedge	rstn_i)	begin
	if	(!rstn_i)	begin
		stg3_start_op			<=	'0;
		pre_sum_stg3			<=	'0;
		e_bigger_stg3			<=	'0;
		bigger_normalized_stg3	<=	'0;
		fpu_op_new_stg3			<=	'0;
		sign_stg3				<=	'0;
		stg3_status_flags		<=	'0;
		stg3_inst_info			<=	'0;
		stg3_op_valid			<=	'0;
	end	else	if	(stg2_op_valid)	begin
		stg3_start_op			<=	'1;
		pre_sum_stg3			<=	pre_sum;
		e_bigger_stg3			<=	e_bigger_stg2;
		bigger_normalized_stg3	<=	bigger_normalized_stg2;
		fpu_op_new_stg3			<=	fpu_op_new_stg2;
		sign_stg3				<=	sign_stg2;
		stg3_status_flags		<=	stg2_status_flags;
		stg3_inst_info			<=	stg2_inst_info;
		stg3_op_valid			<=	stg2_op_valid;
	end	else	begin
		stg3_start_op			<=	'0;
		pre_sum_stg3			<=	'0;
		e_bigger_stg3			<=	'0;
		bigger_normalized_stg3	<=	'0;
		fpu_op_new_stg3			<=	'0;
		sign_stg3				<=	'0;
		stg3_status_flags		<=	'0;
		stg3_inst_info			<=	'0;
		stg3_op_valid			<=	'0;
	end
end
// ----------------------------------------------------------------------------------

//wire [55:0] pre_sum_complement;
//assign pre_sum_complement= (pre_sum_stg3[55] & fpu_op_new_stg3) ?  ~pre_sum_stg3 + 1'b1: pre_sum_stg3;

// Si después de realizar la suma existe algun Overflow tendremos que hacer un desplazamiento a la derecha y sumar 1 al exponente
// Si despues de realizar la resta se encuentra desnormalizado el número tendremos que recorrer hacia la izquierda tantos ceros haya antes del primer uno
wire NoZero;
wire [5:0] numZeros1; // Auxiliar
lagarto_fp_lzc fp_adder_lzc (
  .clk(clk_i), 
  .A1({pre_sum_stg3[54:0],9'b000000000}),
  .Z1(numZeros1),
  .V1(NoZero)
);

//----------------------------------------------------------------------------------
//      Stage X - Register
// ---------------------------------------------------------------------------------
fp_status_flags stg4_status_flags;
fp_info         stg4_inst_info;

logic [10:0]e_bigger_stg4;
logic [55:0] pre_sum_stg4;
logic bigger_normalized_stg4;
logic [5:0]numZeros1_stg4;
logic NoZero_stg4;
logic fpu_op_new_stg4;
logic sign_final_stg4;

assign pre_sum_stg4           = pre_sum_stg3;
assign e_bigger_stg4          = e_bigger_stg3;
assign bigger_normalized_stg4 = bigger_normalized_stg3;
assign numZeros1_stg4         = numZeros1;
assign NoZero_stg4            = NoZero;
assign fpu_op_new_stg4        = fpu_op_new_stg3;
assign sign_final_stg4        = sign_stg3;
assign stg4_status_flags      = stg3_status_flags;
assign stg4_inst_info         = stg3_inst_info;

// ----------------------------------------------------------------------------------

wire [5:0] numZeros; // para caso de resta
//Debo restar 9 al conteo ya que el circuito LeadingZeroCount tiene concatenados 9 ceros ya que es de 64 bits y la entrada no
// Zero=1 contiene algo
// Zero=0 No contiene nada 
assign numZeros= (NoZero_stg4) ? (numZeros1_stg4):6'b000000; //(numZeros1_stg4-6'b001001):6'b000000; 

wire [10:0] shift_left_valid;
assign shift_left_valid= (e_bigger_stg4>={5'b00000,numZeros}) ? {5'b00000,numZeros}: e_bigger_stg4;

wire Overflow;
assign Overflow=pre_sum_stg4[55];

//Caso de que sume dos números desnormalizados y genero un resultado normalizado
wire sum_desnorm;
wire denorm_to_norm;
assign sum_desnorm = pre_sum_stg4[54];
assign denorm_to_norm = sum_desnorm & ~bigger_normalized_stg4; // si el mayor no estaba normalizado , el menor tampoco


//----------------------------------------------------------------------------------
//      Stage 4 - Register
// ---------------------------------------------------------------------------------
fp_status_flags stg5_status_flags;
fp_info         stg5_inst_info;

reg [10:0]e_bigger_stg5;
reg [55:0] pre_sum_stg5;
reg fpu_op_new_stg5;
reg sign_final_stg5;
reg [10:0]shift_left_valid_stg5;
reg denorm_to_norm_stg5;
reg Overflow_stg5;

always	@	(posedge	clk_i,negedge	rstn_i)	begin
	if	(!rstn_i)	begin
		stg4_start_op			<=	'0;
		pre_sum_stg5			<=	56'b0;
		e_bigger_stg5			<=	11'b0;
		fpu_op_new_stg5			<=	1'b0;
		sign_final_stg5			<=	1'b0;
		Overflow_stg5			<=	1'b0;
		denorm_to_norm_stg5		<=	1'b0;
		shift_left_valid_stg5	<=	11'b0;
		stg5_status_flags		<=	'0;
		stg5_inst_info			<=	'0;
		stg4_op_valid			<=	'0;
	end	else	if	(stg3_op_valid)	begin
		stg4_start_op			<=	'1;
		pre_sum_stg5			<=	pre_sum_stg4;
		e_bigger_stg5			<=	e_bigger_stg4;
		fpu_op_new_stg5			<=	fpu_op_new_stg4;
		sign_final_stg5			<=	sign_final_stg4;
		Overflow_stg5			<=	Overflow;
		denorm_to_norm_stg5		<=	denorm_to_norm;
		shift_left_valid_stg5	<=	shift_left_valid;
		stg5_status_flags		<=	stg4_status_flags;
		stg5_inst_info			<=	stg4_inst_info;
		stg4_op_valid			<=	stg3_op_valid;
	end	else	begin
		stg4_start_op			<=	'0;
		pre_sum_stg5			<=	56'b0;
		e_bigger_stg5			<=	11'b0;
		fpu_op_new_stg5			<=	1'b0;
		sign_final_stg5			<=	1'b0;
		Overflow_stg5			<=	1'b0;
		denorm_to_norm_stg5		<=	1'b0;
		shift_left_valid_stg5	<=	11'b0;
		stg5_status_flags		<=	'0;
		stg5_inst_info			<=	'0;
		stg4_op_valid			<=	'0;
	end
end
// ----------------------------------------------------------------------------------

logic sign_final;
logic [11:0] exp_final; // 12 bits para detectar infinito en redondeo y excepciones
logic [54:0] mantissa_final;

wire [5:0] shift_left_valid_short;
assign shift_left_valid_short = shift_left_valid_stg5[5:0];

always @(*) begin
  case({fpu_op_new_stg5,Overflow_stg5,denorm_to_norm_stg5})
    3'b100: begin
          mantissa_final = pre_sum_stg5[54:0] << shift_left_valid_short ;
          exp_final =  {1'b0,e_bigger_stg5} - {1'b0,shift_left_valid_stg5}; // Si fue resta hay que recorrer a la izquierda
          end
    3'b110: begin
          mantissa_final = pre_sum_stg5[54:0] << shift_left_valid_short ;
          exp_final =  {1'b0,e_bigger_stg5} - {1'b0,shift_left_valid_stg5}; // Si fue resta hay que recorrer a la izquierda
          end
    3'b010: begin
          mantissa_final = pre_sum_stg5[55:1];
          exp_final =  {1'b0,e_bigger_stg5} + 12'h001; // Si existió un overflow en la suma
          end
    3'b001: begin 
          mantissa_final = pre_sum_stg5[54:0];
          exp_final =  {1'b0,e_bigger_stg5} + 12'h001; // Si los dos estaban desnormalizados y genero un normalizado , sumar 1 al exp
          end
    3'b000:  begin
          mantissa_final = pre_sum_stg5[54:0];
          exp_final =  {1'b0,e_bigger_stg5}; // si fue suma y no hubo nada 
          end
    default: begin
          mantissa_final = pre_sum_stg5[54:0];
          exp_final =  {1'b0,e_bigger_stg5};
          end
  endcase
end

//Signo final
assign sign_final=sign_final_stg5;


//----------------------------------------------------------------------------------
//      Stage 5 - Register
// ---------------------------------------------------------------------------------
fp_status_flags stg6_status_flags;
fp_info         stg6_inst_info;

reg [54:0] mantissa_stg6;
reg [11:0] exponent_stg6;
reg sign_stg6;

always	@	(posedge	clk_i,negedge	rstn_i)	begin
	if	(!rstn_i)	begin
		stg5_start_op		<=	'0;
		mantissa_stg6		<=	'0;
		exponent_stg6		<=	'0;
		sign_stg6			<=	'0;
		stg6_status_flags	<=	'0;
		stg6_inst_info		<=	'0;
		stg5_op_valid		<=	'0;
	end	else	if	(stg4_op_valid)	begin
		stg5_start_op		<=	'1;
		mantissa_stg6		<=	mantissa_final;
		exponent_stg6		<=	exp_final;
		sign_stg6			<=	sign_final;
		stg6_status_flags	<=	stg5_status_flags;
		stg6_inst_info		<=	stg5_inst_info;
		stg5_op_valid		<=	stg4_op_valid;
	end	else	begin
		stg5_start_op		<=	'0;
		mantissa_stg6		<=	'0;
		exponent_stg6		<=	'0;
		sign_stg6			<=	'0;
		stg6_status_flags	<=	'0;
		stg6_inst_info		<=	'0;
		stg5_op_valid		<=	'0;
	end
end

wire overflow_after_rm;
wire sign_round;
wire [11:0] exponent_round;
wire [54:0] mantissa_round;

lagarto_fpu_rm fp_adder_rm(
  stg6_inst_info.rm,
  sign_stg6,
  exponent_stg6,
  mantissa_stg6,
  sign_round,
  exponent_round,
  mantissa_round,
  overflow_after_rm
);

//----------------------------------------------------------------------------------
//      Stage X - Register
// ---------------------------------------------------------------------------------
fp_status_flags stg7_status_flags;
fp_info         stg7_inst_info;

reg [54:0] mantissa_stg7;
reg [11:0] exponent_stg7;
reg sign_stg7;
reg overflow_after_rm_stg7;

assign mantissa_stg7          = mantissa_round;
assign exponent_stg7          = exponent_round;
assign sign_stg7              = sign_round;
assign overflow_after_rm_stg7 = overflow_after_rm;
assign stg7_status_flags      = stg6_status_flags;
assign stg7_inst_info         = stg6_inst_info;
// ---------------------------------------------------------------------------------

fp_status_flags stg7_status_flags_d;
fp_info         stg7_inst_info_d;


assign stg7_inst_info_d    = stg7_inst_info;

logic zero_int;
logic underflow_int;
logic overflow_int;
logic inexact_int;

lagarto_fpu_xcpt fp_adder_xcpt(
  .exponent_i           (exponent_stg7),
  .mantissa_i           (mantissa_stg7),
  .overflow_round_i     (overflow_after_rm_stg7),
  .invalid_operation_i  (stg7_status_flags_d.NV),
  .underflow_o          (underflow_int),
  .overflow_o           (overflow_int),
  .inexact_o            (inexact_int),
  .zero_o               (zero_int)
);
  
  assign stg7_status_flags_d.DZ = 1'b0;
  assign stg7_status_flags_d.NV = stg7_status_flags.NV;
  assign stg7_status_flags_d.UF = underflow_int;
  assign stg7_status_flags_d.OF = overflow_int;
  assign stg7_status_flags_d.NX = inexact_int;

wire [63:0] in_result;
assign in_result= {sign_stg7, exponent_stg7[10:0], mantissa_stg7[53:2]};

logic [63:0] out_fp;
always	@	(*)	begin
	case({stg7_status_flags_d.OF,stg7_status_flags_d.NV,zero_int})
		3'b001:   begin
				out_fp={64'b0};
		end
		3'b010:   begin
				if(stg7_inst_info_d.is_snan)
				out_fp={in_result[63],11'b11111111111,52'h0000000000001};
				else
				out_fp={in_result[63],11'b11111111111,52'h8000000000000};
		end
		3'b100:   begin
			case(stg7_inst_info_d.rm)
				3'b000:  begin //round_neaEXst_even
						if(~sign_stg7) // Si es overflow con signo positivo se EXdondea a +infinito
							out_fp={1'b0,11'b11111111111,52'h0000000000000};
						else        // de lo contrario a -infinito
							out_fp={1'b1,11'b11111111111,52'h0000000000000};
				end
				3'b001:  begin // round_to_zero
						if(~sign_stg7) // Si es overflow con signo positivo se EXdondea a el número positivo más grande EXpEXsentable
							out_fp={1'b0,11'b11111111110,52'hFFFFFFFFFFFFF};
						else         // de lo contrario al número negativo más grande
							out_fp={1'b1,11'b11111111110,52'hFFFFFFFFFFFFF};
				end   
				3'b010:  begin // round_up
						if(~sign_stg7) // Si es overflow con signo positivo se EXdondea a +infinito
							out_fp={1'b0,11'b11111111111,52'h0000000000000};
						else         // de lo contrario al número negativo más grande
							out_fp={1'b1,11'b11111111110,52'hFFFFFFFFFFFFF};
				end   
				3'b011:  begin // round_down
						if(~sign_stg7) // Si es overflow con signo positivo se EXdondea a el número positivo más grande EXpEXsentable
							out_fp={1'b0,11'b11111111110,52'hFFFFFFFFFFFFF};
						else         // de lo contrario a -infinito
							out_fp={1'b1,11'b11111111111,52'h0000000000000};
				end
				default: begin
							out_fp=in_result;
							$fatal (1,"Not supported RM\n");
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
		cycle_counter	=	5;
	end	else	if	(stg2_op_valid)	begin
		cycle_counter	=	4;
	end	else	if	(stg3_op_valid)	begin
		cycle_counter	=	3;
	end	else	if	(stg4_op_valid)	begin
		cycle_counter	=	2;
	end	else	if	(stg5_op_valid)	begin
		cycle_counter	=	1;
	end	else	begin
		cycle_counter	=	0;
	end
end

assign result_o   = out_fp;
assign op_ready_o = stg7_inst_info_d.valid_op;
assign status_o   = stg7_status_flags_d;
assign tag_id_o   = stg7_inst_info_d.tag_id;
assign busy_o     = op_ready_o	?	'0:((stg1_start_op	|	stg2_start_op	|	stg3_start_op	|	stg4_start_op	|	stg5_start_op)	?	'1:'0);

endmodule