module integrate (
	input 			    clock 	 		,
	input  logic [13:0] address_a [31:0],
	input  logic [13:0] address_b [31:0],

	input  logic [7 :0] q_aB,
	input  logic [7 :0] q_bB,

	output logic [15:0] resa[31:0],
	output logic [15:0] resb[31:0]
);

logic [7:0]	q_aA [31:0];
logic [7:0]	q_bA [31:0];

romA_128x128 romA_1x128  (.clock(clock), .address_a(address_a[ 0]), .address_b(address_b[ 0]), .q_a(q_aA[ 0]), .q_b(q_bA[ 0]));
romA_128x128 romA_2x128  (.clock(clock), .address_a(address_a[ 1]), .address_b(address_b[ 1]), .q_a(q_aA[ 1]), .q_b(q_bA[ 1]));
romA_128x128 romA_3x128  (.clock(clock), .address_a(address_a[ 2]), .address_b(address_b[ 2]), .q_a(q_aA[ 2]), .q_b(q_bA[ 2]));
romA_128x128 romA_4x128  (.clock(clock), .address_a(address_a[ 3]), .address_b(address_b[ 3]), .q_a(q_aA[ 3]), .q_b(q_bA[ 3]));
romA_128x128 romA_5x128  (.clock(clock), .address_a(address_a[ 4]), .address_b(address_b[ 4]), .q_a(q_aA[ 4]), .q_b(q_bA[ 4]));
romA_128x128 romA_6x128  (.clock(clock), .address_a(address_a[ 5]), .address_b(address_b[ 5]), .q_a(q_aA[ 5]), .q_b(q_bA[ 5]));
romA_128x128 romA_7x128  (.clock(clock), .address_a(address_a[ 6]), .address_b(address_b[ 6]), .q_a(q_aA[ 6]), .q_b(q_bA[ 6]));
romA_128x128 romA_8x128  (.clock(clock), .address_a(address_a[ 7]), .address_b(address_b[ 7]), .q_a(q_aA[ 7]), .q_b(q_bA[ 7]));
romA_128x128 romA_9x128  (.clock(clock), .address_a(address_a[ 8]), .address_b(address_b[ 8]), .q_a(q_aA[ 8]), .q_b(q_bA[ 8]));
romA_128x128 romA_10x128 (.clock(clock), .address_a(address_a[ 9]), .address_b(address_b[ 9]), .q_a(q_aA[ 9]), .q_b(q_bA[ 9]));
romA_128x128 romA_11x128 (.clock(clock), .address_a(address_a[10]), .address_b(address_b[10]), .q_a(q_aA[10]), .q_b(q_bA[10]));
romA_128x128 romA_12x128 (.clock(clock), .address_a(address_a[11]), .address_b(address_b[11]), .q_a(q_aA[11]), .q_b(q_bA[11]));
romA_128x128 romA_13x128 (.clock(clock), .address_a(address_a[12]), .address_b(address_b[12]), .q_a(q_aA[12]), .q_b(q_bA[12]));
romA_128x128 romA_14x128 (.clock(clock), .address_a(address_a[13]), .address_b(address_b[13]), .q_a(q_aA[13]), .q_b(q_bA[13]));
romA_128x128 romA_15x128 (.clock(clock), .address_a(address_a[14]), .address_b(address_b[14]), .q_a(q_aA[14]), .q_b(q_bA[14]));
romA_128x128 romA_16x128 (.clock(clock), .address_a(address_a[15]), .address_b(address_b[15]), .q_a(q_aA[15]), .q_b(q_bA[15]));
romA_128x128 romA_17x128 (.clock(clock), .address_a(address_a[16]), .address_b(address_b[16]), .q_a(q_aA[16]), .q_b(q_bA[16]));
romA_128x128 romA_18x128 (.clock(clock), .address_a(address_a[17]), .address_b(address_b[17]), .q_a(q_aA[17]), .q_b(q_bA[17]));
romA_128x128 romA_19x128 (.clock(clock), .address_a(address_a[18]), .address_b(address_b[18]), .q_a(q_aA[18]), .q_b(q_bA[18]));
romA_128x128 romA_20x128 (.clock(clock), .address_a(address_a[19]), .address_b(address_b[19]), .q_a(q_aA[19]), .q_b(q_bA[19]));
romA_128x128 romA_21x128 (.clock(clock), .address_a(address_a[20]), .address_b(address_b[20]), .q_a(q_aA[20]), .q_b(q_bA[20]));
romA_128x128 romA_22x128 (.clock(clock), .address_a(address_a[21]), .address_b(address_b[21]), .q_a(q_aA[21]), .q_b(q_bA[21]));
romA_128x128 romA_23x128 (.clock(clock), .address_a(address_a[22]), .address_b(address_b[22]), .q_a(q_aA[22]), .q_b(q_bA[22]));
romA_128x128 romA_24x128 (.clock(clock), .address_a(address_a[23]), .address_b(address_b[23]), .q_a(q_aA[23]), .q_b(q_bA[23]));
romA_128x128 romA_25x128 (.clock(clock), .address_a(address_a[24]), .address_b(address_b[24]), .q_a(q_aA[24]), .q_b(q_bA[24]));
romA_128x128 romA_26x128 (.clock(clock), .address_a(address_a[25]), .address_b(address_b[25]), .q_a(q_aA[25]), .q_b(q_bA[25]));
romA_128x128 romA_27x128 (.clock(clock), .address_a(address_a[26]), .address_b(address_b[26]), .q_a(q_aA[26]), .q_b(q_bA[26]));
romA_128x128 romA_28x128 (.clock(clock), .address_a(address_a[27]), .address_b(address_b[27]), .q_a(q_aA[27]), .q_b(q_bA[27]));
romA_128x128 romA_29x128 (.clock(clock), .address_a(address_a[28]), .address_b(address_b[28]), .q_a(q_aA[28]), .q_b(q_bA[28]));
romA_128x128 romA_30x128 (.clock(clock), .address_a(address_a[29]), .address_b(address_b[29]), .q_a(q_aA[29]), .q_b(q_bA[29]));
romA_128x128 romA_31x128 (.clock(clock), .address_a(address_a[30]), .address_b(address_b[30]), .q_a(q_aA[30]), .q_b(q_bA[30]));
romA_128x128 romA_32x128 (.clock(clock), .address_a(address_a[31]), .address_b(address_b[31]), .q_a(q_aA[31]), .q_b(q_bA[31]));


