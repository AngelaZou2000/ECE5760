`timescale 1ns/1ns
module stepping_tb();

  reg clk, reset;
  reg [4:0] init_rotor_position_0;
  reg [4:0] init_rotor_position_1;
  reg [4:0] init_rotor_position_2;
  reg [4:0] rotor_turnover_0;
  reg [4:0] rotor_turnover_1;
  reg [4:0] rotor_turnover_2;
  wire [4:0] rotor_position_0;
  wire [4:0] rotor_position_1;
  wire [4:0] rotor_position_2;

  stepping DUT (
    .clk(clk),
    .reset(reset),
    .init_rotor_position_0(init_rotor_position_0),
    .init_rotor_position_1(init_rotor_position_1),
    .init_rotor_position_2(init_rotor_position_2),
    .rotor_turnover_0(rotor_turnover_0),
    .rotor_turnover_1(rotor_turnover_1),
    .rotor_turnover_2(rotor_turnover_2),
    .rotor_position_0(rotor_position_0),
    .rotor_position_1(rotor_position_1),
    .rotor_position_2(rotor_position_2)
  );

  //Intialize and drive signals
  initial begin
    reset = 1'b0;
    clk = 1'b0;
    rotor_turnover_0 = 5'd21;
    rotor_turnover_1 = 5'd4;
    rotor_turnover_2 = 5'd16;
    init_rotor_position_0 = 5'd10;
    init_rotor_position_1 = 5'd3;
    init_rotor_position_2 = 5'd14;
    #10
    reset = 1'b1;
    #30
    reset = 1'b0;
  end

  //Toggle the clocks
  always begin
    #10
    clk = !clk;
  end

endmodule