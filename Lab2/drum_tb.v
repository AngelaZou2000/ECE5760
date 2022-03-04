`timescale 1ns/1ns

module drum_tb();
	
	reg clk, reset;
	reg iteration_enable;
	
	wire signed [17:0] center_node_out;
	wire [12:0] cycle_time_out;
  // wire signed [9:0] number_of_rows, number_of_columns;

  drum #(13, 5, 31) DUT (
  .clk(clk),
  .reset(reset),
  .number_of_rows(10'd31),
  // .number_of_columns(10'd31),
  .init_node(18'h00000),
  .incr_value_col(18'h00091), //31x31--(0.25/15/15)=00091 02AAA for 7 nodes, 01249 for 15 nodes, 00888 for 31 nodes
  .incr_value_row(18'h00888), // 02AAA for 7 nodes, 01249 for 15 nodes, 00888 for 31 nodes
  .init_center_node(18'h08000),
  .init_rho(18'h00800), 
  .iteration_enable(iteration_enable),
  .center_node_out(center_node_out),
	.cycle_time_out(cycle_time_out)
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
	
	//Toggle iteration_enable signal
	always begin
		#2000
		iteration_enable = 1'b1;
		#20
		iteration_enable = 1'b0;
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