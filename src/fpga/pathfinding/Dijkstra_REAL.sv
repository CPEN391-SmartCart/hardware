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

module Dijkstra
#(
	parameter MAX_NODES = 200
)
(
	input logic clk,
	input logic reset,
	input logic start_pulse,
	input logic [15:0] start_node_id,
	input map_node goal,
	output node_info path [6],
	output integer j
);

	localparam IDLE 								= 8'd0;
	localparam START								= 8'd1;
	localparam LOW_FIND							= 8'd2;
	localparam INIT_QUEUE						= 8'd3;
	localparam LOOP								= 8'd4;
	localparam POP 								= 8'd5;
	localparam IS_GOAL							= 8'd6;
	localparam EXPLORE							= 8'd7;
	localparam INCREMENT_EXPLORE_INDEX		= 8'd8;
	localparam GET_CHILD_1						= 8'd9;
	localparam INCREMENT_CHILD_1_COST		= 8'd10;
	localparam INCREMENT_CHILD_2_COST		= 8'd11;
	localparam INCREMENT_CHILD_3_COST		= 8'd12;
	localparam INCREMENT_CHILD_4_COST		= 8'd13;
	localparam ADD_CHILD_1_TO_QUEUE			= 8'd14;
	localparam REMOVE_NODE_1					= 8'd15;
	localparam GET_CHILD_2						= 8'd16;
	localparam GET_CHILD_3						= 8'd17;
	localparam GET_CHILD_4						= 8'd18;
	localparam EXPLORE_CHILD_2					= 8'd19;
	localparam EXPLORE_CHILD_3					= 8'd20;
	localparam EXPLORE_CHILD_4					= 8'd21;
	localparam INCREMENT_CHILD_INDEX_1		= 8'd22;
	localparam INCREMENT_CHILD_INDEX_2		= 8'd23;
	localparam INCREMENT_CHILD_INDEX_3		= 8'd24;
	localparam INCREMENT_CHILD_INDEX_4		= 8'd25;
	localparam ADD_CHILD_2_TO_QUEUE			= 8'd26;
	localparam ADD_CHILD_3_TO_QUEUE			= 8'd27;
	localparam ADD_CHILD_4_TO_QUEUE			= 8'd28;
	localparam WAIT_1								= 8'd29;
	localparam WAIT_2								= 8'd30;
	localparam WAIT_3								= 8'd31;
	localparam EXPLORE_CHILD_1					= 8'd32;
	localparam GET_CHILD_1_FROM_QUEUE		= 8'd38;
	localparam IS_SHORTER_1						= 8'd39;
	localparam GET_CHILD_2_FROM_QUEUE		= 8'd40;
	localparam IS_SHORTER_2						= 8'd41;
	localparam GET_CHILD_3_FROM_QUEUE		= 8'd42;
	localparam IS_SHORTER_3						= 8'd43;
	localparam GET_CHILD_4_FROM_QUEUE		= 8'd44;
	localparam IS_SHORTER_4						= 8'd45;
	localparam REMOVE_CHILD_1					= 8'd46;
	localparam REMOVE_CHILD_2					= 8'd47;
	localparam REMOVE_CHILD_3					= 8'd48;
	localparam REMOVE_CHILD_4					= 8'd49;
	localparam SUCCESS							= 8'd60;
	localparam RECONSTRUCT_PATH 				= 6'd61;
	localparam GET_PARENT						= 6'd62;
	localparam PATH_DONE							= 6'd63;

	logic [7:0] state;
	
	logic [15:0] current_node_id;
	
	node_info current_node;
	node_info current_node_mem;
	node_info current_minimum_node;
	node_info current_child;
	node_info child_from_queue;
	node_info parent_node;
	
	logic find_node;
	logic found;
	
	node_info child_one_node;
	node_info child_two_node;
	node_info child_three_node;
	node_info child_four_node;
	node_info child_five_node;
	node_info child_six_node;
	Dijkstra_Mem #(.MAX_NODES(MAX_NODES)) mem(
		.clk(clk),
		.reset(reset),
		.node_id(current_node_id),
		.find_node(find_node),
		.found(found),
		.node(current_node_mem), 
		.child_one(child_one_node), 
		.child_two(child_two_node), 
		.child_three(child_three_node),
		.child_four(child_four_node),
		.child_five(child_five_node),
		.child_six(child_six_node)
		);
	
	logic explored_child;
	logic child_queued;
	
	logic [15:0] child_queued_index;
	logic [15:0] child_index;
	logic [15:0] minimum_index;
	node_info queue[MAX_NODES];
	
	logic [15:0] explored_node_index;
	node_info explored_nodes[MAX_NODES];
	
	Node_Comparator #(.MAX_NODES(MAX_NODES)) comparator(
		.queue(queue), 
		.explored_nodes(explored_nodes), 
		.current_child(current_child),
		.parent_node_id(current_node.parent_node_id),
		.explored_child(explored_child), 
		.child_queued(child_queued), 
		.child_queued_index(child_queued_index),
		.index(minimum_index), 
		.minimum_node(current_minimum_node), 
		.child_queued_node(child_from_queue),
		.parent_node(parent_node)
	);
	
	always_ff @(posedge clk)
	begin
		if (reset) begin
			state <= IDLE;
		end
		else begin
			case (state)
				IDLE:
					if (start_pulse)
						state <= START;
				START: state <= LOW_FIND;
				LOW_FIND: 
					if (found)
						state <= INIT_QUEUE;
				INIT_QUEUE: state <= LOOP;
				LOOP: state <= POP;
				POP: state <= WAIT_1;
				WAIT_1: state <= WAIT_2;
				WAIT_2: state <= WAIT_3;
				WAIT_3: state <= IS_GOAL;
				IS_GOAL:
					if (current_node.x == goal.x && current_node.y == goal.y)
						state <= SUCCESS;
					else
						state <= EXPLORE;
				EXPLORE: state <= INCREMENT_EXPLORE_INDEX;
				INCREMENT_EXPLORE_INDEX: state <= GET_CHILD_1;
				GET_CHILD_1: state <= EXPLORE_CHILD_1;
				EXPLORE_CHILD_1:
					if (!explored_child && !child_queued && current_child.node_id != 16'd800)
						state <= INCREMENT_CHILD_1_COST;
					else if (child_queued)
						state <= GET_CHILD_1_FROM_QUEUE;
					else
						state <= REMOVE_NODE_1;
				REMOVE_NODE_1: state <= GET_CHILD_2;

				GET_CHILD_1_FROM_QUEUE: state <= IS_SHORTER_1;
				IS_SHORTER_1:
					if (current_child.current_cost > (current_node.current_cost + current_node.distance_child_one))
						state <= REMOVE_CHILD_1;
					else
						state <= GET_CHILD_2;
				
				REMOVE_CHILD_1: state <= INCREMENT_CHILD_1_COST;
				INCREMENT_CHILD_1_COST: state <= ADD_CHILD_1_TO_QUEUE;
				ADD_CHILD_1_TO_QUEUE: state <= INCREMENT_CHILD_INDEX_1;
				INCREMENT_CHILD_INDEX_1: state <= GET_CHILD_2;
				
				GET_CHILD_2: state <= EXPLORE_CHILD_2;
				EXPLORE_CHILD_2:
					if (!explored_child && !child_queued && current_child.node_id != 16'd800)
						state <= INCREMENT_CHILD_2_COST;
					else if (child_queued)
						state <= GET_CHILD_2_FROM_QUEUE;
					else
						state <= GET_CHILD_3;
						
				GET_CHILD_2_FROM_QUEUE: state <= IS_SHORTER_2;
				IS_SHORTER_2:
					if (current_child.current_cost > (current_node.current_cost + current_node.distance_child_two))
						state <= REMOVE_CHILD_2;
					else
						state <= GET_CHILD_3;
				
				REMOVE_CHILD_2: state <= INCREMENT_CHILD_2_COST;
				INCREMENT_CHILD_2_COST: state <= ADD_CHILD_2_TO_QUEUE;
				ADD_CHILD_2_TO_QUEUE: state <= INCREMENT_CHILD_INDEX_2;
				INCREMENT_CHILD_INDEX_2: state <= GET_CHILD_3;
				
				GET_CHILD_3: state <= EXPLORE_CHILD_3;
				EXPLORE_CHILD_3:
					if (!explored_child && !child_queued && current_child.node_id != 16'd800)
						state <= INCREMENT_CHILD_3_COST;
					else if (child_queued)
						state <= GET_CHILD_3_FROM_QUEUE;
					else
						state <= GET_CHILD_4;
						
				GET_CHILD_3_FROM_QUEUE: state <= IS_SHORTER_3;
				IS_SHORTER_3:
					if (current_child.current_cost > (current_node.current_cost + current_node.distance_child_three))
						state <= REMOVE_CHILD_3;
					else
						state <= GET_CHILD_4;
				
				REMOVE_CHILD_3: state <= INCREMENT_CHILD_3_COST;
				INCREMENT_CHILD_3_COST: state <= ADD_CHILD_3_TO_QUEUE;
				ADD_CHILD_3_TO_QUEUE: state <= INCREMENT_CHILD_INDEX_3;
				INCREMENT_CHILD_INDEX_3: state <= GET_CHILD_4;
				
				GET_CHILD_4: state <= EXPLORE_CHILD_4;
				EXPLORE_CHILD_4:
					if (!explored_child && !child_queued && current_child.node_id != 16'd800)
						state <= INCREMENT_CHILD_4_COST;
					else if (child_queued)
						state <= GET_CHILD_4_FROM_QUEUE;
					else
						state <= LOOP;
				
				GET_CHILD_4_FROM_QUEUE: state <= IS_SHORTER_4;
				IS_SHORTER_4:
					if (current_child.current_cost > (current_node.current_cost + current_node.distance_child_four))
						state <= REMOVE_CHILD_4;
					else
						state <= LOOP;
				
				REMOVE_CHILD_4: state <= INCREMENT_CHILD_4_COST;
				INCREMENT_CHILD_4_COST: state <= ADD_CHILD_4_TO_QUEUE;
				ADD_CHILD_4_TO_QUEUE: state <= INCREMENT_CHILD_INDEX_4;
				INCREMENT_CHILD_INDEX_4: state <= LOOP;
				
				SUCCESS: state <= RECONSTRUCT_PATH;
				RECONSTRUCT_PATH: state <= GET_PARENT;
				GET_PARENT: state <= PATH_DONE;
				PATH_DONE: 
					if (current_node.node_id == start_node_id)
						state <= IDLE;
					else
						state <= RECONSTRUCT_PATH;
			endcase
		end
	end
	
	always_ff @(posedge clk)
	begin
		case (state)
			IDLE: begin
				current_node_id <= start_node_id;
				child_index <= 16'd0;
				explored_node_index <= 16'd0;
				j = 0;
			end
			START: begin
				find_node <= 1'b1;
			end
			LOW_FIND: begin
				find_node <= 1'b0;
			end
			INIT_QUEUE: begin
				queue[0] <= current_node_mem;
			end
			POP: begin
				current_node <= current_minimum_node;
				current_node_id <= current_minimum_node.node_id;
			end
			WAIT_1: begin
				find_node <= 1'b1;
			end
			WAIT_2: begin
				find_node <= 1'b0;
			end
			EXPLORE: begin
				explored_nodes[explored_node_index] <= current_node;
			end
			INCREMENT_EXPLORE_INDEX: begin
				explored_node_index <= explored_node_index + 1'd1;
			end
			GET_CHILD_1: begin
				current_child <= child_one_node;
			end
			REMOVE_NODE_1: begin
				queue[minimum_index] <= '{current_node.x, current_node.y, 16'd800, 16'd800, 16'd800, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0};
			end
			GET_CHILD_1_FROM_QUEUE: begin
				current_child <= child_from_queue;
			end
			REMOVE_CHILD_1: begin
				queue[child_queued_index] <= '{current_node.x, current_node.y, 16'd800, 16'd800, 16'd800, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0};
			end
			INCREMENT_CHILD_1_COST: begin
				current_child.current_cost <= current_node.current_cost + current_node.distance_child_one;
				current_child.parent_node_id <= current_node.node_id;
			end
			ADD_CHILD_1_TO_QUEUE: begin
				queue[minimum_index] <= current_child;
			end
			INCREMENT_CHILD_INDEX_1: begin
				child_index <= child_index + 1'd1;
			end
			
			GET_CHILD_2: begin
				current_child <= child_two_node;
			end
			EXPLORE_CHILD_2: begin
				current_child.parent_node_id <= current_node.node_id;
			end
			GET_CHILD_2_FROM_QUEUE: begin
				current_child <= child_from_queue;
			end
			REMOVE_CHILD_2: begin
				queue[child_queued_index] <= '{current_node.x, current_node.y, 16'd800, 16'd800, 16'd800, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0};
			end
			INCREMENT_CHILD_2_COST: begin
				current_child.current_cost <= current_node.current_cost + current_node.distance_child_two;
				current_child.parent_node_id <= current_node.node_id;
			end
			ADD_CHILD_2_TO_QUEUE: begin
				queue[child_index] <= current_child;
			end
			INCREMENT_CHILD_INDEX_2: begin
				child_index <= child_index + 1'd1;
			end
			
			GET_CHILD_3: begin
				current_child <= child_three_node;
			end
			EXPLORE_CHILD_3: begin
				current_child.parent_node_id <= current_node.node_id;
			end
			GET_CHILD_3_FROM_QUEUE: begin
				current_child <= child_from_queue;
			end
			REMOVE_CHILD_3: begin
				queue[child_queued_index] <= '{current_node.x, current_node.y, 16'd800, 16'd800, 16'd800, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0};
			end
			INCREMENT_CHILD_3_COST: begin
				current_child.current_cost <= current_node.current_cost + current_node.distance_child_three;
				current_child.parent_node_id <= current_node.node_id;
			end
			ADD_CHILD_3_TO_QUEUE: begin
				queue[child_index] <= current_child;
			end
			INCREMENT_CHILD_INDEX_3: begin
				child_index <= child_index + 1'd1;
			end
			
			GET_CHILD_4: begin
				current_child <= child_four_node;
			end
			EXPLORE_CHILD_4: begin
				current_child.parent_node_id <= current_node.node_id;
			end
			GET_CHILD_4_FROM_QUEUE: begin
				current_child <= child_from_queue;
			end
			REMOVE_CHILD_4: begin
				queue[child_queued_index] <= '{current_node.x, current_node.y, 16'd800, 16'd800, 16'd800, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0};
			end
			INCREMENT_CHILD_4_COST: begin
				current_child.current_cost <= current_node.current_cost + current_node.distance_child_four;
				current_child.parent_node_id <= current_node.node_id;
			end
			ADD_CHILD_4_TO_QUEUE: begin
				queue[child_index] <= current_child;
			end
			INCREMENT_CHILD_INDEX_4: begin
				child_index <= child_index + 1'd1;
			end
			
			RECONSTRUCT_PATH: begin
				path[j] <= parent_node;
			end
			GET_PARENT: begin
				j <= j + 1;
				current_node <= parent_node;
			end
		endcase
	end

