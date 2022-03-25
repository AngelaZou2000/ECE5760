module mapper #(
  parameter PARTITION = 2,
  parameter PARTITION_SIZE = 500000
  ) (
  input [9:0] next_x,
  input [9:0] next_y,
  output [$clog2(PARTITION_SIZE)-1:0] m10k_read_address,
  output [$clog2(PARTITION)-1:0] partition_index
);

wire [$clog2(PARTITION_SIZE)-1:0] mult;

assign partition_index = next_x[0];
assign mult = next_y * (10'd320);
assign m10k_read_address = mult + (next_x >> 1);


endmodule