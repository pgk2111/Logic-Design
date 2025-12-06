module add_sub(a,b,add_sel,result,flag);

input  logic [18:0] a;
input  logic [18:0] b;
input  logic add_sel;
output logic [18:0] result;
output logic [4:0] flag;

logic sign_a, NaN_a, inf_a, zero_a, normal_a, denormal_a;
logic sign_b, NaN_b, inf_b, zero_b, normal_b, denormal_b;
logic [10:0] m_A, m_B, tA_m, tB_m;
logic [9:0] out_m;
logic signed [9:0] e_A, e_B,out_e,t_e,t2_e,norm_e;
logic [11:0] t_m,t2_m,norm_m;
logic [21:0] in_m;
logic signed [10:0] shift;
logic [2:0] na;
logic			 inexact;

logic sub,sign;

int i;

logic [18:0] inf_def, zero_def, Nan_def, denorm_def;
logic [11:0] mask;

assign mask = {12{1'b1}};
assign inf_def = {sign,{8{1'b1}},{10{1'b0}}};
assign zero_def = {1'b0,{8{1'b0}},{10{1'b0}}};
assign Nan_def = {1'b0,{8{1'b1}},1'b1,{9{1'b0}}};
assign denorm_def = {1'b0,{8{1'b0}},{10{1'b1}}};

localparam INVALID             = 4;
localparam DIVIDEBYZERO        = 3;
localparam OVERFLOW            = 2;
localparam UNDERFLOW           = 1;
localparam INEXACT             = 0;


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
			
assign sub = sign_a ^ sign_b;			

always_comb begin
shift = 0;
i = 0;
result = 0;
t_e = 0;
tA_m = 0;
tB_m = 0;
t_m = 0;
sign = 0;
flag = 0;
na = 0;
norm_m = 0;
norm_e = 0;
	if(add_sel) begin
		if (NaN_a || NaN_b) begin 
		result = NaN_a ? a :b;
		flag[INVALID] = 1'b1;
		end
		else if (inf_a || inf_b) begin
		result = inf_a ? a:b;
		flag[OVERFLOW] = 1'b1;
		end
		else if (zero_a || zero_b) result = zero_a ? b:a;
		else if (inf_a && inf_b) begin
		result = sub ? Nan_def : inf_def;
		flag[INVALID] = sub;
		flag[OVERFLOW] = ~sub;
		end
		else begin 
			if((e_A > e_B) || ((e_A == e_B) && (m_A > m_B))) begin
			shift = e_A - e_B;
			tB_m = m_B >> shift;
			tA_m = m_A;
			t_e = e_A;
			sign = sign_a;
			t_m = sub ? tA_m - tB_m : tA_m + tB_m;
			end else begin
			shift = e_B - e_A;
			tA_m = m_A >> shift;
			tB_m = m_B;
			t_e  = e_B;
			sign = sign_b;
			t_m = sub ? tB_m - tA_m : tA_m + tB_m;
			end 
			
			norm_m = t2_m;
			for (i = 8; i > 0; i = i >> 1)
          begin
            if ((norm_m & (mask << (11 - i))) == 0)
              begin
                norm_m = norm_m << i;
                na = na | i;
              end
          end
			 
			norm_e = t2_e - na;
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
			flag[INEXACT] = (shift > 12 ) ? 1'b1 : inexact; 
		end
	end 
end

assign t2_m = t_m >> t_m[11];
assign t2_e = t_e + t_m[11];
assign in_m = {norm_m,{11{1'b0}}};

encode #(22)
Out(
			.in_e(norm_e),
			.in_m(in_m),
			.out_e(out_e),
			.out_m(out_m),
			.inexact(inexact)
);

endmodule