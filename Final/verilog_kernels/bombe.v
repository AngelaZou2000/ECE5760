`default_nettype wire
`include "drumbank.v"

module bombe #(parameter BANK_SIZE=1) (
  input clk,
  input reset,
  input wire [2:0] rotor_config_0,
  input wire [2:0] rotor_config_1,
  input wire [2:0] rotor_config_2,
  input wire [4:0] init_rotor_position_0,
  input wire [4:0] init_rotor_position_1,
  input wire [4:0] init_rotor_position_2,
  input wire [4:0] rotor_turnover_0,
  input wire [4:0] rotor_turnover_1,
  input wire [4:0] rotor_turnover_2,
  input wire [5*BANK_SIZE-1:0] msg_input,
  input wire [5*BANK_SIZE-1:0] msg_output,
  input wire [5*BANK_SIZE-1:0] msg_position,
  input wire next_attempt,
  output wire valid_output
);
  
  reg [2:0] state_reg, state_next;
  localparam INIT = 3'd0;
  localparam INIT1 = 3'd1;
  localparam UPDATE = 3'd2;
  localparam RUN = 3'd3;
  localparam VALID = 3'd4;
  localparam DONE = 3'd5;

  reg [4:0] plugboard_passin_mapping;
  reg [25:0] plugboard_in;
  reg drumbank_reset;
  wire bank_done, bank_fault;
  assign valid_output = (state_reg==VALID);

  always@(posedge clk) begin
    if (reset) state_reg <= INIT;
    else state_reg <= state_next;
  end
  always@(*) begin
    case(state_reg)
      INIT: state_next = INIT1;
      INIT1: state_next = RUN;
      UPDATE: begin
        if (plugboard_passin_mapping>5'd25) state_next = DONE;
        else state_next = RUN;
      end
      RUN: begin
        if (bank_fault) state_next = UPDATE;
        else if (bank_done&&(!bank_fault)) state_next = VALID;
        else state_next = state_reg;
      end
      VALID: begin
        if (reset) state_next = INIT;
        else if (next_attempt) state_next = UPDATE;
        else state_next = state_reg;
      end
      default: state_next <= state_reg;
    endcase
  end

  always@(*) begin
    case(state_reg)
      INIT: begin
        plugboard_passin_mapping = 5'b0;
        plugboard_in = 26'd1;
        // TODO: both pass in mapping and input mesasge mapping
      end
      INIT1: begin
        drumbank_reset = 1'b1;
      end
      UPDATE: begin
        if (plugboard_passin_mapping<5'd26) begin
          plugboard_passin_mapping = plugboard_passin_mapping + 1'd1;
          plugboard_in = plugboard_in<<1;
          drumbank_reset = 1'b1;
        end
      end
      RUN: begin
        drumbank_reset = 1'b0;
      end
    endcase
  end


  drumbank #(BANK_SIZE) inst (
    .clk                          (clk),
    .reset                        (drumbank_reset),
    .rotor_config_0               (rotor_config_0),
    .rotor_config_1               (rotor_config_1),
    .rotor_config_2               (rotor_config_2),
    .init_rotor_position_0        (init_rotor_position_0),
    .init_rotor_position_1        (init_rotor_position_1),
    .init_rotor_position_2        (init_rotor_position_2),
    .rotor_turnover_0             (rotor_turnover_0),
    .rotor_turnover_1             (rotor_turnover_1),
    .rotor_turnover_2             (rotor_turnover_2),
    .msg_input                    (msg_input),
    .msg_output                   (msg_output),
    .msg_position                 (msg_position),
    .plugboard_passin_mapping     (plugboard_passin_mapping),
    .plugboard_in                 (plugboard_in),
    .bank_done                    (bank_done),
    .bank_fault                   (bank_fault)
  );

endmodule