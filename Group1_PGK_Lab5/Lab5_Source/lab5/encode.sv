module encode(in_e,in_m,out_e,out_m,inexact);

parameter M = 22;

input [9:0] in_e;
input [M-1:0] in_m;
output [9:0] out_e;
output [9:0] out_m;
output  inexact;

logic [11:0] t2_m;
logic [11:0] round_m;
logic [11:0] temp_m;
logic None_zero;

assign t2_m = in_m[M-1:M-11] + 1'b1;
assign round_m = in_m[M-12] ? t2_m : in_m[M-1:M-11];
assign out_e = in_e + round_m[11];
assign temp_m = round_m >> round_m[11];
assign out_m = temp_m[9:0];
assign None_zero = |in_m[M-13:0];
assign inexact = in_m[M-12]| None_zero ;



 
endmodule