//`default_nettype none

// Starter code for Project 2.  See README.md for details

module ChipInterface(  
	//inputs
	input  logic       CLOCK_50,
   input  logic [9:0] SW,
   input  logic [3:0] KEY,
	
	//test signal
	output logic [23:0] sum,
	
	//outputs
	output logic		 done,
   output logic [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0
);
	
	logic [23:0] data, result, ticks;
	
	assign sum = data;
	assign data = (SW[0] == 0) ? result : ticks;
	
	p2 p2
	(  
		.clk_i 	(CLOCK_50),
		.rst_ni 	(KEY[0]	),
   	.result 	(result	),
		.ticks	(ticks	),
		.done		(done		)
	);
	
	bcdtohex iohex5
	(
		.bcd		(data[23:20]),
		.segment	(HEX5)
   );
	
	bcdtohex iohex4
	(
		.bcd		(data[19:16]),
		.segment	(HEX4)
   );
	
	bcdtohex iohex3
	(
		.bcd		(data[15:12]),
		.segment	(HEX3)
   );
	
	bcdtohex iohex2
	(
		.bcd		(data[11:8]),
		.segment	(HEX2)
   );
	
	bcdtohex iohex1
	(
		.bcd		(data[7:4]),
		.segment	(HEX1)
   );
	
	bcdtohex iohex0
	(
		.bcd		(data[3:0]),
		.segment	(HEX0)
   );
	
endmodule
