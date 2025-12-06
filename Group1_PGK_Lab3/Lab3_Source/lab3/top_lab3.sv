module top_lab3
			(input  logic CLOCK_50,
			 input  logic clk_r,
			 input  logic clk_w,
			 input  logic [8:0] SW,
			 input  logic [2:0] KEY,
			 output logic LEDR0, LEDR1,LEDR2,
			 output logic [6:0] HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);
			 
logic [23:0] data, in, out;
logic [5:0]  length;
logic 		 en1, en2, rst;			 
			 
fifo fifo(
			.clkw(clk_w),
			.clkr(clk_r),
			.rst(KEY[2]),
			.en1(KEY[1]),
			.en2(KEY[0]),
			.full(LEDR0),
			.empty(LEDR2),
			.notempty(LEDR1),
			.data(in),
			.length(length),
			.out(out)
);

lfshr gendata(
			.clk(clk_w),
			.rst(rst),
			.seed(16'd1),
			.out(in)
);


bcdtohex dis0(.bcd(data[3:0]), .segment(HEX0));
bcdtohex dis1(.bcd(data[7:4]), .segment(HEX1));
bcdtohex dis2(.bcd(data[11:8]), .segment(HEX2));
bcdtohex dis3(.bcd(data[15:12]), .segment(HEX3));
bcdtohex dis4(.bcd(data[19:16]), .segment(HEX4));
bcdtohex dis5(.bcd(data[23:20]), .segment(HEX5));


always @(posedge CLOCK_50) begin
	if(SW[0]) data <= out;
	else data <= length;
end




endmodule