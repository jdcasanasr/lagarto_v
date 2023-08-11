// Integer Instructions
`define vadd_vv 	32'b000000xxxxxxxxxxx000xxxxx1010111
`define vadd_vx 	32'b000000xxxxxxxxxxx100xxxxx1010111
`define vadd_vi 	32'b000000xxxxxxxxxxx011xxxxx1010111

// Floating-Point Instructions
`define vfadd_vv 	32'b000000xxxxxxxxxxx001xxxxx1010111
`define vfadd_vf 	32'b000000xxxxxxxxxxx101xxxxx1010111

// Reduction Operations
`define vredsum_vs 	32'b000000xxxxxxxxxxx010xxxxx1010111

// Permutation Operations
`define vmv_x_s 	32'b0100001xxxxx00000010xxxxx1010111

// Mask Operations
`define vmand_mm 	32'b0110011xxxxxxxxxx010xxxxx1010111

// Memory Operations
`define vle8_v 		32'b000000x00000xxxxx000xxxxx0000111
`define vle16_v 	32'b000000x00000xxxxx101xxxxx0000111
`define vle32_v 	32'b000000x00000xxxxx110xxxxx0000111
`define vle64_v 	32'b000000x00000xxxxx111xxxxx0000111

// Fixed-Point Operations
`define vsaddu_vv	32'b100000xxxxxxxxxxx000xxxxx1010111
`define vsaddu_vx	32'b100000xxxxxxxxxxx100xxxxx1010111
`define vsaddu_vi	32'b100000xxxxxxxxxxx011xxxxx1010111