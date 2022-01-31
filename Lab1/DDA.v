module solver (
  input clk,
  input reset,
  input signed [26:0] dt,
  input signed [26:0] init_x,
  input signed [26:0] init_y,
  input signed [26:0] init_z,
  input signed [26:0] beta,
  input signed [26:0] sigma,
  input signed [26:0] rho,
  output signed [26:0] x,
  output signed [26:0] y,
  output signed [26:0] z
);

    reg signed [26:0] x_reg;
    reg signed [26:0] y_reg, z_reg;
    wire signed [26:0] x_calc, y_calc, z_calc;
    wire signed [26:0] x_reg_new, y_reg_new, z_reg_new;
    wire signed [26:0] x_inter, y_inter, z_inter1, z_inter2;

    assign x = x_reg; 
    assign y = y_reg;
    assign z = z_reg;

    always @ (posedge clk) begin
        if (reset) begin
            x_reg <= init_x;
            y_reg <= init_y;
            z_reg <= init_z;
        end 
        else begin
            x_reg <= x_reg_new;
            y_reg <= y_reg_new;
            z_reg <= z_reg_new;
        end
    end
    


    // After adder, before mux
    assign x_reg_new = x_reg + x_calc;
    assign y_reg_new = y_reg + y_calc;
    assign z_reg_new = z_reg + z_calc;

    // x_calc = dx*dt
    assign x_inter = y-x;
    signed_mult x_mult_1 (.a(sigma),.b(x_inter>>>8),.out(x_calc));

    // y_calc = dy*dt
    signed_mult y_mult_1 (.a(x>>>8),.b(rho-z),.out(y_inter));
    assign y_calc = y_inter - (y>>>8);

    // z_calc = dz*dt
    signed_mult z_mult_1 (.a(x>>>8),.b(y),.out(z_inter1));
    signed_mult z_mult_2 (.a(beta),.b(z>>>8),.out(z_inter2));
    assign z_calc = (z_inter1) - (z_inter2);

endmodule


module signed_mult (out, a, b);
	output 	signed  [26:0]	out;
	input 	signed	[26:0] 	a;
	input 	signed	[26:0] 	b;
	// intermediate full bit length
	wire 	signed	[53:0]	mult_out;
	assign mult_out = a * b;
	// select bits for 7.20 fixed point
	assign out = {mult_out[53], mult_out[45:20]};
endmodule
