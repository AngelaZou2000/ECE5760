`timescale 1ns/1ns

module iterator_tb();
  
  reg clk, reset;
  
  wire signed [10:0] counter;
  wire done;
  iterator DUT(
  .clk(clk),
  .reset(reset),
  .cr(27'h2f5c29),
  .ci(27'h2f5c29),
  .counter(counter),
  .done(done),
  .m10k_read_address(),
  .m10k_write_address(),
  .m10k_read_data()
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
