module one_node 
#(parameter eta_width, parameter g_tension_width)
(
  input wire clk, 
  input wire reset, 
  input wire [17:0] init_node,
  input wire [17:0] init_rho,
  input wire [3:0]  init_gtention_width,
  output wire [17:0] node_out
);
  reg signed [17:0] curr_node;
  reg signed [17:0] prev_node;
  wire signed [17:0] curr_rho;
  reg signed [17:0] const_rho;
  assign node_out = curr_node;

  wire signed [17:0] term1, term2, term3, term4;
  wire signed [17:0] rho_term1, rho_term2; 

  assign term1 = prev_node - (prev_node>>>eta_width);
  signed_mult inst1 (
    .out(term2),
    .a(curr_node<<2),
    .b(const_rho)
  );
  assign term3 = (curr_node<<1) - term2 - term1;
  assign term4 = term3 - (term3>>>eta_width);

  assign rho_term1 = curr_node >>> g_tension_width;
  signed_mult inst2 (
    .out(rho_term2),
    .a(rho_term1),
    .b(rho_term1)
  );
  assign curr_rho = (18'h0FAE1 < init_rho + rho_term2) ? 18'h0FAE1 : init_rho + rho_term2;

  always@(posedge clk) begin
    if (reset) begin
      curr_node <= init_node;
      prev_node <= init_node;
      const_rho <= init_rho;
    end else begin
      curr_node <= term4;
      prev_node <= curr_node;
      const_rho <= curr_rho;
    end
  end

endmodule

module signed_mult (out, a, b);
  output  signed  [17:0]  out;
  input   signed  [17:0]  a;
  input   signed  [17:0]  b;
  // intermediate full bit length
  wire  signed  [35:0]  mult_out;
  assign mult_out = a * b;
  // select bits for 7.20 fixed point
  assign out = {mult_out[35], mult_out[33:17]};
endmodule
