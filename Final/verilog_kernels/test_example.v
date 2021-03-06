// !! example1

  assign msg_input[4:0] = Y;
  assign msg_input[9:5] = S;
  assign msg_input[14:10] = R;
  assign msg_input[19:15] = A;
  assign msg_input[24:20] = O;
  assign msg_input[29:25] = V;
  assign msg_input[34:30] = N;
  assign msg_input[39:35] = E;
  assign msg_input[44:40] = T;
  assign msg_input[49:45] = C;
  assign msg_input[54:50] = K;
  assign msg_input[59:55] = L;

  assign msg_output[4:0] = S;
  assign msg_output[9:5] = R;
  assign msg_output[14:10] = A;
  assign msg_output[19:15] = O;
  assign msg_output[24:20] = V;
  assign msg_output[29:25] = N;
  assign msg_output[34:30] = E;
  assign msg_output[39:35] = T;
  assign msg_output[44:40] = C;
  assign msg_output[49:45] = K;
  assign msg_output[54:50] = L;
  assign msg_output[59:55] = B;

  assign msg_position[4:0] = 5'd16;
  assign msg_position[9:5] = 5'd18;
  assign msg_position[14:10] = 5'd12;
  assign msg_position[19:15] = 5'd10;
  assign msg_position[24:20] = 5'd1;
  assign msg_position[29:25] = 5'd3;
  assign msg_position[34:30] = 5'd4;
  assign msg_position[39:35] = 5'd14;
  assign msg_position[44:40] = 5'd8;
  assign msg_position[49:45] = 5'd19;
  assign msg_position[54:50] = 5'd6;
  assign msg_position[59:55] = 5'd5;

// !! example 2
  assign msg_input[4:0] = K;
  assign msg_input[9:5] = Y;
  assign msg_input[14:10] = L;
  assign msg_input[19:15] = E;
  assign msg_input[24:20] = J;
  assign msg_input[29:25] = V;
  assign msg_input[34:30] = I;
  assign msg_input[39:35] = T;
  assign msg_input[44:40] = F;
  assign msg_input[49:45] = X;
  assign msg_input[54:50] = S;
  assign msg_input[59:55] = Q;

  assign msg_output[4:0] = Y;
  assign msg_output[9:5] = L;
  assign msg_output[14:10] = E;
  assign msg_output[19:15] = J;
  assign msg_output[24:20] = V;
  assign msg_output[29:25] = I;
  assign msg_output[34:30] = T;
  assign msg_output[39:35] = F;
  assign msg_output[44:40] = X;
  assign msg_output[49:45] = S;
  assign msg_output[54:50] = Q;
  assign msg_output[59:55] = N;

  assign msg_position[4:0] = 5'd7;
  assign msg_position[9:5] = 5'd17;
  assign msg_position[14:10] = 5'd2;
  assign msg_position[19:15] = 5'd0;
  assign msg_position[24:20] = 5'd10;
  assign msg_position[29:25] = 5'd4;
  assign msg_position[34:30] = 5'd6;
  assign msg_position[39:35] = 5'd16;
  assign msg_position[44:40] = 5'd5;
  assign msg_position[49:45] = 5'd13;
  assign msg_position[54:50] = 5'd8;
  assign msg_position[59:55] = 5'd12;


