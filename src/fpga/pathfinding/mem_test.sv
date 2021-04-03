typedef struct packed {
	logic [15:0] x;
	logic [15:0] y;
	logic [15:0] node_id;
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

module dijsktra_mem_tb;

	logic clk;
	logic reset;
	logic [15:0] node_id;
	node_info node;
	
	Dijkstra_Mem mem(.node_id(node_id), .node(node));
	
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
		
		#20;
		node_id = 16'd3;
		#20;
		node_id = 16'h0013;
	end
endmodule