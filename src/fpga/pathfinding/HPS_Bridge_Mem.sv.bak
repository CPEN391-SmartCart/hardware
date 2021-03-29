
typedef struct packed {
	logic [15:0] x;
	logic [15:0] y;
	logic [15:0] node_id;
	logic [15:0] parent_node_id;
	logic [15:0] current_cost;
	logic [15:0] child_one_id;
	logic [15:0] distance_child_one;
	logic [15:0] child_two_id;
	logic [15:0] distance_child_two;
	logic [15:0] child_three_id;
	logic [15:0] distance_child_three;
	logic [15:0] child_four_id;
	logic [15:0] distance_child_four;
	logic [15:0] child_five_id;
	logic [15:0] distance_child_five;
	logic [15:0] child_six_id;
	logic [15:0] distance_child_six;
} node_info;

module HPS_Bridge_Mem_FSM
(
	input logic clk,
	input logic get_goal_node,
	input logic [511:0] readdata,
	
	output logic [3:0] address,
	output logic [511:0] start_data,
	output logic [511:0] goal_data,
	
	output logic start_pulse
);
	
	localparam IDLE 				= 3'b000;
	localparam IDLE_START		= 3'b001;
	localparam WAIT_START		= 3'b010;
	localparam READ_START 		= 3'b011;
	localparam IDLE_GOAL			= 3'b100;
	localparam WAIT_GOAL			= 3'b101;
	localparam READ_GOAL			= 3'b110;
	localparam FINISH				= 3'b111;

	logic [2:0] state;
	
	always_ff @(posedge clk)
	begin
		case (state)
			IDLE:
				if (get_goal_node)
					state <= IDLE_START;
			
			IDLE_START: state <= WAIT_START;
			WAIT_START: state <= READ_START;
			READ_START: state <= IDLE_GOAL;
			
			IDLE_GOAL: state <= WAIT_GOAL;
			WAIT_GOAL: state <= READ_GOAL;
			READ_GOAL: state <= FINISH;
			
			FINISH: state <= IDLE;
		endcase
	end
	
	always_ff @(posedge clk)
	begin
		case (state)
			IDLE: begin
				start_pulse <= 1'b0;
			end
		
			IDLE_START: begin
				address <= 4'b0000;
			end
			READ_START: begin
				start_data <= readdata; 
			end
			
			IDLE_GOAL: begin
				address <= 4'b0001;
			end
			READ_GOAL: begin
				goal_data <= readdata;
			end
			
			FINISH: begin
				start_pulse <= 1'b1;
			end
		endcase
	end
endmodule
