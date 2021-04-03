typedef struct packed {
	logic [15:0] x;
	logic [15:0] y;
} coord;

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


module dijsktra_real_tb;

	logic clk;
	logic reset;
	logic start_pulse;
	coord path [100];
	logic [15:0] index;
	logic success;
	
	//node_info start = '{16'h0010, 16'h0010,16'h0013,16'h0000,16'h0000,16'h0016,16'h0004,16'h0017,16'h0002,16'h0000,16'h0000,16'h0000,16'h0000,16'h0000,16'h0000,16'h0000,16'h0000};
	//node_info goal = '{16'h0082, 16'h0043,16'h0045,16'h0000,16'h0000,16'h0000,16'h0000,16'h0000,16'h0000,16'h0000,16'h0000,16'h0000,16'h0000,16'h0000,16'h0000,16'h0000,16'h0000};
	
	node_info start = '{16'h0015,
			16'h0012,
			16'h003a,
			16'h0000,
			16'h0000,
			16'h0039,
			16'h001f,
			16'h0001,
			16'h0057,
			16'h0000,
			16'h0000,
			16'h0000,
			16'h0000,
			16'h0000,
			16'h0000,
			16'h0000,
			16'h0000};

	node_info goal = '{16'h0225,
			16'h01bd,
			16'h0051,
			16'h0000,
			16'h0000,
			16'h0049,
			16'h005f,
			16'h0050,
			16'h0028,
			16'h0000,
			16'h0000,
			16'h0000,
			16'h0000,
			16'h0000,
			16'h0000,
			16'h0000,
			16'h0000};

	// node_info goal = '{16'h0088,
	// 		16'h00E6,
	// 		16'h0008,
	// 		16'h0000,
	// 		16'h0000,
	// 		16'h0009,
	// 		16'h0027,
	// 		16'h0007,
	// 		16'h001C,
	// 		16'h0014,
	// 		16'h0061,
	// 		16'h0000,
	// 		16'h0000,
	// 		16'h0000,
	// 		16'h0000,
	// 		16'h0000,
	// 		16'h0000};
	
	Dijkstra dijkstra(
		.clk(clk), 
		.reset(reset), 
		.start(start_pulse), 
		.start_node(start), 
		.goal_node(goal),
		.path(path),
		.i(index),
		.success(success)
	);
	
	initial
	begin
		reset = 1;
		clk = 0;
	
		forever
		begin
			#10 clk =~clk;
		end
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