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

  // Declare wire for intermediate terms 
  wire signed [17:0] term1, term2, term3, term4;
  wire signed [17:0] rho_term1, rho_term2; 
  
  //term1 = ( 1 - eta * deltaT / 2 ) * previous node
  assign term1 = prev_node - (prev_node>>>eta_width);
  //term2 = rho * 4 * current node
  signed_mult inst1 (
    .out(term2),
    .a(curr_node<<2),
    .b(const_rho)
  );
  //term3 = 2 * current node - term2 - term1
  assign term3 = (curr_node<<1) - term2 - term1;
  // term4 = ( 1 - eta * deltaT / 2 ) * term3
  assign term4 = term3 - (term3>>>eta_width);

  // 𝜌𝑒𝑓𝑓=min(0.49,𝜌0+[U𝑐𝑒𝑛𝑡𝑒𝑟⋅G𝑡𝑒𝑛𝑠𝑖𝑜𝑛]^2)
  assign rho_term1 = curr_node >>> g_tension_width;
  signed_mult inst2 (
    .out(rho_term2),
    .a(rho_term1),
    .b(rho_term1)
  );
  //Non-linear rho
  assign curr_rho = (18'h0FAE1 < init_rho + rho_term2) ? 18'h0FAE1 : init_rho + rho_term2;

  always@(posedge clk) begin
    if (reset) begin // If reset, init all variables
      curr_node <= init_node;
      prev_node <= init_node;
      const_rho <= init_rho;
    end else begin //else update current node, previous node, and rho
      curr_node <= term4;
      prev_node <= curr_node;
      const_rho <= curr_rho;
    end
  end

endmodule

// Fixed Point Multiplier
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
