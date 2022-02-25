`timescale 1ns/1ns

module one_column_tb();
	
	reg clk, reset;
	
	wire signed [17:0]  node_out;

  one_column #(9, 5) DUT (
  .clk(clk),
  .reset(reset),
  .column_size(10'd31),
  .init_node(18'h00000),
  .incr_value(18'h00888), // 02AAA for 7 nodes, 01249 for 15 nodes
  .init_center_node(18'h08000),
  .init_rho(18'h01000), 
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