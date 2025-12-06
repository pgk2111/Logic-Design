module top(clk,rst,en,input_data,output_data,en_out);

input wire clk;
input wire rst;
input logic en;
input logic [3:0] input_data;
output logic en_out;
output logic [3:0] output_data;


converter conv(
	.clk
	.rst
	.input_stb
	.input_data
	.is_input_op
	.input_ack
	.output_stb
	.output_data
	.is_output_op
	.output_ack
)


rpn_calculator cal(
	.clk
	.rst
	.input_stb
	.input_data
	.is_input_op
	.input_ack
	.output_stb
	.output_data
	.output_ack
)


endmodule