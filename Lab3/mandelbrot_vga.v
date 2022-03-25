`include "iterator_top.v"
`include "vga_driver.v"

module mandelbrot_vga #(
  parameter MAX_ITERATIONS = 100,
  parameter PARTITION = 2,
  parameter PARTITION_SIZE = 100000
) (
  input iterator_clk,
  input vga_driver_clk,
  input iterator_reset,
  input vga_reset,
  // iterator signals
  input signed [26:0] init_x,
  input signed [26:0] init_y,
  input signed [26:0] x_partition_incr,
  input signed [26:0] y_partition_incr,
  input signed [26:0] x_incr, // TODO: process on the HPS side
  input signed [26:0] y_incr,
  input signed [26:0] x_limit, 
  input signed [26:0] y_limit,
  // VGA driver signals
  output wire hsync,    // HSYNC (to VGA connector)
  output wire vsync,    // VSYNC (to VGA connctor)
  output [7:0] red,     // RED (to resistor DAC VGA connector)
  output [7:0] green,   // GREEN (to resistor DAC to VGA connector)
  output [7:0] blue,    // BLUE (to resistor DAC to VGA connector)
  output sync,          // SYNC to VGA connector
  output clk,           // CLK to VGA connector
  output blank          // BLANK to VGA connector
);


  wire [7:0] vga_data;
  wire [$clog2(PARTITION_SIZE)-1:0] m10k_read_address;
  wire [$clog2(PARTITION)-1:0] partition_index;
  wire [9:0] next_x, next_y;

  iterator_top #(MAX_ITERATIONS, PARTITION, PARTITION_SIZE) iterator_inst (
    .clk(iterator_clk),
    .reset(iterator_reset),
    .init_x(init_x),
    .init_y(init_y),
    .x_partition_incr(x_partition_incr),
    .y_partition_incr(y_partition_incr),
    .x_incr(x_incr),
    .y_incr(y_incr),
    .x_limit(x_limit), 
    .y_limit(y_limit),
    .done(),
    .m10k_read_address(m10k_read_address),
    .partition_index(partition_index),
    .vga_data(vga_data)
  );

  mapper #(PARTITION, PARTITION_SIZE) mapper_inst (
    .next_x(next_x),
    .next_y(next_y),
    .m10k_read_address(m10k_read_address),
    .partition_index(partition_index)
  );

  vga_driver driver_inst (
    .clock(vga_driver_clk),     
    .reset(vga_reset),     
    .color_in(vga_data), 
    .next_x(next_x),  
    .next_y(next_y),  
    .hsync(hsync),    
    .vsync(vsync),    
    .red(red),     
    .green(green),   
    .blue(blue),    
    .sync(sync),          
    .clk(clk),           
    .blank(blank)     
);

endmodule
