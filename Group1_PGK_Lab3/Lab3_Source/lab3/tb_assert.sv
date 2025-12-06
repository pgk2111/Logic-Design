`timescale 1ns / 1ps
module tb_assert;

logic clk_w;
logic clk_r;
logic rst;
logic en_rd;
logic en_wr;
logic full;
logic empty;
logic notempty;
logic [23:0] in, out;
logic [5:0] length;

fifo uut(
			.clkw(clk_w),
			.clkr(clk_r),
			.rst(rst),
			.en1(en_rd),
			.en2(en_wr),
			.full(full),
			.empty(empty),
			.notempty(notempty),
			.data(in),
			.length(length),
			.out(out)
);

//
  property async_rst_startup;
	  @(posedge clk_w or posedge clk_r) rst |-> ##1 (uut.ctrl.wrcnt==0 && uut.ctrl.rdcnt == 0 && empty);
  endproperty
  
  // rst check in general
  property async_rst_chk;
	  @(posedge rst) 1'b1 |-> ##1 @(posedge clk_w | clk_r) (uut.ctrl.wrcnt==0 && uut.ctrl.rdcnt == 0 && empty);
  endproperty
  //
  sequence rd_detect(ptr);
    ##[0:$] (uut.rd && !empty && (uut.ctrl.rdcnt == ptr));
  endsequence
  property data_wr_rd_chk(wrPtr);
    // local variable
    integer ptr;
    logic [23:0] data;
    @(posedge clk_w) disable iff(rst)
    (uut.wr && !full, ptr = wrPtr, data = in, $display($time, " wrcnt=%h, i_fifo=%h",uut.ctrl.wrcnt, data))
    |-> ##1 @(posedge clk_r) first_match(rd_detect(ptr), $display($time, " rdcnt=%h, o_fifo=%h",uut.ctrl.rdcnt, out)) ##0  out == data;
  endproperty
  //
  property dont_write_if_full;
    // @(posedge i_clk) disable iff(!i_rst_n) o_full |-> ##1 $stable(wr_ptr);
    // alternative way of writing the same assertion
    @(posedge clk_w) disable iff(rst) (uut.wr && full) |-> ##1 uut.ctrl.wrcnt == $past(uut.ctrl.wrcnt);
  endproperty
  //
  property dont_read_if_empty;
    @(posedge clk_r) disable iff(rst) (uut.rd && empty) |-> ##1 $stable(uut.ctrl.rdcnt);
  endproperty
  //  
  property inc_wr_one;
      @(posedge clk_w) disable iff(rst) (uut.ctrl.write && !full) |-> ##1 ($past(uut.ctrl.wrcnt) + 1'b1 == uut.ctrl.wrcnt)||
									  (uut.ctrl.wrcnt == 0 && $past(uut.ctrl.wrcnt) == 6'h20);
  endproperty
  //
  property inc_rd_one;
		@(posedge clk_r) disable iff(rst) (uut.ctrl.read && !empty) |-> ##1 ($past(uut.ctrl.rdcnt) + 1'b1 == uut.ctrl.rdcnt)||
										    (uut.ctrl.rdcnt == 0 && $past(uut.ctrl.rdcnt) == 6'h20) ;
  endproperty
  //	 
  //
  property empty_full;
		@(posedge clk_w or posedge clk_r) (full || empty ) |-> ##1 ({empty,full} != 2'b11);
  endproperty
  //
  property write_check;
		@(posedge clk_w) disable iff(rst) (uut.wr && !full) |-> ##1 (uut.ctrl.fifolen == $past(uut.ctrl.fifolen) + 1'b1) ||
																				  ((uut.ctrl.fifolen == $past(uut.ctrl.fifolen)) && (uut.ctrl.rdcnt == $past(uut.ctrl.rdcnt) + 1'b1)) ||
																				  ((uut.ctrl.fifolen == $past(uut.ctrl.fifolen) + 1'b1) && (uut.ctrl.rdcnt == $past(uut.ctrl.rdcnt) + 2'b10));
  endproperty
  //
  property read_check;
		@(posedge clk_r) disable iff(rst) (uut.rd && !empty) |-> ##1 (uut.ctrl.fifolen == $past(uut.ctrl.fifolen) - 1'b1) ||
																				  ((uut.ctrl.fifolen == $past(uut.ctrl.fifolen)) && (uut.ctrl.wrcnt == $past(uut.ctrl.wrcnt) + 1'b1));
  endproperty
  //
  property not_empty_check;
		@(posedge clk_w) disable iff(rst) (uut.wr && empty) |-> ##1 (notempty == 1'b1);
  endproperty
  //
  property empty_after_last_rd_check;
		@(posedge clk_r) disable iff(rst) (uut.rd && full) |-> ##1 (full == 1'b0);
  endproperty
  //
  property full_len;
		@(posedge clk_w) disable iff(rst) (uut.ctrl.fifolen == 6'h20) |-> full;
  endproperty
  //
  property empty_len;
		@(posedge clk_w) disable iff(rst) (uut.ctrl.fifolen == 6'h0) |-> empty;
  endproperty
//assertion
int fail;
assert property (async_rst_startup) else begin 
	$error("rst at clock dont work");
	fail++;
	end
assert property (async_rst_chk) else begin 
	$error("rst dont work");
	fail++;
	end
assert property (data_wr_rd_chk(1)) else  begin
	$error("write wrong");
	fail++;
	end
assert property (dont_write_if_full) else begin
	$error("data write when full");
	fail++;
	end
assert property (dont_read_if_empty) else begin
	$error("read from empty data");
	fail++;
	end
assert property (inc_wr_one) else begin
	$error("inc wr wrong");
	fail++;
	end
assert property (inc_rd_one) else begin
	$error ("inc rd wrong");
	fail++;
	end
assert property (empty_full) else begin 
	$error ("empty and full same time ");
	fail++;
	end
assert property (write_check) else begin
	$error ("write error ");
	fail++;
	end
assert property (read_check) else begin
	$error ("read error ");
	fail++;
	end
assert property (not_empty_check) else begin 
	$error ("after first write data still empty");
	fail++;
	end
assert property (empty_after_last_rd_check) else begin 
	$error ("after last read data still full");
	fail++;
	end
assert property (full_len) else begin
	$error ("error full");
	fail++;
	end
assert property (empty_len) else begin
	$error ("error empty");
	fail++;
	end
//scenario 	
initial begin
        // Initialize signals
        clk_w = 0;
        clk_r = 0;
        rst = 1;
        en_rd = 0;
        en_wr = 0;
		  
        // Apply reset
        #10 rst = 0;  // Deassert reset after some delay
	
// Test case 1: Write into FIFO until full
    $display("Starting test case 1: Writing into FIFO...");
    for (int i = 0; i < 33; i++) begin
      en_wr = 1;
      in = $random;  // Random input data
      #10;
		en_wr = 0;
      #10;
    end
	 
	 if (full)
      $display("Test case 1 passed: FIFO is full after %0d writes", 32);
    else
      $display("Test case 1 failed: FIFO is not full!");
// Test case 2: Read from FIFO until empty		
	$display("Starting test case 2: Reading from FIFO...");
    for (int i = 0; i < 32; i++) begin
      en_rd = 1'b1;
      #10;
      en_rd = 0;
      #10;
	 end
	 
	 if (empty)
      $display("Test case 2 passed: FIFO is empty after %0d reads", 32);
    else
      $display("Test case 2 failed: FIFO is not empty!");
        // Run the simulation for a fixed duration
//Test case 3 write then read
 $display("Starting test case 3");
	for (int i = 0; i < 5; i++) begin
      en_wr = 1;
      in = $random;  // Random input data
      #10;
		en_wr = 0;
      #10;
		en_rd = 1'b1;
      #10;
      en_rd = 0;
      #10;
    end	
	 
	 if (empty)
      $display("Test case 3 passed");
    else
      $display("Test case 3 failed");
// Test case 4 write full read then write until full and read to empty
 $display("Starting test case 4");
	for (int i = 0; i < 32; i++) begin
      en_wr = 1;
      in = $random;  // Random input data
      #10;
		en_wr = 0;
      #10;
    end
	for (int i = 0; i < 5; i++) begin
      en_rd = 1'b1;
      #10;
      en_rd = 0;
      #10;
	 end
	for (int i = 0; i < 32; i++) begin
      en_wr = 1;
      in = $random;  // Random input data
      #10;
		en_wr = 0;
      #10;
    end
	 for (int i = 0; i < 32; i++) begin
      en_rd = 1'b1;
      #10;
      en_rd = 0;
      #10;
	 end
	if (empty)
      $display("Test case 4 passed");
    else
      $display("Test case 4 failed");
//Test case 5 write and read same time
$display("Starting test case 5");
      en_wr = 1;
		en_rd = 1;
      in = $random;  // Random input data
      #10;
		en_wr = 0;
		en_rd = 0;
      #10;

if(!fail) 
$display("PASSED");
else 
$display("FAILED, num fail = %0d",fail);
     
$finish;
end


always #10 clk_w = ~clk_w;
always #5 clk_r = ~clk_r;





	
	
endmodule