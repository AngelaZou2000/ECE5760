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
  input wire [5*BANK_SIZE-1:0] msg_input,
  input wire [5*BANK_SIZE-1:0] msg_output,
  output wire [5*BANK_SIZE-1:0] msg_mapping,
  input wire [5*BANK_SIZE-1:0] msg_position,
  input wire [4:0] plugboard_passin_mapping,
  input wire [25:0] plugboard_in,
  output wire bank_done,
  output wire bank_fault
);

  wire [BANK_SIZE-1:0] done, fault;
  wire [25:0] plugboard_setting [BANK_SIZE:0];
  wire [4:0] plugboard_pass_mapping [BANK_SIZE:0];
  wire [BANK_SIZE-1:0] plugboard_write_enable;
  wire [4:0] plugboard_write_address [BANK_SIZE-1:0];
  wire [4:0] plugboard_read_address [BANK_SIZE-1:0];
  wire [4:0] plugboard_write_msg [BANK_SIZE-1:0];
  // wire [4:0] plugboard_read_msg [BANK_SIZE-1:0];
  reg INIT_plugboard_write_enable;
  reg [4:0] INIT_plugboard_write_address;
  reg [4:0] INIT_plugboard_read_address;
  reg [4:0] INIT_plugboard_write_msg;
  wire valid_plugboard_write_enable;
  wire [4:0] valid_plugboard_write_address;
  wire [4:0] valid_plugboard_read_address;
  wire [4:0] valid_plugboard_write_msg;
  wire [4:0] valid_plugboard_read_msg;
  reg [4:0] drum_stage_count;
  reg drum0_enable;
  assign plugboard_setting[0] = plugboard_in;
  assign plugboard_pass_mapping[0] = plugboard_passin_mapping;
  assign bank_done = &done;
  assign bank_fault = |fault;

  localparam INIT = 2'b0;
  localparam WRITE0 = 2'b1;
  localparam WRITE1 = 2'd2;
  localparam RUN = 2'd3;
  reg [1:0] state_reg, state_next;

  always@(*) begin
    if (state_reg==INIT) state_next = WRITE0;
    else if (state_reg==WRITE0) state_next = WRITE1;
    else if (state_reg==WRITE1) state_next = RUN;
    else state_next = state_reg;
  end
  always@(posedge clk) begin
    if (reset) state_reg <= INIT;
    else state_reg <= state_next;
  end
  always@(*) begin
    if (state_reg==INIT) begin
      drum0_enable = 1'b0;
    end
    else if (state_reg==WRITE0) begin
      drum0_enable = 1'b0;
      INIT_plugboard_write_enable = 1'b1;
      INIT_plugboard_write_address = msg_input;
      INIT_plugboard_write_msg = plugboard_passin_mapping;
    end
    else if (state_reg==WRITE1) begin
      drum0_enable = 1'b0;
      INIT_plugboard_write_enable = 1'b1;
      INIT_plugboard_write_address = plugboard_passin_mapping;
      INIT_plugboard_write_msg = msg_input;
    end
    else if (state_reg==RUN) begin
      drum0_enable = 1'b1;
    end
  end

  genvar inst;
  generate
    for (inst = 0; inst < BANK_SIZE; inst = inst + 1) begin: INST
      drum drum_inst (
        .clk                        (clk),
        .reset                      (reset),
        .enable                     (inst==0?drum0_enable:done[inst-1]),
        .done                       (done[inst]),
        .fault                      (fault[inst]),
        .msg_input                  (msg_input[5*inst+4:5*inst]),
        .msg_output                 (msg_output[5*inst+4:5*inst]),
        .msg_position               (msg_position[5*inst+4:5*inst]),
        .rotor_config_0             (rotor_config_0),
        .rotor_config_1             (rotor_config_1),
        .rotor_config_2             (rotor_config_2),
        .init_rotor_position_0      (init_rotor_position_0),
        .init_rotor_position_1      (init_rotor_position_1),
        .init_rotor_position_2      (init_rotor_position_2),
        .rotor_turnover_0           (rotor_turnover_0),
        .rotor_turnover_1           (rotor_turnover_1),
        .rotor_turnover_2           (rotor_turnover_2),
        .plugboard_write_enable     (plugboard_write_enable[inst]),
        .plugboard_write_address    (plugboard_write_address[inst]),
        .plugboard_read_address     (plugboard_read_address[inst]),
        .plugboard_write_msg        (plugboard_write_msg[inst]),
        .plugboard_read_msg         (valid_plugboard_read_msg),
        .plugboard_passin_mapping   (plugboard_pass_mapping[inst]),
        .plugboard_passout_mapping  (plugboard_pass_mapping[inst+1]),
        .plugboard_in               (plugboard_setting[inst]),
        .plugboard_out              (plugboard_setting[inst+1]),
        .final_rotor_output         (msg_mapping[5*inst+4:5*inst])
      );
    end
  endgenerate  

  // TODO: cannot parametrize?
  always@(posedge clk) begin
    drum_stage_count <= done[0]+done[1]+done[2]+done[3]+done[4]+done[5]+done[6]+done[7]+done[8]+done[9]+done[10]+done[11];
  end

  assign valid_plugboard_write_enable = (state_reg!=RUN)?INIT_plugboard_write_enable:plugboard_write_enable[drum_stage_count];
  assign valid_plugboard_write_address = (state_reg!=RUN)?INIT_plugboard_write_address:plugboard_write_address[drum_stage_count];
  assign valid_plugboard_write_msg = (state_reg!=RUN)?INIT_plugboard_write_msg:plugboard_write_msg[drum_stage_count];
  assign valid_plugboard_read_address = (state_reg!=RUN)?INIT_plugboard_read_address:plugboard_read_address[drum_stage_count];

  M10K #(5, 26) plugboard (
    .clk            (clk),
    .write_enable   (valid_plugboard_write_enable),
    .write_address  (valid_plugboard_write_address),
    .read_address   (valid_plugboard_read_address),
    .d              (valid_plugboard_write_msg),
    .q              (valid_plugboard_read_msg)
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