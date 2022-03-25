`include "iterator.v"
`default_nettype wire

module iterator_loop (
  input clk,
  input reset,
  input signed [26:0] init_x,
  input signed [26:0] init_y,
  input signed [26:0] x_incr,
  input signed [26:0] y_incr,
  input signed [26:0] x_limit,
  input signed [26:0] y_limit,
  output [10:0] output_counter,
  output wire done
);
  
  reg signed [26:0] current_x, current_y;
  // wire [10:0] output_counter;
  reg [31:0] total_counter;
  reg iterator_done, node_reset, node_reset_signal;
  wire node_done;
  
  assign done       = iterator_done;
  // assign counter = output_counter;
  
  always@(posedge clk) begin
    if (reset) begin
      current_x     <= init_x;
      current_y     <= init_y;
      total_counter <= 32'd0;
      node_reset    <= 1'd1;
      iterator_done <= 1'd0;
      if (node_reset) node_reset <= 1'd0;
    end else begin
      if (node_done & ~iterator_done & ~node_reset) begin
        node_reset    <= 1'd1;
        total_counter <= total_counter + {{21{1'b0}}, output_counter};
        current_x     <= current_x + x_incr;
        if ($signed(current_x)>$signed(x_limit)) begin
          current_y <= current_y + y_incr;
          current_x <= init_x;
          if ($signed(current_y)>$signed(y_limit)) begin
            iterator_done <= 1'd1;
          end
        end
      end
      if (node_reset) begin
        node_reset <= 1'd0;
      end
    end
  end
      
  iterator node_inst (
  .clk       (clk),
  .reset     (node_reset),
  .cr        (current_x),
  .ci        (current_y),
  .counter   (output_counter),
  .done      (node_done)
  );
      
endmodule
