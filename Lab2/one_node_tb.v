`timescale 1ns/1ns

module one_node_tb();
	
	reg clk, reset;
	
	wire signed [17:0]  node_out;

  one_node #(18'h1FFFF - 18'h00080) DUT (
  .clk(clk),
  .reset(reset),
  .init_node(18'h28000),
  .init_rho(18'h02000),
  .node_out(node_out)
);
	
	//Initialize clocks and index
	initial begin
    // $dumpfile("dump.vcd");
    // $dumpvars(1);
	  clk = 1'b0;
    reset = 1'b0;
	end
	
	//Toggle the clocks
	always begin
		#10
		clk  = !clk;
	end
	
	//Intialize and drive signals
	initial begin
		reset  = 1'b0;
		#10 
		reset  = 1'b1;
		#30
		reset  = 1'b0;
	end
	
endmodule