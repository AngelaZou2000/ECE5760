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
  // reg and wire init
  reg signed [17:0] center_node_reg;
  reg [17:0] curr_write_data, prev_write_data;
  reg [8:0] curr_write_address, curr_read_address, prev_write_address, prev_read_address;
  reg curr_write_enable, prev_write_enable;
  wire [17:0] curr_read_data, prev_read_data;
  assign center_node = center_node_reg;
  
  // declare M10K memory block for current node
  M10K #(18) mem_curr_node (
    .clk(clk),
    .write_enable(curr_write_enable),
    .write_address(curr_write_address),
    .read_address(curr_read_address),
    .d(curr_write_data),
    .q(curr_read_data)
  );
  // declare M10K memory block for previous node
  M10K #(18) mem_prev_node (
    .clk(clk),
    .write_enable(prev_write_enable),
    .write_address(prev_write_address),
    .read_address(prev_read_address),
    .d(prev_write_data),
    .q(prev_read_data)
  );
  
  // registers used in state machine
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
    end else begin
      state_reg <= state_next;
    end
  end

  // --------------- state transition -------------------
  always@(*) begin
    case (state_reg)
      INIT: state_next = INIT_LOAD;
      INIT_LOAD: begin
        if (counter==(column_size-1)) state_next = BASE_LOAD_1; // move to next state if reached top node
        else state_next = INIT_LOAD;
      end
      BASE_LOAD_1: state_next = BASE_LOAD_2;
      BASE_LOAD_2: state_next = CALC;
      CALC: state_next = UPDATE;
      UPDATE: begin
        if (counter != (column_size-1)) state_next = CALC; // keep calculating next node
        else state_next = ITERATION_DONE; // move to ITERATION DONE state if reached top node
      end
      ITERATION_DONE: begin
        if (iteration_enable) state_next = CALC;// move to CALC if received enable from HPS
        else state_next = ITERATION_DONE;
      end
      default: state_next = state_reg;
    endcase
  end

  // ---------------- state output ----------------------
  reg [17:0] curr_node, prev_node, top_node, bottom_node;
  wire [17:0] next_node;
  reg signed [17:0] init_node_value, init_node_value_term1;

  assign curr_node_out = curr_node;

  always @ (posedge clk) begin
    if (reset) begin
      counter <= 0; // reset initalization counter
      center_node_reg <= init_center_node; // output center node value
    end else begin
      case (state_reg)
      INIT: begin
        counter <= 0;
        cycle_time <= 0;
        init_node_value <= init_node;
        init_node_value_term1 <= init_node;
      end
      INIT_LOAD: begin
        // keep incresing intialization counter
        counter <= counter + 1'b1;
        // increase init value if at the first half, decrease at the second half
        init_node_value_term1 = (counter < (column_size>>1))? init_node_value_term1 + incr_value : init_node_value_term1 - incr_value;
        // cutoff if init value is higher than the center node value
        init_node_value = (init_node_value_term1 < init_center_node) ? init_node_value_term1 : init_center_node;
      end
      BASE_LOAD_2: begin
        counter <= 0;
        // write the current M10K array output to curr_node
        curr_node <= curr_read_data;
      end
      CALC: begin
        cycle_time <= cycle_time + 1;
        // write the current M10K array output to top_node
        top_node <= curr_read_data;
        // write the previous M10K array output to prev_node
        prev_node <= prev_read_data;
        // if the center node gets updated, modify the column module output
        center_node_reg <= (counter == (column_size>>1)) ? next_node : center_node_reg;
      end
      UPDATE: begin
        cycle_time <= cycle_time + 1;
        // next cycle, top_node becomes curr_node 
        curr_node <= top_node;
        // next cycle, curr_node becomes bottom_node 
        bottom_node <= curr_node;
        // write the current M10K array output to top_node
        top_node <= curr_read_data;
        // write the previous M10K array output to prev_node
        prev_node <= prev_read_data;
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
  end

  always@(*) begin
    case(state_reg)
      INIT_LOAD: begin
        // each cycle write the initialization value calculated in the curr and prev M10K array
        curr_write_enable = 1'b1;
        curr_write_data = init_node_value;
        curr_write_address = counter;
        prev_write_enable = 1'b1;
        prev_write_data = init_node_value;
        prev_write_address = counter;
        // latch prevention
        curr_read_address = curr_read_address;
        prev_read_address = prev_read_address;
      end
      BASE_LOAD_1: begin
        // read the node 0 current value
        curr_read_address = 18'd0;
        // disable write enable signals
        curr_write_enable = 1'b0;
        prev_write_enable = 1'b0;
        // latch prevention
        prev_read_address = prev_read_address;
        curr_write_data = curr_write_data;
        prev_write_data = prev_write_data;
        curr_write_address = curr_write_address;
        prev_write_address = prev_write_address;
      end
      BASE_LOAD_2: begin
        // read node 1 current value
        curr_read_address = 18'd1;
        // read node 0 previous value
        prev_read_address = 18'd0;
        // latch prevention
        curr_write_enable = 1'b0;
        prev_write_enable = 1'b0;
        curr_write_data = curr_write_data;
        prev_write_data = prev_write_data;
        curr_write_address = curr_write_address;
        prev_write_address = prev_write_address;
      end
      CALC: begin 
        // latch prevention
        curr_write_enable = 1'b0;
        prev_write_enable = 1'b0;
        curr_write_data = curr_write_data;
        prev_write_data = prev_write_data;
        curr_write_address = curr_write_address;
        prev_write_address = prev_write_address;
        curr_read_address = curr_read_address;
        prev_read_address = prev_read_address;
      end
      UPDATE: begin
        // enable write signals
        curr_write_enable = 1'b1;
        prev_write_enable = 1'b1;
        // write the calculated value into current node
        curr_write_address = counter;
        curr_write_data = next_node;
        // write the original current value into previous node
        prev_write_address = counter;
        prev_write_data = curr_node;
        // read the top node value for next iteration -- if reach the bottom node
        // read the node 0 / node 1 value from the current array
        curr_read_address = (counter==(column_size-2)) ? 0 :
                             ((counter==(column_size-1)) ? 1 : counter + 2);
        // read the previous node value for next iteration -- if reach the bottom node
        // read the node 0 value from the previous array
        prev_read_address = (counter==(column_size-1)) ? 0 : counter + 1;
      end
      default: begin
        // latch prevention
        curr_write_enable = 1'b0;
        prev_write_enable = 1'b0;
        curr_write_data = curr_write_data;
        prev_write_data = prev_write_data;
        curr_write_address = curr_write_address;
        prev_write_address = prev_write_address;
        curr_read_address = curr_read_address;
        prev_read_address = prev_read_address;
      end
    endcase
  end

  // single node calculation module
  node_compute #(eta_width) compute_inst 
  (
    .curr_node(curr_node),
    .left_node(left_node_in),
    .right_node(right_node_in),
    .top_node((counter==(column_size-1))?18'd0:top_node),
    .bottom_node((counter==0)?18'd0:bottom_node),
    .prev_node(prev_node),
    .rho(init_rho),
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
  // declare wire for intermediate terms 
  wire signed [17:0] node_sum, current_term, undamped_sum, damped_prev_node;
  // summation of current node, left node, right node, top node, and bottom node
  assign node_sum = left_node+right_node+top_node+bottom_node-(curr_node<<2);
  // nonlinear rho effect
  signed_mult inst1 (
    .out(current_term),
    .a(node_sum),
    .b(rho)
  );
  // damp the previous node
  assign damped_prev_node = prev_node - (prev_node>>>eta_width); 
  assign undamped_sum = current_term + (curr_node<<1) - damped_prev_node;
  assign next_node = undamped_sum - (undamped_sum>>>eta_width);
endmodule

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
    q <= mem[read_address][data_width-1:0];
  end
endmodule
