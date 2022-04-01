`include "iterator.v"
`default_nettype wire

module iterator_loop #(
  parameter PARTITION = 2,
  parameter PARTITION_SIZE = 100000,
  parameter PARTITION_ROW_SIZE = 320,
  parameter PARTITION_COL_SIZE = 480
  ) (
  input clk,
  input reset,
  input signed [26:0] init_x,
  input signed [26:0] init_y,
  input signed [26:0] x_incr,
  input signed [26:0] y_incr,
  input signed [26:0] x_limit,
  input signed [26:0] y_limit,
  output [$clog2(PARTITION_SIZE)-1:0] output_counter,
  output wire done,
  // VGA handling
  input [$clog2(PARTITION_SIZE)-1:0] m10k_read_address,
  input [31:0] MAX_ITERATIONS,
  output [7:0] m10k_read_data
);
  
  reg signed [26:0] current_x, current_y;
  reg [31:0] total_counter;
  reg iterator_done, node_reset, node_reset_signal;
  reg [$clog2(PARTITION_SIZE)-1:0] node_address, node_row_address, node_col_address;
  wire node_done;
  
  assign done       = iterator_done;
  
  always@(posedge clk) begin
    if (reset) begin
      current_x     <= init_x;
      current_y     <= init_y;
      total_counter <= 32'd0;
      node_reset    <= 1'd1;
      iterator_done <= 1'd0;
      node_address <= 0;
      node_row_address <= 0;
      node_col_address <= 0;
      if (node_reset) node_reset <= 1'd0;
    end else begin
      if (node_done & ~iterator_done & ~node_reset) begin
        node_address <= node_address + 1'b1;
        node_reset    <= 1'd1;
        total_counter <= total_counter + output_counter;
        current_x     <= current_x + x_incr;
        node_row_address <= node_row_address + 1'b1;
        if (node_row_address>=PARTITION_ROW_SIZE-1) begin
          current_y <= current_y + y_incr;
          current_x <= init_x;
          node_row_address <= 0;
          node_col_address <= node_col_address + 1'b1;
          if (node_col_address>=PARTITION_COL_SIZE-1) begin
            iterator_done <= 1'd1;
          end
        end
      end
      if (node_reset) begin
        node_reset <= 1'd0;
      end
    end
  end
      
  iterator #(PARTITION_SIZE) node_inst (
  .clk                (clk),
  .reset              (node_reset),
  .cr                 (current_x),
  .ci                 (current_y),
  .counter            (output_counter),
  .done               (node_done),
  .m10k_read_address  (m10k_read_address),
  .m10k_write_address (node_address),
  .MAX_ITERATIONS     (MAX_ITERATIONS),
  .m10k_read_data     (m10k_read_data)
  );

endmodule
