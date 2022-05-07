`timescale 1ns/1ns
module drumbank_tb();

  reg clk, reset;
  reg [4:0] init_rotor_position_0;
  reg [4:0] init_rotor_position_1;
  reg [4:0] init_rotor_position_2;
  reg [4:0] rotor_turnover_0;
  reg [4:0] rotor_turnover_1;
  reg [4:0] rotor_turnover_2;
  reg [4:0] msg_input;
  reg [4:0] msg_output;
  reg [4:0] msg_position;
  reg [4:0] plugboard_passin_mapping;
  reg [25:0] plugboard_in;
  wire done, fault;

  drumbank DUT (
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
    .msg_position(msg_position),
    .plugboard_passin_mapping(plugboard_passin_mapping),
    .plugboard_in(plugboard_in),
    .bank_done(done),
    .bank_fault(fault)
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

  //Intialize and drive signals
  // AABBCCDDEEFFGGHHIIJJKKLLMMNN

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
    msg_input = A;
    msg_output = I;
    msg_position = 5'd0;
    plugboard_passin_mapping = A;
    plugboard_in = 26'd0;
    #800
    // ------------
    reset = 1'b1;
    #40
    reset = 1'b0;
    msg_input = A;
    msg_output = X;
    msg_position = msg_position + 1;
    plugboard_passin_mapping = A;
    plugboard_in[9] = 1;
  end
    // ------------
    // reset = 1'b1;
    // #40
    // reset = 1'b0;
    // msg_input = B;
    // msg_position = msg_position + 1;
    // #800
    // reset = 1'b1;
    // #40
    // reset = 1'b0;
    // msg_input = B;
    // msg_position = msg_position + 1;
    // #800
    // reset = 1'b1;
    // #40
    // reset = 1'b0;
    // msg_input = C;
    // msg_position = msg_position + 1;
    // #800
    // reset = 1'b1;
    // #40
    // reset = 1'b0;
    // msg_input = C;
    // msg_position = msg_position + 1;
    // #800
    // reset = 1'b1;
    // #40
    // reset = 1'b0;
    // msg_input = D;
    // msg_position = msg_position + 1;
    // #800
    // reset = 1'b1;
    // #40
    // reset = 1'b0;
    // msg_input = D;
    // msg_position = msg_position + 1;
    // #800
    // reset = 1'b1;
    // #40
    // reset = 1'b0;
    // msg_input = E;
    // msg_position = msg_position + 1;
    // #800
    // reset = 1'b1;
    // #40
    // reset = 1'b0;
    // msg_input = E;
    // msg_position = msg_position + 1;
    // #800
    // reset = 1'b1;
    // #40
    // reset = 1'b0;
    // msg_input = F;
    // msg_position = msg_position + 1;
    // #800
    // reset = 1'b1;
    // #40
    // reset = 1'b0;
    // msg_input = F;
    // msg_position = msg_position + 1;
    // #800
    // reset = 1'b1;
    // #40
    // reset = 1'b0;
    // msg_input = G;
    // msg_position = msg_position + 1;
    // #800
    // reset = 1'b1;
    // #40
    // reset = 1'b0;
    // msg_input = G;
    // msg_position = msg_position + 1;
    // #800
    // reset = 1'b1;
    // #40
    // reset = 1'b0;
    // msg_input = H;
    // msg_position = msg_position + 1;
    // #800
    // reset = 1'b1;
    // #40
    // reset = 1'b0;
    // msg_input = H;
    // msg_position = msg_position + 1;
    // #800
    // reset = 1'b1;
    // #40
    // reset = 1'b0;
    // msg_input = I;
    // msg_position = msg_position + 1;
    // #800
    // reset = 1'b1;
    // #40
    // reset = 1'b0;
    // msg_input = I;
    // msg_position = msg_position + 1;
    // #800
    // reset = 1'b1;
    // #40
    // reset = 1'b0;
    // msg_input = J;
    // msg_position = msg_position + 1;
    // #800
    // reset = 1'b1;
    // #40
    // reset = 1'b0;
    // msg_input = J;
    // msg_position = msg_position + 1;
    // #800
    // reset = 1'b1;
    // #40
    // reset = 1'b0;
    // msg_input = K;
    // msg_position = msg_position + 1;
    // #800
    // reset = 1'b1;
    // #40
    // reset = 1'b0;
    // msg_input = K;
    // msg_position = msg_position + 1;
    // #800
    // reset = 1'b1;
    // #40
    // reset = 1'b0;
    // msg_input = L;
    // msg_position = msg_position + 1;
    // #800
    // reset = 1'b1;
    // #40
    // reset = 1'b0;
    // msg_input = L;
    // msg_position = msg_position + 1;
    // #800
    // reset = 1'b1;
    // #40
    // reset = 1'b0;
    // msg_input = M;
    // msg_position = msg_position + 1;
    // #800
    // reset = 1'b1;
    // #40
    // reset = 1'b0;
    // msg_input = M;
    // msg_position = msg_position + 1;
    // #800
    // reset = 1'b1;
    // #40
    // reset = 1'b0;
    // msg_input = N;
    // msg_position = msg_position + 1;
    // #800
    // reset = 1'b1;
    // #40
    // reset = 1'b0;
    // msg_input = N;
    // msg_position = msg_position + 1;
  // end

  //Toggle the clocks
  always begin
    #10
    clk = !clk;
  end

endmodule