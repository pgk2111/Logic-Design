/* verilator lint_off WIDTH */
module matrix_multiply (
	//inputs
	input  logic		  clk_i ,
	input  logic 		  rst_ni,
	input  logic [6 :0] addr_a,
	input  logic [6 :0] addr_b,

	//outputs
	output logic [23:0] q_a   , 
	output logic [23:0] q_b
);

localparam WIDTH = 32;
logic [7:0] i, k;

logic [13:0] addr_aA [WIDTH-1:0];
logic [13:0] addr_bA [WIDTH-1:0];
logic [15:0] resa    [WIDTH-1:0];
logic [15:0] resb    [WIDTH-1:0];
logic [23:0] tmpa    [WIDTH-1:0];
logic [23:0] tmpb    [WIDTH-1:0];
	
logic [7 :0] addr_aB;
logic [7 :0] addr_bB;	
logic [7 :0] q_aB   ;
logic [7 :0] q_bB   ;

logic [23:0] ram [127:0];

logic done_a_term, done_all_term ;
logic start, st_en, flush;


integrate integrate (
	.clock 	  	(clk_i),
	.address_a 	(addr_aA),
	.address_b	(addr_bA),
	.q_aB 		(q_aB),
	.q_bB		   (q_bB),
	.resa 		(resa),
	.resb 		(resb)
);	

