`default_nettype wire
// `include "plugboard.v"
`include "reflector.v"
`include "rotor.v"
`include "stepping_en.v"

module drum (
  input wire clk,
  input wire reset,
  input wire enable,
  input wire [4:0] msg_input,
  input wire [4:0] msg_output,
  input wire [4:0] msg_position,
  input wire [2:0] rotor_config_0,
  input wire [2:0] rotor_config_1,
  input wire [2:0] rotor_config_2,
  // for stepping config
  input wire [4:0] init_rotor_position_0,
  input wire [4:0] init_rotor_position_1,
  input wire [4:0] init_rotor_position_2,
  input wire [4:0] rotor_turnover_0,
  input wire [4:0] rotor_turnover_1,
  input wire [4:0] rotor_turnover_2,
  output wire done,
  output reg [4:0] final_rotor_output
);

  reg [2:0] state_reg, state_next;
  localparam INIT = 3'd0;
  localparam STEPPING = 3'd1;
  localparam READ = 3'd2;
  localparam RUN = 3'd3;
  localparam WRITE = 3'd4;
  localparam DONE = 3'd5;

  always @ (posedge clk) begin
    if (reset) begin
      state_reg <= INIT;
    end else begin
      state_reg <= state_next;
    end
  end

  reg [4:0] stepping_count;
  wire stepping_en;
  reg [4:0] plugboard1_input;
  wire [4:0] plugboard2_output;
  wire [4:0] rotor_position_0, rotor_position_1,rotor_position_2;
  wire [4:0] plugboard1_output, rotor_forward_output2, rotor_forward_output1, rotor_forward_output0;
  wire [4:0] reflector_output, rotor_backward_output0, rotor_backward_output1, rotor_backward_output2;

  always @(*) begin
    case(state_reg)
      INIT: state_next = STEPPING;
      STEPPING: if (stepping_count==0) state_next = RUN;
      // READ:
      RUN: state_next = DONE;
      // WRITE: 
      default: state_next = state_reg;
    endcase
  end
  assign stepping_en = (state_reg==STEPPING);
  always @(posedge clk) begin
    if (state_reg==INIT) stepping_count <= msg_position;
    else if (state_reg==STEPPING) begin
      // stepping_en <= 1'b1;
      stepping_count <= stepping_count - 1'b1;
    end
    else if (state_reg==RUN) begin
      // stepping_en <= 1'b0;
      final_rotor_output <= rotor_backward_output2;
    end
  end

  // M10K #(5, 26) plugboard (
  //   .clk            (clk),
  //   .write_enable   (plugboard_write_enable),
  //   .write_address  (plugboard_write_address),
  //   .read_address   (plugboard_read_address),
  //   .d              (plugboard_write_msg),
  //   .q              (plugboard_read_msg)
  // );

  stepping_en stepping_inst (
    .clk                      (clk),
    .reset                    (reset),
    .enable                   (stepping_en),
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
  rotor forward_rotor2 (
    .rotor_input              (msg_input),
    .rotor_position           (rotor_position_2),
    .rotor_config             (rotor_config_2),
    .forward                  (1'b1),
    .rotor_output             (rotor_forward_output2)
  );
  rotor forward_rotor1 (
    .rotor_input              (rotor_forward_output2),
    .rotor_position           (rotor_position_1),
    .rotor_config             (rotor_config_1),
    .forward                  (1'b1),
    .rotor_output             (rotor_forward_output1)
  );
  rotor forward_rotor0 (
    .rotor_input              (rotor_forward_output1),
    .rotor_position           (rotor_position_0),
    .rotor_config             (rotor_config_0),
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
    .rotor_config             (rotor_config_0),
    .forward                  (1'b0),
    .rotor_output             (rotor_backward_output0)
  );
  rotor backward_rotor1 (
    .rotor_input              (rotor_backward_output0),
    .rotor_position           (rotor_position_1),
    .rotor_config             (rotor_config_1),
    .forward                  (1'b0),
    .rotor_output             (rotor_backward_output1)
  );
  rotor backward_rotor2 (
    .rotor_input              (rotor_backward_output1),
    .rotor_position           (rotor_position_2),
    .rotor_config             (rotor_config_2),
    .forward                  (1'b0),
    .rotor_output             (rotor_backward_output2)
  );

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