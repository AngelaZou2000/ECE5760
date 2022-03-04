module one_column
#(parameter eta_width=9, parameter g_tension_width=5)
(
  input clk,
  input reset,
  input [9:0] column_size,
  input signed [17:0] init_node,
  input signed [17:0] incr_value,
  input signed [17:0] init_center_node,
  input signed [17:0] init_rho,
  input signed [17:0] left_node_in,
  input signed [17:0] right_node_in,
  input iteration_enable,
  output signed [17:0] center_node,
  output signed [17:0] curr_node_out,
  output reg [12:0] cycle_time
);

  reg signed [17:0] center_node_reg;
  reg [17:0] curr_write_data, prev_write_data;
  reg [8:0] curr_write_address, curr_read_address, prev_write_address, prev_read_address;
  reg curr_write_enable, prev_write_enable;
  wire [17:0] curr_read_data, prev_read_data;
  assign center_node = center_node_reg;
  // reg [12:0] cycle_time;

  M10K #(18) mem_curr_node (
    .clk(clk),
    .write_enable(curr_write_enable),
    .write_address(curr_write_address),
    .read_address(curr_read_address),
    .d(curr_write_data),
    .q(curr_read_data)
  );

  M10K #(18) mem_prev_node (
    .clk(clk),
    .write_enable(prev_write_enable),
    .write_address(prev_write_address),
    .read_address(prev_read_address),
    .d(prev_write_data),
    .q(prev_read_data)
  );

  reg [3:0] state_reg, state_next;
  reg [9:0] counter;

  // state parameters
  localparam INIT = 4'd0;
  localparam INIT_LOAD = 4'd1;
  localparam BASE_LOAD_1 = 4'd2;
  localparam BASE_LOAD_2 = 4'd3;
	localparam BASE_WAIT = 4'd7;
  localparam CALC = 4'd4;
  localparam UPDATE = 4'd5;
	localparam WAIT = 4'd8;
  localparam ITERATION_DONE = 4'd6;

  // ------------- next state update -------------------
  always@(posedge clk) begin
    if (reset) begin
      state_reg <= INIT;
      counter <= 0;
      center_node_reg <= init_center_node;
    end else begin
      state_reg <= state_next;
    end
  end

  // --------------- state transition -------------------
  always@(*) begin
    case (state_reg)
      INIT: state_next = INIT_LOAD;
      INIT_LOAD: if (counter==(column_size-1)) state_next = BASE_LOAD_1;
      BASE_LOAD_1: state_next = BASE_LOAD_2;
      BASE_LOAD_2: state_next = BASE_WAIT;
			BASE_WAIT: state_next = CALC;
      CALC: state_next = UPDATE;
      UPDATE: begin
        if (counter != (column_size-1)) state_next = WAIT;
        else state_next = ITERATION_DONE;
      end
			WAIT: state_next = CALC;
      ITERATION_DONE: if (iteration_enable) state_next = CALC;
    endcase
  end

  // ---------------- state output ----------------------
  reg [17:0] curr_node, prev_node, top_node, bottom_node;
  wire [17:0] next_node;
  reg signed [17:0] init_node_value, init_node_value_term1;

  assign curr_node_out = curr_node;

  always @ (posedge clk) begin
    case (state_reg)
    INIT: begin
      counter <= 0;
      cycle_time <= 0;
      init_node_value <= init_node;
      init_node_value_term1 <= init_node;
    end
    INIT_LOAD: begin
      counter <= counter + 1'b1;
      init_node_value_term1 = (counter < (column_size>>1))? init_node_value_term1 + incr_value : init_node_value_term1 - incr_value;
      init_node_value = (init_node_value_term1 < init_center_node) ? init_node_value_term1 : init_center_node;
    end
    BASE_LOAD_2: begin
      counter <= 0;
      curr_node <= curr_read_data;
    end
		BASE_WAIT: begin
      curr_node <= curr_read_data;
		end
    CALC: begin
      cycle_time <= cycle_time + 1;
      top_node <= curr_read_data;
      prev_node <= prev_read_data;
      center_node_reg <= (counter == (column_size>>1)) ? next_node : center_node_reg;
    end
    UPDATE: begin
      cycle_time <= cycle_time + 1;
      curr_node <= top_node;
      bottom_node <= curr_node;
      // top_node <= curr_read_data;
      // prev_node <= prev_read_data;
      // counter <= (counter==(column_size-1)) ? 0 : counter + 1;
      counter <= counter + 1;
    end
    ITERATION_DONE: begin
      if (iteration_enable) begin
        counter <= 0;
        cycle_time <= 0;
      end
    end
    endcase
  end

  always@(*) begin
    case(state_reg)
      INIT_LOAD: begin
        curr_write_enable = 1'b1;
        curr_write_data = init_node_value; //(counter == (column_size>>1)) ? init_center_node : init_node;
        curr_write_address = counter;
        prev_write_enable = 1'b1;
        prev_write_data = init_node_value; //(counter == (column_size>>1)) ? init_center_node : init_node;
        prev_write_address = counter;
      end
      BASE_LOAD_1: begin
        curr_read_address = 18'd0;
        curr_write_enable = 1'b0;
        prev_write_enable = 1'b0;
      end
      BASE_LOAD_2: begin
        // curr_node <= curr_read_data;
        curr_read_address = 18'd1;
        prev_read_address = 18'd0;
      end
      CALC: begin 
        // TODO: disable M10K write?
        // top_node <= curr_read_data;
        // prev_node <= prev_read_data;
        // TODO: center node update
        // if (counter == (column_size>>1)) center_node <= next_node;
      end
      UPDATE: begin
        curr_write_enable = 1'b1;
        prev_write_enable = 1'b1;
        curr_write_address = counter;
        curr_write_data = next_node;
        prev_write_address = counter;
        prev_write_data = curr_node;
        curr_read_address = (counter==(column_size-2)) ? 0 :
                             ((counter==(column_size-1)) ? 1 : counter + 2);
        prev_read_address = (counter==(column_size-1)) ? 0 : counter + 1;
        // curr_node <= top_node;
        // bottom_node <= curr_node;
        // TODO: wrap around and overflow handling
        // counter <= (counter==(column_size-1)) ? 0 : counter + 1;
      end
    endcase
  end

  // TODO: edge handling
  // wire signed [17:0] rho;
  node_compute #(eta_width) compute_inst 
  (
    .curr_node(curr_node),
    .left_node(left_node_in),
    .right_node(right_node_in),
    .top_node((counter==(column_size-1))?18'd0:top_node),
    .bottom_node((counter==0)?18'd0:bottom_node),
    .prev_node(prev_node),
    .rho(init_rho), //rho),
    .next_node(next_node)
  );

endmodule

module node_compute 
#(parameter eta_width)
(
  input signed [17:0] curr_node,
  input signed [17:0] left_node,
  input signed [17:0] right_node,
  input signed [17:0] top_node,
  input signed [17:0] bottom_node,
  input signed [17:0] prev_node,
  input signed [17:0] rho,
  output signed [17:0] next_node
);
  wire signed [17:0] node_sum, current_term, undamped_sum, damped_prev_node;
  assign node_sum = left_node+right_node+top_node+bottom_node-(curr_node<<2);
  signed_mult inst1 (
    .out(current_term),
    .a(node_sum),
    .b(rho)
  );
  assign damped_prev_node = prev_node - (prev_node>>>eta_width); 
  assign undamped_sum = current_term + (curr_node<<1) - damped_prev_node;
  assign next_node = undamped_sum - (undamped_sum>>>eta_width);
endmodule

// module rho_update
// #(parameter g_tension_width)
// (
//   input signed [17:0] init_rho,
//   input signed [17:0] center_node,
//   output signed [17:0] rho_value
// );
//   wire signed [17:0] rho_term1, rho_term2;
//   assign rho_term1 = center_node >>> g_tension_width;
//   signed_mult inst2 (
//     .out(rho_term2),
//     .a(rho_term1),
//     .b(rho_term1)
//   );
//   assign rho_value = (18'h0FAE1 < (init_rho + rho_term2)) ? 18'h0FAE1 : (init_rho + rho_term2);
// endmodule

module signed_mult (out, a, b);
  output  signed  [17:0]  out;
  input   signed  [17:0]  a;
  input   signed  [17:0]  b;
  // intermediate full bit length
  wire  signed  [35:0]  mult_out;
  assign mult_out = a * b;
  // select bits for 7.20 fixed point
  assign out = {mult_out[35], mult_out[33:17]};
endmodule

module M10K #(parameter data_width) (
  input clk,
  input write_enable,
  input [8:0] write_address,
  input [8:0] read_address,
  input [data_width-1:0] d,
  output reg [data_width-1:0] q
);
  reg [19:0] mem [511:0];
  reg [data_width-1:0] buffer;
  always @ (posedge clk) begin
    if (write_enable) begin
      mem[write_address] <= d;
    end
    buffer <= mem[read_address][data_width-1:0];
		q <= buffer;
  end
endmodule
