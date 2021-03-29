
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

module Dijkstra_Mem
#(
	parameter MAX_NODES = 5
)
(
	input logic clk,
	input logic reset,
	input logic [15:0] node_id,
	input logic find_node,
	output logic found,
	output node_info node,
	output node_info child_one,
	output node_info child_two,
	output node_info child_three,
	output node_info child_four,
	output node_info child_five,
	output node_info child_six
);
	localparam IDLE							= 3'b000;
	localparam FIND_NODE 					= 3'b001;
	localparam FIND_CHILDREN 				= 3'b010;

	integer node_index;
	integer child_one_index;
	integer child_two_index;
	integer child_three_index;
	integer child_four_index;
	integer child_five_index;
	integer child_six_index;
	
	integer child_one_id;
	integer child_two_id;
	integer child_three_id;
	integer child_four_id;
	integer child_five_id;
	integer child_six_id;
	
	node_info memory [MAX_NODES];
	
	initial begin
		$readmemh("/home/jared/Desktop/smartcart/hardware/src/fpga/pathfinding/nodes.mem", memory);
	end
	
	logic [2:0] state;
	
	always_ff @(posedge clk)
	begin
		if (reset) begin
			state <= IDLE;
		end
		else begin
			case (state)
				IDLE: 
					if (find_node)
						state <= FIND_NODE;
				FIND_NODE:
					if (found)
						state <= FIND_CHILDREN;
				FIND_CHILDREN: state <= IDLE;
			endcase
		end
	end
	
	integer i;
	integer j;
	integer k;
	
	always_ff @(posedge clk)
	begin
		if (reset) begin
			node_index <= -1;
			child_one_index <= -1;
			child_two_index <= -1;
			child_three_index <= -1;
			child_four_index <= -1;
			child_five_index <= -1;
			child_six_index <= -1;
		
			found <= 1'b0;
		end
		else begin
			case (state)
				FIND_NODE: begin
					for (i = 0; i < MAX_NODES; i++) begin
						if (memory[i][239:224] == node_id) begin
							node_index <= i;
							found <= 1'b1;
						end
					end
				end
				FIND_CHILDREN: begin
					found = 1'b0;
					child_one_index <= -1;
					child_two_index <= -1;
					child_three_index <= -1;
					child_four_index <= -1;
					child_five_index <= -1;
					child_six_index <= -1;
					for (j = 0; j < MAX_NODES; j++) begin
						if (memory[j][239:224] == child_one_id) begin
							child_one_index <= j;
						end
						else if (memory[j][239:224] == child_two_id) begin
							child_two_index <= j;
						end
						else if (memory[j][239:224] == child_three_id) begin
							child_three_index <= j;
						end
						else if (memory[j][239:224] == child_four_id) begin
							child_four_index <= j;
						end
						else if (memory[j][239:224] == child_five_id) begin
							child_five_index <= j;
						end
						else if (memory[j][239:224] == child_six_id) begin
							child_six_index <= j;
						end
					end
				end
			endcase
		end
	end
	
	assign child_one_id 		= memory[node_index][191:176];
	assign child_two_id 		= memory[node_index][159:144];
	assign child_three_id 	= memory[node_index][127:112];
	assign child_four_id		= memory[node_index][111:96];
	assign child_five_id 	= memory[node_index][95:80];
	assign child_six_id 		= memory[node_index][31:16];
	
	assign node.x 							= node_index == -1 ? 16'h0 : memory[node_index][271:256];
	assign node.y 	 						= node_index == -1 ? 16'h0 : memory[node_index][255:240];
	assign node.node_id 					= node_index == -1 ? 16'd800 : memory[node_index][239:224];
	assign node.parent_node_id 		= node_index == -1 ? 16'h0 : memory[node_index][223:208];
	assign node.current_cost			= node_index == -1 ? 16'h0 : memory[node_index][207:192];
	assign node.child_one_id 			= node_index == -1 ? 16'h0 : memory[node_index][191:176];
	assign node.distance_child_one  	= node_index == -1 ? 16'h0 : memory[node_index][175:160];
	assign node.child_two_id 			= node_index == -1 ? 16'h0 : memory[node_index][159:144];
	assign node.distance_child_two	= node_index == -1 ? 16'h0 : memory[node_index][143:128];
	assign node.child_three_id 		= node_index == -1 ? 16'h0 : memory[node_index][127:112];
	assign node.distance_child_three = node_index == -1 ? 16'h0 : memory[node_index][111:96];
	assign node.child_four_id  		= node_index == -1 ? 16'h0 : memory[node_index][95:80];
	assign node.distance_child_four  = node_index == -1 ? 16'h0 : memory[node_index][79:64];
	assign node.child_five_id			= node_index == -1 ? 16'h0 : memory[node_index][63:48];
	assign node.distance_child_five	= node_index == -1 ? 16'h0 : memory[node_index][47:32];
	assign node.child_six_id			= node_index == -1 ? 16'h0 : memory[node_index][31:16];
	assign node.distance_child_six	= node_index == -1 ? 16'h0 : memory[node_index][15:0];

	assign child_one.x 							= child_one_index == -1 ? 16'h0 : memory[child_one_index][271:256];
	assign child_one.y 	 						= child_one_index == -1 ? 16'h0 : memory[child_one_index][255:240];
	assign child_one.node_id 					= child_one_index == -1 ? 16'd800 : memory[child_one_index][239:224];
	assign child_one.parent_node_id 			= node_index == -1 ? 16'h0 : memory[node_index][223:208];
	assign child_one.current_cost				= child_one_index == -1 ? 16'h0 : memory[child_one_index][207:192];
	assign child_one.child_one_id 			= child_one_index == -1 ? 16'h0 : memory[child_one_index][191:176];
	assign child_one.distance_child_one  	= child_one_index == -1 ? 16'h0 : memory[child_one_index][175:160];
	assign child_one.child_two_id 			= child_one_index == -1 ? 16'h0 : memory[child_one_index][159:144];
	assign child_one.distance_child_two		= child_one_index == -1 ? 16'h0 : memory[child_one_index][143:128];
	assign child_one.child_three_id 			= child_one_index == -1 ? 16'h0 : memory[child_one_index][127:112];
	assign child_one.distance_child_three 	= child_one_index == -1 ? 16'h0 : memory[child_one_index][111:96];
	assign child_one.child_four_id  			= child_one_index == -1 ? 16'h0 : memory[child_one_index][95:80];
	assign child_one.distance_child_four  	= child_one_index == -1 ? 16'h0 : memory[child_one_index][79:64];
	assign child_one.child_five_id			= child_one_index == -1 ? 16'h0 : memory[child_one_index][63:48];
	assign child_one.distance_child_five	= child_one_index == -1 ? 16'h0 : memory[child_one_index][47:32];
	assign child_one.child_six_id				= child_one_index == -1 ? 16'h0 : memory[child_one_index][31:16];
	assign child_one.distance_child_six		= child_one_index == -1 ? 16'h0 : memory[child_one_index][15:0];
	
	assign child_two.x 							= child_two_index == -1 ? 16'h0 : memory[child_two_index][271:256];
	assign child_two.y 	 						= child_two_index == -1 ? 16'h0 : memory[child_two_index][255:240];
	assign child_two.node_id 					= child_two_index == -1 ? 16'd800 : memory[child_two_index][239:224];
	assign child_two.parent_node_id 			= node_index == -1 ? 16'h0 : memory[node_index][223:208];
	assign child_two.current_cost				= child_two_index == -1 ? 16'h0 : memory[child_two_index][207:192];
	assign child_two.child_one_id 			= child_two_index == -1 ? 16'h0 : memory[child_two_index][191:176];
	assign child_two.distance_child_one  	= child_two_index == -1 ? 16'h0 : memory[child_two_index][175:160];
	assign child_two.child_two_id 			= child_two_index == -1 ? 16'h0 : memory[child_two_index][159:144];
	assign child_two.distance_child_two		= child_two_index == -1 ? 16'h0 : memory[child_two_index][143:128];
	assign child_two.child_three_id 			= child_two_index == -1 ? 16'h0 : memory[child_two_index][127:112];
	assign child_two.distance_child_three 	= child_two_index == -1 ? 16'h0 : memory[child_two_index][111:96];
	assign child_two.child_four_id  			= child_two_index == -1 ? 16'h0 : memory[child_two_index][95:80];
	assign child_two.distance_child_four  	= child_two_index == -1 ? 16'h0 : memory[child_two_index][79:64];
	assign child_two.child_five_id			= child_two_index == -1 ? 16'h0 : memory[child_two_index][63:48];
	assign child_two.distance_child_five	= child_two_index == -1 ? 16'h0 : memory[child_two_index][47:32];
	assign child_two.child_six_id				= child_two_index == -1 ? 16'h0 : memory[child_two_index][31:16];
	assign child_two.distance_child_six		= child_two_index == -1 ? 16'h0 : memory[child_two_index][15:0];
	
	assign child_three.x 							= child_three_index == -1 ? 16'h0 : memory[child_three_index][271:256];
	assign child_three.y 	 						= child_three_index == -1 ? 16'h0 : memory[child_three_index][255:240];
	assign child_three.node_id 					= child_three_index == -1 ? 16'd800 : memory[child_three_index][239:224];
	assign child_three.parent_node_id 			= node_index == -1 ? 16'h0 : memory[node_index][223:208];
	assign child_three.current_cost				= child_three_index == -1 ? 16'h0 : memory[child_three_index][207:192];
	assign child_three.child_one_id 				= child_three_index == -1 ? 16'h0 : memory[child_three_index][191:176];
	assign child_three.distance_child_one  	= child_three_index == -1 ? 16'h0 : memory[child_three_index][175:160];
	assign child_three.child_two_id 				= child_three_index == -1 ? 16'h0 : memory[child_three_index][159:144];
	assign child_three.distance_child_two		= child_three_index == -1 ? 16'h0 : memory[child_three_index][143:128];
	assign child_three.child_three_id 			= child_three_index == -1 ? 16'h0 : memory[child_three_index][127:112];
	assign child_three.distance_child_three	= child_three_index == -1 ? 16'h0 : memory[child_three_index][111:96];
	assign child_three.child_four_id  			= child_three_index == -1 ? 16'h0 : memory[child_three_index][95:80];
	assign child_three.distance_child_four 	= child_three_index == -1 ? 16'h0 : memory[child_three_index][79:64];
	assign child_three.child_five_id				= child_three_index == -1 ? 16'h0 : memory[child_three_index][63:48];
	assign child_three.distance_child_five		= child_three_index == -1 ? 16'h0 : memory[child_three_index][47:32];
	assign child_three.child_six_id				= child_three_index == -1 ? 16'h0 : memory[child_three_index][31:16];
	assign child_three.distance_child_six		= child_three_index == -1 ? 16'h0 : memory[child_three_index][15:0];
	
	assign child_four.x 							= child_four_index == -1 ? 16'h0 : memory[child_four_index][271:256];
	assign child_four.y 	 						= child_four_index == -1 ? 16'h0 : memory[child_four_index][255:240];
	assign child_four.node_id 					= child_four_index == -1 ? 16'd800 : memory[child_four_index][239:224];
	assign child_four.parent_node_id 		= node_index == -1 ? 16'h0 : memory[node_index][223:208];
	assign child_four.current_cost			= child_four_index == -1 ? 16'h0 : memory[child_four_index][207:192];
	assign child_four.child_one_id 			= child_four_index == -1 ? 16'h0 : memory[child_four_index][191:176];
	assign child_four.distance_child_one  	= child_four_index == -1 ? 16'h0 : memory[child_four_index][175:160];
	assign child_four.child_two_id 			= child_four_index == -1 ? 16'h0 : memory[child_four_index][159:144];
	assign child_four.distance_child_two	= child_four_index == -1 ? 16'h0 : memory[child_four_index][143:128];
	assign child_four.child_three_id 		= child_four_index == -1 ? 16'h0 : memory[child_four_index][127:112];
	assign child_four.distance_child_three = child_four_index == -1 ? 16'h0 : memory[child_four_index][111:96];
	assign child_four.child_four_id  		= child_four_index == -1 ? 16'h0 : memory[child_four_index][95:80];
	assign child_four.distance_child_four  = child_four_index == -1 ? 16'h0 : memory[child_four_index][79:64];
	assign child_four.child_five_id			= child_four_index == -1 ? 16'h0 : memory[child_four_index][63:48];
	assign child_four.distance_child_five	= child_four_index == -1 ? 16'h0 : memory[child_four_index][47:32];
	assign child_four.child_six_id			= child_four_index == -1 ? 16'h0 : memory[child_four_index][31:16];
	assign child_four.distance_child_six	= child_four_index == -1 ? 16'h0 : memory[child_four_index][15:0];
	
	assign child_five.x 							= child_five_index == -1 ? 16'h0 : memory[child_five_index][271:256];
	assign child_five.y 	 						= child_five_index == -1 ? 16'h0 : memory[child_five_index][255:240];
	assign child_five.node_id 					= child_five_index == -1 ? 16'd800 : memory[child_five_index][239:224];
	assign child_five.parent_node_id 		= node_index == -1 ? 16'h0 : memory[node_index][223:208];
	assign child_five.current_cost			= child_five_index == -1 ? 16'h0 : memory[child_five_index][207:192];
	assign child_five.child_one_id 			= child_five_index == -1 ? 16'h0 : memory[child_five_index][191:176];
	assign child_five.distance_child_one  	= child_five_index == -1 ? 16'h0 : memory[child_five_index][175:160];
	assign child_five.child_two_id 			= child_five_index == -1 ? 16'h0 : memory[child_five_index][159:144];
	assign child_five.distance_child_two	= child_five_index == -1 ? 16'h0 : memory[child_five_index][143:128];
	assign child_five.child_three_id 		= child_five_index == -1 ? 16'h0 : memory[child_five_index][127:112];
	assign child_five.distance_child_three = child_five_index == -1 ? 16'h0 : memory[child_five_index][111:96];
	assign child_five.child_four_id  		= child_five_index == -1 ? 16'h0 : memory[child_five_index][95:80];
	assign child_five.distance_child_four  = child_five_index == -1 ? 16'h0 : memory[child_five_index][79:64];
	assign child_five.child_five_id			= child_five_index == -1 ? 16'h0 : memory[child_five_index][63:48];
	assign child_five.distance_child_five	= child_five_index == -1 ? 16'h0 : memory[child_five_index][47:32];
	assign child_five.child_six_id			= child_five_index == -1 ? 16'h0 : memory[child_five_index][31:16];
	assign child_five.distance_child_six	= child_five_index == -1 ? 16'h0 : memory[child_five_index][15:0];
	
	assign child_six.x 							= child_six_index == -1 ? 16'h0 : memory[child_six_index][271:256];
	assign child_six.y 	 						= child_six_index == -1 ? 16'h0 : memory[child_six_index][255:240];
	assign child_six.node_id 					= child_six_index == -1 ? 16'd800 : memory[child_six_index][239:224];
	assign child_six.parent_node_id 			= node_index == -1 ? 16'h0 : memory[node_index][223:208];
	assign child_six.current_cost				= child_six_index == -1 ? 16'h0 : memory[child_six_index][207:192];
	assign child_six.child_one_id 			= child_six_index == -1 ? 16'h0 : memory[child_six_index][191:176];
	assign child_six.distance_child_one  	= child_six_index == -1 ? 16'h0 : memory[child_six_index][175:160];
	assign child_six.child_two_id 			= child_six_index == -1 ? 16'h0 : memory[child_six_index][159:144];
	assign child_six.distance_child_two		= child_six_index == -1 ? 16'h0 : memory[child_six_index][143:128];
	assign child_six.child_three_id 			= child_six_index == -1 ? 16'h0 : memory[child_six_index][127:112];
	assign child_six.distance_child_three 	= child_six_index == -1 ? 16'h0 : memory[child_six_index][111:96];
	assign child_six.child_four_id  			= child_six_index == -1 ? 16'h0 : memory[child_six_index][95:80];
	assign child_six.distance_child_four  	= child_six_index == -1 ? 16'h0 : memory[child_six_index][79:64];
	assign child_six.child_five_id			= child_six_index == -1 ? 16'h0 : memory[child_six_index][63:48];
	assign child_six.distance_child_five	= child_six_index == -1 ? 16'h0 : memory[child_six_index][47:32];
	assign child_six.child_six_id				= child_six_index == -1 ? 16'h0 : memory[child_six_index][31:16];
	assign child_six.distance_child_six		= child_six_index == -1 ? 16'h0 : memory[child_six_index][15:0];
endmodule
