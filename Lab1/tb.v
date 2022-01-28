`timescale 1ns/1ns

module testbench();
	
	reg clk, reset;
	
	// reg [31:0] index;
	wire signed [26:0]  x_tb, y_tb, z_tb;

  solver DUT (
  .clk(clk),
  .reset(reset),
  .dt({7'h0, 20'h01000}),
  .init_x({7'h7f, 20'd0}),
  .init_y({7'h0, 20'h19999}),
  .init_z({7'd25, 20'd0}),
  .beta({7'd2, 20'haaaaa}),
  .sigma({7'd10, 20'd0}),
  .rho({7'd28, 20'd0}),
  .x(x_tb),
  .y(y_tb),
  .z(z_tb)
);
	
	//Initialize clocks and index
	initial begin
    // $dumpfile("dump.vcd");
    // $dumpvars(1);
		clk = 1'b0;
    reset = 1'b0;
		// index  = 32'd0;
		//testbench_out = 15'd0 ;
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
	
	// //Increment index
	// always @ (posedge clk_50) begin
	// 	index  <= index + 32'd1;
	// end
	
endmodule