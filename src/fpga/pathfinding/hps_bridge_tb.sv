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

module hps_mem_tb;

	logic clk;
	logic reset;
	logic get_goal_node;
	logic [15:0] readdata;
	
	logic [5:0] address;
	logic [271:0] start_data;
	logic [271:0] goal_data;
	
	logic start_pulse;

	HPS_Bridge_Mem_FSM DUT(
		.clk(clk),
		.reset(reset),
		.get_goal_node(get_goal_node),
		.readdata(readdata),
		.address(address),
		.start_data(start_data),
		.goal_data(goal_data),
		.start_pulse(start_pulse)
	);
	
	int i;
	
	initial
	begin
		reset = 1;
		clk = 0;
	
		forever
		begin
			#10 clk =~clk;
		end
		
		#800 $finish;
	end
	// Sending the test data inputs.
	initial
	begin
		#20;
		reset = 0;
		#10;

		get_goal_node = 1;
		#20;
		get_goal_node = 0;
	end
endmodule