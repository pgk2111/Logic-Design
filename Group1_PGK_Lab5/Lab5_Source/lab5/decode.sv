module decode(
	input [18:0] in,
	//out
	output logic sign ,
	output logic NaN,
	output logic inf,
	output logic zero,
	output logic normal,
	output logic denormal,
	output logic signed [9:0] out_e,
	output logic [10:0] out_m
);

logic [7:0] e;
logic [9:0] m;
logic [10:0] shift;
int i;
logic [10:0] mask;

assign mask ={11{1'b1}};


assign e = in[17:10];	
assign m = in[9:0];
assign sign = in[18];
assign inf = ( e == 8'hFF && m == 0) ? 1'b1 : 1'b0;
assign NaN = ( e == 8'hFF 	&& m != 0) ? 1'b1 : 1'b0;
assign zero = ( e == 0 && m == 0 ) ? 1'b1 : 1'b0;
assign denormal = ( e == 0 && m != 0 ) ? 1'b1 : 1'b0;
assign normal = ~(inf | NaN | zero | denormal);

always_comb begin
out_e = e;
out_m = m;
shift = 0;
i = 0;
	if(normal) begin
		out_e = e - 8'd127;
		out_m = {1'b1,m};
	end else if (denormal) begin
		for (i = 8; i >0; i= i>>1) begin
			if( (m & (mask<<(11-i)) == 0)) begin
				out_m = m << i;
				shift = shift | i ;
			end
		end
		out_e = e - 8'd127 - shift;
	end else begin
	out_e = e;
	out_m = m;
	end
end

endmodule 
