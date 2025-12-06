module lfshr (clk,rst,seed,out); //16-bit linear feed back shift register
    input clk;
    input rst;
    input logic [15:0] seed;
    output logic [15:0] out;

	 wire feedback;

assign feedback = out[15] ^ out[13] ^ out[12] ^ out[10] ^ out[0];	 
	 
always @(posedge clk) begin
		if(rst) begin
		out <= seed;
		end else begin
		out <= {out[14:0],feedback};
		end
end
	 

endmodule