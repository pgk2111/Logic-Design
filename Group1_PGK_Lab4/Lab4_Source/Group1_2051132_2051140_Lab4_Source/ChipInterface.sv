//`default_nettype none

// Starter code for Project 4.  See README.md for details

module ChipInterface
  (input  logic       CLOCK_50,
   input  logic [3:0] SW,
   input  logic [2:0] KEY,
	output logic [8:0] LEDR,
   output logic [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);
	
logic clk;
logic [7:0] answer;
logic [15:0] bcd;	
parameter DIV_FACTOR = 25_000_000;
integer count;


converter rpn_cal(
		.clk(clk),
		.rst(!KEY[2]),
		.input_stb(!KEY[1]),
		.input_data(SW[3:0]),
		.ready(LEDR[0]),
		.error(LEDR[1]),
		.out(answer)
	);

bin2bcd conv(.bin({6'b0,{answer}}),.bcd(bcd));
	
bcdtohex dis0(.bcd(bcd[3:0]), .segment(HEX0));
bcdtohex dis1(.bcd(bcd[7:4]), .segment(HEX1));
bcdtohex dis2(.bcd(bcd[11:8]), .segment(HEX2));

always @(posedge CLOCK_50) begin: clock05HZ
	if(!KEY[0]) begin
		count  <= 0;
		clk  <= 0;
	end else
	 if (count == (DIV_FACTOR / 2) - 1) begin
       clk <= ~clk; // Toggle the output clock
       count <= 0;          // Reset the counter
    end else begin
       count <= count + 1;  // Increment the counter
   end
end

endmodule:ChipInterface