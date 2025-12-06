module stack	  
#( 
// default: 4-bits data with 100 layers of stack. 
parameter WIDTH = 4,
parameter DEPTH = 5
)
(                            
input  wire        clk,      
input  wire        rst,                      
input  wire        push_stb, 
input  wire [WIDTH-1:0] push_dat,                            
input  wire        pop_stb,  
output wire [WIDTH-1:0] pop_dat ,
output wire [DEPTH-1:0] len
);     
                      
logic   	[DEPTH-1:0] ptr;
logic		[WIDTH-1:0] stack[0:DEPTH-1];

always@(posedge clk or posedge rst)
begin
 if(rst) ptr <= 0;
 else if(push_stb)
  ptr <= ptr + 1;  
 else if(pop_stb)
  ptr <= ptr - 1;
end

always@(posedge clk) begin
	if(push_stb) 
		stack[ptr] <= push_dat; 
end

assign  pop_dat = stack[ptr-1]; 
assign  len = ptr;

endmodule