endmodule

module Node_Comparator
#(
	parameter MAX_NODES = 5
)
(
	input node_info queue[MAX_NODES],
	input node_info explored_nodes[MAX_NODES],
	input node_info current_child,
	input logic [15:0] parent_node_id,
	output logic explored_child,
	output logic child_queued,
	output logic [15:0] child_queued_index,
	output logic [15:0] index,
	output node_info minimum_node,
	output node_info child_queued_node,
	output node_info parent_node
);
	logic [15:0] i;
	always_comb
	begin
		minimum_node = queue[0];
		index = 16'd0;
		explored_child = 1'b0;
		child_queued = 1'b0;
		child_queued_index = 16'd0;
		child_queued_node = '{0, 0, 16'd800, 16'd800, 16'd800, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0};
		parent_node = '{0, 0, 16'd800, 16'd800, 16'd800, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0};
		for (i = 16'd0; i < MAX_NODES; i++)
		begin
			if (queue[i].current_cost < minimum_node.current_cost && queue[i].node_id != 16'd0) begin
				minimum_node = queue[i];
				index = i;
			end
			if (explored_nodes[i].x == current_child.x && explored_nodes[i].y == current_child.y)
				explored_child = 1'b1;
			if (queue[i].x == current_child.x && queue[i].y == current_child.y) begin
				child_queued = 1'b1;
				child_queued_index = i;
				child_queued_node = queue[i];
			end
			if (explored_nodes[i].node_id == parent_node_id) begin
				parent_node = explored_nodes[i];
			end
		end
	end
endmodule
