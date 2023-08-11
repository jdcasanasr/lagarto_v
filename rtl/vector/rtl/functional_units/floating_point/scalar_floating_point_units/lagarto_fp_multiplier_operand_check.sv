/*******************************************************************************************************************/
/*| TITLE      |  LAGARTO FPU: Operand Check                                                                      |*/
/*|------------|--------------------------------------------------------------------------------------------------|*/
/*| FILE       |  lagarto_fp_multiplier_operand_check.sv                                                               |*/
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

module lagarto_fp_multiplier_operand_check (
  input logic                         op_valid_i,
  input [63:0]                        operand_a_i,
  input [63:0]                        operand_b_i,
  output logic                        invalid_operation_o,
  output logic                        is_snan_o,
  output logic                        is_qnan_o,
  output logic                        is_zero_o,
  output logic                        is_inf_o
);

logic is_nan_int;

logic operand_a_qnan_int;
logic operand_b_qnan_int;

logic operand_a_snan_int;
logic operand_b_snan_int;

logic operand_a_zero_int;
logic operand_b_zero_int;

logic operand_a_inf_int;
logic operand_b_inf_int;

logic operand_a_subnormal_int;
logic operand_b_subnormal_int;

logic is_zeroxinf;

assign operand_a_qnan_int=&operand_a_i[62:52] & operand_a_i[51];
assign operand_b_qnan_int=&operand_b_i[62:52] & operand_b_i[51];

assign operand_a_snan_int=&operand_a_i[62:52] & ~operand_a_i[51] & |operand_a_i[50:0];
assign operand_b_snan_int= &operand_b_i[62:52] & ~operand_b_i[51] & |operand_b_i[50:0];

assign is_snan_o = operand_a_snan_int | operand_b_snan_int  || is_zeroxinf;
assign is_qnan_o = operand_a_qnan_int | operand_b_qnan_int;
assign is_nan_int= is_snan_o | is_qnan_o;

assign operand_a_zero_int= ~(|operand_a_i[62:52]) && ~(|operand_a_i[51:0]);
assign operand_b_zero_int= ~(|operand_b_i[62:52]) && ~(|operand_b_i[51:0]);

assign operand_a_inf_int = (&operand_a_i[62:52]) && ~(|operand_a_i[51:0]);
assign operand_b_inf_int = (&operand_b_i[62:52]) && ~(|operand_b_i[51:0]);

assign operand_a_subnormal_o = ~(|operand_a_i[62:52]) && (|operand_a_i[51:0]);
assign operand_b_subnormal_o = ~(|operand_b_i[62:52]) && (|operand_b_i[51:0]);

assign is_zeroxinf = (operand_a_zero_int && operand_b_inf_int) ||
                     (operand_a_inf_int && operand_b_zero_int);

assign invalid_operation_o = is_nan_int || is_zeroxinf;

assign is_zero_o = (operand_a_zero_int && !operand_b_inf_int && !is_nan_int) ||
                (operand_b_zero_int && !operand_a_inf_int && !is_nan_int) ;

assign is_inf_o = (operand_a_inf_int && !operand_b_zero_int && !is_nan_int) ||
                (operand_b_inf_int && !operand_a_zero_int && !is_nan_int) ;


endmodule
