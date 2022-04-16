`timescale 1ns/1ns
module rotor_tb();

  reg [4:0] rotor_input;
  reg [4:0] rotor_position;
  reg [2:0] rotor_config;
  reg forward;
  wire [4:0] rotor_output;

  rotor DUT (
    .rotor_input(rotor_input),
    .rotor_position(rotor_position),
    .rotor_config(rotor_config),
    .forward(forward),
    .rotor_output(rotor_output)
  );

  initial begin
    rotor_input = 5'd0;
    rotor_position = 5'd0;
    rotor_config = 3'd0;
    forward = 1;
  end

  always begin
      #10
      if (rotor_input < 25)
        rotor_input = rotor_input + 1;
      else if (rotor_input == 25) begin
        if (rotor_config < 2) begin
          rotor_config = rotor_config + 1;
          rotor_input = 0;
        end else if (rotor_config == 2) begin
          if (forward) begin
            forward = 0;
            rotor_config = 0;
            rotor_input = 0;
          end else begin
          forward = 'x;
          rotor_config = 'x;
          rotor_input = 'x;
          end
        end
      end

end

endmodule