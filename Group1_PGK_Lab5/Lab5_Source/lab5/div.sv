module div(a,b,div_sel,result,flag);

input  logic [18:0] a;
input logic [18:0] b;
input  logic div_sel;
output logic [18:0] result;
output logic [4:0] flag;


localparam INVALID             = 4;
localparam DIVIDEBYZERO        = 3;
localparam OVERFLOW            = 2;
localparam UNDERFLOW           = 1;
localparam INEXACT             = 0;


logic sign_a, NaN_a, inf_a, zero_a, normal_a, denormal_a;
logic sign_b, NaN_b, inf_b, zero_b, normal_b, denormal_b;
logic [10:0] m_A, m_B,out_m;
logic signed [9:0] e_A, e_B,out_e;
logic inexact;
logic sign;

logic signed [12:0] tA_m, tB_m, q_m, r_m;
logic signed [9:0] t_e,norm_e;
logic [11:0] t_m;
logic [25:0] in_m;

decode A_dec(
			.in(a),
			.sign(sign_a),
			.NaN(NaN_a),
			.inf(inf_a),
			.zero(zero_a),
			.normal(normal_a),
			.denormal(denormal_a),
			.out_e(e_A),
			.out_m(m_A)
			);
			
decode B_dec(
			.in(b),
			.sign(sign_b),
			.NaN(NaN_b),
			.inf(inf_b),
			.zero(zero_b),
			.normal(normal_b),
			.denormal(denormal_b),
			.out_e(e_B),
			.out_m(m_B)
			);
			
wire [18:0] inf_def ;
wire [18:0] zero_def ;
wire [18:0] Nan_def ;
wire [18:0] denorm_def ;
int i;

assign inf_def = {sign,{8{1'b1}},{10{1'b0}}};
assign zero_def = {1'b0,{8{1'b0}},{10{1'b0}}};
assign Nan_def = {1'b0,{8{1'b1}},1'b1,{9{1'b0}}};
assign denorm_def = {1'b0,{8{1'b0}},{10{1'b1}}};

assign sign = a[18] ^ b[18];

always_comb begin
result = 0;
t_m = 0;
t_e = 0;
flag = 0;
r_m = 0;
tA_m = 0;
tB_m = 0;
q_m = 0;
norm_e = 0;
i=0;
	if(div_sel) begin
						if (NaN_a || NaN_b) begin 
							result = NaN_a ? a :b;
							flag[INVALID] = 1'b1;
						end
						else if (inf_a && inf_b) begin
							result = Nan_def;
							flag[INVALID] = 1'b1;
						end
						else if (inf_a) begin 
							result = inf_def;
							flag[OVERFLOW] = 1'b1;
						end
						else if (inf_b) begin 
							result = zero_def;
						end
						else if (zero_a && zero_b) begin 
							result = Nan_def;
							flag[INVALID] = 1'b1;
						end
						else if (zero_a) begin 
							result = zero_def;
						end
						else if (zero_b) begin 
							result = inf_def;
							flag[DIVIDEBYZERO] = 1'b1;
						end
						else begin
						tA_m = {2'b00,m_A};
						tB_m = {2'b00,m_B};
							for (i = 0; i < 13; i = i + 1)
								begin
									r_m =  tA_m - tB_m;
									q_m = {q_m[11:0], ~r_m[12]};
									tA_m = {(r_m[12] ? tA_m[11:0] : r_m[11:0]), 1'b0};
								end
							norm_e[0] = ~q_m[12];
							t_m = q_m << norm_e[0];
							t_e = e_A - e_B - norm_e;
							if(out_e < -126) begin
							result = zero_def;
							flag[UNDERFLOW] = 1'b1;
							end
							else if(out_e > 127) begin
							result = inf_def;
							flag[OVERFLOW] = 1'b1;
							end
							else begin 
							result[18] = sign;
							result[17:10] = out_e + 127;
							result[9:0] = out_m;
							end
							flag[INEXACT] = inexact;
						end
	end
end


assign in_m = {t_m,tA_m};

encode #(26)
 Out(
			.in_e(t_e),
			.in_m(in_m),
			.out_e(out_e),
			.out_m(out_m),
			.inexact(inexact)
);


endmodule