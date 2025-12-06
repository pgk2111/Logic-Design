`timescale 1ns / 1ps

module tb;

	// Inputs
	logic clk;
	logic rst;	
	logic strobe;
	logic [3:0] token;

	// Outputs
	logic ready, error;
	logic [7:0] answer;

	// Instantiate Unit Under Test (UUT)
	converter dut(
		.clk(clk),
		.rst(rst),
		.input_stb(strobe),
		.input_data(token),
		.ready(ready),
		.error(error),
		.out(answer)
	);

	// 40MHz clock
	always begin
		#12 clk = 0;
		#13 clk = 1;
	end

	initial begin

		// Initialize Inputs
		clk = 1;
		strobe = 0;
		token = 4'h0;

		// 3 + 4 =
	        rst = 1'b1;
		#10
		rst = 1'b0;
		#10
		puttok(4'h3); // 3
		puttok(4'hA); // +
		puttok(4'h4); // 4
		puttok(4'hE); // =

		// 7 - 8 / 4 =
		
		rst = 1'b1;
		#10
		rst = 1'b0;
		#10
		puttok(4'h8); // 8
		puttok(4'hB); // -
		puttok(4'h2); // 7
                puttok(4'hA); // +
		puttok(4'h6); // 6
		puttok(4'hE); // =

		// 
		rst = 1'b1;
		#10
		rst = 1'b0;
		#10
		puttok(4'h3); // 3
		puttok(4'h3); // 3
		puttok(4'hA); // +
		puttok(4'h4); // 4
		puttok(4'h5); // 5
		puttok(4'hE); // =
    	        //
		rst = 1'b1;
		#10
		rst = 1'b0;
		#10
		puttok(4'h9); // 9
		puttok(4'h3); // 3
		puttok(4'hB); // -
		puttok(4'h2); // 2
		puttok(4'h9); // 9
		puttok(4'hE); // =
		rst = 1'b1;
		#10
		rst = 1'b0;
		#10
		puttok(4'h9); // 9
		puttok(4'h9); // 9
		puttok(4'hA); // +
		puttok(4'h9); // 9
		puttok(4'h9); // 9
		puttok(4'hB); // -
		puttok(4'h8); // 8
 		puttok(4'h0); // 0
		puttok(4'hE); // =
		//
		rst = 1'b1;
		#10
		rst = 1'b0;
		#10
 		puttok(4'h9); // 9
		puttok(4'hA);
		puttok(4'hE);
 		$monitor("%d",answer);
		// Finished
		#1000 $display("finished");
		$stop;
	end

	task puttok;
		input [3:0] value;
		begin
			wait(!clk) #1 token = value;
			wait(clk) #1 strobe = 1;
			wait(!clk);
			wait(clk) #1 strobe = 0;
			wait(!clk);
			if(error) $stop;
			else
			wait(ready);
		end
	endtask

endmodule
