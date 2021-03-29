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
	input logic start,
	input node_info start_node,
	input node_info goal_node,
	output node_info path [100],
	output integer i,
	output logic success
);

	localparam IDLE 								= 8'd0;
	localparam START								= 8'd1;
	localparam LOW_FIND							= 8'd2;
	localparam INIT_QUEUE						= 8'd3;
	localparam LOOP								= 8'd4;
	localparam FIND_MINIMUM_HIGH				= 8'd5;
	localparam FIND_MINIMUM_LOW				= 8'd6;
	localparam FIND_MINIMUM_DONE				= 8'd7;
	localparam POP 								= 8'd8;
	localparam FIND_NODE_HIGH					= 8'd9;
	localparam FIND_NODE_LOW					= 8'd10;
	localparam FIND_NODE_DONE					= 8'd11;
	localparam IS_GOAL							= 8'd12;
	localparam EXPLORE							= 8'd13;
	localparam INCREMENT_EXPLORE_INDEX		= 8'd14;
	
	localparam GET_CHILD_1						= 8'd15;
	localparam IS_CHILD_1_QUEUED_HIGH		= 8'd16;
	localparam IS_CHILD_1_QUEUED_LOW			= 8'd17;
	localparam IS_CHILD_1_QUEUED_DONE		= 8'd18;
	localparam GET_CHILD_1_FROM_QUEUE		= 8'd19;
	localparam IS_CHILD_1_EXPLORED_HIGH		= 8'd20;
	localparam IS_CHILD_1_EXPLORED_LOW 		= 8'd21;
	localparam IS_CHILD_1_EXPLORED_DONE		= 8'd22;
	localparam REMOVE_NODE_1					= 8'd23;
	localparam IS_SHORTER_1						= 8'd24;
	localparam INCREMENT_CHILD_1_COST		= 8'd25;
	localparam ADD_CHILD_1_TO_QUEUE			= 8'd26;
	localparam REMOVE_CHILD_1					= 8'd27;
	localparam INCREMENT_CHILD_INDEX_1 		= 8'd28;
	
	localparam GET_CHILD_2						= 8'd29;
	localparam IS_CHILD_2_QUEUED_HIGH		= 8'd30;
	localparam IS_CHILD_2_QUEUED_LOW			= 8'd31;
	localparam IS_CHILD_2_QUEUED_DONE		= 8'd32;
	localparam GET_CHILD_2_FROM_QUEUE		= 8'd33;
	localparam IS_CHILD_2_EXPLORED_HIGH		= 8'd34;
	localparam IS_CHILD_2_EXPLORED_LOW 		= 8'd35;
	localparam IS_CHILD_2_EXPLORED_DONE 	= 8'd36;
	localparam IS_SHORTER_2						= 8'd37;
	localparam INCREMENT_CHILD_2_COST		= 8'd38;
	localparam ADD_CHILD_2_TO_QUEUE			= 8'd39;
	localparam REMOVE_CHILD_2					= 8'd40;
	localparam INCREMENT_CHILD_INDEX_2 		= 8'd41;
	
	localparam GET_CHILD_3						= 8'd42;
	localparam IS_CHILD_3_QUEUED_HIGH		= 8'd43;
	localparam IS_CHILD_3_QUEUED_LOW			= 8'd44;
	localparam IS_CHILD_3_QUEUED_DONE 		= 8'd45;
	localparam GET_CHILD_3_FROM_QUEUE		= 8'd46;
	localparam IS_CHILD_3_EXPLORED_HIGH		= 8'd47;
	localparam IS_CHILD_3_EXPLORED_LOW 		= 8'd48;
	localparam IS_CHILD_3_EXPLORED_DONE		= 8'd49;
	localparam IS_SHORTER_3						= 8'd50;
	localparam INCREMENT_CHILD_3_COST		= 8'd51;
	localparam ADD_CHILD_3_TO_QUEUE			= 8'd52;
	localparam REMOVE_CHILD_3					= 8'd53;
	localparam INCREMENT_CHILD_INDEX_3 		= 8'd54;
	
	localparam GET_CHILD_4						= 8'd55;
	localparam IS_CHILD_4_QUEUED_HIGH		= 8'd56;
	localparam IS_CHILD_4_QUEUED_LOW			= 8'd57;
	localparam IS_CHILD_4_QUEUED_DONE		= 8'd58;
	localparam GET_CHILD_4_FROM_QUEUE		= 8'd59;
	localparam IS_CHILD_4_EXPLORED_HIGH		= 8'd60;
	localparam IS_CHILD_4_EXPLORED_LOW 		= 8'd61;
	localparam IS_CHILD_4_EXPLORED_DONE		= 8'd62;
	localparam IS_SHORTER_4						= 8'd63;
	localparam INCREMENT_CHILD_4_COST		= 8'd64;
	localparam ADD_CHILD_4_TO_QUEUE			= 8'd65;
	localparam REMOVE_CHILD_4					= 8'd66;
	localparam INCREMENT_CHILD_INDEX_4 		= 8'd67;
	
	localparam CHECK_CHILD_1					= 8'd68;
	localparam CHECK_CHILD_2					= 8'd69;
	localparam CHECK_CHILD_3					= 8'd70;
	localparam CHECK_CHILD_4					= 8'd71;
	
	localparam RECONSTRUCT_PATH				= 8'd72;
	localparam GET_PARENT_HIGH					= 8'd73;
	localparam GET_PARENT_LOW					= 8'd74;
	localparam GET_PARENT_DONE					= 8'd75;
	localparam PATH_DONE							= 8'd76;
	localparam ADD_START							= 8'd77;
	
	localparam ERASE								= 8'd78;
	localparam ERASE_HIGH						= 8'd79;
	localparam ERASE_LOW							= 8'd80;
	
	localparam DONE								= 8'd81;
	
	localparam SUCCESS							= 8'd82;
	
	localparam WRITE_START 						= 8'd83;
	localparam WRITE_GOAL						= 8'd84;

	localparam node_info initial_node = '{16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0};

	logic [7:0] state;
	
	node_info current_node;
	node_info current_child;
	node_info removed_node = '{16'd0, 16'd0, 16'd800, 16'd800, 16'd800, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0};
	
	
	logic node_mem_write;
	logic [6:0] node_mem_write_address;
	logic [271:0] node_mem_write_data;
	logic [6:0] node_mem_read_address;
	node_info mem_node_temp;
	
	Determined_Nodes_Mem nodes_mem(
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
	
	Dijkstra_Mem_Reader nodes_mem_reader(
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
	
	Queue_RAM queue_mem(
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
	
	Queue_Minimum_Node queue_min(
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
	
	Queue_Child child_queue(
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
	
	Explored_RAM explored_mem(
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
	
	Explored_Child explored_child_mem(
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
	
	Explored_Parent explored_parent_mem(
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
				
				//
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
				
				
				//
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
				
				
				//
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
					if (current_child.current_cost > (current_node.current_cost + current_node.distance_child_two))
						state <= REMOVE_CHILD_3;
					else
						state <= GET_CHILD_4;
						
				IS_CHILD_3_EXPLORED_HIGH: state <= IS_CHILD_3_EXPLORED_LOW;
				IS_CHILD_3_EXPLORED_LOW: state <= IS_CHILD_3_EXPLORED_DONE;
				IS_CHILD_3_EXPLORED_DONE:
					if (explored_done) begin
						if (explored_child || current_child.node_id == 16'd800)
							state <= GET_CHILD_4;
						else
							state <= INCREMENT_CHILD_3_COST;
					end
				
				REMOVE_CHILD_3: state <= INCREMENT_CHILD_3_COST;
				INCREMENT_CHILD_3_COST: state <= ADD_CHILD_3_TO_QUEUE;
				ADD_CHILD_3_TO_QUEUE: state <= INCREMENT_CHILD_INDEX_3;
				INCREMENT_CHILD_INDEX_3: state <= GET_CHILD_4;
				
				
				//
				CHECK_CHILD_4:
					if (mem_child_four.node_id == 16'd800)
						state <= LOOP;
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
					if (current_child.current_cost > (current_node.current_cost + current_node.distance_child_two))
						state <= REMOVE_CHILD_4;
					else
						state <= LOOP;
						
				IS_CHILD_4_EXPLORED_HIGH: state <= IS_CHILD_4_EXPLORED_LOW;
				IS_CHILD_4_EXPLORED_LOW: state <= IS_CHILD_4_EXPLORED_DONE;
				IS_CHILD_4_EXPLORED_DONE:
					if (explored_done) begin
						if (explored_child || current_child.node_id == 16'd800)
							state <= LOOP;
						else
							state <= INCREMENT_CHILD_4_COST;
					end
				
				REMOVE_CHILD_4: state <= INCREMENT_CHILD_4_COST;
				INCREMENT_CHILD_4_COST: state <= ADD_CHILD_4_TO_QUEUE;
				ADD_CHILD_4_TO_QUEUE: state <= INCREMENT_CHILD_INDEX_4;
				INCREMENT_CHILD_INDEX_4: state <= LOOP;
				
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
				current_child.current_cost <= current_node.current_cost + current_node.distance_child_three;
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
			
			RECONSTRUCT_PATH: begin
				path[i] <= current_node;
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
				path[i] <= current_node;
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
