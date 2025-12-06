`timescale 1ns / 1ps
module fifoctrl
    (
     clkw, //clock write
     clkr, //clock read
     rst,
     
     fiford,    // FIFO control
     fifowr,

     fifofull,  // high when fifo full
     notempty,  // high when fifo not empty
     fifolen,   // fifo length

                // Connect to memories
     write,     // enable to write memories
     wraddr,    // write address of memories
     read,      // enable to read memories
     rdaddr     // read address of memories
     );

parameter ADDRBIT = 5;
parameter LENGTH = 32;

input   clkw,
        clkr,
        rst,
        fiford,
        fifowr;

output  fifofull,
        notempty;

output [ADDRBIT:0] fifolen;

output  write;
output  read;

output [ADDRBIT-1:0] wraddr;
output [ADDRBIT-1:0] rdaddr;

wire     [ADDRBIT:0]   fifo_len;
reg     [ADDRBIT:0] wrcnt;
reg     [ADDRBIT:0] rdcnt;

wire    [ADDRBIT-1:0] wraddr;
assign  wraddr = wrcnt;

wire    fifoempt;
assign  fifoempt    =   (fifo_len=={1'b0,{ADDRBIT{1'b0}}});

wire    notempty;
assign  notempty    =   !fifoempt;

wire    fifofull;
assign  fifofull    =   (wrcnt + 1'b1 == rdcnt || (wrcnt == 6'h20 && rdcnt == 0)) ? 1'b1 : 1'b0;

assign  fifolen     =   fifo_len;

reg clk_en, clken;

wire    write;
assign  write       =   (fifowr& !fifofull & clk_en);

wire    read;
assign  read        =   (fiford& !fifoempt & clken);



wire    [ADDRBIT-1:0] rdaddr;
assign  rdaddr = rdcnt;


assign fifo_len = (wrcnt >= rdcnt) ? (wrcnt - rdcnt) : (wrcnt - rdcnt + 6'd33);



always @(posedge clkw or posedge rst) begin
	if(rst) clk_en <= 0;
	else clk_en <= 1;
end

always @(posedge clkr or posedge rst) begin
	if(rst) clken <= 0;
	else clken <= 1;
end

always @(posedge clkw or posedge rst)
    begin
    if(rst) wrcnt <= 6'b0;
    else if(write) begin 
		wrcnt <= wrcnt  + 1'b1;
		if(wrcnt == 6'h20) wrcnt <= 6'b0;
    end
end

always @(posedge clkr or posedge rst)
    begin
    if(rst) rdcnt <= 6'b0;
	 else if(read) begin
	      rdcnt <= rdcnt + 1'b1;
	      if (rdcnt == 6'h20) rdcnt <= 6'b0;
	 end
end
	 	 
	
endmodule
