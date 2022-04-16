`timescale 1ns/1ns
module enigma_tb();

  reg clk, reset;
  reg [4:0] init_rotor_position_0;
  reg [4:0] init_rotor_position_1;
  reg [4:0] init_rotor_position_2;
  reg [4:0] rotor_turnover_0;
  reg [4:0] rotor_turnover_1;
  reg [4:0] rotor_turnover_2;
  // wire [4:0] rotor_position_0;
  // wire [4:0] rotor_position_1;
  // wire [4:0] rotor_position_2;
  reg [4:0] enigma_input;
  wire [4:0] enigma_output;

  enigma DUT (
    .clk(clk),
    .reset(reset),
    .init_rotor_position_0(init_rotor_position_0),
    .init_rotor_position_1(init_rotor_position_1),
    .init_rotor_position_2(init_rotor_position_2),
    .rotor_turnover_0(rotor_turnover_0),
    .rotor_turnover_1(rotor_turnover_1),
    .rotor_turnover_2(rotor_turnover_2),
    .enigma_input(enigma_input),
    .enigma_output(enigma_output)
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
  // HRPSQQWEFFHOQISOONEUGLUCLRSE
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
    enigma_input = H;
    #20
    enigma_input = R;
    #20
    enigma_input = P;
    #20
    enigma_input = S;
    #20
    enigma_input = Q;
    #20
    enigma_input = Q;
    #20
    enigma_input = W;
    #20
    enigma_input = E;
    #20
    enigma_input = F;
    #20
    enigma_input = F;
    #20
    enigma_input = H;
    #20
    enigma_input = O;
    #20
    enigma_input = Q;
    #20
    enigma_input = I;
    #20
    enigma_input = S;
    #20
    enigma_input = O;
    #20
    enigma_input = O;
    #20
    enigma_input = N;
    #20
    enigma_input = E;
    #20
    enigma_input = U;
    #20
    enigma_input = G;
    #20
    enigma_input = L;
    #20
    enigma_input = U;
    #20
    enigma_input = C;
    #20
    enigma_input = L;
    #20
    enigma_input = R;
    #20
    enigma_input = S;
    #20
    enigma_input = E;
  end

  //Toggle the clocks
  always begin
    #10
    clk = !clk;
  end

endmodule