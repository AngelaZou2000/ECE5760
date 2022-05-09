`default_nettype wire
module stepping_en (
  input wire clk,
  input wire reset,
  input wire enable,
  input wire [4:0] init_rotor_position_0,
  input wire [4:0] init_rotor_position_1,
  input wire [4:0] init_rotor_position_2,
  input wire [4:0] rotor_turnover_0,
  input wire [4:0] rotor_turnover_1,
  input wire [4:0] rotor_turnover_2,
  output reg [4:0] rotor_position_0,
  output reg [4:0] rotor_position_1,
  output reg [4:0] rotor_position_2
);

  always@(posedge clk) begin
    if (reset) begin
      rotor_position_2 <= init_rotor_position_2;
      rotor_position_1 <= init_rotor_position_1;
      rotor_position_0 <= init_rotor_position_0;
    end else if (enable) begin
      if (rotor_position_1==rotor_turnover_1) begin
        rotor_position_0 <= (rotor_position_0==5'd25) ? 5'd0 : (rotor_position_0+5'd1);
        rotor_position_1 <= (rotor_position_1==5'd25) ? 5'd0 : (rotor_position_1+5'd1);
      end
      if (rotor_position_2==rotor_turnover_2) begin
        rotor_position_1 <= (rotor_position_1==5'd25) ? 5'd0 : (rotor_position_1+5'd1);
      end
      rotor_position_2 <= (rotor_position_2==5'd25) ? 5'd0 : (rotor_position_2+5'd1);
    end
  end

endmodule