// !! example 3
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

  // !! example 4 Plugboard: ACDEF | BNQPR  
  //Input: CORNELLITHACANEWYORKUSA Output: OVVKTAKPNTEBNJALSQVNIWC
  assign msg_input[4:0] = R;
  assign msg_input[9:5] = V;
  assign msg_input[14:10] = O;
  assign msg_input[19:15] = C;
  assign msg_input[24:20] = A;
  assign msg_input[29:25] = E;
  assign msg_input[34:30] = T;
  assign msg_input[39:35] = N;
  assign msg_input[44:40] = K;
  assign msg_input[49:45] = L;
  assign msg_input[54:50] = W;
  assign msg_input[59:55] = S;

  assign msg_output[4:0] = V;
  assign msg_output[9:5] = O;
  assign msg_output[14:10] = C;
  assign msg_output[19:15] = A;
  assign msg_output[24:20] = E;
  assign msg_output[29:25] = T;
  assign msg_output[34:30] = N;
  assign msg_output[39:35] = K;
  assign msg_output[44:40] = L;
  assign msg_output[49:45] = W;
  assign msg_output[54:50] = S;
  assign msg_output[59:55] = Y;

  assign msg_position[4:0] = 5'd2;
  assign msg_position[9:5] = 5'd1;
  assign msg_position[14:10] = 5'd0;
  assign msg_position[19:15] = 5'd22;
  assign msg_position[24:20] = 5'd10;
  assign msg_position[29:25] = 5'd4;
  assign msg_position[34:30] = 5'd8;
  assign msg_position[39:35] = 5'd3;
  assign msg_position[44:40] = 5'd6;
  assign msg_position[49:45] = 5'd15;
  assign msg_position[54:50] = 5'd21;
  assign msg_position[59:55] = 5'd16;

 // !! example 5 Plugboard: ACDEFGZ | BNQPRVY  
 //Input: CORNELLUNIVERSITYITHACANEWYORK Output: OGGKTAKFTBUUWXBEANXBVGCPTTLVVZ
  assign msg_input[4:0] = H;
  assign msg_input[9:5] = B;
  assign msg_input[14:10] = I;
  assign msg_input[19:15] = N;
  assign msg_input[24:20] = T;
  assign msg_input[29:25] = E;
  assign msg_input[34:30] = U;
  assign msg_input[39:35] = V;
  assign msg_input[44:40] = A;
  assign msg_input[49:45] = C;
  assign msg_input[54:50] = G;
  assign msg_input[59:55] = R;

  assign msg_output[4:0] = B;
  assign msg_output[9:5] = I;
  assign msg_output[14:10] = N;
  assign msg_output[19:15] = T;
  assign msg_output[24:20] = E;
  assign msg_output[29:25] = U;
  assign msg_output[34:30] = V;
  assign msg_output[39:35] = A;
  assign msg_output[44:40] = C;
  assign msg_output[49:45] = G;
  assign msg_output[54:50] = R;
  assign msg_output[59:55] = W;

  assign msg_position[4:0] = 5'd19;
  assign msg_position[9:5] = 5'd14;
  assign msg_position[14:10] = 5'd17;
  assign msg_position[19:15] = 5'd8;
  assign msg_position[24:20] = 5'd4;
  assign msg_position[29:25] = 5'd11;
  assign msg_position[34:30] = 5'd10;
  assign msg_position[39:35] = 5'd20;
  assign msg_position[44:40] = 5'd22;
  assign msg_position[49:45] = 5'd21;
  assign msg_position[54:50] = 5'd2;
  assign msg_position[59:55] = 5'd12; 

