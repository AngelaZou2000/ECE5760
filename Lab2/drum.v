`include "one_column.v"

module drum #(
  parameter eta_width=9,
  parameter g_tension_width=5
) (
  input clk,
  input reset,
  input [9:0] number_of_rows,
  input [9:0] number_of_columns,
  input signed [17:0] init_node,
  input signed [17:0] incr_value_col,
  input signed [17:0] incr_value_row,
  input signed [17:0] init_center_node,
  input signed [17:0] init_rho,
  output signed [17:0] center_node_out
);
  reg signed [17:0] rho;

  rho_update #(g_tension_width) rho_inst
  (
    .init_rho(init_rho),
    .center_node(center_node),
    .rho_value(rho)
  );

  // TODO: same rho for the drum or for columns?
  // TODO: initialization
  genvar col;
  generate
    wire signed [17:0] curr_node_out [number_of_columns-1:0];
    wire signed [17:0] center_node [number_of_columns-1:0];
    for (col = 0; col < number_of_columns; col = col + 1) begin: DRUM_COL
    if (col==1) begin
      one_column #(9, 5) inst_col (
        .clk(clk),
        .reset(reset),
        .column_size(number_of_rows),
        .init_node(init_node),
        .incr_value(incr_value_col),
        .init_center_node(init_center_node_array[col]),
        .init_rho(rho),
        .left_node_in(18'd0),
        .right_node_in(curr_node_out[col+1]),
        .center_node(center_node[col]),
        .curr_node_out(curr_node_out[col])
      );
    end else if (col==(number_of_columns-1)) begin
      one_column #(9, 5) inst_col (
        .clk(clk),
        .reset(reset),
        .column_size(number_of_rows),
        .init_node(init_node),
        .incr_value(incr_value_col),
        .init_center_node(init_center_node_array[col]),
        .init_rho(rho),
        .left_node_in(curr_node_out[col-1]),
        .right_node_in(18'd0),
        .center_node(center_node[col]),
        .curr_node_out(curr_node_out[col])
      );
    end else begin
      one_column #(9, 5) inst_col (
        .clk(clk),
        .reset(reset),
        .column_size(number_of_rows),
        .init_node(init_node),
        .incr_value(incr_value_col),
        .init_center_node(init_center_node_array[col]),
        .init_rho(rho),
        .left_node_in(curr_node_out[col-1]),
        .right_node_in(curr_node_out[col+1]),
        .center_node(center_node[col]),
        .curr_node_out(curr_node_out[col])
      );
    end
  endgenerate

  assign center_node_out = center_node[number_of_columns>>1];

  localparam INIT = 2'b0;
  localparam CALC = 2'b1;
  reg [9:0] counter;
  reg [1:0] state_reg, state_next;

  always @ (posedge clk) begin
    if (reset) begin
      state_reg <= INIT;
      counter <= 10'd0;
      init_center_node_value <= init_node;
    end else begin
      state_reg <= state_next;
    end
  end

  always@(*) begin
    if (state_reg == INIT) state_next = CALC;
    else state_next = state_reg;
  end

  reg [17:0] init_center_node_array [number_of_columns-1:0];
  reg [17:0] init_center_node_value;

  always@(posedge clk) begin
    if (state_reg == INIT) begin
      counter <= counter + 1'b1;
      init_center_node_value <= (counter < (number_of_columns>>1))? init_center_node_value + incr_value_row : init_center_node_value - incr_value_row;
      init_center_node_array[counter] <= init_center_node_value; // TODO: sequentiality
    end
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