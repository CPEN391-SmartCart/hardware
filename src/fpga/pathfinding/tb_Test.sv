typedef struct packed {
	logic [9:0] x;
	logic [9:0] y;
} map_node;

typedef struct packed {
	logic [9:0] x;
	logic [9:0] y;
	integer parent_node_index;
	logic [31:0] currentCost;
} dijkstra_node;


module dijsktra_tb;

	logic clk;
	logic reset;
	logic start_pulse;
	dijkstra_node path [1499:0];

	map_node start = '{9'd20, 9'd20};
	map_node goal = '{9'd40, 9'd30};
	
	Dijkstra dijkstra(.clk(clk), .reset(reset), .start_pulse(start_pulse), .start(start), .goal(goal), .path(path));
	
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
		
		#100;
		start_pulse = 1;
		#20;
		start_pulse = 0;
	end
endmodule