// !! example 6 Plugboard: ACDEFGZ | BNQPRVY 
  //Input: THISISANENCRYPTEDMESSAGE Output: GCVOGDMGIKFXEUPTPXPMPEJV
  assign msg_input[4:0] = R;
  assign msg_input[9:5] = X;
  assign msg_input[14:10] = M;
  assign msg_input[19:15] = S;
  assign msg_input[24:20] = D;
  assign msg_input[29:25] = P;
  assign msg_input[34:30] = E;
  assign msg_input[39:35] = V;
  assign msg_input[44:40] = I;
  assign msg_input[49:45] = E;
  assign msg_input[54:50] = T;
  assign msg_input[59:55] = G;

  assign msg_output[4:0] = X;
  assign msg_output[9:5] = M;
  assign msg_output[14:10] = S;
  assign msg_output[19:15] = D;
  assign msg_output[24:20] = P;
  assign msg_output[29:25] = E;
  assign msg_output[34:30] = V;
  assign msg_output[39:35] = I;
  assign msg_output[44:40] = E;
  assign msg_output[49:45] = T;
  assign msg_output[54:50] = G;
  assign msg_output[59:55] = J;

  assign msg_position[4:0] = 5'd11;
  assign msg_position[9:5] = 5'd17;
  assign msg_position[14:10] = 5'd19;
  assign msg_position[19:15] = 5'd5;
  assign msg_position[24:20] = 5'd16;
  assign msg_position[29:25] = 5'd18;
  assign msg_position[34:30] = 5'd23;
  assign msg_position[39:35] = 5'd2;
  assign msg_position[44:40] = 5'd8;
  assign msg_position[49:45] = 5'd15;
  assign msg_position[54:50] = 5'd0;
  assign msg_position[59:55] = 5'd22;

   // !! example 7 Plugboard: BRG | CEI
 //INPUT: CORNELLITHACANEWYORKUSA OUTPUT:EVLVLCKXBTOKEKXLSDPBGWT
  assign msg_input[4:0] = Y;
  assign msg_input[9:5] = S;
  assign msg_input[14:10] = W;
  assign msg_input[19:15] = L;
  assign msg_input[24:20] = E;
  assign msg_input[29:25] = C;
  assign msg_input[34:30] = K;
  assign msg_input[39:35] = N;
  assign msg_input[44:40] = V;
  assign msg_input[49:45] = O;
  assign msg_input[54:50] = A;
  assign msg_input[59:55] = T;

  assign msg_output[4:0] = S;
  assign msg_output[9:5] = W;
  assign msg_output[14:10] = L;
  assign msg_output[19:15] = E;
  assign msg_output[24:20] = C;
  assign msg_output[29:25] = K;
  assign msg_output[34:30] = N;
  assign msg_output[39:35] = V;
  assign msg_output[44:40] = O;
  assign msg_output[49:45] = A;
  assign msg_output[54:50] = T;
  assign msg_output[59:55] = B;

  assign msg_position[4:0] = 5'd16;
  assign msg_position[9:5] = 5'd21;
  assign msg_position[14:10] = 5'd15;
  assign msg_position[19:15] = 5'd4;
  assign msg_position[24:20] = 5'd0;
  assign msg_position[29:25] = 5'd11;
  assign msg_position[34:30] = 5'd13;
  assign msg_position[39:35] = 5'd3;
  assign msg_position[44:40] = 5'd1;
  assign msg_position[49:45] = 5'd10;
  assign msg_position[54:50] = 5'd22;
  assign msg_position[59:55] = 5'd8;

  // !! example 8 Plugboard: ACDEFGT | BNQPRVS
 //INPUT: THEYSAYECESCANDOEVERYTHING OUTPUT:RCCJELCDBQLBNJZHNGPWXWKQUK
assign msg_input[4:0] = V;
assign msg_input[9:5] = G;
assign msg_input[14:10] = K;
assign msg_input[19:15] = H;
assign msg_input[24:20] = C;
assign msg_input[29:25] = Y;
assign msg_input[34:30] = J;
assign msg_input[39:35] = N;
assign msg_input[44:40] = A;
assign msg_input[49:45] = L;
assign msg_input[54:50] = S;
assign msg_input[59:55] = E;

assign msg_output[4:0] = G;
assign msg_output[9:5] = K;
assign msg_output[14:10] = H;
assign msg_output[19:15] = C;
assign msg_output[24:20] = Y;
assign msg_output[29:25] = J;
assign msg_output[34:30] = N;
assign msg_output[39:35] = A;
assign msg_output[44:40] = L;
assign msg_output[49:45] = S;
assign msg_output[54:50] = E;
assign msg_output[59:55] = P;

assign msg_position[4:0] = 5'd17;
assign msg_position[9:5] = 5'd23;
assign msg_position[14:10] = 5'd22;
assign msg_position[19:15] = 5'd1;
assign msg_position[24:20] = 5'd6;
assign msg_position[29:25] = 5'd3;
assign msg_position[34:30] = 5'd13;
assign msg_position[39:35] = 5'd12;
assign msg_position[44:40] = 5'd5;
assign msg_position[49:45] = 5'd10;
assign msg_position[54:50] = 5'd4;
assign msg_position[59:55] = 5'd18;
