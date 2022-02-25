module top (
  input clk,
  input reset,
  input [17:0] init_node,
  output [17:0] node_out
);

  reg [17:0] curr_node, prev_node;
  wire [17:0] next_node, rho;
  assign node_out = curr_node;

  node_compute #(9) inst1 (
    .curr_node(curr_node),
    .left_node(18'd0),
    .right_node(18'd0),
    .top_node(18'd0),
    .bottom_node(18'd0),
    .prev_node(prev_node),
    .rho(rho),
    .next_node(next_node)
  );

  rho_update #(5) inst2 (
    .init_rho(18'h01000),
    .center_node(curr_node),
    .rho_value(rho)
  );

    always@(posedge clk) begin
    if (reset) begin
      curr_node <= init_node;
      prev_node <= init_node;
    end else begin
      curr_node <= next_node;
      prev_node <= curr_node;
    end
  end

endmodule

module node_compute 
#(parameter eta_width)
(
  input signed [17:0] curr_node,
  input signed [17:0] left_node,
  input signed [17:0] right_node,
  input signed [17:0] top_node,
  input signed [17:0] bottom_node,
  input signed [17:0] prev_node,
  input signed [17:0] rho,
  output signed [17:0] next_node
);
  wire signed [17:0] node_sum, current_term, undamped_sum, damped_prev_node;
  assign node_sum = left_node+right_node+top_node+bottom_node-(curr_node<<2);
  signed_mult inst1 (
    .out(current_term),
    .a(node_sum),
    .b(rho)
  );
  assign damped_prev_node = prev_node - (prev_node>>>eta_width); 
  assign undamped_sum = current_term + (curr_node<<1) - damped_prev_node;
  assign next_node = undamped_sum - (undamped_sum>>>eta_width);
endmodule

module rho_update
#(parameter g_tension_width)
(
  input [17:0] init_rho,
  input [17:0] center_node,
  output [17:0] rho_value
);
  wire [17:0] rho_term1, rho_term2;
  assign rho_term1 = center_node >>> g_tension_width;
  signed_mult inst2 (
    .out(rho_term2),
    .a(rho_term1),
    .b(rho_term1)
  );
  assign rho_value = (18'h0FAE1 < init_rho + rho_term2) ? 18'h0FAE1 : init_rho + rho_term2;
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