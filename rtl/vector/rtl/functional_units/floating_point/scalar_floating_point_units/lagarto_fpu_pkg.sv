/*******************************************************************************************************************/
/*| TITLE      |  LAGARTO FPU: FPU Package                                                                        |*/
/*|------------|--------------------------------------------------------------------------------------------------|*/
/*| FILE       |  lagarto_fpu_pkg.sv                                                                              |*/
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

package lagarto_fpu_pkg;

localparam int unsigned SFP_MANTISSA_BITS = 23;
localparam int unsigned SFP_EXPONENT_BITS = 8;
// Encoding for a format
typedef struct packed {
  logic sign;
  logic [SFP_EXPONENT_BITS-1:0] exp;
  logic [SFP_MANTISSA_BITS-1:0] mnt;
} sfp_encoding_t;

localparam int unsigned DFP_MANTISSA_BITS = 52;
localparam int unsigned DFP_EXPONENT_BITS = 11;

// Encoding for a format
typedef struct packed {
  logic sign;
  logic [DFP_EXPONENT_BITS-1:0] exp;
  logic [DFP_MANTISSA_BITS-1:0] mnt;
} fp_t;

localparam int unsigned CANONICAL_NAN = 'h7FF8000000000000;

// Floating-point class types
localparam int unsigned FP_CLASSES = 10;
typedef enum logic [$clog2(FP_CLASSES)-1:0] {
  POS_NORMAL,
  NEG_NORMAL,
  POS_SUBNORMAL,
  NEG_SUBNORMAL,
  POS_INFINITY,
  NEG_INFINITY,
  POS_ZERO,
  NEG_ZERO,
  SNAN,
  QNAN
} fp_class_t;

typedef struct packed {
  logic guard;
  logic round;
  logic sticky;
} aux_round_bits_t;

typedef struct packed {
  fp_t fp;
  aux_round_bits_t aux;
} prerounding_fp_t;


localparam int unsigned NUM_FP_FORMATS = 4;
localparam int unsigned FP_FORMAT_BITS = $clog2(NUM_FP_FORMATS);
// Floating-point formats
typedef enum logic [FP_FORMAT_BITS-1:0] {
  FP32	,//	= 'h0,
  FP64	,//	= 'h1,
  FP16	,//	= 'h2,
  FP8 	//	= 'h3
} fp_fmt;

localparam int unsigned NUM_INT_FORMATS = 4;
localparam int unsigned INT_FORMAT_BITS = $clog2(NUM_INT_FORMATS);
// Integer formats
typedef enum logic [INT_FORMAT_BITS-1:0] {
  INT8,
  INT16,
  INT32,
  INT64
} int_fmt;

localparam int unsigned OP_BITS = 64; // Updating as we add support for more fp inst
// Floating point operations
typedef enum logic [OP_BITS-1:0] {
  ADD,
  SUB,
  MUL,
  DIV,
  SQRT,
  SGNJ,
  SGNJN,
  SGNJX,
  MIN,
  MAX,
  CMP_GR,
  CMP_EQ,
  CMP_LO,
  CMP_GE,
  CMP_LE,
  F2D,
  D2F,
  SI2D,
  I2D,
  D2SI,
  D2I,
  CLASSIFY
} fp_operation_t;

localparam int unsigned NUM_ROUNDING_MODES = 6;
localparam int unsigned RM_BITS = $clog2(NUM_ROUNDING_MODES);
// Rounding modes
typedef enum logic [RM_BITS-1:0] {
  RNE = 3'b000, // Round to Nearest, ties to Even
  RTZ = 3'b001, // Round towards Zero
  RDN = 3'b010, // Round Down (towards −∞)
  RUP = 3'b011, // Round Up (towards +∞)
  RMM = 3'b100, // Round to Nearest, ties to Max Magnitude
  DYN = 3'b111  // In instruction’s rm field, selects dynamic rounding mode; In Rounding Mode register, Invalid.
} fp_rounding_mode;

// Status flags
typedef struct packed {
  logic NV; // Invalid
  logic DZ; // Divide by zero
  logic OF; // Overflow
  logic UF; // Underflow
  logic NX; // Inexact
} fp_status_flags;

localparam int unsigned NUM_TAG_ID = 128;
localparam int unsigned TAG_ID_BITS = $clog2(NUM_TAG_ID);

typedef logic [TAG_ID_BITS-1:0] fp_tag_id;

// Information about a floating point value
typedef struct packed {
  logic             valid_op;      // valid operation
  fp_operation_t      op;          // fp operation
  fp_tag_id         tag_id;        // tag id
  fp_fmt            fmt;           // fp operation format
  fp_rounding_mode  rm;            // fp operation rouding mode
  logic [63:0]      operand_a;     // operand a
  logic [63:0]      operand_b;     // operand b
  logic [63:0]      operand_c;     // operand c
  logic             is_normal;     // is the value normal
  logic             is_subnormal;  // is the value subnormal
  logic             is_zero;       // is the value zero
  logic             is_inf;        // is the value infinity
  logic             is_nan;        // is the value NaN
  logic             is_snan;       // is the value a signalling NaN
  logic             is_qnan;       // is the value a quiet NaN
  logic             is_boxed;      // is the value properly NaN-boxed (RISC-V specific)
} fp_info;

// Floating point unit input interface
typedef struct packed {
  logic               op_valid;
  fp_operation_t      op;
  fp_fmt              fmt;
  fp_rounding_mode    rnd_mode;
  logic [63:0]        operand_a;
  logic [63:0]        operand_b;
  logic [63:0]        operand_c;
  fp_tag_id           tag_id;
} unit_input_t;

// Floating point unit output interface
typedef struct packed {
  logic               op_ready;      // result ready
  logic [63:0]        result;        // result data
  fp_status_flags     status;        // result status flag
  fp_tag_id           tag_id;        // result tag id
  logic               busy;          // fpu busy
} unit_output_t;

endpackage
