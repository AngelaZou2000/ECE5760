`default_nettype wire

`include "plugboard.v"
`include "reflector.v"
`include "rotor.v"
`include "stepping.v"

module enigma (
  input clk,
  input reset,
  input wire [4:0] init_rotor_position_0,
  input wire [4:0] init_rotor_position_1,
  input wire [4:0] init_rotor_position_2,
  input wire [4:0] rotor_turnover_0,
  input wire [4:0] rotor_turnover_1,
  input wire [4:0] rotor_turnover_2,
  input wire [4:0] enigma_input,
  output reg [4:0] enigma_output
);

  reg [4:0] plugboard1_input;
  wire [4:0] plugboard2_output;
  wire [4:0] rotor_position_0, rotor_position_1,rotor_position_2;
  wire [4:0] plugboard1_output, rotor_forward_output2, rotor_forward_output1, rotor_forward_output0;
  wire [4:0] reflector_output, rotor_backward_output0, rotor_backward_output1, rotor_backward_output2;

  always@(posedge clk) begin
    plugboard1_input <= enigma_input;
    enigma_output <= plugboard2_output;
  end

  stepping stepping_inst (
    .clk                      (clk),
    .reset                    (reset),
    .init_rotor_position_0    (init_rotor_position_0),
    .init_rotor_position_1    (init_rotor_position_1),
    .init_rotor_position_2    (init_rotor_position_2),
    .rotor_turnover_0         (rotor_turnover_0),
    .rotor_turnover_1         (rotor_turnover_1), 
    .rotor_turnover_2         (rotor_turnover_2),
    .rotor_position_0         (rotor_position_0),
    .rotor_position_1         (rotor_position_1),
    .rotor_position_2         (rotor_position_2)
  );
  plugboard plugboard1 (
    .plugboard_input          (plugboard1_input), 
    .plugboard_output_wire    (plugboard1_output)
  );
  rotor forward_rotor2 (
    .rotor_input              (plugboard1_output),
    .rotor_position           (rotor_position_2),
    .rotor_config             (3'd2),
    .forward                  (1'b1),
    .rotor_output             (rotor_forward_output2)
  );
  rotor forward_rotor1 (
    .rotor_input              (rotor_forward_output2),
    .rotor_position           (rotor_position_1),
    .rotor_config             (3'd1),
    .forward                  (1'b1),
    .rotor_output             (rotor_forward_output1)
  );
  rotor forward_rotor0 (
    .rotor_input              (rotor_forward_output1),
    .rotor_position           (rotor_position_0),
    .rotor_config             (3'd0),
    .forward                  (1'b1),
    .rotor_output             (rotor_forward_output0)
  );
  reflector reflector_inst(
    .reflector_input          (rotor_forward_output0),
    .reflector_output_wire    (reflector_output)
  );
  rotor backward_rotor0 (
    .rotor_input              (reflector_output),
    .rotor_position           (rotor_position_0),
    .rotor_config             (3'd0),
    .forward                  (1'b0),
    .rotor_output             (rotor_backward_output0)
  );
  rotor backward_rotor1 (
    .rotor_input              (rotor_backward_output0),
    .rotor_position           (rotor_position_1),
    .rotor_config             (3'd1),
    .forward                  (1'b0),
    .rotor_output             (rotor_backward_output1)
  );
  rotor backward_rotor2 (
    .rotor_input              (rotor_backward_output1),
    .rotor_position           (rotor_position_2),
    .rotor_config             (3'd2),
    .forward                  (1'b0),
    .rotor_output             (rotor_backward_output2)
  );
  plugboard plugboard2 (
    .plugboard_input          (rotor_backward_output2), 
    .plugboard_output_wire    (plugboard2_output)
  );

endmodule