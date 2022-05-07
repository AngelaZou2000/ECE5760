`default_nettype wire
`include "drum.v"

module drumbank #(parameter BANK_SIZE=1) (
  input wire clk,
  input wire reset,
  input wire [2:0] rotor_config_0,
  input wire [2:0] rotor_config_1,
  input wire [2:0] rotor_config_2,
  input wire [4:0] init_rotor_position_0,
  input wire [4:0] init_rotor_position_1,
  input wire [4:0] init_rotor_position_2,
  input wire [4:0] rotor_turnover_0,
  input wire [4:0] rotor_turnover_1,
  input wire [4:0] rotor_turnover_2,
  input wire [4:0] msg_input,
  input wire [4:0] msg_output,
  input wire [4:0] msg_position,
  input wire [4:0] plugboard_passin_mapping,
  input wire [25:0] plugboard_in,
  output wire bank_done,
  output wire bank_fault
);

  // TODO: initialize M10K value

  wire [BANK_SIZE-1:0] done, fault;
  wire [25:0] plugboard_setting [BANK_SIZE:0];
  wire [4:0] plugboard_pass_mapping [BANK_SIZE:0];
  wire plugboard_write_enable;
  wire [4:0] plugboard_write_address, plugboard_read_address;
  wire [4:0] plugboard_write_msg, plugboard_read_msg;
  assign plugboard_setting[0] = plugboard_in;
  assign plugboard_pass_mapping[0] = plugboard_passin_mapping;
  assign bank_done = &done;
  assign bank_fault = |fault;

  drum inst0 (
    .clk                        (clk),
    .reset                      (reset),
    .enable                     (1'b1),
    .done                       (done[0]),
    .fault                      (fault[0]),
    .msg_input                  (msg_input),
    .msg_output                 (msg_output),
    .msg_position               (msg_position),
    .rotor_config_0             (rotor_config_0),
    .rotor_config_1             (rotor_config_1),
    .rotor_config_2             (rotor_config_2),
    .init_rotor_position_0      (init_rotor_position_0),
    .init_rotor_position_1      (init_rotor_position_1),
    .init_rotor_position_2      (init_rotor_position_2),
    .rotor_turnover_0           (rotor_turnover_0),
    .rotor_turnover_1           (rotor_turnover_1),
    .rotor_turnover_2           (rotor_turnover_2),
    .plugboard_write_enable     (plugboard_write_enable),
    .plugboard_write_address    (plugboard_write_address),
    .plugboard_read_address     (plugboard_read_address),
    .plugboard_write_msg        (plugboard_write_msg),
    .plugboard_read_msg         (plugboard_write_msg),
    .plugboard_passin_mapping   (plugboard_pass_mapping[0]),
    .plugboard_passout_mapping  (plugboard_pass_mapping[1]),
    .plugboard_in               (plugboard_setting[0]),
    .plugboard_out              (plugboard_setting[1]),
    .final_rotor_output         ()
  );

  M10K #(5, 26) plugboard (
    .clk            (clk),
    .write_enable   (plugboard_write_enable),
    .write_address  (plugboard_write_address),
    .read_address   (plugboard_read_address),
    .d              (plugboard_write_msg),
    .q              (plugboard_read_msg)
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