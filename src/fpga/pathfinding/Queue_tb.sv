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

module queue_tb;

	logic clk;
	logic reset;
	logic write_enable;
	logic [6:0] write_address;
	logic [271:0] write_data;
	logic [6:0] read_address;
	logic [271:0] read_data;
	
	//node_info start = '{16'h0010, 16'h0010, 16'h0013, 16'h0001, 16'h0010, 16'h0023, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000, 16'h0000};

	node_info read_node;
	assign read_node = '{read_data[271:256], read_data[255:240], read_data[239:224], read_data[223:204], read_data[207:192], read_data[191:176], read_data[175:160], read_data[159:144], read_data[143:128], read_data[127:112], read_data[111:96], read_data[95:80], read_data[79:64], read_data[63:48], read_data[47:32], read_data[31:16], read_data[15:0]};
	
	Queue_RAM queue(
		.clk(clk), 
		.write_enable(write_enable), 
		.write_address(write_address), 
		.write_data(write_data), 
		.read_address(read_address),
		.read_data(read_data)
	);
	
	logic find_minimum;
	logic finding_minimum;
	node_info minimum_node;
	logic [6:0] minimum_address;
	logic minimum_found;
	logic [6:0] minimum_read_address;
	
	Queue_Minimum_Node minimum(
		.clk(clk),
		.reset(reset),
		.find(find_minimum),
		.read_node(read_node),
		.finding_minimum(finding_minimum),
		.read_address(minimum_read_address),
		.minimum_node(minimum_node),
		.minimum_address(minimum_address),
		.done(minimum_found)
	);
	
	logic find_child;
	logic finding_child;
	node_info current_child;
	node_info child_from_queue;
	logic child_queued;
	logic [6:0] child_address;
	logic child_found;
	logic [6:0] child_read_address;
	
	Queue_Child child_queue(
		.clk(clk),
		.reset(reset),
		.find(find_child),
		.current_child(current_child),
		.read_node(read_node),
		.finding_child(finding_child),
		.read_address(child_read_address),
		.child_from_queue(child_from_queue),
		.child_queued(child_queued),
		.child_address(child_address),
		.done(child_found)
	);
	
	assign read_address = finding_minimum ? minimum_read_address : child_read_address;
	
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
		
		find_minimum = 1;
		#20;
		find_minimum = 0;
		
		#1000;
		current_child = '{16'd0, 16'd0, 16'h0016, 16'd800, 16'd800, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0};
		
		#50;
		find_child = 1;
		#20;
		find_child = 0;
	end
endmodule
