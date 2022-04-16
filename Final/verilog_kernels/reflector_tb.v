`timescale 1ns/1ns
module reflector_tb();

  reg [4:0] in;
  wire [4:0] out;
  reflector DUT (
    .reflector_input(in),
    .reflector_output_wire(out)
  );

  initial begin
    in = 5'd0;
  end

  always begin
      #10
      if (in < 30)
        in = in + 1;
end

endmodule