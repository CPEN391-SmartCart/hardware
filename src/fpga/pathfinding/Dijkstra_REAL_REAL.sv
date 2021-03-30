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

typedef struct packed {
	logic [15:0] x;
	logic [15:0] y;
} coord;

module Dijkstra
#(
	parameter MAX_NODES = 10
)
(
	input logic clk,
	input logic reset,
	input logic start,
	input node_info start_node,
	input node_info goal_node,
	output coord path [100],
	output integer i,
	output logic success
);

	enum logic [7:0] {
			IDLE,
			START,
			WRITE_START,
			WRITE_GOAL,
			LOW_FIND,
			INIT_QUEUE,
			LOOP,
			FIND_MINIMUM_HIGH,
			FIND_MINIMUM_LOW,
			FIND_MINIMUM_DONE,
			POP,
			FIND_NODE_HIGH,
			FIND_NODE_LOW,
			FIND_NODE_DONE,
			IS_GOAL,
			EXPLORE,
			INCREMENT_EXPLORE_INDEX,

			CHECK_CHILD_1,
			GET_CHILD_1,
			IS_CHILD_1_QUEUED_HIGH,
			IS_CHILD_1_QUEUED_LOW,
			IS_CHILD_1_QUEUED_DONE,
			GET_CHILD_1_FROM_QUEUE,
			IS_CHILD_1_EXPLORED_HIGH,
			IS_CHILD_1_EXPLORED_LOW,
			IS_CHILD_1_EXPLORED_DONE,
			REMOVE_NODE_1,
			IS_SHORTER_1,
			INCREMENT_CHILD_1_COST,
			ADD_CHILD_1_TO_QUEUE,
			REMOVE_CHILD_1,
			INCREMENT_CHILD_INDEX_1,

			CHECK_CHILD_2,
			GET_CHILD_2,
			IS_CHILD_2_QUEUED_HIGH,
			IS_CHILD_2_QUEUED_LOW,
			IS_CHILD_2_QUEUED_DONE,
			GET_CHILD_2_FROM_QUEUE,
			IS_CHILD_2_EXPLORED_HIGH,
			IS_CHILD_2_EXPLORED_LOW,
			IS_CHILD_2_EXPLORED_DONE,
			IS_SHORTER_2,
			INCREMENT_CHILD_2_COST,
			ADD_CHILD_2_TO_QUEUE,
			REMOVE_CHILD_2,
			INCREMENT_CHILD_INDEX_2,

			CHECK_CHILD_3,
			GET_CHILD_3,
			IS_CHILD_3_QUEUED_HIGH,
			IS_CHILD_3_QUEUED_LOW,
			IS_CHILD_3_QUEUED_DONE,
			GET_CHILD_3_FROM_QUEUE,
			IS_CHILD_3_EXPLORED_HIGH,
			IS_CHILD_3_EXPLORED_LOW,
			IS_CHILD_3_EXPLORED_DONE,
			IS_SHORTER_3,
			INCREMENT_CHILD_3_COST,
			ADD_CHILD_3_TO_QUEUE,
			REMOVE_CHILD_3,
			INCREMENT_CHILD_INDEX_3,

			CHECK_CHILD_4,
			GET_CHILD_4,
			IS_CHILD_4_QUEUED_HIGH,
			IS_CHILD_4_QUEUED_LOW,
			IS_CHILD_4_QUEUED_DONE,
			GET_CHILD_4_FROM_QUEUE,
			IS_CHILD_4_EXPLORED_HIGH,
			IS_CHILD_4_EXPLORED_LOW,
			IS_CHILD_4_EXPLORED_DONE,
			IS_SHORTER_4,
			INCREMENT_CHILD_4_COST,
			ADD_CHILD_4_TO_QUEUE,
			REMOVE_CHILD_4,
			INCREMENT_CHILD_INDEX_4,

			CHECK_CHILD_5,
			GET_CHILD_5,
			IS_CHILD_5_QUEUED_HIGH,
			IS_CHILD_5_QUEUED_LOW,
			IS_CHILD_5_QUEUED_DONE,
			GET_CHILD_5_FROM_QUEUE,
			IS_CHILD_5_EXPLORED_HIGH,
			IS_CHILD_5_EXPLORED_LOW,
			IS_CHILD_5_EXPLORED_DONE,
			IS_SHORTER_5,
			INCREMENT_CHILD_5_COST,
			ADD_CHILD_5_TO_QUEUE,
			REMOVE_CHILD_5,
			INCREMENT_CHILD_INDEX_5,

			CHECK_CHILD_6,
			GET_CHILD_6,
			IS_CHILD_6_QUEUED_HIGH,
			IS_CHILD_6_QUEUED_LOW,
			IS_CHILD_6_QUEUED_DONE,
			GET_CHILD_6_FROM_QUEUE,
			IS_CHILD_6_EXPLORED_HIGH,
			IS_CHILD_6_EXPLORED_LOW,
			IS_CHILD_6_EXPLORED_DONE,
			IS_SHORTER_6,
			INCREMENT_CHILD_6_COST,
			ADD_CHILD_6_TO_QUEUE,
			REMOVE_CHILD_6,
			INCREMENT_CHILD_INDEX_6,

			RECONSTRUCT_PATH,
			GET_PARENT_HIGH,
			GET_PARENT_LOW,
			GET_PARENT_DONE,
			PATH_DONE,
			ADD_START,

			ERASE,
			ERASE_HIGH,
			ERASE_LOW,

			DONE,
			SUCCESS
	} state;
	
	localparam node_info initial_node = '{16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0};
	
	node_info current_node;
	node_info current_child;
	node_info removed_node = '{16'd0, 16'd0, 16'd800, 16'd800, 16'd800, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0};
	
	
	logic node_mem_write;
	logic [6:0] node_mem_write_address;
	logic [271:0] node_mem_write_data;
	logic [6:0] node_mem_read_address;
	node_info mem_node_temp;
	
	Determined_Nodes_Mem #(.MAX_NODES(MAX_NODES)) nodes_mem(
		.clk(clk),
		.write_enable(node_mem_write),
		.write_address(node_mem_write_address),
		.write_data(node_mem_write_data),
		.read_address(node_mem_read_address),
		.mem_node(mem_node_temp)
	);
	
	
		
	logic [15:0] current_node_id;
	logic find_node;
	node_info mem_node;
	node_info mem_child_one;
	node_info mem_child_two;
	node_info mem_child_three;
	node_info mem_child_four;
	node_info mem_child_five;
	node_info mem_child_six;
	logic found_node_and_children;
	
	Dijkstra_Mem_Reader #(.MAX_NODES(MAX_NODES)) nodes_mem_reader(
		.clk(clk),
		.reset(reset),
		.node_id(current_node_id),
		.find_node(find_node),
		.mem_node(mem_node_temp),
		.read_address(node_mem_read_address),
		.node(mem_node),
		.child_one(mem_child_one),
		.child_two(mem_child_two),
		.child_three(mem_child_three),
		.child_four(mem_child_four),
		.child_five(mem_child_five),
		.child_six(mem_child_six),
		.done(found_node_and_children)
	);
	
	
	
	
	logic queue_write;
	logic [6:0] queue_write_address;
	node_info queue_write_data;
	logic [6:0] queue_read_address;
	node_info queue_node;
	
	Queue_RAM #(.MAX_NODES(MAX_NODES)) queue_mem(
		.clk(clk),
		.write_enable(queue_write),
		.write_address(queue_write_address),
		.write_data(queue_write_data),
		.read_address(queue_read_address),
		.queue_node(queue_node)
	);
	
	
	
	logic find_minimum;
	logic finding_minimum;
	logic [6:0] min_queue_read_address;
	node_info minimum_node;
	logic [6:0] minimum_address;
	logic found_minimum;
	
	Queue_Minimum_Node #(.MAX_NODES(MAX_NODES)) queue_min(
		.clk(clk),
		.reset(reset),
		.find(find_minimum),
		.read_node(queue_node),
		.finding_minimum(finding_minimum),
		.read_address(min_queue_read_address),
		.minimum_node(minimum_node),
		.minimum_address(minimum_address),
		.done(found_minimum)
	);
	
	
	
	logic find_child_from_queue;
	logic finding_child;
	logic [6:0] child_queue_read_address;
	node_info child_from_queue;
	logic child_queued;
	logic [6:0] child_address;
	logic found_child;
	
	logic [6:0] child_write_address;
	
	Queue_Child #(.MAX_NODES(MAX_NODES)) child_queue(
		.clk(clk),
		.reset(reset),
		.find(find_child_from_queue),
		.current_child(current_child),
		.read_node(queue_node),
		.finding_child(finding_child),
		.read_address(child_queue_read_address),
		.child_from_queue(child_from_queue),
		.child_queued(child_queued),
		.child_address(child_address),
		.done(found_child)
	);
	
	assign queue_read_address = finding_minimum ? min_queue_read_address : child_queue_read_address;
	
	
	logic explored_write;
	logic [6:0] explored_write_address;
	node_info explored_write_data;
	logic [6:0] explored_read_address;
	node_info explored_node;
	
	Explored_RAM #(.MAX_NODES(MAX_NODES)) explored_mem(
		.clk(clk),
		.write_enable(explored_write),
		.write_address(explored_write_address),
		.write_data(explored_write_data),
		.read_address(explored_read_address),
		.explored_node(explored_node)
	);
	
	
	logic explored_child_find;
	logic explored_child;
	logic explored_done;
	logic [6:0] explored_child_read_address;
	
	Explored_Child #(.MAX_NODES(MAX_NODES)) explored_child_mem(
		.clk(clk),
		.reset(reset),
		.find(explored_child_find),
		.current_child(current_child),
		.read_node(explored_node),
		.read_address(explored_child_read_address),
		.explored_child(explored_child),
		.done(explored_done)
	);
	
	
	logic explored_parent_find;
	node_info parent_node;
	logic finding_parent;
	logic [6:0] explored_parent_read_address;
	logic explored_parent_done;
	
	Explored_Parent #(.MAX_NODES(MAX_NODES)) explored_parent_mem(
		.clk(clk),
		.reset(reset),
		.find(explored_parent_find),
		.current_node(current_node),
		.read_node(explored_node),
		.finding_parent(finding_parent),
		.read_address(explored_parent_read_address),
		.parent_node(parent_node),
		.done(explored_parent_done)
	);
	
	assign explored_read_address = finding_parent ? explored_parent_read_address : explored_child_read_address;
	
	always_ff @(posedge clk)
	begin
		if (reset)
			state <= IDLE;
		else
			case (state)
				IDLE:
					if (start)
						state <= START;
				
				START: state <= WRITE_START;
				WRITE_START: state <= WRITE_GOAL;
				WRITE_GOAL: state <= LOW_FIND;
				LOW_FIND:
					if (found_node_and_children)
						state <= INIT_QUEUE;
				INIT_QUEUE: state <= LOOP;
				LOOP: state <= FIND_MINIMUM_HIGH;
				
				FIND_MINIMUM_HIGH: state <= FIND_MINIMUM_LOW;
				FIND_MINIMUM_LOW: state <= FIND_MINIMUM_DONE;
				FIND_MINIMUM_DONE:
					if (found_minimum)
						state <= POP;
				
				POP: state <= FIND_NODE_HIGH;
				
				FIND_NODE_HIGH: state <= FIND_NODE_LOW;
				FIND_NODE_LOW: state <= FIND_NODE_DONE;
				FIND_NODE_DONE:
					if (found_node_and_children)
						state <= IS_GOAL;
						
				IS_GOAL:
					if (current_node.x == goal_node.x && current_node.y == goal_node.y)
						state <= SUCCESS;
					else
						state <= EXPLORE;
				
				EXPLORE: state <= INCREMENT_EXPLORE_INDEX;
				INCREMENT_EXPLORE_INDEX: state <= CHECK_CHILD_1;
				
				//CHILD 1
				CHECK_CHILD_1:
					if (mem_child_one.node_id == 16'd800)
						state <= CHECK_CHILD_2;
					else
						state <= GET_CHILD_1;
				GET_CHILD_1: state <= IS_CHILD_1_QUEUED_HIGH;
				IS_CHILD_1_QUEUED_HIGH: state <= IS_CHILD_1_QUEUED_LOW;
				IS_CHILD_1_QUEUED_LOW: state <= IS_CHILD_1_QUEUED_DONE;
				IS_CHILD_1_QUEUED_DONE:
					if (found_child) begin
						if (child_queued)
							state <= GET_CHILD_1_FROM_QUEUE;
						else
							state <= IS_CHILD_1_EXPLORED_HIGH;
					end
					
				GET_CHILD_1_FROM_QUEUE: state <= IS_SHORTER_1;
				IS_SHORTER_1:
					if (current_child.current_cost > (current_node.current_cost + current_node.distance_child_one))
						state <= REMOVE_CHILD_1;
					else
						state <= CHECK_CHILD_2;
					
				IS_CHILD_1_EXPLORED_HIGH: state <= IS_CHILD_1_EXPLORED_LOW;	
				IS_CHILD_1_EXPLORED_LOW: state <= IS_CHILD_1_EXPLORED_DONE;
				IS_CHILD_1_EXPLORED_DONE:
					if (explored_done) begin
						if (explored_child || current_child.node_id == 16'd800)
							state <= REMOVE_NODE_1;
						else
							state <= INCREMENT_CHILD_1_COST;
					end
				
				REMOVE_NODE_1: state <= CHECK_CHILD_2;
				
				REMOVE_CHILD_1: state <= INCREMENT_CHILD_1_COST;
				INCREMENT_CHILD_1_COST: state <= ADD_CHILD_1_TO_QUEUE;
				ADD_CHILD_1_TO_QUEUE: state <= INCREMENT_CHILD_INDEX_1;
				INCREMENT_CHILD_INDEX_1: state <= CHECK_CHILD_2;
				
				
				//CHILD 2
				CHECK_CHILD_2:
					if (mem_child_two.node_id == 16'd800)
						state <= CHECK_CHILD_3;
					else
						state <= GET_CHILD_2;
				GET_CHILD_2: state <= IS_CHILD_2_QUEUED_HIGH;
				IS_CHILD_2_QUEUED_HIGH: state <= IS_CHILD_2_QUEUED_LOW;
				IS_CHILD_2_QUEUED_LOW: state <= IS_CHILD_2_QUEUED_DONE;
				IS_CHILD_2_QUEUED_DONE:
					if (found_child) begin
						if (child_queued)
							state <= GET_CHILD_2_FROM_QUEUE;
						else
							state <= IS_CHILD_2_EXPLORED_HIGH;
					end
				
				GET_CHILD_2_FROM_QUEUE: state <= IS_SHORTER_2;
				IS_SHORTER_2:
					if (current_child.current_cost > (current_node.current_cost + current_node.distance_child_two))
						state <= REMOVE_CHILD_2;
					else
						state <= CHECK_CHILD_3;
						
				IS_CHILD_2_EXPLORED_HIGH: state <= IS_CHILD_2_EXPLORED_LOW;
				IS_CHILD_2_EXPLORED_LOW: state <= IS_CHILD_2_EXPLORED_DONE;
				IS_CHILD_2_EXPLORED_DONE:
					if (explored_done) begin
						if (explored_child || current_child.node_id == 16'd800)
							state <= CHECK_CHILD_3;
						else
							state <= INCREMENT_CHILD_2_COST;
					end
				
				REMOVE_CHILD_2: state <= INCREMENT_CHILD_2_COST;
				INCREMENT_CHILD_2_COST: state <= ADD_CHILD_2_TO_QUEUE;
				ADD_CHILD_2_TO_QUEUE: state <= INCREMENT_CHILD_INDEX_2;
				INCREMENT_CHILD_INDEX_2: state <= CHECK_CHILD_3;
				
				
				//CHILD 3
				CHECK_CHILD_3:
					if (mem_child_three.node_id == 16'd800)
						state <= CHECK_CHILD_4;
					else
						state <= GET_CHILD_3;
				GET_CHILD_3: state <= IS_CHILD_3_QUEUED_HIGH;
				IS_CHILD_3_QUEUED_HIGH: state <= IS_CHILD_3_QUEUED_LOW;
				IS_CHILD_3_QUEUED_LOW: state <= IS_CHILD_3_QUEUED_DONE;
				IS_CHILD_3_QUEUED_DONE:
					if (found_child) begin
						if (child_queued)
							state <= GET_CHILD_3_FROM_QUEUE;
						else
							state <= IS_CHILD_3_EXPLORED_HIGH;
					end
				
				GET_CHILD_3_FROM_QUEUE: state <= IS_SHORTER_3;
				IS_SHORTER_3:
					if (current_child.current_cost > (current_node.current_cost + current_node.distance_child_three))
						state <= REMOVE_CHILD_3;
					else
						state <= CHECK_CHILD_4;
						
				IS_CHILD_3_EXPLORED_HIGH: state <= IS_CHILD_3_EXPLORED_LOW;
				IS_CHILD_3_EXPLORED_LOW: state <= IS_CHILD_3_EXPLORED_DONE;
				IS_CHILD_3_EXPLORED_DONE:
					if (explored_done) begin
						if (explored_child || current_child.node_id == 16'd800)
							state <= CHECK_CHILD_4;
						else
							state <= INCREMENT_CHILD_3_COST;
					end
				
				REMOVE_CHILD_3: state <= INCREMENT_CHILD_3_COST;
				INCREMENT_CHILD_3_COST: state <= ADD_CHILD_3_TO_QUEUE;
				ADD_CHILD_3_TO_QUEUE: state <= INCREMENT_CHILD_INDEX_3;
				INCREMENT_CHILD_INDEX_3: state <= CHECK_CHILD_4;
				
								
				//CHILD 4
				CHECK_CHILD_4:
					if (mem_child_four.node_id == 16'd800)
						state <= CHECK_CHILD_5;
					else
						state <= GET_CHILD_4;
				GET_CHILD_4: state <= IS_CHILD_4_QUEUED_HIGH;
				IS_CHILD_4_QUEUED_HIGH: state <= IS_CHILD_4_QUEUED_LOW;
				IS_CHILD_4_QUEUED_LOW: state <= IS_CHILD_4_QUEUED_DONE;
				IS_CHILD_4_QUEUED_DONE:
					if (found_child) begin
						if (child_queued)
							state <= GET_CHILD_4_FROM_QUEUE;
						else
							state <= IS_CHILD_4_EXPLORED_HIGH;
					end
				
				GET_CHILD_4_FROM_QUEUE: state <= IS_SHORTER_4;
				IS_SHORTER_4:
					if (current_child.current_cost > (current_node.current_cost + current_node.distance_child_four))
						state <= REMOVE_CHILD_4;
					else
						state <= CHECK_CHILD_5;
						
				IS_CHILD_4_EXPLORED_HIGH: state <= IS_CHILD_4_EXPLORED_LOW;
				IS_CHILD_4_EXPLORED_LOW: state <= IS_CHILD_4_EXPLORED_DONE;
				IS_CHILD_4_EXPLORED_DONE:
					if (explored_done) begin
						if (explored_child || current_child.node_id == 16'd800)
							state <= CHECK_CHILD_5;
						else
							state <= INCREMENT_CHILD_4_COST;
					end
				
				REMOVE_CHILD_4: state <= INCREMENT_CHILD_4_COST;
				INCREMENT_CHILD_4_COST: state <= ADD_CHILD_4_TO_QUEUE;
				ADD_CHILD_4_TO_QUEUE: state <= INCREMENT_CHILD_INDEX_4;
				INCREMENT_CHILD_INDEX_4: state <= CHECK_CHILD_5;
				
								
				//CHILD 5
				CHECK_CHILD_5:
					if (mem_child_five.node_id == 16'd800)
						state <= CHECK_CHILD_6;
					else
						state <= GET_CHILD_5;
				GET_CHILD_5: state <= IS_CHILD_5_QUEUED_HIGH;
				IS_CHILD_5_QUEUED_HIGH: state <= IS_CHILD_5_QUEUED_LOW;
				IS_CHILD_5_QUEUED_LOW: state <= IS_CHILD_5_QUEUED_DONE;
				IS_CHILD_5_QUEUED_DONE:
					if (found_child) begin
						if (child_queued)
							state <= GET_CHILD_5_FROM_QUEUE;
						else
							state <= IS_CHILD_5_EXPLORED_HIGH;
					end
				
				GET_CHILD_5_FROM_QUEUE: state <= IS_SHORTER_5;
				IS_SHORTER_5:
					if (current_child.current_cost > (current_node.current_cost + current_node.distance_child_five))
						state <= REMOVE_CHILD_5;
					else
						state <= CHECK_CHILD_6;
						
				IS_CHILD_5_EXPLORED_HIGH: state <= IS_CHILD_5_EXPLORED_LOW;
				IS_CHILD_5_EXPLORED_LOW: state <= IS_CHILD_5_EXPLORED_DONE;
				IS_CHILD_5_EXPLORED_DONE:
					if (explored_done) begin
						if (explored_child || current_child.node_id == 16'd800)
							state <= CHECK_CHILD_6;
						else
							state <= INCREMENT_CHILD_5_COST;
					end
				
				REMOVE_CHILD_5: state <= INCREMENT_CHILD_5_COST;
				INCREMENT_CHILD_5_COST: state <= ADD_CHILD_5_TO_QUEUE;
				ADD_CHILD_5_TO_QUEUE: state <= INCREMENT_CHILD_INDEX_5;
				INCREMENT_CHILD_INDEX_5: state <= CHECK_CHILD_6;


				//CHILD 6
				CHECK_CHILD_6:
					if (mem_child_six.node_id == 16'd800)
						state <= LOOP;
					else
						state <= GET_CHILD_6;
				GET_CHILD_6: state <= IS_CHILD_6_QUEUED_HIGH;
				IS_CHILD_6_QUEUED_HIGH: state <= IS_CHILD_6_QUEUED_LOW;
				IS_CHILD_6_QUEUED_LOW: state <= IS_CHILD_6_QUEUED_DONE;
				IS_CHILD_6_QUEUED_DONE:
					if (found_child) begin
						if (child_queued)
							state <= GET_CHILD_6_FROM_QUEUE;
						else
							state <= IS_CHILD_6_EXPLORED_HIGH;
					end
				
				GET_CHILD_6_FROM_QUEUE: state <= IS_SHORTER_6;
				IS_SHORTER_6:
					if (current_child.current_cost > (current_node.current_cost + current_node.distance_child_six))
						state <= REMOVE_CHILD_6;
					else
						state <= LOOP;
						
				IS_CHILD_6_EXPLORED_HIGH: state <= IS_CHILD_6_EXPLORED_LOW;
				IS_CHILD_6_EXPLORED_LOW: state <= IS_CHILD_6_EXPLORED_DONE;
				IS_CHILD_6_EXPLORED_DONE:
					if (explored_done) begin
						if (explored_child || current_child.node_id == 16'd800)
							state <= LOOP;
						else
							state <= INCREMENT_CHILD_6_COST;
					end
				
				REMOVE_CHILD_6: state <= INCREMENT_CHILD_6_COST;
				INCREMENT_CHILD_6_COST: state <= ADD_CHILD_6_TO_QUEUE;
				ADD_CHILD_6_TO_QUEUE: state <= INCREMENT_CHILD_INDEX_6;
				INCREMENT_CHILD_INDEX_6: state <= LOOP;
				
				SUCCESS: state <= RECONSTRUCT_PATH;
				
				RECONSTRUCT_PATH: state <= GET_PARENT_HIGH;
				GET_PARENT_HIGH: state <= GET_PARENT_LOW;
				GET_PARENT_LOW: state <= GET_PARENT_DONE;
				GET_PARENT_DONE:
					if (explored_parent_done)
						state <= PATH_DONE;
				PATH_DONE:
					if (parent_node.node_id == start_node.node_id)
						state <= ADD_START;
					else
						state <= RECONSTRUCT_PATH;
				ADD_START: state <= ERASE;
			
				ERASE: state <= ERASE_HIGH;
				ERASE_HIGH: state <= ERASE_LOW;
				ERASE_LOW: 
					if (queue_write_address < 7'd127)
						state <= ERASE_HIGH;
					else
						state <= DONE;
				
				DONE: state <= IDLE;
			endcase
	end
	
	always_ff @(posedge clk)
	begin
		case (state)
			IDLE: begin
				current_node_id <= start_node.node_id;
				node_mem_write_address <= 7'b0;
				node_mem_write_data <= initial_node;
			end
			
			START: begin
				find_node <= 1'b1;
				explored_write_address <= 7'b0;
				child_write_address <= 7'b1;
				i <= 0;
				success <= 1'b0;
			end
			WRITE_START: begin
				node_mem_write <= 1'b1;
				node_mem_write_address <= 7'd7;
				node_mem_write_data <= start_node;
			end
			WRITE_GOAL: begin
				node_mem_write <= 1'b1;
				node_mem_write_address <= 7'd8;
				node_mem_write_data <= goal_node;
			end
			
			LOW_FIND: begin
				node_mem_write <= 1'b0;
				find_node <= 1'b0;
			end
			INIT_QUEUE: begin
				queue_write <= 1'b1;
				queue_write_address <= 7'b0;
				queue_write_data <= start_node;
			end
			LOOP: begin
				queue_write <= 1'b0;
			end
			
			
			FIND_MINIMUM_HIGH: begin
				find_minimum <= 1'b1;
			end
			FIND_MINIMUM_LOW: begin
				find_minimum <= 1'b0;
			end
			POP: begin
				current_node <= minimum_node;
				current_node_id <= minimum_node.node_id;
			end
			FIND_NODE_HIGH: begin
				find_node <= 1'b1;
			end
			FIND_NODE_LOW: begin
				find_node <= 1'b0;
			end
			
			EXPLORE: begin
				explored_write <= 1'b1;
				explored_write_data <= current_node;
			end
			INCREMENT_EXPLORE_INDEX: begin
				explored_write <= 1'b0;
				explored_write_address <= explored_write_address + 1'b1;
			end
			
			
			//
			GET_CHILD_1: begin
				current_child <= mem_child_one;
			end
			IS_CHILD_1_QUEUED_HIGH: begin
				find_child_from_queue <= 1'b1;
			end
			IS_CHILD_1_QUEUED_LOW: begin
				find_child_from_queue <= 1'b0;
			end
			
			GET_CHILD_1_FROM_QUEUE: begin
				current_child <= child_from_queue;
			end
			REMOVE_CHILD_1: begin
				queue_write <= 1'b1;
				queue_write_address <= child_address;
				queue_write_data <= removed_node;
			end
			
			IS_CHILD_1_EXPLORED_HIGH: begin
				explored_child_find <= 1'b1;
			end
			IS_CHILD_1_EXPLORED_LOW: begin
				explored_child_find <= 1'b0;
			end
			REMOVE_NODE_1: begin
				queue_write <= 1'b1;
				queue_write_address <= minimum_address;
				queue_write_data <= removed_node;
			end
			
			INCREMENT_CHILD_1_COST: begin
				queue_write <= 1'b0;
				current_child.current_cost <= current_node.current_cost + current_node.distance_child_one;
				current_child.parent_node_id <= current_node.node_id;
			end
			ADD_CHILD_1_TO_QUEUE: begin
				queue_write <= 1'b1;
				queue_write_address <= minimum_address;
				queue_write_data <= current_child;
			end
			INCREMENT_CHILD_INDEX_1: begin
				queue_write <= 1'b0;
			end
			
			
			//
			GET_CHILD_2: begin
				queue_write <= 1'b0;
				current_child <= mem_child_two;
			end
			IS_CHILD_2_QUEUED_HIGH: begin
				find_child_from_queue <= 1'b1;
			end
			IS_CHILD_2_QUEUED_LOW: begin
				find_child_from_queue <= 1'b0;
			end
			
			GET_CHILD_2_FROM_QUEUE: begin
				current_child <= child_from_queue;
			end
			REMOVE_CHILD_2: begin
				queue_write <= 1'b1;
				queue_write_address <= child_address;
				queue_write_data <= removed_node;
			end
			
			IS_CHILD_2_EXPLORED_HIGH: begin
				explored_child_find <= 1'b1;
			end
			IS_CHILD_2_EXPLORED_LOW: begin
				explored_child_find <= 1'b0;
			end
			
			INCREMENT_CHILD_2_COST: begin
				queue_write <= 1'b0;
				current_child.current_cost <= current_node.current_cost + current_node.distance_child_two;
				current_child.parent_node_id <= current_node.node_id;
			end
			ADD_CHILD_2_TO_QUEUE: begin
				queue_write <= 1'b1;
				queue_write_address <= child_write_address;
				queue_write_data <= current_child;
			end
			INCREMENT_CHILD_INDEX_2: begin
				queue_write <= 1'b0;
				child_write_address <= child_write_address + 1'b1;
			end
			
			
			//
			GET_CHILD_3: begin
				queue_write <= 1'b0;
				current_child <= mem_child_three;
			end
			IS_CHILD_3_QUEUED_HIGH: begin
				find_child_from_queue <= 1'b1;
			end
			IS_CHILD_3_QUEUED_LOW: begin
				find_child_from_queue <= 1'b0;
			end
			
			GET_CHILD_3_FROM_QUEUE: begin
				current_child <= child_from_queue;
			end
			REMOVE_CHILD_3: begin
				queue_write <= 1'b1;
				queue_write_address <= child_address;
				queue_write_data <= removed_node;
			end
			
			IS_CHILD_3_EXPLORED_HIGH: begin
				explored_child_find <= 1'b1;
			end
			IS_CHILD_3_EXPLORED_LOW: begin
				explored_child_find <= 1'b0;
			end
			
			INCREMENT_CHILD_3_COST: begin
				queue_write <= 1'b0;
				current_child.current_cost <= current_node.current_cost + current_node.distance_child_three;
				current_child.parent_node_id <= current_node.node_id;
			end
			ADD_CHILD_3_TO_QUEUE: begin
				queue_write <= 1'b1;
				queue_write_address <= child_write_address;
				queue_write_data <= current_child;
			end
			INCREMENT_CHILD_INDEX_3: begin
				queue_write <= 1'b0;
				child_write_address <= child_write_address + 1'b1;
			end
			

			//
			GET_CHILD_4: begin
				queue_write <= 1'b0;
				current_child <= mem_child_four;
			end
			IS_CHILD_4_QUEUED_HIGH: begin
				find_child_from_queue <= 1'b1;
			end
			IS_CHILD_4_QUEUED_LOW: begin
				find_child_from_queue <= 1'b0;
			end
			
			GET_CHILD_4_FROM_QUEUE: begin
				current_child <= child_from_queue;
			end
			REMOVE_CHILD_4: begin
				queue_write <= 1'b1;
				queue_write_address <= child_address;
				queue_write_data <= removed_node;
			end
			
			IS_CHILD_4_EXPLORED_HIGH: begin
				explored_child_find <= 1'b1;
			end
			IS_CHILD_4_EXPLORED_LOW: begin
				explored_child_find <= 1'b0;
			end
			
			INCREMENT_CHILD_4_COST: begin
				queue_write <= 1'b0;
				current_child.current_cost <= current_node.current_cost + current_node.distance_child_four;
				current_child.parent_node_id <= current_node.node_id;
			end
			ADD_CHILD_4_TO_QUEUE: begin
				queue_write <= 1'b1;
				queue_write_address <= child_write_address;
				queue_write_data <= current_child;
			end
			INCREMENT_CHILD_INDEX_4: begin
				queue_write <= 1'b0;
				child_write_address <= child_write_address + 1'b1;
			end


			//
			GET_CHILD_5: begin
				queue_write <= 1'b0;
				current_child <= mem_child_five;
			end
			IS_CHILD_5_QUEUED_HIGH: begin
				find_child_from_queue <= 1'b1;
			end
			IS_CHILD_5_QUEUED_LOW: begin
				find_child_from_queue <= 1'b0;
			end
			
			GET_CHILD_5_FROM_QUEUE: begin
				current_child <= child_from_queue;
			end
			REMOVE_CHILD_5: begin
				queue_write <= 1'b1;
				queue_write_address <= child_address;
				queue_write_data <= removed_node;
			end
			
			IS_CHILD_5_EXPLORED_HIGH: begin
				explored_child_find <= 1'b1;
			end
			IS_CHILD_5_EXPLORED_LOW: begin
				explored_child_find <= 1'b0;
			end
			
			INCREMENT_CHILD_5_COST: begin
				queue_write <= 1'b0;
				current_child.current_cost <= current_node.current_cost + current_node.distance_child_five;
				current_child.parent_node_id <= current_node.node_id;
			end
			ADD_CHILD_5_TO_QUEUE: begin
				queue_write <= 1'b1;
				queue_write_address <= child_write_address;
				queue_write_data <= current_child;
			end
			INCREMENT_CHILD_INDEX_5: begin
				queue_write <= 1'b0;
				child_write_address <= child_write_address + 1'b1;
			end


			//
			GET_CHILD_6: begin
				queue_write <= 1'b0;
				current_child <= mem_child_six;
			end
			IS_CHILD_6_QUEUED_HIGH: begin
				find_child_from_queue <= 1'b1;
			end
			IS_CHILD_6_QUEUED_LOW: begin
				find_child_from_queue <= 1'b0;
			end
			
			GET_CHILD_6_FROM_QUEUE: begin
				current_child <= child_from_queue;
			end
			REMOVE_CHILD_6: begin
				queue_write <= 1'b1;
				queue_write_address <= child_address;
				queue_write_data <= removed_node;
			end
			
			IS_CHILD_6_EXPLORED_HIGH: begin
				explored_child_find <= 1'b1;
			end
			IS_CHILD_6_EXPLORED_LOW: begin
				explored_child_find <= 1'b0;
			end
			
			INCREMENT_CHILD_6_COST: begin
				queue_write <= 1'b0;
				current_child.current_cost <= current_node.current_cost + current_node.distance_child_six;
				current_child.parent_node_id <= current_node.node_id;
			end
			ADD_CHILD_6_TO_QUEUE: begin
				queue_write <= 1'b1;
				queue_write_address <= child_write_address;
				queue_write_data <= current_child;
			end
			INCREMENT_CHILD_INDEX_6: begin
				queue_write <= 1'b0;
				child_write_address <= child_write_address + 1'b1;
			end

			
			RECONSTRUCT_PATH: begin
				path[i] <= '{current_node.x, current_node.y};
			end
			GET_PARENT_HIGH: begin
				explored_parent_find <= 1'b1;
			end
			GET_PARENT_LOW: begin
				explored_parent_find <= 1'b0;
			end
			PATH_DONE: begin
				i <= i + 1;
				current_node <= parent_node;
			end
			ADD_START: begin
				path[i] <= '{current_node.x , current_node.y};
			end
			
			ERASE: begin
				queue_write_address <= 7'b0;
				explored_write_address <= 7'b0;
				queue_write_data <= 272'b0;
				explored_write_data <= 272'b0;
			end
			ERASE_HIGH: begin
				explored_write <= 1'b1;
				queue_write <= 1'b1;
			end
			ERASE_LOW: begin
				explored_write <= 1'b0;
				queue_write <= 1'b0;
				queue_write_address <= queue_write_address + 1'b1;
				explored_write_address <= explored_write_address + 1'b1;
			end
			
			DONE: begin
				success <= 1'b1;
			end
		endcase
	end
endmodule