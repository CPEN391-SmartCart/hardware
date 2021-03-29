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

// {10, 10, 32}

typedef struct packed {
	logic [15:0] x;
	logic [15:0] y;
	logic [15:0] node_id;
	logic [15:0] parent_id;
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
	logic [15:0] current_cost;
} node_info;

module Dijkstra
(
	input logic clk,
	input logic reset,
	input logic start_pulse,
	input map_node start,
	input map_node goal,
	
	output dijkstra_node path [100:0]
);

	localparam IDLE 						= 6'd0;
	localparam INIT 						= 6'd1;
	localparam LOOP						= 6'd2;
	localparam POP 						= 6'd3;
	localparam IS_GOAL					= 6'd4;
	localparam EXPLORE_NEIGHBOURS		= 6'd5;
	localparam EXPLORE_NEIGHBOUR_1	= 6'd6;
	localparam EXPLORE_NEIGHBOUR_2	= 6'd7;
	localparam EXPLORE_NEIGHBOUR_3	= 6'd8;
	localparam EXPLORE_NEIGHBOUR_4	= 6'd9;
	localparam GET_CHILD_1				= 6'd10;
	localparam GET_CHILD_2				= 6'd11;
	localparam GET_CHILD_3				= 6'd12;
	localparam GET_CHILD_4				= 6'd13;
	localparam INCREMENT_EXPLORE_INDEX = 6'd14;
	localparam INCREMENT_NODE_INDEX_1 	= 6'd15; 
	localparam INCREMENT_NODE_INDEX_2 	= 6'd16; 
	localparam INCREMENT_NODE_INDEX_3 	= 6'd17; 
	localparam INCREMENT_NODE_INDEX_4 	= 6'd18;
	localparam ADD_CHILD_1_TO_QUEUE		= 6'd19;
	localparam ADD_CHILD_2_TO_QUEUE		= 6'd20;
	localparam ADD_CHILD_3_TO_QUEUE		= 6'd21; 
	localparam ADD_CHILD_4_TO_QUEUE		= 6'd22;
	localparam REMOVE_NODE_1				= 6'd23;
	localparam SUCCESS					= 6'd30;
	localparam RECONSTRUCT_PATH 		= 6'd31;
	localparam FIND_NEXT_NODE			= 6'd32;
	localparam PATH_DONE					= 6'd33;

	logic [5:0] state;
	
	node_info nodes [100:0];
	
	logic [15:0] current_node_index;
	logic [15:0] current_child_index;
	
	node_info explored_nodes [100:0];
	logic [15:0] explored_node_index;
	logic explored_child;
	logic explored_current;
	logic child_queued;

	node_info current_node;
	node_info current_child;
	node_info minimum;
	
	node_info mem_node;
	
	Dijsktra_Mem mem(.node_id(current_node.node_id), .node(mem_node));
	
	integer j;
	
	always_ff @(posedge clk)
	begin
		if (reset) begin
			state <= IDLE;
			nodes[0] = '{16'h0010, 16'h0010, 16'h0013, 16'h0001, 16'h0010, 16'h0023, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000};
		end
		else begin
			case (state)
				IDLE:
					if (start_pulse)
						state <= INIT;
				INIT: state <= LOOP;
				LOOP: state <= POP;
				POP: state <= IS_GOAL;
				IS_GOAL:
					if (current_node.x == goal.x && current_node.y == goal.y)
						state <= SUCCESS;
					else
						state <= EXPLORE_NEIGHBOURS;
						
				EXPLORE_NEIGHBOURS: 
					if (!explored_current)
						state <= INCREMENT_EXPLORE_INDEX;
					else
						state <= GET_CHILD_1;
				INCREMENT_EXPLORE_INDEX: state <= GET_CHILD_1;
				
				GET_CHILD_1: state <= EXPLORE_NEIGHBOUR_1;
				EXPLORE_NEIGHBOUR_1: 
					if (!explored_child && !child_queued)
						state <= ADD_CHILD_1_TO_QUEUE;
					else
						state <= REMOVE_NODE_1;
						
				ADD_CHILD_1_TO_QUEUE: state <= INCREMENT_NODE_INDEX_1;
				INCREMENT_NODE_INDEX_1: state <= GET_CHILD_2;
				
				REMOVE_NODE_1: state <= GET_CHILD_2;
				GET_CHILD_2: state <= EXPLORE_NEIGHBOUR_2;
				EXPLORE_NEIGHBOUR_2: 
					if (!explored_child && !child_queued)
						state <= ADD_CHILD_2_TO_QUEUE;
					else
						state <= GET_CHILD_3;
						
				ADD_CHILD_2_TO_QUEUE: state <= INCREMENT_NODE_INDEX_2;
				INCREMENT_NODE_INDEX_2: state <= GET_CHILD_3;
				
				GET_CHILD_3: state <= EXPLORE_NEIGHBOUR_3;
				EXPLORE_NEIGHBOUR_3: 
					if (!explored_child && !child_queued)
						state <= ADD_CHILD_3_TO_QUEUE;
					else
						state <= GET_CHILD_4;
						
				ADD_CHILD_3_TO_QUEUE: state <= INCREMENT_NODE_INDEX_3;
				INCREMENT_NODE_INDEX_3: state <= GET_CHILD_4;
				
				GET_CHILD_4: state <= EXPLORE_NEIGHBOUR_4;
				EXPLORE_NEIGHBOUR_4: 
					if (!explored_child && !child_queued)
						state <= ADD_CHILD_4_TO_QUEUE;
					else
						state <= LOOP;
				
				ADD_CHILD_4_TO_QUEUE: state <= INCREMENT_NODE_INDEX_4;
				INCREMENT_NODE_INDEX_4: state <= LOOP;
				
				SUCCESS: state <= RECONSTRUCT_PATH;
				RECONSTRUCT_PATH: state <= FIND_NEXT_NODE;
				FIND_NEXT_NODE: state <= PATH_DONE;
				PATH_DONE: 
					if (current_node.x == start.x && current_node.y == start.y)
						state <= IDLE;
					else
						state <= RECONSTRUCT_PATH;
			endcase
		end
	end

	integer k;
	always_ff @(posedge clk)
	begin
		if (!reset) begin
			case (state)
				POP: begin
					current_node <= minimum;
				end
				EXPLORE_NEIGHBOURS: begin
					if (!explored_current) begin
						explored_nodes[explored_node_index] <= current_node;
					end
				end
				INCREMENT_EXPLORE_INDEX: begin
					explored_node_index <= explored_node_index + 1;
				end
				
				GET_CHILD_1: begin
					current_child <= '{current_node.x + 1'b1, current_node.y, explored_node_index - 1, current_node.currentCost};
				end
				EXPLORE_NEIGHBOUR_1: begin
					if (!explored_child) begin
						current_child.currentCost <= current_child.currentCost + 1'b1;
					end
				end
				ADD_CHILD_1_TO_QUEUE: begin
					if (!child_queued)
						nodes[current_node_index] <= current_child;
				end
				
				REMOVE_NODE_1: begin
					nodes[current_node_index] <= '{current_node.x, current_node.y, 999999, 32'd999};
				end
				GET_CHILD_2: begin
					current_child <= '{current_node.x - 1'b1, current_node.y, explored_node_index - 1, current_node.currentCost};
				end
				EXPLORE_NEIGHBOUR_2: begin
					if (!explored_child) begin
						current_child.currentCost <= current_child.currentCost + 1'b1;
					end
				end
				ADD_CHILD_2_TO_QUEUE: begin
					if (!child_queued)
						nodes[current_child_index] <= current_child;
				end
				INCREMENT_NODE_INDEX_2: begin
					current_child_index <= current_child_index + 1;
				end
				
				GET_CHILD_3: begin
					current_child <= '{current_node.x, current_node.y + 1'b1, explored_node_index - 1, current_node.currentCost};
				end
				EXPLORE_NEIGHBOUR_3: begin
					if (!explored_child) begin
						current_child.currentCost <= current_child.currentCost + 1'b1;
					end
				end
				ADD_CHILD_3_TO_QUEUE: begin
					if (!child_queued)
						nodes[current_child_index] <= current_child;
				end
				INCREMENT_NODE_INDEX_3: begin
					current_child_index <= current_child_index + 1;
				end
				
				GET_CHILD_4: begin
					current_child <= '{current_node.x, current_node.y - 1'b1, explored_node_index - 1, current_node.currentCost};
				end
				EXPLORE_NEIGHBOUR_4: begin
					if (!explored_child) begin
						current_child.currentCost <= current_child.currentCost + 1'b1;
					end
				end
				ADD_CHILD_4_TO_QUEUE: begin
					if (!child_queued)
						nodes[current_child_index] <= current_child;
				end
				INCREMENT_NODE_INDEX_4: begin
					current_child_index <= current_child_index + 1;
				end
				
				RECONSTRUCT_PATH: begin
					path[j] <= explored_nodes[current_node.parent_node_index];
				end
				FIND_NEXT_NODE: begin
					j <= j + 1;
					current_node <= explored_nodes[current_node.parent_node_index];
				end
			endcase
		end
	end
	
	integer i;
	always_comb
	begin
		minimum = nodes[0];
		current_node_index = 0;
		explored_child = 1'b0;
		explored_current = 1'b0;
		child_queued = 1'b0;
		for (i = 0; i < 100; i++)
		begin
			if (nodes[i].current_cost < minimum.current_cost) begin
				minimum = nodes[i];
				current_node_index = i;
			end
			if (explored_nodes[i].x == current_child.x && explored_nodes[i].y == current_child.y)
				explored_child = 1'b1;
			if (explored_nodes[i].x == current_node.x && explored_nodes[i].y == current_node.y)
				explored_current = 1'b1;
			if (nodes[i].x == current_child.x && nodes[i].y == current_child.y)
				child_queued = 1'b1;
		end
	end

endmodule