romB_128x1 		romB_128x1 		(
	.address_a	(addr_aB[6:0]) ,
	.address_b	(addr_bB[6:0]) ,	
	.clock		(clk_i)  		,
	.q_a		   (q_aB )			,
	.q_b		 	(q_bB )	
);

	//MAC: Multiplier-Accumulator 
	always_ff @(posedge clk_i) begin
		if (!rst_ni) begin
			for (k = 0; k < WIDTH; k++) begin
				tmpa[k] <= 0;
				tmpb[k] <= 0;
			end
		end
		
		else begin
			if (start) begin
				if (flush) begin
					for (k = 0; k < WIDTH; k++) begin
						tmpa[k] <= 0;
						tmpb[k] <= 0;
					end
				end
		
				else begin	
					for (k = 0; k < WIDTH; k++) begin
						tmpa[k] <= tmpa[k] + {8'b0, resa[k]};
						tmpb[k] <= tmpb[k] + {8'b0, resb[k]};
					end			
				end
			end
		end
	end
	
	//DMEM: Data Memory
	assign q_a = ram[addr_a];
	assign q_b = ram[addr_b];
	
	always_ff @(posedge clk_i) begin
		if (!rst_ni) begin
			i <= 0;
			for (k = 0; k < 128; k++) begin
				ram[k] <= 0;	
			end
			
//USE THIS FOR VERILATOR INSTEAD OF FOR LOOP
//			ram[  0] <= 0;ram[  1] <= 0;ram[  2] <= 0;ram[  3] <= 0;ram[  4] <= 0;ram[  5] <= 0;ram[  6] <= 0;ram[  7] <= 0;ram[  8] <= 0;ram[  9] <= 0;
//			ram[ 10] <= 0;ram[ 11] <= 0;ram[ 12] <= 0;ram[ 13] <= 0;ram[ 14] <= 0;ram[ 15] <= 0;ram[ 16] <= 0;ram[ 17] <= 0;ram[ 18] <= 0;ram[ 19] <= 0;
//			ram[ 20] <= 0;ram[ 21] <= 0;ram[ 22] <= 0;ram[ 23] <= 0;ram[ 24] <= 0;ram[ 25] <= 0;ram[ 26] <= 0;ram[ 27] <= 0;ram[ 28] <= 0;ram[ 29] <= 0;
//			ram[ 30] <= 0;ram[ 31] <= 0;ram[ 32] <= 0;ram[ 33] <= 0;ram[ 34] <= 0;ram[ 35] <= 0;ram[ 36] <= 0;ram[ 37] <= 0;ram[ 38] <= 0;ram[ 39] <= 0;
//			ram[ 40] <= 0;ram[ 41] <= 0;ram[ 42] <= 0;ram[ 43] <= 0;ram[ 44] <= 0;ram[ 45] <= 0;ram[ 46] <= 0;ram[ 47] <= 0;ram[ 48] <= 0;ram[ 49] <= 0;			
//			ram[ 50] <= 0;ram[ 51] <= 0;ram[ 52] <= 0;ram[ 53] <= 0;ram[ 54] <= 0;ram[ 55] <= 0;ram[ 56] <= 0;ram[ 57] <= 0;ram[ 58] <= 0;ram[ 59] <= 0;
//			ram[ 60] <= 0;ram[ 61] <= 0;ram[ 62] <= 0;ram[ 63] <= 0;ram[ 64] <= 0;ram[ 65] <= 0;ram[ 66] <= 0;ram[ 67] <= 0;ram[ 68] <= 0;ram[ 69] <= 0;
//			ram[ 70] <= 0;ram[ 71] <= 0;ram[ 72] <= 0;ram[ 73] <= 0;ram[ 74] <= 0;ram[ 75] <= 0;ram[ 76] <= 0;ram[ 77] <= 0;ram[ 78] <= 0;ram[ 79] <= 0;
//			ram[ 80] <= 0;ram[ 81] <= 0;ram[ 82] <= 0;ram[ 83] <= 0;ram[ 84] <= 0;ram[ 85] <= 0;ram[ 86] <= 0;ram[ 87] <= 0;ram[ 88] <= 0;ram[ 89] <= 0;
//			ram[ 90] <= 0;ram[ 91] <= 0;ram[ 92] <= 0;ram[ 93] <= 0;ram[ 94] <= 0;ram[ 95] <= 0;ram[ 96] <= 0;ram[ 97] <= 0;ram[ 98] <= 0;ram[ 99] <= 0;
//			ram[100] <= 0;ram[101] <= 0;ram[102] <= 0;ram[103] <= 0;ram[104] <= 0;ram[105] <= 0;ram[106] <= 0;ram[107] <= 0;ram[108] <= 0;ram[109] <= 0;
//			ram[110] <= 0;ram[111] <= 0;ram[112] <= 0;ram[113] <= 0;ram[114] <= 0;ram[115] <= 0;ram[116] <= 0;ram[117] <= 0;ram[118] <= 0;ram[119] <= 0;		
//			ram[120] <= 0;ram[121] <= 0;ram[122] <= 0;ram[123] <= 0;ram[124] <= 0;ram[125] <= 0;ram[126] <= 0;ram[127] <= 0;
		end
	
		else begin
			if (start) begin
				if (st_en) begin
					for (k = 0; k < WIDTH; k++) begin
						ram[k + i] <= tmpa[k + i] + tmpb[k + i];
					end
					i 	    <= i + WIDTH;
				end
			end
		end
	end

	//Control Unit
	assign done_all_term = (i == 128) ? 1 : 0;
	assign done_a_term 	= addr_aB[7] ;	

	always_ff @(posedge clk_i) begin
		if (!rst_ni) begin
			start   <= 0;
			addr_aB <= 0;
			addr_bB <= 1;

			for (k = 0; k < WIDTH; k++) begin
				addr_aA[k] <= k * 128;
				addr_bA[k] <= k * 128 + 1;
			end
		end

		else begin
			start <= 1;
			if (done_all_term) begin
				st_en   <= 0;
				flush   <= 1;
			end

			else begin
				if (done_a_term) begin
					st_en   <= 1;
					flush   <= 1;
					addr_aB <= 0;
					addr_bB <= 1;
					for (k = 0; k < WIDTH; k++) begin
						addr_aA[k] <= addr_aA[k] + (WIDTH - 1) * 128;
						addr_bA[k] <= addr_aA[k] + (WIDTH - 1) * 128 + 1;
					end						
				end	

				else begin
					st_en   <= 0;
					flush   <= 0;
					addr_aB <= addr_aB + 2;
					addr_bB <= addr_bB + 2;
					for (k = 0; k < WIDTH; k++) begin
						addr_aA[k] <= addr_aA[k] + 2;
						addr_bA[k] <= addr_bA[k] + 2;
					end
				end
			end
		end
	end	
endmodule