multiplier_8816 mula1  (.dataa(q_aA[ 0]), .datab(q_aB), .result(resa[ 0]));
multiplier_8816 mula2  (.dataa(q_aA[ 1]), .datab(q_aB), .result(resa[ 1]));
multiplier_8816 mula3  (.dataa(q_aA[ 2]), .datab(q_aB), .result(resa[ 2]));
multiplier_8816 mula4  (.dataa(q_aA[ 3]), .datab(q_aB), .result(resa[ 3]));
multiplier_8816 mula5  (.dataa(q_aA[ 4]), .datab(q_aB), .result(resa[ 4]));
multiplier_8816 mula6  (.dataa(q_aA[ 5]), .datab(q_aB), .result(resa[ 5]));
multiplier_8816 mula7  (.dataa(q_aA[ 6]), .datab(q_aB), .result(resa[ 6]));
multiplier_8816 mula8  (.dataa(q_aA[ 7]), .datab(q_aB), .result(resa[ 7]));
multiplier_8816 mula9  (.dataa(q_aA[ 8]), .datab(q_aB), .result(resa[ 8]));
multiplier_8816 mula10 (.dataa(q_aA[ 9]), .datab(q_aB), .result(resa[ 9]));
multiplier_8816 mula11 (.dataa(q_aA[10]), .datab(q_aB), .result(resa[10]));
multiplier_8816 mula12 (.dataa(q_aA[11]), .datab(q_aB), .result(resa[11]));
multiplier_8816 mula13 (.dataa(q_aA[12]), .datab(q_aB), .result(resa[12]));
multiplier_8816 mula14 (.dataa(q_aA[13]), .datab(q_aB), .result(resa[13]));
multiplier_8816 mula15 (.dataa(q_aA[14]), .datab(q_aB), .result(resa[14]));
multiplier_8816 mula16 (.dataa(q_aA[15]), .datab(q_aB), .result(resa[15]));
multiplier_8816 mula17 (.dataa(q_aA[16]), .datab(q_aB), .result(resa[16]));
multiplier_8816 mula18 (.dataa(q_aA[17]), .datab(q_aB), .result(resa[17]));
multiplier_8816 mula19 (.dataa(q_aA[18]), .datab(q_aB), .result(resa[18]));
multiplier_8816 mula20 (.dataa(q_aA[19]), .datab(q_aB), .result(resa[19]));
multiplier_8816 mula21 (.dataa(q_aA[20]), .datab(q_aB), .result(resa[20]));
multiplier_8816 mula22 (.dataa(q_aA[21]), .datab(q_aB), .result(resa[21]));
multiplier_8816 mula23 (.dataa(q_aA[22]), .datab(q_aB), .result(resa[22]));
multiplier_8816 mula24 (.dataa(q_aA[23]), .datab(q_aB), .result(resa[23]));
multiplier_8816 mula25 (.dataa(q_aA[24]), .datab(q_aB), .result(resa[24]));
multiplier_8816 mula26 (.dataa(q_aA[25]), .datab(q_aB), .result(resa[25]));
multiplier_8816 mula27 (.dataa(q_aA[26]), .datab(q_aB), .result(resa[26]));
multiplier_8816 mula28 (.dataa(q_aA[27]), .datab(q_aB), .result(resa[27]));
multiplier_8816 mula29 (.dataa(q_aA[28]), .datab(q_aB), .result(resa[28]));
multiplier_8816 mula30 (.dataa(q_aA[29]), .datab(q_aB), .result(resa[29]));
multiplier_8816 mula31 (.dataa(q_aA[30]), .datab(q_aB), .result(resa[30]));
multiplier_8816 mula32 (.dataa(q_aA[31]), .datab(q_aB), .result(resa[31]));


