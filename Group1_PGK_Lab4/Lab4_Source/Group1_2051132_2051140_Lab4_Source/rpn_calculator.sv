/*
I got this Idea from the following link:
Title: Polish Postfix Notation Calculator
You can take a look at this very interesting project.
*/
module rpn_calculator(	
	input wire clk,
	input wire rst,	   
	// Input variables
	input 	wire input_stb,
	input 	wire [6:0] input_data,
	input 	wire  is_op,
	output 	reg input_ack,	
	// Output variables
	output reg	[7:0] output_data
	);

///////////////////////////////////
//Write your code from here


typedef enum logic [3:0] {
    IDLE = 4'b0000,
    PUSH = 4'b0001,
	 CAL1	= 4'b0010,
	 CAL2  = 4'b0011,
	 CAL3 = 4'b0100,
	 DISP = 4'b0101,
	 WAIT = 4'b0110,
	 WAIT2 = 4'b0111,
	 WAIT3 = 4'b1000
} state_t;

state_t state;

assign is_equal = (input_data == 4'hE) ? 1'b1 : 1'b0;
logic [6:0] reg1, reg2;
logic push, pop;
logic [7:0] in, out;
logic [3:0] len;
//

//
always @(posedge clk) begin
if(rst) begin
	state <= IDLE;
	reg1 <= 7'bx;
	reg2 <= 7'bx;
	push <= 0;
	pop <= 0;
	output_data <= 8'b0;
	out <= 8'bx;
	input_ack <= 1'b0;
end else begin
	case(state) 
	 IDLE: begin
				if (input_stb) begin
					if(is_op) begin
					 if(is_equal) state <= DISP;
					 else	state <= CAL1;
					end else state <= PUSH;
				end
			 end
	 PUSH: begin
	       push <= 1'b1;
			 in <= input_data;
			 input_ack <= 1'b1;
			 state <= WAIT3;
			 end
	 CAL1: begin
	       pop <= 1'b1;
			 reg1 <= out;
			 state <= WAIT;
			 end
	WAIT: begin
	      pop <= 1'b0;
			state <= CAL2;
			end
	CAL2: begin
			 pop <= 1'b1;
			 reg2 <= out;
			 state <= WAIT2;
			 end
	WAIT2: begin
			 pop <= 1'b0;
			 state <= CAL3;
			 end
	CAL3: begin
			 push <= 1'b1;
			 input_ack <= 1'b1;
			 case(input_data)
				4'b1010:in <= reg1 + reg2;
				4'b1011:in <= reg2 - reg1;
				default: in <= 0;
			 endcase
			 state <= WAIT3;
			end
	WAIT3: begin
	       push <= 1'b0;
			 state <= IDLE;
			 input_ack <= 1'b0;
			 end
	DISP: begin 
			input_ack <= 1'b1;
			output_data <= out;
			state <= WAIT3;
			end
	endcase	
end	
end
//


//


stack #(.WIDTH(8),
		  .DEPTH(4))
stack(
	.clk(clk),
	.rst(rst),
	.push_stb(push),
	.push_dat(in),
	.pop_stb(pop),
	.pop_dat(out),
	.len(len)
);

///////////////////////////////////

  endmodule