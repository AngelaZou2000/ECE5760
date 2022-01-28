

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

  reg signed [26:0] x_reg, y_reg, z_reg;
  wire signed [26:0] x_calc, y_calc, z_calc;
  wire signed [26:0] dx, dy, dz, y_inter;
  wire signed [26:0] x_mult_y, beta_mult_z;
  assign x = x_reg; 
  assign y = y_reg;
  assign z = z_reg;

  always @ (posedge clk) begin
    if (reset) begin
      x_reg <= init_x;
      y_reg <= init_y;
      z_reg <= init_z;
    end else begin
      x_reg <= x_calc+x;
      y_reg <= y_calc+y;
      z_reg <= z_calc+z;
    end
  end

  // x_calc = sigma*(y-x)*dt
  signed_mult x_mult_1 (
    .a((y>>>8)-(x>>>8)),
    .b(sigma),
    .out(x_calc)
  );
  // signed_mult x_mult_2 (
  //   .a(dx),
  //   .b(dt),
  //   .out(x_calc)
  // );

  // y_calc = (x*(rho-z)-y)*dt
  signed_mult y_mult_1 (
    .a(x>>>8),
    .b(rho-z),
    .out(y_inter)
  );
  assign y_calc = y_inter - (y>>>8);
  // signed_mult y_mult_2 (
  //   .a(dy),
  //   .b(dt),
  //   .out(y_calc)
  // );

  // z_calc = (x*y-beta*z)*dt
  signed_mult z_mult_1 (
    .a(x>>>8),
    .b(y),
    .out(x_mult_y)
  );
  signed_mult z_mult_2 (
    .a(beta),
    .b(z>>>8),
    .out(beta_mult_z)
  );
  assign z_calc = (x_mult_y) - (beta_mult_z);
  // signed_mult z_mult_3 (
  //   .a(x_mult_y - beta_mult_z),
  //   .b(dt),
  //   .out(z_calc)
  // );
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

// module integrator(out,funct,InitialOut,clk,reset);
// 	output signed [26:0] out; 		//the state variable V
// 	input signed [26:0] funct;      //the dV/dt function
// 	input clk, reset;
// 	input signed [26:0] InitialOut;  //the initial state variable V
	
// 	wire signed	[26:0] out, v1new ;
// 	reg signed	[26:0] v1 ;
	
// 	always @ (posedge clk) 
// 	begin
// 		if (reset==0) //reset	
// 			v1 <= InitialOut;
// 		else 
// 			v1 <= v1new;	
// 	end
// 	assign v1new = v1 + funct;
// 	assign out = v1 ;
// endmodule


// // clock divider to slow system down for testing
// reg [4:0] count;
// // analog update divided clock
// always @ (posedge CLOCK_50) 
// begin
//         count <= count + 1; 
// end	
// assign AnalogClock = (count==0);		
