`include "one_column.v"

module drum #(
  parameter eta_width=9,
  parameter g_tension_width=5,
  parameter number_of_columns=31
) (
  input clk,
  input reset,
  input [9:0] number_of_rows,
  // input [9:0] number_of_columns,
  input signed [17:0] init_node,
  input signed [17:0] incr_value_col,
  input signed [17:0] incr_value_row,
  input signed [17:0] init_center_node,
  input signed [17:0] init_rho,
  output signed [17:0] center_node_out
);
  wire signed [17:0] rho;
  reg signed [17:0] init_center_node_array [number_of_columns-1:0];
  reg signed [17:0] init_center_node_value;
  reg signed [17:0] col_incr_array [number_of_columns-1:0];
  reg signed [17:0] col_incr_value;
  wire enable_signal;

  rho_update #(g_tension_width) rho_inst
  (
    .init_rho(init_rho),
    .center_node(center_node_out),
    .rho_value(rho)
  );

  // TODO: same rho for the drum or for columns?
  // TODO: initialization
  wire signed [17:0] curr_node_out [number_of_columns-1:0];
  wire signed [17:0] center_node [number_of_columns-1:0];
  genvar col;
  generate
    for (col = 0; col < number_of_columns; col = col + 1) begin: DRUM_COL
      if (col==0) begin
        one_column #(eta_width, g_tension_width) inst_col (
          .clk(clk),
          .reset(enable_signal),
          .column_size(number_of_rows),
          .init_node(init_node),
          .incr_value(col_incr_array[col]),//(incr_value_col),
          .init_center_node(init_center_node_array[col]),
          .init_rho(rho),
          .left_node_in(18'd0),
          .right_node_in(curr_node_out[col+1]),
          .center_node(center_node[col]),
          .curr_node_out(curr_node_out[col])
        );
      end else if (col==(number_of_columns-1)) begin
        one_column #(eta_width, g_tension_width) inst_col (
          .clk(clk),
          .reset(enable_signal),
          .column_size(number_of_rows),
          .init_node(init_node),
          .incr_value(col_incr_array[col]),//(incr_value_col),
          .init_center_node(init_center_node_array[col]),
          .init_rho(rho),
          .left_node_in(curr_node_out[col-1]),
          .right_node_in(18'd0),
          .center_node(center_node[col]),
          .curr_node_out(curr_node_out[col])
        );
      end else begin
        one_column #(eta_width, g_tension_width) inst_col (
          .clk(clk),
          .reset(enable_signal),
          .column_size(number_of_rows),
          .init_node(init_node),
          .incr_value(col_incr_array[col]),//(incr_value_col),
          .init_center_node(init_center_node_array[col]),
          .init_rho(rho),
          .left_node_in(curr_node_out[col-1]),
          .right_node_in(curr_node_out[col+1]),
          .center_node(center_node[col]),
          .curr_node_out(curr_node_out[col])
        );
      end
    end
  endgenerate

  assign center_node_out = center_node[number_of_columns>>1];

  localparam INIT = 2'd0;
  localparam START_SIGNAL = 2'd1;
  localparam CALC = 2'd2;
  reg [9:0] counter;
  reg [1:0] state_reg, state_next;
  assign enable_signal = (state_reg == START_SIGNAL);

  always @ (posedge clk) begin
    if (reset) begin
      state_reg <= INIT;
      counter <= 10'd0;
      init_center_node_value <= init_node;
      col_incr_value <= init_node;
    end else begin
      state_reg <= state_next;
    end
  end

  always@(*) begin
    if ((state_reg == INIT) && (counter ==(number_of_columns-1))) state_next = START_SIGNAL;
    else if (state_reg == START_SIGNAL) state_next = CALC;
    else state_next = state_reg;
  end

  always@(posedge clk) begin
    if (state_reg == INIT) begin
      counter <= counter + 1'b1;
      init_center_node_value <= (counter < (number_of_columns>>1))? init_center_node_value + incr_value_row : init_center_node_value - incr_value_row;
      init_center_node_array[counter] <= init_center_node_value; // TODO: sequentiality
      col_incr_value <= (counter < (number_of_columns>>1))? col_incr_value + incr_value_col : col_incr_value - incr_value_col;
      col_incr_array[counter] <= col_incr_value; // TODO: sequentiality
    end
    // else begin
    //   counter <= counter;
    //   init_center_node_value <= init_center_node_value;
    // end
    // if (state_reg == START_SIGNAL) begin
    //   enable_signal = 1'b1;
    // end else begin
    //   enable_signal = 1'b0;
    // end
  end

endmodule

module rho_update
#(parameter g_tension_width)
(
  input signed [17:0] init_rho,
  input signed [17:0] center_node,
  output signed [17:0] rho_value
);
  wire signed [17:0] rho_term1, rho_term2;
  assign rho_term1 = center_node >>> g_tension_width;
  signed_mult inst2 (
    .out(rho_term2),
    .a(rho_term1),
    .b(rho_term1)
  );
  assign rho_value = (18'h0FAE1 < (init_rho + rho_term2)) ? 18'h0FAE1 : (init_rho + rho_term2);
endmodule