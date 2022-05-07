`default_nettype wire
// `include "plugboard.v"
`include "reflector.v"
`include "rotor.v"
`include "stepping_en.v"

module drum (
  // control signal
  input wire clk,
  input wire reset,
  input wire enable,
  output wire done,
  output reg fault,
  input wire [4:0] msg_input,
  input wire [4:0] msg_output,
  input wire [4:0] msg_position,
  // for rotor config
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
  // for plugboard access
  output reg plugboard_write_enable,
  output reg [4:0] plugboard_write_address,
  output wire [4:0] plugboard_read_address,
  output reg [4:0] plugboard_write_msg,
  input wire [4:0] plugboard_read_msg,
  input wire [4:0] plugboard_passin_mapping,
  output reg [4:0] plugboard_passout_mapping,
  input wire [25:0] plugboard_in,
  output reg [25:0] plugboard_out,
  // output
  output reg [4:0] final_rotor_output
);

  reg [2:0] state_reg, state_next;
  localparam INIT = 3'd0;
  localparam STEPPING = 3'd1;
  // localparam READ = 3'd2;
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

  wire [4:0] plugboard_read_mapping;
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
      RUN: if (fault) state_next = DONE;
          else state_next = WRITE;
      WRITE: state_next = DONE;
      default: state_next = state_reg;
    endcase
  end

  assign stepping_en = (state_reg==STEPPING);
  assign done = (state_reg==DONE);
  assign plugboard_read_address = msg_output;
  assign plugboard_read_mapping = plugboard_read_msg;

  always @(posedge clk) begin
    if (state_reg==INIT) begin
      plugboard_write_enable <= 1'b0;
      stepping_count <= msg_position;
      plugboard_out <= plugboard_in;
      fault <= 0;
    end
    else if (state_reg==STEPPING) begin
      stepping_count <= stepping_count - 1'b1;
    end
    else if (state_reg==RUN) begin
      final_rotor_output <= rotor_backward_output2;
      if ((plugboard_in[msg_output]^plugboard_in[rotor_backward_output2])||
         ((plugboard_in[msg_output])&&(plugboard_read_mapping!=rotor_backward_output2))) begin
          fault <= 1;
      end else begin
        plugboard_write_enable <= 1'b1;
        plugboard_write_address <= rotor_backward_output2;
        plugboard_write_msg <= msg_output;
      end
    end
    else if (state_reg==WRITE) begin
      plugboard_write_enable <= 1'b1;
      plugboard_write_address <= msg_output;
      plugboard_write_msg <= rotor_backward_output2;
      plugboard_passout_mapping <= rotor_backward_output2;
    end
  end

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
    // mapping input to passed in mapping from the plugboard
    .rotor_input              (plugboard_passin_mapping),
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