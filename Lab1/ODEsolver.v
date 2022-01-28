`default_nettype none

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

  signed reg [26:0] x_reg, y_reg, z_reg;
  signed wire [26:0] x_calc, y_calc, z_calc;
  signed wire [26:0] dx, dy, dz, y_inter;
  signed wire [26:0] x_mult_y, beta_mult_z;
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

  signed_mult x_mult_1 (
    .a(y-x),
    .b(sigma),
    .out(dx)
  );
  signed_mult x_mult_2 (
    .a(dx),
    .b(dt),
    .out(x_calc)
  );


  //TODO Y
  signed_mult y_mult_1 (
    .a(x),
    .b(rho-z),
    .out(y_inter)
  );

  assign dy = y_inter - y;
  signed_mult y_mult_2 (
    .a(dy-y),
    .b(dt),
    .out(y_calc)
  );

  //TODO Z
  
  signed_mult z_mult_1 (
    .a(x),
    .b(y),
    .out(x_mult_y)
  );
  signed_mult z_mult_2 (
    .a(beta),
    .b(z),
    .out(beta_mult_z)
  );
  signed_mult z_mult_3 (
    .a(x_mult_y - beta_mult_z),
    .b(dt),
    .out(z_calc)
  );
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


// // clock divider to slow system down for testing
// reg [4:0] count;
// // analog update divided clock
// always @ (posedge CLOCK_50) 
// begin
//         count <= count + 1; 
// end	
// assign AnalogClock = (count==0);		
