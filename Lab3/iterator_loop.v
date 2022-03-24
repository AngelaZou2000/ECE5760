`include "iterator.v"

module iterator_loop (
  input clk,
  input reset,
  input signed [26:0] init_x,
  input signed [26:0] init_y,
  input signed [26:0] x_incr,
  input signed [26:0] y_incr,
  input signed [26:0] x_limit,
  input signed [26:0] y_limit,
  output [10:0] counter
);

  


endmodule


module iterator(
  input clk,
  input reset,
  input signed [26:0] cr,
  input signed [26:0] ci,
  output [10:0] counter
);