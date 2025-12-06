`timescale 1ns / 1ps
module fifo (
	input 		  clkw,
	input 		  clkr,
	input 		  rst,
	input 		  en1,en2,
	output 		  full,
	output 		  empty,
	output 		  notempty,
	input  [23:0] data,
	output [5:0]  length,
	output [23:0] out
);


logic wr,rd;
logic temp;
logic [4:0] rdadd; 
logic [4:0] wradd;

assign empty = !temp;
assign notempty = temp;



fifoctrl  ctrl(
     .clkw(clkw), //clock write
     .clkr(clkr), //clock read
     .rst(rst),
     
     .fiford(en1),    // FIFO control
     .fifowr(en2),

     .fifofull(full),  // high when fifo full
     .notempty(temp),  // high when fifo not empty
     .fifolen(length),   // fifo length

                // Connect to memories
     .write(wr),     // enable to write memories
     .wraddr(wradd),    // write address of memories
     .read(rd),      // enable to read memories
     .rdaddr(rdadd)     // read address of memories
     );
  
	  
ram2 mem(
   .data(data),
	.rdaddress(rdadd),
	.rdclock(clkr),
	.rden(rd),
	.wraddress(wradd),
	.wrclock(clkw),
	.wren(wr),
	.q(out));


	
endmodule