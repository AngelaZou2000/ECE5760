`default_nettype wire
module iterator #(parameter PARTITION_SIZE = 100000) (
  input               clk,
  input               reset,
  input signed [26:0] cr,
  input signed [26:0] ci,
  output [$clog2(PARTITION_SIZE)-1:0]       counter,
  output              done,
  // VGA handling
  input [$clog2(PARTITION_SIZE)-1:0] m10k_read_address,
  input [$clog2(PARTITION_SIZE)-1:0] m10k_write_address,
  input [31:0] MAX_ITERATIONS,
  output [7:0] m10k_read_data
);
  reg signed [26:0] curr_zr, curr_zi, curr_zr_pow2, curr_zi_pow2;
  wire signed [26:0] next_zr, next_zi, next_zr_pow2, next_zi_pow2, zizr;
  reg [$clog2(PARTITION_SIZE)-1:0] local_counter;
  reg done_signal;
  assign counter = local_counter;
  assign done = done_signal;

  localparam signed TWO = 27'h1000000;
  localparam signed FOUR = 27'h2000000;
  localparam signed NEGTWO = 27'h7000000;

  always@(posedge clk) begin
    if (reset) begin
      curr_zr <= 27'd0;
      curr_zr_pow2 <= 27'd0;
      curr_zi <= 27'd0;
      curr_zi_pow2 <= 27'd0;
      local_counter <= 'd0;
      done_signal <= 1'b0;
    end else begin
      if (local_counter >= MAX_ITERATIONS) begin // end case
        local_counter <= local_counter;
        done_signal <= 1'b1;
      end else if (($signed(curr_zr)>=$signed(TWO))|($signed(curr_zi)>=$signed(TWO))|
                  ($signed(curr_zr)<=$signed(NEGTWO))|($signed(curr_zi)<=$signed(NEGTWO))|
                  ($signed(curr_zr_pow2+curr_zi_pow2)>=$signed(FOUR))) begin
        local_counter <= local_counter;
        done_signal <= 1'b1;
      end else begin 
        // update iterators 
        local_counter <= local_counter + 1'd1;
        curr_zr <= next_zr;
        curr_zi <= next_zi;
        curr_zr_pow2 <= next_zr_pow2;
        curr_zi_pow2 <= next_zi_pow2; 
      end
    end
  end

  assign next_zr = curr_zr_pow2 - curr_zi_pow2 + cr;
  signed_mult zizrmult (zizr, curr_zr, curr_zi);
  assign next_zi = (zizr <<< 1) + ci;
  signed_mult zr_sq (next_zr_pow2, next_zr, next_zr);
  signed_mult zi_sq (next_zi_pow2, next_zi, next_zi);
  
  // Declare and assign color reg
  wire [7:0] color_reg;
  assign color_reg = (counter >= MAX_ITERATIONS)         ? 8'b00000000 : 
                     (counter >= (MAX_ITERATIONS >>> 1)) ? 8'b01100100 :
                     (counter >= (MAX_ITERATIONS >>> 2)) ? 8'b01100100 :
                     (counter >= (MAX_ITERATIONS >>> 3)) ? 8'b10101001 :
                     (counter >= (MAX_ITERATIONS >>> 4)) ? 8'b01100101 :
                     (counter >= (MAX_ITERATIONS >>> 5)) ? 8'b00100101 :
                     (counter >= (MAX_ITERATIONS >>> 6)) ? 8'b01101010 :
                     (counter >= (MAX_ITERATIONS >>> 7)) ? 8'b01010010 :
                     (counter >= (MAX_ITERATIONS >>> 8)) ? 8'b01010010 : 8'b01010010;

  M10K #(8, PARTITION_SIZE) mem (
  .clk(clk),
  .write_enable(done_signal),
  .write_address(m10k_write_address),
  .read_address(m10k_read_address),
  .d(color_reg),
  .q(m10k_read_data)
);

endmodule

// 4.23 notation mult module
module signed_mult (out, a, b);
  output  signed  [26:0]  out;
  input   signed  [26:0]  a;
  input   signed  [26:0]  b;
  // intermediate full bit length
  wire  signed  [53:0]  mult_out;
  assign mult_out = a * b;
  // select bits for 4.23 fixed point
  assign out = {mult_out[53], mult_out[48:23]};
endmodule

// M10K module
module M10K #(parameter DATA_WIDTH = 8, parameter PARTITION_SIZE = 100000) (
  input clk,
  input write_enable,
  input [$clog2(PARTITION_SIZE)-1:0] write_address,
  input [$clog2(PARTITION_SIZE)-1:0] read_address,
  input [DATA_WIDTH-1:0] d,
  output reg [DATA_WIDTH-1:0] q
);
  reg [DATA_WIDTH-1:0] mem [PARTITION_SIZE-1:0];
  always @ (posedge clk) begin
    if (write_enable) begin
      mem[write_address] <= d;
    end
    q <= mem[read_address][DATA_WIDTH-1:0];
  end
endmodule
