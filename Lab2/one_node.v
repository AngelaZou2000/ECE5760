module one_node 
#(parameter const_eta)
(
  input wire clk, 
  input wire reset, 
  input wire [17:0] init_node,
  input wire [17:0] init_rho,
  output wire [17:0] node_out
);

  // localparam const_eta = 18'h1FFFF - 18'h00080;
  // localparam const_rho = 18'h02000;
  localparam g_tension = 18'h02000;
  reg [17:0] curr_node;
  reg [17:0] prev_node;
  wire [17:0] curr_rho;
  reg [17:0] const_rho;
  assign node_out = curr_node;

  wire [17:0] term1, term2, term3, inter_term;
  wire [17:0] rho_term1, rho_term2; 
  signed_mult inst1 (
    .out(term1),
    .a(prev_node),
    .b(const_eta)
  );
  signed_mult inst2 (
    .out(term2),
    .a(curr_node),
    .b(inter_term<<2)
  );
  assign inter_term = 18'h10000 - const_rho;
  signed_mult inst3 (
    .out(term3),
    .a(term2-term1),
    .b(const_eta)
  );

  signed_mult inst4 (
    .out(rho_term1),
    .a(g_tension),
    .b(curr_node)
  );
  signed_mult inst5 (
    .out(rho_term2),
    .a(rho_term1),
    .b(rho_term1)
  );
  assign curr_rho = (18'h10000 < init_rho + rho_term2) ? 18'h10000 : init_rho + rho_term2;

  always@(posedge clk) begin
    if (reset) begin
      curr_node <= init_node;
      prev_node <= init_node;
      const_rho <= init_rho;
    end else begin
      curr_node <= term3;
      prev_node <= curr_node;
      const_rho <= curr_rho;
    end
  end

endmodule

module signed_mult (out, a, b);
	output 	signed  [17:0]	out;
	input 	signed	[17:0] 	a;
	input 	signed	[17:0] 	b;
	// intermediate full bit length
	wire 	signed	[35:0]	mult_out;
	assign mult_out = a * b;
	// select bits for 7.20 fixed point
	assign out = {mult_out[35], mult_out[33:17]};
endmodule
