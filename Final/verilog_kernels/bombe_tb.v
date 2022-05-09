`timescale 1ns/1ns
module bombe_tb();

  reg clk, reset;
  reg [4:0] init_rotor_position_0;
  reg [4:0] init_rotor_position_1;
  reg [4:0] init_rotor_position_2;
  reg [4:0] rotor_turnover_0;
  reg [4:0] rotor_turnover_1;
  reg [4:0] rotor_turnover_2;
  wire [59:0] msg_input;
  wire [59:0] msg_output;
  wire [59:0] msg_position;
  wire [59:0] msg_mapping;
  reg next_attempt_1, next_attempt_2;
  reg finish_compute;
  wire valid_output;

  localparam BANK_SIZE = 12;

  bombe #(BANK_SIZE) DUT (
    .clk(clk),
    .reset(reset),
    .rotor_config_0(3'd0),
    .rotor_config_1(3'd1),
    .rotor_config_2(3'd2),
    .init_rotor_position_0(init_rotor_position_0),
    .init_rotor_position_1(init_rotor_position_1),
    .init_rotor_position_2(init_rotor_position_2),
    .rotor_turnover_0(rotor_turnover_0),
    .rotor_turnover_1(rotor_turnover_1),
    .rotor_turnover_2(rotor_turnover_2),
    .msg_input(msg_input),
    .msg_output(msg_output),
    .msg_mapping(msg_mapping),
    .msg_position(msg_position),
    .next_attempt_1(next_attempt_1),
    .next_attempt_2(next_attempt_2),
    .finish_compute(finish_compute),
    .valid_output(valid_output)
  );

  localparam A = 5'd0;
  localparam B = 5'd1;
  localparam C = 5'd2;
  localparam D = 5'd3;
  localparam E = 5'd4;
  localparam F = 5'd5;
  localparam G = 5'd6;
  localparam H = 5'd7;
  localparam I = 5'd8;
  localparam J = 5'd9;
  localparam K = 5'd10;
  localparam L = 5'd11;
  localparam M = 5'd12;
  localparam N = 5'd13;
  localparam O = 5'd14;
  localparam P = 5'd15;
  localparam Q = 5'd16;
  localparam R = 5'd17;
  localparam S = 5'd18;
  localparam T = 5'd19;
  localparam U = 5'd20;
  localparam V = 5'd21;
  localparam W = 5'd22;
  localparam X = 5'd23;
  localparam Y = 5'd24;
  localparam Z = 5'd25;


  assign msg_input[4:0] = G;
  assign msg_input[9:5] = O;
  assign msg_input[14:10] = C;
  assign msg_input[19:15] = M;
  assign msg_input[24:20] = R;
  assign msg_input[29:25] = F;
  assign msg_input[34:30] = Y;
  assign msg_input[39:35] = A;
  assign msg_input[44:40] = T;
  assign msg_input[49:45] = N;
  assign msg_input[54:50] = K;
  assign msg_input[59:55] = L;

  assign msg_output[4:0] = O;
  assign msg_output[9:5] = C;
  assign msg_output[14:10] = M;
  assign msg_output[19:15] = R;
  assign msg_output[24:20] = F;
  assign msg_output[29:25] = Y;
  assign msg_output[34:30] = A;
  assign msg_output[39:35] = T;
  assign msg_output[44:40] = N;
  assign msg_output[49:45] = K;
  assign msg_output[54:50] = L;
  assign msg_output[59:55] = B;

  assign msg_position[4:0] = 5'd1;
  assign msg_position[9:5] = 5'd0;
  assign msg_position[14:10] = 5'd11;
  assign msg_position[19:15] = 5'd2;
  assign msg_position[24:20] = 5'd18;
  assign msg_position[29:25] = 5'd16;
  assign msg_position[34:30] = 5'd10;
  assign msg_position[39:35] = 5'd12;
  assign msg_position[44:40] = 5'd8;
  assign msg_position[49:45] = 5'd3;
  assign msg_position[54:50] = 5'd6;
  assign msg_position[59:55] = 5'd5;


  initial begin
    clk = 1'b0;
    reset = 1'b0;
    rotor_turnover_0 = K;
    rotor_turnover_1 = D;
    rotor_turnover_2 = O;
    init_rotor_position_0 = V;
    init_rotor_position_1 = E;
    init_rotor_position_2 = Q;
    #10
    reset = 1'b1;
    #40
    reset = 1'b0;
    next_attempt_1 = 1'b1;
    next_attempt_2 = 1'b0;
  end

  //Toggle the clocks
  always begin
    #10
    clk = !clk;
  end

endmodule