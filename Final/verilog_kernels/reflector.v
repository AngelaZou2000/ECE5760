`default_nettype wire
module reflector(
  input wire [4:0] reflector_input,
  output wire [4:0] reflector_output_wire
);
reg [4:0] reflector_output;
assign reflector_output_wire = reflector_output;

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
  case (reflector_input)
    A: reflector_output = Y;
    B: reflector_output = R;
    C: reflector_output = U;
    D: reflector_output = H;
    E: reflector_output = Q;
    F: reflector_output = S;
    G: reflector_output = L;
    H: reflector_output = D;
    I: reflector_output = P;
    J: reflector_output = X;
    K: reflector_output = N;
    L: reflector_output = G;
    M: reflector_output = O;
    N: reflector_output = K;
    O: reflector_output = M;
    P: reflector_output = I;
    Q: reflector_output = E;
    R: reflector_output = B;
    S: reflector_output = F;
    T: reflector_output = Z;
    U: reflector_output = C;
    V: reflector_output = W;
    W: reflector_output = V;
    X: reflector_output = J;
    Y: reflector_output = A;
    Z: reflector_output = T;
    default: reflector_output = 'x;
  endcase
end

endmodule
