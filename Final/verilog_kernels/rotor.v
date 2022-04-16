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
      A: exit_contact = (rotor_config==rI) ? E : ((rotor_config==rII) ? A : ((rotor_config==rIII) ? B : 'x));
      B: exit_contact = (rotor_config==rI) ? K : ((rotor_config==rII) ? J : ((rotor_config==rIII) ? D : 'x));
      C: exit_contact = (rotor_config==rI) ? M : ((rotor_config==rII) ? D : ((rotor_config==rIII) ? F : 'x));
      D: exit_contact = (rotor_config==rI) ? F : ((rotor_config==rII) ? K : ((rotor_config==rIII) ? H : 'x));
      E: exit_contact = (rotor_config==rI) ? L : ((rotor_config==rII) ? S : ((rotor_config==rIII) ? J : 'x));
      F: exit_contact = (rotor_config==rI) ? G : ((rotor_config==rII) ? I : ((rotor_config==rIII) ? L : 'x));
      G: exit_contact = (rotor_config==rI) ? D : ((rotor_config==rII) ? R : ((rotor_config==rIII) ? C : 'x));
      H: exit_contact = (rotor_config==rI) ? Q : ((rotor_config==rII) ? U : ((rotor_config==rIII) ? P : 'x));
      I: exit_contact = (rotor_config==rI) ? V : ((rotor_config==rII) ? X : ((rotor_config==rIII) ? R : 'x));
      J: exit_contact = (rotor_config==rI) ? Z : ((rotor_config==rII) ? B : ((rotor_config==rIII) ? T : 'x));
      K: exit_contact = (rotor_config==rI) ? N : ((rotor_config==rII) ? L : ((rotor_config==rIII) ? X : 'x));
      L: exit_contact = (rotor_config==rI) ? T : ((rotor_config==rII) ? H : ((rotor_config==rIII) ? V : 'x));
      M: exit_contact = (rotor_config==rI) ? O : ((rotor_config==rII) ? W : ((rotor_config==rIII) ? Z : 'x));
      N: exit_contact = (rotor_config==rI) ? W : ((rotor_config==rII) ? T : ((rotor_config==rIII) ? N : 'x));
      O: exit_contact = (rotor_config==rI) ? Y : ((rotor_config==rII) ? M : ((rotor_config==rIII) ? Y : 'x));
      P: exit_contact = (rotor_config==rI) ? H : ((rotor_config==rII) ? C : ((rotor_config==rIII) ? E : 'x));
      Q: exit_contact = (rotor_config==rI) ? X : ((rotor_config==rII) ? Q : ((rotor_config==rIII) ? I : 'x));
      R: exit_contact = (rotor_config==rI) ? U : ((rotor_config==rII) ? G : ((rotor_config==rIII) ? W : 'x));
      S: exit_contact = (rotor_config==rI) ? S : ((rotor_config==rII) ? Z : ((rotor_config==rIII) ? G : 'x));
      T: exit_contact = (rotor_config==rI) ? P : ((rotor_config==rII) ? N : ((rotor_config==rIII) ? A : 'x));
      U: exit_contact = (rotor_config==rI) ? A : ((rotor_config==rII) ? P : ((rotor_config==rIII) ? K : 'x));
      V: exit_contact = (rotor_config==rI) ? I : ((rotor_config==rII) ? Y : ((rotor_config==rIII) ? M : 'x));
      W: exit_contact = (rotor_config==rI) ? B : ((rotor_config==rII) ? F : ((rotor_config==rIII) ? U : 'x));
      X: exit_contact = (rotor_config==rI) ? R : ((rotor_config==rII) ? V : ((rotor_config==rIII) ? S : 'x));
      Y: exit_contact = (rotor_config==rI) ? C : ((rotor_config==rII) ? O : ((rotor_config==rIII) ? Q : 'x));
      Z: exit_contact = (rotor_config==rI) ? J : ((rotor_config==rII) ? E : ((rotor_config==rIII) ? O : 'x));
      default: exit_contact = 'x;
    endcase
  end else begin
    case (enter_contact)
      A: exit_contact = (rotor_config==rI) ? U : ((rotor_config==rII) ? A : ((rotor_config==rIII) ? T : 'x));
      B: exit_contact = (rotor_config==rI) ? W : ((rotor_config==rII) ? J : ((rotor_config==rIII) ? A : 'x));
      C: exit_contact = (rotor_config==rI) ? Y : ((rotor_config==rII) ? P : ((rotor_config==rIII) ? G : 'x));
      D: exit_contact = (rotor_config==rI) ? G : ((rotor_config==rII) ? C : ((rotor_config==rIII) ? B : 'x));
      E: exit_contact = (rotor_config==rI) ? A : ((rotor_config==rII) ? Z : ((rotor_config==rIII) ? P : 'x));
      F: exit_contact = (rotor_config==rI) ? D : ((rotor_config==rII) ? W : ((rotor_config==rIII) ? C : 'x));
      G: exit_contact = (rotor_config==rI) ? F : ((rotor_config==rII) ? R : ((rotor_config==rIII) ? S : 'x));
      H: exit_contact = (rotor_config==rI) ? P : ((rotor_config==rII) ? L : ((rotor_config==rIII) ? D : 'x));
      I: exit_contact = (rotor_config==rI) ? V : ((rotor_config==rII) ? F : ((rotor_config==rIII) ? Q : 'x));
      J: exit_contact = (rotor_config==rI) ? Z : ((rotor_config==rII) ? B : ((rotor_config==rIII) ? E : 'x));
      K: exit_contact = (rotor_config==rI) ? B : ((rotor_config==rII) ? D : ((rotor_config==rIII) ? U : 'x));
      L: exit_contact = (rotor_config==rI) ? E : ((rotor_config==rII) ? K : ((rotor_config==rIII) ? F : 'x));
      M: exit_contact = (rotor_config==rI) ? C : ((rotor_config==rII) ? O : ((rotor_config==rIII) ? V : 'x));
      N: exit_contact = (rotor_config==rI) ? K : ((rotor_config==rII) ? T : ((rotor_config==rIII) ? N : 'x));
      O: exit_contact = (rotor_config==rI) ? M : ((rotor_config==rII) ? Y : ((rotor_config==rIII) ? Z : 'x));
      P: exit_contact = (rotor_config==rI) ? T : ((rotor_config==rII) ? U : ((rotor_config==rIII) ? H : 'x));
      Q: exit_contact = (rotor_config==rI) ? H : ((rotor_config==rII) ? Q : ((rotor_config==rIII) ? Y : 'x));
      R: exit_contact = (rotor_config==rI) ? X : ((rotor_config==rII) ? G : ((rotor_config==rIII) ? I : 'x));
      S: exit_contact = (rotor_config==rI) ? S : ((rotor_config==rII) ? E : ((rotor_config==rIII) ? X : 'x));
      T: exit_contact = (rotor_config==rI) ? L : ((rotor_config==rII) ? N : ((rotor_config==rIII) ? J : 'x));
      U: exit_contact = (rotor_config==rI) ? R : ((rotor_config==rII) ? H : ((rotor_config==rIII) ? W : 'x));
      V: exit_contact = (rotor_config==rI) ? I : ((rotor_config==rII) ? X : ((rotor_config==rIII) ? L : 'x));
      W: exit_contact = (rotor_config==rI) ? N : ((rotor_config==rII) ? M : ((rotor_config==rIII) ? R : 'x));
      X: exit_contact = (rotor_config==rI) ? Q : ((rotor_config==rII) ? I : ((rotor_config==rIII) ? K : 'x));
      Y: exit_contact = (rotor_config==rI) ? O : ((rotor_config==rII) ? V : ((rotor_config==rIII) ? O : 'x));
      Z: exit_contact = (rotor_config==rI) ? J : ((rotor_config==rII) ? S : ((rotor_config==rIII) ? M : 'x));
      default: exit_contact = 'x;
    endcase
  end
end



endmodule