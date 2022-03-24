`timescale 1ns/1ns

module iterator_loop_tb();
  
  reg clk, reset;
  
  wire signed [10:0] counter;
  wire done;
  iterator_loop DUT(
  .clk      (clk),
  .reset    (reset),
  .init_x   (27'h0),
  .init_y   (27'h0),
  .x_incr   (27'h400000),
  .y_incr   (27'h400000),
  .x_limit  (27'h1000000),
  .y_limit  (27'h1000000),
  .output_counter(counter),
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
