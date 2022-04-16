`default_nettype wire
module plugboard(
  input wire [4:0] plugboard_input,
  output wire [4:0] plugboard_output_wire
);
reg [4:0] plugboard_output;
assign plugboard_output_wire = plugboard_output;

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

always@(*) begin
  case (plugboard_input)
    A: plugboard_output = M;
    // B: plugboard_output = R;
    C: plugboard_output = N;
    D: plugboard_output = P;
    E: plugboard_output = Q;
    F: plugboard_output = S;
    G: plugboard_output = V;
    // H: plugboard_output = D;
    // I: plugboard_output = P;
    // J: plugboard_output = X;
    // K: plugboard_output = N;
    // L: plugboard_output = G;
    M: plugboard_output = A;
    N: plugboard_output = C;
    // O: plugboard_output = M;
    P: plugboard_output = D;
    Q: plugboard_output = E;
    // R: plugboard_output = B;
    S: plugboard_output = F;
    // T: plugboard_output = Z;
    // U: plugboard_output = C;
    V: plugboard_output = G;
    // W: plugboard_output = V;
    // X: plugboard_output = J;
    // Y: plugboard_output = A;
    // Z: plugboard_output = T;
    default: plugboard_output = plugboard_input;
  endcase
end

endmodule