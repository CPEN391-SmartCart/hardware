
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
	
	input logic io_enable,
	input logic write_enable,
	input logic [15:0] address,
	input logic [15:0] readdata,
	
	output logic [271:0] start_data,
	output logic [271:0] goal_data,
	
	output logic finished
);
	
	enum logic [1:0] {
		IDLE,
		READING,
		FINISH
	} state;
	
	always_ff @(posedge clk)
	begin
		if (reset)
			state <= IDLE;
		else
			case (state)
			IDLE:
				if (get_goal_node)
					state <= READING;
					
			READING:
				if (address[15:1] == 15'b0000_0100_0100_001 || readdata == 15'hFFFF)
					state <= FINISH;
					
			FINISH: state <= IDLE;
		endcase
	end
	
	always_ff @(posedge clk)
	begin
		case (state)
			IDLE: begin
				finished <= 1'b0;
			end

			READING: begin
				if (!write_enable && !io_enable)
					if (address[15:1] == 15'b0000_0100_0000_000)
						start_data[271:256] <= readdata;
					else if (address[15:1] == 15'b0000_0100_0000_001)
						start_data[255:240] <= readdata;
					else if (address[15:1] == 15'b0000_0100_0000_010)
						start_data[239:224] <= readdata;
					else if (address[15:1] == 15'b0000_0100_0000_011)
						start_data[223:208] <= readdata;
					else if (address[15:1] == 15'b0000_0100_0000_100)
						start_data[207:192] <= readdata;
					else if (address[15:1] == 15'b0000_0100_0000_101)
						start_data[191:176] <= readdata;
					else if (address[15:1] == 15'b0000_0100_0000_110)
						start_data[175:160] <= readdata;
					else if (address[15:1] == 15'b0000_0100_0000_111)
						start_data[159:144] <= readdata;
					else if (address[15:1] == 15'b0000_0100_0001_000)
						start_data[143:128] <= readdata;
					else if (address[15:1] == 15'b0000_0100_0001_001)
						start_data[127:112] <= readdata;
					else if (address[15:1] == 15'b0000_0100_0001_010)
						start_data[111:96] <= readdata;
					else if (address[15:1] == 15'b0000_0100_0001_011)
						start_data[95:80] <= readdata;
					else if (address[15:1] == 15'b0000_0100_0001_100)
						start_data[79:64] <= readdata;
					else if (address[15:1] == 15'b0000_0100_0001_101)
						start_data[63:48] <= readdata;
					else if (address[15:1] == 15'b0000_0100_0001_110)
						start_data[47:32] <= readdata;
					else if (address[15:1] == 15'b0000_0100_0001_111)
						start_data[31:16] <= readdata;
					else if (address[15:1] == 15'b0000_0100_0010_000)
						start_data[15:0] <= readdata;
					else if (address[15:1] == 15'b0000_0100_0010_001)
						goal_data[271:256] <= readdata;
					else if (address[15:1] == 15'b0000_0100_0010_010)
						goal_data[255:240] <= readdata;
					else if (address[15:1] == 15'b0000_0100_0010_011)
						goal_data[239:224] <= readdata;
					else if (address[15:1] == 15'b0000_0100_0010_100)
						goal_data[223:208] <= readdata;
					else if (address[15:1] == 15'b0000_0100_0010_101)
						goal_data[207:192] <= readdata;
					else if (address[15:1] == 15'b0000_0100_0010_110)
						goal_data[191:176] <= readdata;
					else if (address[15:1] == 15'b0000_0100_0010_111)
						goal_data[175:160] <= readdata;
					else if (address[15:1] == 15'b0000_0100_0011_000)
						goal_data[159:144] <= readdata;
					else if (address[15:1] == 15'b0000_0100_0011_001)
						goal_data[143:128] <= readdata;
					else if (address[15:1] == 15'b0000_0100_0011_010)
						goal_data[127:112] <= readdata;
					else if (address[15:1] == 15'b0000_0100_0011_011)
						goal_data[111:96] <= readdata;
					else if (address[15:1] == 15'b0000_0100_0011_100)
						goal_data[95:80] <= readdata;
					else if (address[15:1] == 15'b0000_0100_0011_101)
						goal_data[79:64] <= readdata;
					else if (address[15:1] == 15'b0000_0100_0011_110)
						goal_data[63:48] <= readdata;
					else if (address[15:1] == 15'b0000_0100_0011_111)
						goal_data[47:32] <= readdata;
					else if (address[15:1] == 15'b0000_0100_0100_000)
						goal_data[31:16] <= readdata;
					else if (address[15:1] == 15'b0000_0100_0100_001)
						goal_data[15:0] <= readdata;
			end
			
			FINISH: begin
				finished <= 1'b1;
			end
		endcase
	end
endmodule
