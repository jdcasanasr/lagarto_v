`include		"../../includes/riscv_vector.vh"
module	vector_decode	
#(
	parameter	INSTRUCTION_LENGTH	 	= 	`instruction_length,
	parameter	SYSTEM_VECTOR_LENGTH 	=	`system_vector_length,
	parameter	RESOURCE_VECTOR_LENGTH 	= 	`resource_vector_length,
	parameter	REGISTER_VECTOR_LENGTH 	=	`register_vector_length,
	parameter	OPERATION_VECTOR_LENGTH	= 	`operation_vector_length
)(
	input	[INSTRUCTION_LENGTH-1:0]			instruction_i,
		
	output	[SYSTEM_VECTOR_LENGTH-1:0]			system_vector_o,
	output	[RESOURCE_VECTOR_LENGTH-1:0]		resource_vector_o,
	output	[REGISTER_VECTOR_LENGTH-1:0]		register_vector_o,
	output	[OPERATION_VECTOR_LENGTH-1:0]		operation_vector_o
);
	vdecode	
	#(
		.INSTRUCTION_LENGTH	 		(INSTRUCTION_LENGTH	 	),
		.SYSTEM_VECTOR_LENGTH 		(SYSTEM_VECTOR_LENGTH 	),
		.RESOURCE_VECTOR_LENGTH 	(RESOURCE_VECTOR_LENGTH ),
		.REGISTER_VECTOR_LENGTH 	(REGISTER_VECTOR_LENGTH ),
		.OPERATION_VECTOR_LENGTH 	(OPERATION_VECTOR_LENGTH)
	)
	decode
	(
		.instruction_i				(instruction_i		),
		.system_vector_o			(system_vector_o	),
		.resource_vector_o			(resource_vector_o	),
		.register_vector_o			(register_vector_o	),
		.operation_vector_o			(operation_vector_o	)
	);
endmodule
