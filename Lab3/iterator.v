module iterator(
  input clk,
  input reset,
  input signed [26:0] cr,
  input signed [26:0] ci,
  output [10:0] counter
);
  reg signed [26:0] curr_zr, curr_zi, curr_zr_pow2, curr_zi_pow2;
  wire signed [26:0] next_zr, next_zi, next_zr_pow2, next_zi_pow2, zizr;
  reg [10:0] local_counter;
  reg [26:0] test;
  assign counter = local_counter;

  localparam MAX_ITERATIONS = 100;
  localparam signed TWO = 27'h1000000;
  localparam signed FOUR = 27'h2000000;
  localparam signed NEGTWO = 27'h7000000;

  always@(posedge clk) begin
    if (reset) begin
      curr_zr <= 27'd0;
      curr_zr_pow2 <= 27'd0;
      curr_zi <= 27'd0;
      curr_zi_pow2 <= 27'd0;
      local_counter <= 11'd0;
      test <= 0;
    end else begin
      if (local_counter >= MAX_ITERATIONS) begin
        local_counter <= local_counter;
        // test <= 26'd1;
      end else if (($signed(curr_zr)>=$signed(TWO))|($signed(curr_zi)>=$signed(TWO))|
                  ($signed(curr_zr)<=$signed(NEGTWO))|($signed(curr_zi)<=$signed(NEGTWO))|
                  ($signed(curr_zr_pow2+curr_zi_pow2)>=$signed(FOUR))) begin
        // if (($signed(curr_zr)>=$signed(TWO))) test <= 26'd2;
        // else if (($signed(curr_zi)>=$signed(TWO))) test <= 26'd3;
        // else if (($signed(curr_zr)<=$signed(NEGTWO))) test <= 26'd4;
        // else if ((curr_zi<=NEGTWO)) test <= 26'd5;
        // else if (((curr_zr_pow2+curr_zi_pow2)>=FOUR)) test <= 26'd6;
        local_counter <= local_counter;
      end else begin
        local_counter <= local_counter + 11'd1;
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

endmodule

// 4.23 notation
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