multiplier_8816 mulb1  (.dataa(q_bA[ 0]), .datab(q_bB), .result(resb[ 0]));
multiplier_8816 mulb2  (.dataa(q_bA[ 1]), .datab(q_bB), .result(resb[ 1]));
multiplier_8816 mulb3  (.dataa(q_bA[ 2]), .datab(q_bB), .result(resb[ 2]));
multiplier_8816 mulb4  (.dataa(q_bA[ 3]), .datab(q_bB), .result(resb[ 3]));
multiplier_8816 mulb5  (.dataa(q_bA[ 4]), .datab(q_bB), .result(resb[ 4]));
multiplier_8816 mulb6  (.dataa(q_bA[ 5]), .datab(q_bB), .result(resb[ 5]));
multiplier_8816 mulb7  (.dataa(q_bA[ 6]), .datab(q_bB), .result(resb[ 6]));
multiplier_8816 mulb8  (.dataa(q_bA[ 7]), .datab(q_bB), .result(resb[ 7]));
multiplier_8816 mulb9  (.dataa(q_bA[ 8]), .datab(q_bB), .result(resb[ 8]));
multiplier_8816 mulb10 (.dataa(q_bA[ 9]), .datab(q_bB), .result(resb[ 9]));
multiplier_8816 mulb11 (.dataa(q_bA[10]), .datab(q_bB), .result(resb[10]));
multiplier_8816 mulb12 (.dataa(q_bA[11]), .datab(q_bB), .result(resb[11]));
multiplier_8816 mulb13 (.dataa(q_bA[12]), .datab(q_bB), .result(resb[12]));
multiplier_8816 mulb14 (.dataa(q_bA[13]), .datab(q_bB), .result(resb[13]));
multiplier_8816 mulb15 (.dataa(q_bA[14]), .datab(q_bB), .result(resb[14]));
multiplier_8816 mulb16 (.dataa(q_bA[15]), .datab(q_bB), .result(resb[15]));
multiplier_8816 mulb17 (.dataa(q_bA[16]), .datab(q_bB), .result(resb[16]));
multiplier_8816 mulb18 (.dataa(q_bA[17]), .datab(q_bB), .result(resb[17]));
multiplier_8816 mulb19 (.dataa(q_bA[18]), .datab(q_bB), .result(resb[18]));
multiplier_8816 mulb20 (.dataa(q_bA[19]), .datab(q_bB), .result(resb[19]));
multiplier_8816 mulb21 (.dataa(q_bA[20]), .datab(q_bB), .result(resb[20]));
multiplier_8816 mulb22 (.dataa(q_bA[21]), .datab(q_bB), .result(resb[21]));
multiplier_8816 mulb23 (.dataa(q_bA[22]), .datab(q_bB), .result(resb[22]));
multiplier_8816 mulb24 (.dataa(q_bA[23]), .datab(q_bB), .result(resb[23]));
multiplier_8816 mulb25 (.dataa(q_bA[24]), .datab(q_bB), .result(resb[24]));
multiplier_8816 mulb26 (.dataa(q_bA[25]), .datab(q_bB), .result(resb[25]));
multiplier_8816 mulb27 (.dataa(q_bA[26]), .datab(q_bB), .result(resb[26]));
multiplier_8816 mulb28 (.dataa(q_bA[27]), .datab(q_bB), .result(resb[27]));
multiplier_8816 mulb29 (.dataa(q_bA[28]), .datab(q_bB), .result(resb[28]));
multiplier_8816 mulb30 (.dataa(q_bA[29]), .datab(q_bB), .result(resb[29]));
multiplier_8816 mulb31 (.dataa(q_bA[30]), .datab(q_bB), .result(resb[30]));
multiplier_8816 mulb32 (.dataa(q_bA[31]), .datab(q_bB), .result(resb[31]));

endmodule
