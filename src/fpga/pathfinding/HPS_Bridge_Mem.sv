
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
	input logic reset,
	input logic get_goal_node,
	input logic [15:0] readdata,
	
	output logic [5:0] address,
	output logic [271:0] start_data,
	output logic [271:0] goal_data,
	
	output logic start_pulse
);
	
	localparam IDLE 							= 4'd0;
	localparam IDLE_START					= 4'd1;
	localparam WAIT_START					= 4'd2;
	localparam READ_START 					= 4'd3;
	localparam SET_READ_START_ADDRESS	= 4'd4;
	localparam IDLE_GOAL						= 4'd5;
	localparam WAIT_GOAL						= 4'd6;
	localparam READ_GOAL						= 4'd7;
	localparam SET_READ_GOAL_ADDRESS		= 4'd8;
	localparam FINISH							= 4'd9;
	
	logic [3:0] state;
	
	always_ff @(posedge clk)
	begin
		if (reset)
			state <= IDLE;
		else
			case (state)
			IDLE:
				if (get_goal_node)
					state <= IDLE_START;
			
			IDLE_START: state <= WAIT_START;
			WAIT_START: state <= READ_START;
			READ_START: 
				if (address < 6'd17)
					state <= SET_READ_START_ADDRESS;
				else
					state <= IDLE_GOAL;
			SET_READ_START_ADDRESS: state <= WAIT_START;
			
			IDLE_GOAL: state <= WAIT_GOAL;
			WAIT_GOAL: state <= READ_GOAL;
			READ_GOAL:
				if (address < 6'd34)
					state <= SET_READ_GOAL_ADDRESS;
				else
					state <= FINISH;
			SET_READ_GOAL_ADDRESS: state <= WAIT_GOAL;
			
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
				address <= 6'd0;
			end
			READ_START: begin
				if (address == 6'd0)
					start_data[271:256] <= readdata;
				else if (address == 6'd1)
					start_data[255:240] <= readdata;
				else if (address == 6'd2)
					start_data[239:224] <= readdata;
				else if (address == 6'd3)
					start_data[223:208] <= readdata;
				else if (address == 6'd4)
					start_data[207:192] <= readdata;
				else if (address == 6'd5)
					start_data[191:176] <= readdata;
				else if (address == 6'd6)
					start_data[175:160] <= readdata;
				else if (address == 6'd7)
					start_data[159:144] <= readdata;
				else if (address == 6'd8)
					start_data[143:128] <= readdata;
				else if (address == 6'd9)
					start_data[127:112] <= readdata;
				else if (address == 6'd10)
					start_data[111:96] <= readdata;
				else if (address == 6'd11)
					start_data[95:80] <= readdata;
				else if (address == 6'd12)
					start_data[79:64] <= readdata;
				else if (address == 6'd13)
					start_data[63:48] <= readdata;
				else if (address == 6'd14)
					start_data[47:32] <= readdata;
				else if (address == 6'd15)
					start_data[31:16] <= readdata;
				else if (address == 6'd16)
					start_data[15:0] <= readdata;
			end
			SET_READ_START_ADDRESS: begin
				address <= address + 1'd1;
			end
			
			
			IDLE_GOAL: begin
				address <= 6'd17;
			end
			READ_GOAL: begin
				if (address == 6'd17)
					goal_data[271:256] <= readdata;
				else if (address == 6'd18)
					goal_data[255:240] <= readdata;
				else if (address == 6'd19)
					goal_data[239:224] <= readdata;
				else if (address == 6'd20)
					goal_data[223:208] <= readdata;
				else if (address == 6'd21)
					goal_data[207:192] <= readdata;
				else if (address == 6'd22)
					goal_data[191:176] <= readdata;
				else if (address == 6'd23)
					goal_data[175:160] <= readdata;
				else if (address == 6'd24)
					goal_data[159:144] <= readdata;
				else if (address == 6'd25)
					goal_data[143:128] <= readdata;
				else if (address == 6'd26)
					goal_data[127:112] <= readdata;
				else if (address == 6'd27)
					goal_data[111:96] <= readdata;
				else if (address == 6'd28)
					goal_data[95:80] <= readdata;
				else if (address == 6'd29)
					goal_data[79:64] <= readdata;
				else if (address == 6'd30)
					goal_data[63:48] <= readdata;
				else if (address == 6'd31)
					goal_data[47:32] <= readdata;
				else if (address == 6'd32)
					goal_data[31:16] <= readdata;
				else if (address == 6'd33)
					goal_data[15:0] <= readdata;
			end
			SET_READ_GOAL_ADDRESS: begin
				address <= address + 1'd1;
			end
			
			FINISH: begin
				start_pulse <= 1'b1;
			end
		endcase
	end
endmodule
