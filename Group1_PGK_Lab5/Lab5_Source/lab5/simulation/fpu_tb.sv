
//-----------------------------------------------------------
// File: fpu_tb.v
// FPU Test Bench
//-----------------------------------------------------------
`timescale 1 ns/100 ps
module fpu_tb ();
 //----------------------------------------------------------
 // inputs to the DUT 
 logic 	      clock;
 logic	      rst;
 logic	      valid;
 logic [31:0] a, b;
 logic [1:0] op;
 logic [4:0] flags;
 logic [31:0] correct;
 logic	      check;
 int fail;
 //----------------------------------------------------------
 // outputs from the DUT 
 logic [18:0] out;
 //----------------------------------------------------------
 // corner case logic
 wire [18:0] inf_def ;
 wire [18:0] zero_def ;
 wire [18:0] Nan_def ;
 wire [18:0] one_def ;

 assign inf_def = {1'b0,{8{1'b1}},{10{1'b0}}};
 assign zero_def = {1'b0,{8{1'b0}},{10{1'b0}}};
 assign Nan_def = {1'b0,{8{1'b1}},1'b1,{9{1'b0}}};
 assign one_def = 19'b0011111110000000000;

 //assertion
 property rst_all;
	@(posedge clock) rst |-> ##1 (dut.sel == 0 && dut.result == 32'b0 && dut.flags == 0);
 endproperty
 
 property invalid_check;
	@(posedge clock) disable iff(rst) (!dut.op_valid) |-> ##1 (dut.sel == 0 && dut.result == 32'b0 && flags == 0);
 endproperty

 property invalidop_check;
	@(posedge clock) disable iff(rst) (flags[4]) |-> (out == Nan_def);
 endproperty

 property dividebyzero_check;
	@(posedge clock) disable iff(rst) (flags[3]) |-> (out == inf_def && b[31:13] == zero_def && op == 2'b10);
 endproperty

 property overflow_check;
	@(posedge clock) disable iff(rst) (flags[2]) |-> (out == inf_def);
 endproperty

 property underflow_check;
	@(posedge clock) disable iff(rst) (flags[1]) |-> (out == zero_def);
 endproperty
 


 assert property (rst_all) else begin 
	$error("rst error");
	fail++;
	end
 assert property (invalid_check) else begin 
	$error("invalid _error");
	fail++;
	end
assert property (invalidop_check) else begin 
	$error("flag invalid error");
	fail++;
	end
 assert property (dividebyzero_check) else begin 
	$error(" divide by zero flag error");
	fail++;
	end
 assert property (overflow_check) else begin 
	$error("overflow error");
	fail++;
	end
 // instantiate the Device Under Test (DUT)
 // using named instantiation
 fpu_top dut (
          .clk(clock),
	  .reset(rst),
	  .op_valid(valid),
          .a(a[31:13]),
          .b(b[31:13]),
          .op_type(op),
          .result(out),
	  .flags(flags)
        );
 //----------------------------------------------------------
 // create a 10Mhz clock
 always
 #100 clock = ~clock; // every 100 nanoseconds invert
 //----------------------------------------------------------
 // initial blocks are sequential and start at time 0
 initial
 begin
 rst = 1'b1;
 check = 1'b0;
 a = 32'b0;
 b = 32'b0;
 correct = 32'b0;
 #100
 rst = 1'b0;
 #100
 valid = 1'b1;

 clock = 0;
//ADD
    $display("ADD");
    op = 2'b00;
    //corner case
    a[31:13] = Nan_def;
    b[31:13] = one_def;
    correct[31:13] = Nan_def;
    #400 //Nan + 1 = Nan
        $display ("Output : %b %b %b %h", out[18], out[17:10], out[9:0], out);
        $display ("Correct: %b %b %b %h",correct[31], correct[30:23], correct[22:0], correct);
        $display();
    a[31:13] = zero_def;
    b[31:13] = one_def;
    correct[31:13] = one_def;
    #400 //zero + 1 = 1
        $display ("Output : %b %b %b %h", out[18], out[17:10], out[9:0], out);
        $display ("Correct: %b %b %b %h",correct[31], correct[30:23], correct[22:0], correct);
        $display();
    a[31:13] = inf_def;
    b[31:13] = inf_def;
    correct[31:13] = inf_def;
    #400 //inf + inf = inf
        $display ("Output : %b %b %b %h", out[18], out[17:10], out[9:0], out);
        $display ("Correct: %b %b %b %h",correct[31], correct[30:23], correct[22:0], correct);
        $display();
    a[31:13] = inf_def;
    b[31:13] = one_def;
    correct[31:13] = inf_def;
    #400 //inf + 1 = inf
        $display ("Output : %b %b %b %h", out[18], out[17:10], out[9:0], out);
        $display ("Correct: %b %b %b %h",correct[31], correct[30:23], correct[22:0], correct);
        $display();
    //direct case
	 $display("ADD direct case");
	 a[31:13] = 19'b0100001011110000000;
	 b[31:13] = 19'b0100010000010110000;
	 correct[31:13] = 19'b0100010000110100000;
	 #400 //120 + 600 = 720
        $display ("Output : %b %b %b %h", out[18], out[17:10], out[9:0], out);
        $display ("Correct: %b %b %b %h",correct[31], correct[30:23], correct[22:0], correct);
        $display();
	 a[31:13] = 19'b0100001100011110010;
	 b[31:13] = 19'b0100000010110001100;
	 correct[31:13] = 19'b0100001100100011110;
	 #400 //158.25 + 5.55 = 163.8
        $display ("Output : %b %b %b %h", out[18], out[17:10], out[9:0], out);
        $display ("Correct: %b %b %b %h",correct[31], correct[30:23], correct[22:0], correct);
        $display();
	 a[31:13] = 19'b0100001011111010101;
	 b[31:13] = 19'b1100001011100011111;
	 correct[31:13] = 19'b0100000100110110001;
	 #400 //125.34 + -113.95 = 11.39
        $display ("Output : %b %b %b %h", out[18], out[17:10], out[9:0], out);
        $display ("Correct: %b %b %b %h",correct[31], correct[30:23], correct[22:0], correct);
        $display();
    //random case
	 $display("ADD random case");
    a = 32'b01010100110100010000011011001011;
    b = 32'b01000110011111001101000100000010;
    correct = 32'b01010100110100010000011011001011;
    #400 //7182097000000.0 * 16180.252 = 7182097000000.0
        $display ("Output : %b %b %b %h", out[18], out[17:10], out[9:0], out);
        $display ("Correct: %b %b %b %h",correct[31], correct[30:23], correct[22:0], correct);
        $display();
    a = 32'b10111110100010000111000111111010;
    b = 32'b11100000000010101010110100001011;
    correct = 32'b11100000000010101010110100001011;
    #400 //-0.26649457 * -3.997062e+19 = -3.997062e+19
    	$display ("Output : %b %b %b %h", out[18], out[17:10], out[9:0], out);
        $display ("Correct: %b %b %b %h",correct[31], correct[30:23], correct[22:0], correct);
        $display();
    a = 32'b10101010111111101110111110110110;
    b = 32'b01110011010010111000101001001000;
    correct = 32'b01110011010010111000101001001000;
    #400 //-4.5285797e-13 * 1.6126113e+31 = 1.6126113e+31
    	$display ("Output : %b %b %b %h", out[18], out[17:10], out[9:0], out);
        $display ("Correct: %b %b %b %h",correct[31], correct[30:23], correct[22:0], correct);
        $display();
    #400
    $display("SUB");
    op = 2'b01;
	 correct[12:0] = 0;
    //corner case
    a[31:13] = Nan_def;
    b[31:13] = one_def;
    correct[31:13] = Nan_def;
    #400 //Nan - 1 = Nan
        $display ("Output : %b %b %b %h", out[18], out[17:10], out[9:0], out);
        $display ("Correct: %b %b %b %h",correct[31], correct[30:23], correct[22:0], correct);
        $display();
    a[31:13] = one_def;
    b[31:13] = zero_def;
    correct[31:13] = one_def;
    #400 //1 - zero = 1
        $display ("Output : %b %b %b %h", out[18], out[17:10], out[9:0], out);
        $display ("Correct: %b %b %b %h",correct[31], correct[30:23], correct[22:0], correct);
        $display();
    a[31:13] = inf_def;
    b[31:13] = inf_def;
    correct[31:13] = Nan_def;
    #400 //inf - inf = NaN
        $display ("Output : %b %b %b %h", out[18], out[17:10], out[9:0], out);
        $display ("Correct: %b %b %b %h",correct[31], correct[30:23], correct[22:0], correct);
        $display();
    a[31:13] = inf_def;
    b[31:13] = one_def;
    correct[31:13] = inf_def;
    #400 //inf - 1 = inf
        $display ("Output : %b %b %b %h", out[18], out[17:10], out[9:0], out);
        $display ("Correct: %b %b %b %h",correct[31], correct[30:23], correct[22:0], correct);
        $display();
    //direct case
	 $display("SUB direct case");
	 a[31:13] = 19'b0100010001001000000;
	 b[31:13] = 19'b0100001101110000000;
	 correct[31:13] = 19'b0100010000001100000;
	 #400 //800 - 240 = 560
        $display ("Output : %b %b %b %h", out[18], out[17:10], out[9:0], out);
        $display ("Correct: %b %b %b %h",correct[31], correct[30:23], correct[22:0], correct);
        $display();
	 a[31:13] = 19'b0100001011001001000;
	 b[31:13] = 19'b0011111100001100110;
	 correct[31:13] = 19'b0100001011000111111;
	 #400 //100.5 - 0.55 = 99.95
        $display ("Output : %b %b %b %h", out[18], out[17:10], out[9:0], out);
        $display ("Correct: %b %b %b %h",correct[31], correct[30:23], correct[22:0], correct);
        $display();
	 a[31:13] = 19'b1100001011111010101;
	 b[31:13] = 19'b0100001011100011111;
	 correct[31:13] = 19'b1100001101101111010;
	 #400 //-125.34567 - 113.9582 = -239.30387
        $display ("Output : %b %b %b %h", out[18], out[17:10], out[9:0], out);
        $display ("Correct: %b %b %b %h",correct[31], correct[30:23], correct[22:0], correct);
        $display();
    //random case
	 $display("SUB random case");
    a = 32'b11101101001111010000100011111000;
    b = 32'b00011111000011010101100111110010;
    correct = 32'b11101101001111010000100011111000;
    #400 //-3.6564693e+27 * 2.9932312e-20 = -3.6564693e+27
        $display ("Output : %b %b %b %h", out[18], out[17:10], out[9:0], out);
        $display ("Correct: %b %b %b %h",correct[31], correct[30:23], correct[22:0], correct);
        $display();
    a = 32'b01100110011010000001000000101001;
    b = 32'b01010100101111111001111100000100;
    correct = 32'b01100110011010000001000000101001;
    #400 //2.7397178e+23 * 6584053000000.0 = 2.7397178e+23
        $display ("Output : %b %b %b %h", out[18], out[17:10], out[9:0], out);
        $display ("Correct: %b %b %b %h",correct[31], correct[30:23], correct[22:0], correct);
        $display();
    a = 32'b01010000111101001111010111000110;
    b = 32'b11011000010101101111001100010001;
    correct = 32'b01011000010101101111010011111011;
    #400 //32877982000.0 * -945357800000000.0 = 945390700000000.0
        $display ("Output : %b %b %b %h", out[18], out[17:10], out[9:0], out);
        $display ("Correct: %b %b %b %h",correct[31], correct[30:23], correct[22:0], correct);
        $display();
    #400
//MULT
   $display("MULT");
    op = 2'b11;
	 correct[12:0] = 0;
    //corner case
    a[31:13] = Nan_def;
    b[31:13] = one_def;
    correct[31:13] = Nan_def;
    #400 //Nan * 1 = Nan
        $display ("Output : %b %b %b %h", out[18], out[17:10], out[9:0], out);
        $display ("Correct: %b %b %b %h",correct[31], correct[30:23], correct[22:0], correct);
        $display();
    a[31:13] = zero_def;
    b[31:13] = one_def;
    correct[31:13] = zero_def;
    #400 //zero * 1 = zero
        $display ("Output : %b %b %b %h", out[18], out[17:10], out[9:0], out);
        $display ("Correct: %b %b %b %h",correct[31], correct[30:23], correct[22:0], correct);
        $display();
    a[31:13] = inf_def;
    b[31:13] = inf_def;
    correct[31:13] = inf_def;
    #400 //inf * inf = inf
        $display ("Output : %b %b %b %h", out[18], out[17:10], out[9:0], out);
        $display ("Correct: %b %b %b %h",correct[31], correct[30:23], correct[22:0], correct);
        $display();
    a[31:13] = inf_def;
    b[31:13] = one_def;
    correct[31:13] = inf_def;
    #400 //inf * 1 = inf
        $display ("Output : %b %b %b %h", out[18], out[17:10], out[9:0], out);
        $display ("Correct: %b %b %b %h",correct[31], correct[30:23], correct[22:0], correct);
        $display();
    a[31:13] = inf_def;
    b[31:13] = zero_def;
    correct[31:13] = Nan_def;
    #400 //inf * 1 = inf
        $display ("Output : %b %b %b %h", out[18], out[17:10], out[9:0], out);
        $display ("Correct: %b %b %b %h",correct[31], correct[30:23], correct[22:0], correct);
        $display();
    //direct case
	 $display("MULT direct case");
	 a[31:13] = 19'b0100111010001111000;
	 b[31:13] = 19'b0101000101011111100;
	 correct[31:13] = 19'b0110000001111001110;
	 #400 //12e8 * 6e10 = 72 e18
        $display ("Output : %b %b %b %h", out[18], out[17:10], out[9:0], out);
        $display ("Correct: %b %b %b %h",correct[31], correct[30:23], correct[22:0], correct);
        $display();
	 a[31:13] = 19'b0100001011100110110;
	 b[31:13] = 19'b0100000100110100000;
	 correct[31:13] = 19'b0100010010100010001;
	 #400 //115.375 * 11.25 = 1297.96875
        $display ("Output : %b %b %b %h", out[18], out[17:10], out[9:0], out);
        $display ("Correct: %b %b %b %h",correct[31], correct[30:23], correct[22:0], correct);
        $display();
	 a[31:13] = 19'b0100011111110100110;
	 b[31:13] = 19'b0011110111100101011;
	 correct[31:13] = 19'b0100011001011011010;
	 #400 //125.3422e3 * 0.112 = 14038.3264
        $display ("Output : %b %b %b %h", out[18], out[17:10], out[9:0], out);
        $display ("Correct: %b %b %b %h",correct[31], correct[30:23], correct[22:0], correct);
        $display();
    //random case
	 $display("MULT random case");
    a = 32'b00011011010100000000001101010000;
    b = 32'b01011101101000101010010010111000;
    correct = 32'b00111001100001000010011111110000;
    #400 //1.7206427e-22 * 1.4649618e+18 = 0.00025206758
        $display ("Output : %b %b %b %h", out[18], out[17:10], out[9:0], out);
        $display ("Correct: %b %b %b %h",correct[31], correct[30:23], correct[22:0], correct);
        $display();
    a = 32'b01001001010011101111100100100100;
    b = 32'b10111101000011111111101001010001;
    correct = 32'b11000110111010001100111100011000;
    #400 //847762.25 * -0.03515083 = -29799.547
        $display ("Output : %b %b %b %h", out[18], out[17:10], out[9:0], out);
        $display ("Correct: %b %b %b %h",correct[31], correct[30:23], correct[22:0], correct);
        $display();
    a = 32'b01010110011011101000111111011001;
    b = 32'b01000101010010011001111000001100;
    correct = 32'b01011100001110111110001000111001;
    #400 //65575397000000.0 * 3225.878 = 2.1153822e+17
        $display ("Output : %b %b %b %h", out[18], out[17:10], out[9:0], out);
        $display ("Correct: %b %b %b %h",correct[31], correct[30:23], correct[22:0], correct);
        $display();
    #400
//DIV
    $display("DIV");
    op = 2'b10;
	 correct[12:0] = 0;
    //corner case
    a[31:13] = Nan_def;
    b[31:13] = one_def;
    correct[31:13] = Nan_def;
    #400 //Nan / 1 = Nan
        $display ("Output : %b %b %b %h", out[18], out[17:10], out[9:0], out);
        $display ("Correct: %b %b %b %h",correct[31], correct[30:23], correct[22:0], correct);
        $display();
    a[31:13] = zero_def;
    b[31:13] = one_def;
    correct[31:13] = zero_def;
    #400 //zero / 1 = zero
        $display ("Output : %b %b %b %h", out[18], out[17:10], out[9:0], out);
        $display ("Correct: %b %b %b %h",correct[31], correct[30:23], correct[22:0], correct);
        $display();
    a[31:13] = one_def;
    b[31:13] = zero_def;
    correct[31:13] = inf_def;
    #400 //1 / zero = inf
        $display ("Output : %b %b %b %h", out[18], out[17:10], out[9:0], out);
        $display ("Correct: %b %b %b %h",correct[31], correct[30:23], correct[22:0], correct);
        $display();
    a[31:13] = zero_def;
    b[31:13] = zero_def;
    correct[31:13] = Nan_def;
    #400 //zero / zero = NaN
        $display ("Output : %b %b %b %h", out[18], out[17:10], out[9:0], out);
        $display ("Correct: %b %b %b %h",correct[31], correct[30:23], correct[22:0], correct);
        $display();
    a[31:13] = inf_def;
    b[31:13] = inf_def;
    correct[31:13] = Nan_def;
    #400 //inf / inf = NaN
        $display ("Output : %b %b %b %h", out[18], out[17:10], out[9:0], out);
        $display ("Correct: %b %b %b %h",correct[31], correct[30:23], correct[22:0], correct);
        $display();
    a[31:13] = inf_def;
    b[31:13] = one_def;
    correct[31:13] = inf_def;
    #400 //inf * 1 = inf
        $display ("Output : %b %b %b %h", out[18], out[17:10], out[9:0], out);
        $display ("Correct: %b %b %b %h",correct[31], correct[30:23], correct[22:0], correct);
        $display();
    a[31:13] = one_def;
    b[31:13] = inf_def;
    correct[31:13] = zero_def;
    #400 //1 / inf = zero
        $display ("Output : %b %b %b %h", out[18], out[17:10], out[9:0], out);
        $display ("Correct: %b %b %b %h",correct[31], correct[30:23], correct[22:0], correct);
        $display();
    //direct case
	 $display("DIV direct case");
	 a[31:13] = 19'b0101000111011111100;
	 b[31:13] = 19'b0100111000001111000;
	 correct[31:13] = 19'b0100001101001000000;
	 #400 //12 e10 / 6 e8 = 2 e2
        $display ("Output : %b %b %b %h", out[18], out[17:10], out[9:0], out);
        $display ("Correct: %b %b %b %h",correct[31], correct[30:23], correct[22:0], correct);
        $display();
	 a[31:13] = 19'b0100001100101111010;
	 b[31:13] = 19'b0100000010101000000;
	 correct[31:13] = 19'b0100001000000101100;
	 #400 //175.25 / 5.25 = 33.380952381
        $display ("Output : %b %b %b %h", out[18], out[17:10], out[9:0], out);
        $display ("Correct: %b %b %b %h",correct[31], correct[30:23], correct[22:0], correct);
        $display();
	 a[31:13] = 19'b0100001011110110101;
	 b[31:13] = 19'b1100001011001111111;
	 correct[31:13] = 19'b1011111110010111111;
	 #400 //123.34 / -103.95 = -1.18653198653
        $display ("Output : %b %b %b %h", out[18], out[17:10], out[9:0], out);
        $display ("Correct: %b %b %b %h",correct[31], correct[30:23], correct[22:0], correct);
        $display();
    //random case
	 $display("DIV random case");
    a = 32'b00001101111001110000011100101100;
    b = 32'b00111011100000011101001111110011;
    correct = 32'b00010001111000111100011001110110;
    #400 //1.4238201e-30 * 0.003962034 = 3.5936596e-28
        $display ("Output : %b %b %b %h", out[18], out[17:10], out[9:0], out);
        $display ("Correct: %b %b %b %h",correct[31], correct[30:23], correct[22:0], correct);
        $display();
    a = 32'b01001110010111110100100101011111;
    b = 32'b11111100011110111111011111010001;
    correct = 32'b10010001011000101101110000010000;
    #400 //936531900.0 * -5.2331713e+36 = -1.7896068e-28
        $display ("Output : %b %b %b %h", out[18], out[17:10], out[9:0], out);
        $display ("Correct: %b %b %b %h",correct[31], correct[30:23], correct[22:0], correct);
		  $display();
    a = 32'b00100011101110001101010001010010;
    b = 32'b00111110110101100101010111100110;
    correct = 32'b00100100010111001100001000010111;
    #400 //2.0039241e-17 * 0.4186241 = 4.7869296e-17
        $display ("Output : %b %b %b %h", out[18], out[17:10], out[9:0], out);
        $display ("Correct: %b %b %b %h",correct[31], correct[30:23], correct[22:0], correct);
        $display();
    $display ("Done.");
    $display  ("Failed = %0d",fail); 
    $finish;
 // stop the simulation
 end

endmodule