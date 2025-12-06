/* verilator lint_off UNUSED */
/* verilator lint_off PINMISSING */
module p2 (  
	input  logic        clk_i , rst_ni,
	output logic		  done  ,
   output logic [23:0] result, ticks
);

	logic 		 en , C_en, haltC;	
	logic [6 :0] addr_aAB, addr_bAB;
	logic [6 :0] addr_aC , addr_bC ;
	logic [15:0] q_aC    , q_bC  ;
	logic [23:0] q_aAB   , q_bAB ;	
	logic [23:0] sumAB, sumC;
	
	matrix_multiply matrix_multiply (
		.clk_i		(clk_i   ),
		.rst_ni  	(rst_ni  ),
		.addr_a		(addr_aAB),
		.addr_b		(addr_bAB),
		.q_a			(q_aAB   ),
		.q_b			(q_bAB   )
	);	
	
	romC_128x1 romC_128x1 (
		.address_a	(addr_aC	),
		.address_b	(addr_bC	),
		.clock		(clk_i  	),
		.q_a			(q_aC   	),
		.q_b			(q_bC   	)
	);
	
	//sumC
	always_ff @(posedge clk_i) begin
		if (!rst_ni) begin
			addr_aC <= 0;
			addr_bC <= 1;
			haltC   <= 0;
			sumC	  <= 0;
		end

		else begin
			if(!haltC) begin
				C_en 	  <= 1;
				addr_aC <= addr_aC + 2;
				addr_bC <= addr_bC + 2;			
				if (addr_bC == 7'h7F)
					haltC <= 1;
			end
			
			else C_en <= 0;
			
			if (C_en == 1) sumC <= sumC + {8'd0, q_aC} + {8'd0, q_bC};
		end	
	end
	
	//sumAB
	always_ff @(posedge clk_i) begin
		if (!rst_ni) begin
			addr_aAB <= 0;
			addr_bAB <= 1;
			done     <= 0;
			sumAB		<= 0;
		end

		else begin
			if (!done) begin
				if (addr_aAB % 32 != 0) begin
					addr_aAB <= addr_aAB - 2;
					addr_bAB <= addr_bAB - 2;				
				end
				
				if (q_aAB != 0) begin	
					sumAB <= sumAB + q_aAB + q_bAB;
					addr_aAB <= addr_aAB + 2;
					addr_bAB <= addr_bAB + 2;							
					if (addr_bAB == 7'h7F)
						done <= 1;		
				end
			end	
		end	
	end
	
	//clock ticks
	always_ff @(posedge clk_i) begin
		if (!rst_ni)
			ticks <= 0;
			
		else begin
			if (!done)
				ticks <= ticks + 1;			
		end
	end

	assign result = sumAB + sumC;
	
endmodule
