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

// wire [$clog2(PARTITION_SIZE)-1:0] mult;
// assign partition_index = next_x[$clog2(PARTITION)-1:0];
// assign mult = next_y * PARTITION_ROW_SIZE;
// assign m10k_read_address = mult + (next_x >> $clog2(PARTITION));

assign partition_index = (next_x < 40)  ? next_x       :
                         (next_x < 80)  ? next_x - 40  : 
                         (next_x < 120) ? next_x - 80  :
                         (next_x < 160) ? next_x - 120 :
                         (next_x < 200) ? next_x - 160 :
                         (next_x < 240) ? next_x - 200 :
                         (next_x < 280) ? next_x - 240 :
                         (next_x < 320) ? next_x - 280 :
                         (next_x < 360) ? next_x - 320 :
                         (next_x < 400) ? next_x - 360 :
                         (next_x < 440) ? next_x - 400 :
                         (next_x < 480) ? next_x - 440 :
                         (next_x < 520) ? next_x - 480 :
                         (next_x < 560) ? next_x - 520 :
                         (next_x < 600) ? next_x - 560 :
                                          next_x - 600;

wire [4:0] grid_idx;
assign grid_idx = (next_x < 40)  ? 0  : 
                  (next_x < 80)  ? 1  :
                  (next_x < 120) ? 2  :
                  (next_x < 160) ? 3  :
                  (next_x < 200) ? 4  :
                  (next_x < 240) ? 5  :
                  (next_x < 280) ? 6  :
                  (next_x < 320) ? 7  :
                  (next_x < 360) ? 8  :
                  (next_x < 400) ? 9  :
                  (next_x < 440) ? 10 :
                  (next_x < 480) ? 11 :
                  (next_x < 520) ? 12 :
                  (next_x < 560) ? 13 :
                  (next_x < 600) ? 14 :
                                   15;

wire [$clog2(PARTITION_SIZE)-1:0] mult;
assign mult = next_y * PARTITION_ROW_SIZE;
assign m10k_read_address = mult + grid_idx;

endmodule