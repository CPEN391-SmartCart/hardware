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

module node_mem_tb;

	logic clk;
	logic reset;
	logic [6:0] read_address;
	logic [271:0] read_data;
	
	//node_info start = '{16'h0010, 16'h0010, 16'h0013, 16'h0001, 16'h0010, 16'h0023, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000};

	node_info mem_node;
	//assign read_node = '{read_data[271:256], read_data[255:240], read_data[239:224], read_data[223:204], read_data[207:192], read_data[191:176], read_data[175:160], read_data[159:144], read_data[143:128], read_data[127:112], read_data[111:96], read_data[95:80], read_data[79:64], read_data[63:48], read_data[47:32], read_data[31:16], read_data[15:0]};
	
	Determined_Nodes_Mem node_mem(
		.clk(clk),
		.write_enable(1'b0),
		.write_address(7'b0),
		.write_data(272'b0),
		.read_address(read_address),
		.mem_node(mem_node)
	);
	
	logic [15:0] node_id;
	logic find_node;
	logic found;
	
	node_info node;
	node_info child_one;
	node_info child_two;
	node_info child_three;
	node_info child_four;
	node_info child_five;
	node_info child_six;
	
	Dijkstra_Mem_Reader node_mem_reader(
		.clk(clk),
		.reset(reset),
		.node_id(node_id),
		.find_node(find_node),
		.mem_node(mem_node),
		.read_address(read_address),
		.found(found),
		.node(node),
		.child_one(child_one),
		.child_two(child_two),
		.child_three(child_three),
		.child_four(child_four),
		.child_five(child_five),
		.child_six(child_six)
	);
	
	initial
	begin
		clk = 0;
	
		forever
		begin
			#10 clk =~clk;
		end
	end
	// Sending the test data inputs.
	initial
	begin
		reset = 0;
		#10;
		reset = 1;
		#20;
		reset = 0;
		#10;
		
		node_id = 16'h0017;
		#10;
		find_node = 1;
	end
endmodule
