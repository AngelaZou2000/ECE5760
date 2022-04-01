module mapper #(
  parameter PARTITION = 2,
  parameter PARTITION_SIZE = 153600,
  parameter PARTITION_ROW_SIZE = 320,
  parameter PARTITION_COL_SIZE = 480
  ) (
  input [9:0] next_x,
  input [9:0] next_y,
  output [$clog2(PARTITION_SIZE)-1:0] m10k_read_address,
  output [$clog2(PARTITION)-1:0] partition_index
);

wire [$clog2(PARTITION_SIZE)-1:0] mult;

assign partition_index = next_x[$clog2(PARTITION)-1:0];
assign mult = next_y * PARTITION_ROW_SIZE;
assign m10k_read_address = mult + (next_x >> $clog2(PARTITION));


endmodule