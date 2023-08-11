/*******************************************************************************************************************/
/*| TITLE      |  LAGARTO FPU: Operand Check                                                                      |*/
/*|------------|--------------------------------------------------------------------------------------------------|*/
/*| FILE       |  lagarto_fp_adder_operand_check.sv                                                               |*/
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

module lagarto_fp_adder_operand_check (
  input lagarto_fpu_pkg::fp_operation_t fpu_op_i,
  input [63:0]                        operand_a_i,
  input [63:0]                        operand_b_i,
  output logic                        invalid_operation_o,
  output logic                        is_snan_o
);

logic is_nan_int;
logic operand_a_qnan_int;
logic operand_b_qnan_int;
logic operand_a_snan_int;
logic operand_b_snan_int;
logic addsub_inf_invalid;
logic operand_a_inf_pos_int;
logic operand_b_inf_pos_int;
logic operand_a_inf_neg_int;
logic operand_b_inf_neg_int;

always@(*)
begin
//--------------------------------------------------------------------------------------    
// Invalid Operation Exception
//--------------------------------------------------------------------------------------    
if(&operand_a_i[62:52] & operand_a_i[51]) //QNaN en operador A X 11111111111 1xxxx....
    operand_a_qnan_int=1'b1;
else
    operand_a_qnan_int=1'b0;
    
if(&operand_b_i[62:52] & operand_b_i[51]) //QNaN en operador B
    operand_b_qnan_int=1'b1;
else
    operand_b_qnan_int=1'b0;
    
if(&operand_a_i[62:52] & ~operand_a_i[51] & |operand_a_i[50:0]) //SNaN en operador A X 11111111111 0xxxx....
    operand_a_snan_int=1'b1;
else
    operand_a_snan_int=1'b0;
    
if(&operand_b_i[62:52] & ~operand_b_i[51] & |operand_b_i[50:0]) //SNaN en operador B
    operand_b_snan_int=1'b1;
else
    operand_b_snan_int=1'b0;
    
if(operand_a_qnan_int | operand_b_qnan_int | operand_a_snan_int | operand_b_snan_int) // Si algún operando no es un número
    is_nan_int=1'b1;
else
    is_nan_int=1'b0;

if(operand_a_snan_int | operand_b_snan_int)
    is_snan_o=1'b1;
else
    is_snan_o=1'b0;

if(&operand_a_i[62:52] & ~(|operand_a_i[51:0]) & ~operand_a_i[63]) // Operador A infinito positivo
    operand_a_inf_pos_int=1'b1; 
else
    operand_a_inf_pos_int=1'b0;

if(&operand_b_i[62:52] & ~(|operand_b_i[51:0]) & ~operand_b_i[63]) // Operador B infinito positivo
    operand_b_inf_pos_int=1'b1;
else
    operand_b_inf_pos_int=1'b0;  

if(&operand_a_i[62:52] & ~(|operand_a_i[51:0]) & operand_a_i[63]) // Operador A infinito negativo
    operand_a_inf_neg_int=1'b1; 
else
    operand_a_inf_neg_int=1'b0;

if(&operand_b_i[62:52] & ~(|operand_b_i[51:0]) & operand_b_i[63]) // Operador B infinito negativo
    operand_b_inf_neg_int=1'b1;
else
    operand_b_inf_neg_int=1'b0;

//Addition or subtraction: magnitude subtraction of infinities, such as (+∞) + (-∞) or (-∞) - (-∞). ....fpu_op_i=0 suma , fpu_op_i=1 resta 
if(((fpu_op_i==ADD) & operand_a_inf_pos_int & operand_b_inf_neg_int) | ((fpu_op_i==ADD) & operand_a_inf_neg_int & operand_b_inf_pos_int) | 
   ((fpu_op_i==SUB) & operand_a_inf_pos_int & operand_b_inf_pos_int) | ((fpu_op_i==SUB) & operand_a_inf_neg_int & operand_b_inf_neg_int))
    addsub_inf_invalid=1'b1;    //Suma o resta de infinitos opuestos (Resultado invalido)
else
    addsub_inf_invalid=1'b0;
    
// Invalid Operation
invalid_operation_o = is_nan_int | addsub_inf_invalid;

end

endmodule
