`include "iterator_loop.v"

module iterator_top #(
  parameter MAX_ITERATIONS = 100,
  parameter PARTITION = 2
)
(
  input clk,
  input reset,
  input signed [26:0] init_x,
  input signed [26:0] init_y,
  input signed [26:0] x_partition_incr,
  input signed [26:0] y_partition_incr,
  input signed [26:0] x_incr, // TODO: process on the HPS side
  input signed [26:0] y_incr,
  input signed [26:0] x_limit,
  input signed [26:0] y_limit,
  // output [10:0] output_counter,
  output wire done
);

  wire iterator_reset;
  reg signed [26:0] init_x_value, init_y_value;
  reg signed [26:0] init_x_arr [PARTITION-1:0];
  reg signed [26:0] init_y_arr [PARTITION-1:0];
  reg signed [26:0] x_limit_arr [PARTITION-1:0];
  reg signed [26:0] y_limit_arr [PARTITION-1:0];
  wire signed [10:0] output_counter_arr [PARTITION-1:0];
  wire [PARTITION-1:0] iterator_done;

  assign done = &iterator_done;

  genvar partition;
  generate
    for (partition = 0; partition < PARTITION; partition = partition + 1) begin: PART
      iterator_loop iterator1 (
        .clk(clk),
        .reset(iterator_reset),
        .init_x(init_x_arr[partition]),
        .init_y(init_y_arr[partition]),
        .x_incr(x_incr),
        .y_incr(y_incr),
        .x_limit(x_limit_arr[partition]),
        .y_limit(y_limit_arr[partition]),
        .output_counter(output_counter_arr[partition]),
        .done(iterator_done[partition])
      );
    end
  endgenerate

  localparam INIT = 2'd0;
  localparam START_SIGNAL = 2'd1;
  localparam CALC = 2'd2;
  reg [31:0] counter;
  reg [1:0] state_reg, state_next;
  assign iterator_reset = (state_reg == START_SIGNAL);

  always @ (posedge clk) begin
    if (reset) begin
      state_reg <= INIT;
    end else begin
      state_reg <= state_next;
    end
  end

  always@(*) begin
    // if finished initialization all columns, move on to next state
    if ((state_reg == INIT) && (counter == (PARTITION-1))) state_next = START_SIGNAL;
    // move to calculation stage after sends out the enable signal
    else if (state_reg == START_SIGNAL) state_next = CALC;
    else state_next = state_reg;
  end

  

  always@(posedge clk) begin
    if (reset) begin
      counter <= 32'd0;
      init_x_value <= init_x;
      init_y_value <= init_y;
    end
    else if (state_reg == INIT) begin
      // increse the initialization counter
      counter <= counter + 1'b1;
      init_x_value <= init_x_value + x_partition_incr;
      init_x_arr[counter] <= init_x_value;
      init_y_value <= init_y_value + y_partition_incr;
      init_y_arr[counter] <= init_y_value;
      x_limit_arr[counter] <= x_limit - x_incr;
      y_limit_arr[counter] <= y_limit - y_incr;
    end
    else if (state_reg == START_SIGNAL) 
      counter <= 32'd0;
    else if (state_reg == CALC & ~done) 
      counter <= counter + 1'b1;
  end



endmodule