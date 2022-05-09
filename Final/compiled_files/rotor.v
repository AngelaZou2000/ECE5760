`default_nettype wire
module rotor(
  input wire [4:0] rotor_input,
  input wire [4:0] rotor_position,
  input wire [2:0] rotor_config,
  input wire forward,
  output wire [4:0] rotor_output 
);

  wire [4:0] enter_contact, exit_contact;
  wire [5:0] enter_sum;
  assign enter_sum = rotor_input+rotor_position;
  assign enter_contact = (enter_sum>6'd25) ? (enter_sum-6'd26) : (enter_sum);
  assign rotor_output = (exit_contact<rotor_position)? (exit_contact-rotor_position+5'd26) : (exit_contact-rotor_position);
  rotor_wiring inst (
    .enter_contact(enter_contact),
    .rotor_config(rotor_config),
    .forward(forward),
    .exit_contact_wire(exit_contact)
  );
endmodule

module rotor_wiring(
  input wire [4:0] enter_contact,
  input wire [2:0] rotor_config,
  input wire forward,
  output wire [4:0] exit_contact_wire
);
reg [4:0] exit_contact;
assign exit_contact_wire = exit_contact;
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

localparam rI = 3'd0;
localparam rII = 3'd1;
localparam rIII = 3'd2;

// ABCDEFGHIJKLMNOPQRSTUVWXYZ
// EKMFLGDQVZNTOWYHXUSPAIBRCJ I
// AJDKSIRUXBLHWTMCQGZNPYFVOE II
// BDFHJLCPRTXVZNYEIWGAKMUSQO III
always@(*) begin
  if (forward) begin
    case (enter_contact)
      A: exit_contact = (rotor_config==rI) ? E : ((rotor_config==rII) ? A : ((rotor_config==rIII) ? B : 5'hx));
      B: exit_contact = (rotor_config==rI) ? K : ((rotor_config==rII) ? J : ((rotor_config==rIII) ? D : 5'hx));
      C: exit_contact = (rotor_config==rI) ? M : ((rotor_config==rII) ? D : ((rotor_config==rIII) ? F : 5'hx));
      D: exit_contact = (rotor_config==rI) ? F : ((rotor_config==rII) ? K : ((rotor_config==rIII) ? H : 5'hx));
      E: exit_contact = (rotor_config==rI) ? L : ((rotor_config==rII) ? S : ((rotor_config==rIII) ? J : 5'hx));
      F: exit_contact = (rotor_config==rI) ? G : ((rotor_config==rII) ? I : ((rotor_config==rIII) ? L : 5'hx));
      G: exit_contact = (rotor_config==rI) ? D : ((rotor_config==rII) ? R : ((rotor_config==rIII) ? C : 5'hx));
      H: exit_contact = (rotor_config==rI) ? Q : ((rotor_config==rII) ? U : ((rotor_config==rIII) ? P : 5'hx));
      I: exit_contact = (rotor_config==rI) ? V : ((rotor_config==rII) ? X : ((rotor_config==rIII) ? R : 5'hx));
      J: exit_contact = (rotor_config==rI) ? Z : ((rotor_config==rII) ? B : ((rotor_config==rIII) ? T : 5'hx));
      K: exit_contact = (rotor_config==rI) ? N : ((rotor_config==rII) ? L : ((rotor_config==rIII) ? X : 5'hx));
      L: exit_contact = (rotor_config==rI) ? T : ((rotor_config==rII) ? H : ((rotor_config==rIII) ? V : 5'hx));
      M: exit_contact = (rotor_config==rI) ? O : ((rotor_config==rII) ? W : ((rotor_config==rIII) ? Z : 5'hx));
      N: exit_contact = (rotor_config==rI) ? W : ((rotor_config==rII) ? T : ((rotor_config==rIII) ? N : 5'hx));
      O: exit_contact = (rotor_config==rI) ? Y : ((rotor_config==rII) ? M : ((rotor_config==rIII) ? Y : 5'hx));
      P: exit_contact = (rotor_config==rI) ? H : ((rotor_config==rII) ? C : ((rotor_config==rIII) ? E : 5'hx));
      Q: exit_contact = (rotor_config==rI) ? X : ((rotor_config==rII) ? Q : ((rotor_config==rIII) ? I : 5'hx));
      R: exit_contact = (rotor_config==rI) ? U : ((rotor_config==rII) ? G : ((rotor_config==rIII) ? W : 5'hx));
      S: exit_contact = (rotor_config==rI) ? S : ((rotor_config==rII) ? Z : ((rotor_config==rIII) ? G : 5'hx));
      T: exit_contact = (rotor_config==rI) ? P : ((rotor_config==rII) ? N : ((rotor_config==rIII) ? A : 5'hx));
      U: exit_contact = (rotor_config==rI) ? A : ((rotor_config==rII) ? P : ((rotor_config==rIII) ? K : 5'hx));
      V: exit_contact = (rotor_config==rI) ? I : ((rotor_config==rII) ? Y : ((rotor_config==rIII) ? M : 5'hx));
      W: exit_contact = (rotor_config==rI) ? B : ((rotor_config==rII) ? F : ((rotor_config==rIII) ? U : 5'hx));
      X: exit_contact = (rotor_config==rI) ? R : ((rotor_config==rII) ? V : ((rotor_config==rIII) ? S : 5'hx));
      Y: exit_contact = (rotor_config==rI) ? C : ((rotor_config==rII) ? O : ((rotor_config==rIII) ? Q : 5'hx));
      Z: exit_contact = (rotor_config==rI) ? J : ((rotor_config==rII) ? E : ((rotor_config==rIII) ? O : 5'hx));
      default: exit_contact = 5'hx;
    endcase
  end else begin
    case (enter_contact)
      A: exit_contact = (rotor_config==rI) ? U : ((rotor_config==rII) ? A : ((rotor_config==rIII) ? T : 5'hx));
      B: exit_contact = (rotor_config==rI) ? W : ((rotor_config==rII) ? J : ((rotor_config==rIII) ? A : 5'hx));
      C: exit_contact = (rotor_config==rI) ? Y : ((rotor_config==rII) ? P : ((rotor_config==rIII) ? G : 5'hx));
      D: exit_contact = (rotor_config==rI) ? G : ((rotor_config==rII) ? C : ((rotor_config==rIII) ? B : 5'hx));
      E: exit_contact = (rotor_config==rI) ? A : ((rotor_config==rII) ? Z : ((rotor_config==rIII) ? P : 5'hx));
      F: exit_contact = (rotor_config==rI) ? D : ((rotor_config==rII) ? W : ((rotor_config==rIII) ? C : 5'hx));
      G: exit_contact = (rotor_config==rI) ? F : ((rotor_config==rII) ? R : ((rotor_config==rIII) ? S : 5'hx));
      H: exit_contact = (rotor_config==rI) ? P : ((rotor_config==rII) ? L : ((rotor_config==rIII) ? D : 5'hx));
      I: exit_contact = (rotor_config==rI) ? V : ((rotor_config==rII) ? F : ((rotor_config==rIII) ? Q : 5'hx));
      J: exit_contact = (rotor_config==rI) ? Z : ((rotor_config==rII) ? B : ((rotor_config==rIII) ? E : 5'hx));
      K: exit_contact = (rotor_config==rI) ? B : ((rotor_config==rII) ? D : ((rotor_config==rIII) ? U : 5'hx));
      L: exit_contact = (rotor_config==rI) ? E : ((rotor_config==rII) ? K : ((rotor_config==rIII) ? F : 5'hx));
      M: exit_contact = (rotor_config==rI) ? C : ((rotor_config==rII) ? O : ((rotor_config==rIII) ? V : 5'hx));
      N: exit_contact = (rotor_config==rI) ? K : ((rotor_config==rII) ? T : ((rotor_config==rIII) ? N : 5'hx));
      O: exit_contact = (rotor_config==rI) ? M : ((rotor_config==rII) ? Y : ((rotor_config==rIII) ? Z : 5'hx));
      P: exit_contact = (rotor_config==rI) ? T : ((rotor_config==rII) ? U : ((rotor_config==rIII) ? H : 5'hx));
      Q: exit_contact = (rotor_config==rI) ? H : ((rotor_config==rII) ? Q : ((rotor_config==rIII) ? Y : 5'hx));
      R: exit_contact = (rotor_config==rI) ? X : ((rotor_config==rII) ? G : ((rotor_config==rIII) ? I : 5'hx));
      S: exit_contact = (rotor_config==rI) ? S : ((rotor_config==rII) ? E : ((rotor_config==rIII) ? X : 5'hx));
      T: exit_contact = (rotor_config==rI) ? L : ((rotor_config==rII) ? N : ((rotor_config==rIII) ? J : 5'hx));
      U: exit_contact = (rotor_config==rI) ? R : ((rotor_config==rII) ? H : ((rotor_config==rIII) ? W : 5'hx));
      V: exit_contact = (rotor_config==rI) ? I : ((rotor_config==rII) ? X : ((rotor_config==rIII) ? L : 5'hx));
      W: exit_contact = (rotor_config==rI) ? N : ((rotor_config==rII) ? M : ((rotor_config==rIII) ? R : 5'hx));
      X: exit_contact = (rotor_config==rI) ? Q : ((rotor_config==rII) ? I : ((rotor_config==rIII) ? K : 5'hx));
      Y: exit_contact = (rotor_config==rI) ? O : ((rotor_config==rII) ? V : ((rotor_config==rIII) ? O : 5'hx));
      Z: exit_contact = (rotor_config==rI) ? J : ((rotor_config==rII) ? S : ((rotor_config==rIII) ? M : 5'hx));
      default: exit_contact = 5'hx;
    endcase
  end
end



endmodule