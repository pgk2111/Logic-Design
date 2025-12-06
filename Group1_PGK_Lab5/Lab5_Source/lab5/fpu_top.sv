// Lab 5 top level for 16-bit IEEE 754 FPU

module fpu_top (
  input         clk,
  input         reset,
  input         op_valid,
  input  [1:0]  op_type, // 00 - Add, 01 - Subtract, 10 - Multiply, 11 - Divide
  input  [18:0] a,
  input  [18:0] b,
  output logic [18:0] result,
  output logic [4:0]  flags 
);

// FPU flags  
// flags[4] - invalid operation
// flags[3] - divide by zero
// flags[2] - overflow
// flags[1] - underflow
// flags[0] - inexact rounding


assign ADD = !op_type[1] & !op_type[0];
assign SUB = !op_type[1] &  op_type[0];
assign DIV =  op_type[1] & !op_type[0];
assign MULT =  op_type[1] &  op_type[0];

logic [18:0] in_a_add, in_b_add, in_a_mult, in_b_mult, in_a_div, in_b_div,out_add, out_mult, out_div;
logic [4:0] add_flag, div_flag, mult_flag;
logic [2:0] sel;
logic 		check;

add_sub U1 (
          .a(in_a_add),
          .b(in_b_add),
          .add_sel(sel[0]),
          .result(out_add),
			 .flag(add_flag)
        );

mult U2 (
          .a(in_a_mult),
          .b(in_b_mult),
          .mult_sel(sel[1]),
          .result(out_mult),
			 .flag(mult_flag)
        );
div U3 (
          .a(in_a_div),
          .b(in_b_div),
          .div_sel(sel[2]),
          .result(out_div),
			 .flag(div_flag)
        );		  

			
always @(posedge clk) begin 
	if(reset) begin
	sel <= 0;
	check <= 0;
	in_a_add <= 0;
	in_b_add <= 0;
	in_a_mult <= 0;
	in_b_mult <= 0;
	in_a_div <= 0;
	in_b_div <= 0;
	result <= 0;
	flags <= 0;
	end else if(op_valid) begin
	if (ADD) begin
			in_a_add <= a;
			in_b_add <= b;
			sel[0] <= 1'b1;
			check <= 1'b1;
			result <= out_add;
			flags <= add_flag;
	end else if (SUB) begin
			in_a_add <= a;
			in_b_add[17:0] <= b[17:0];
			in_b_add[18] <= ~b[18];
			sel[0] <= 1'b1;
			check <= 1'b1;
			result <= out_add;	
			flags <= add_flag;	
	end else if (MULT) begin 
			in_a_mult <= a;
			in_b_mult <= b;
			sel[1] <= 1'b1;
			check <= 1'b1;
			result <= out_mult;	
			flags <= mult_flag;
	end else if (DIV) begin
			in_a_div <= a;
			in_b_div <= b;
			sel[2] <= 1'b1;
			check <= 1'b1;
			result <= out_div;
			flags <= div_flag;			
	end
	end
end

///////////
endmodule