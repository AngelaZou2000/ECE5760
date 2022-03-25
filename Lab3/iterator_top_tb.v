`timescale 1ns/1ns

module iterator_top_tb();
  
  reg clk, reset;
  
  // wire signed [10:0] counter;
  wire done;
  iterator_top #(100, 2) DUT(
  .clk        (clk),
  .reset      (reset),
  .init_x     (27'hff000000),
  .init_y     (27'hff000000),
  .x_partition_incr (27'h100000),
  .y_partition_incr (27'h00000),
  .x_incr     (27'h200000),
  .y_incr     (27'h200000),
  .x_limit    (27'h1000000),
  .y_limit    (27'h1000000),
  .done       (done)
  );
  
  //Initialize clocks and index
  initial begin
    // $dumpfile("dump.vcd");
    // $dumpvars(1);
    clk   = 1'b0;
    reset = 1'b0;
  end
  
  //Toggle the clocks
  always begin
    #10
    clk = !clk;
  end
  
  //Intialize and drive signals
  initial begin
    reset = 1'b0;
    #10
    reset = 1'b1;
    #30
    reset = 1'b0;
  end
  
endmodule
