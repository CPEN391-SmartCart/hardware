typedef struct packed {
	logic [9:0] x;
	logic [9:0] y;
} map_node;

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

module dijsktra_tb;

	logic clk;
	logic reset;
	logic start_pulse;
	node_info path [6];

	//node_info start = '{16'h0010, 16'h0010, 16'h0013, 16'h0001, 16'h0010, 16'h0023, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000};
	map_node goal = '{9'h82, 9'h43};
	
	Dijkstra dijkstra(
		.clk(clk), 
		.reset(reset), 
		.start_pulse(start_pulse), 
		.start_node_id(16'h0013), 
		.goal(goal),
		.path(path)
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

		start_pulse = 1;
		#20;
		start_pulse = 0;
	end
endmodule