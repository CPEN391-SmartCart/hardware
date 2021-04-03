typedef struct packed {
	logic [9:0] x;
	logic [9:0] y;
} map_node;

// {10, 10, 32}

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

module Queue_RAM
#(
	parameter MAX_NODES = 100
)
(
	input logic clk,
	input logic write_enable,
	input logic [6:0] write_address,
	input node_info write_data,
	input logic [6:0] read_address,
	
	output node_info queue_node
);
	
	logic [271:0] read_data;
	
	node_mem mem(
		.clock(clk),
		.data(write_data),
		.rdaddress(read_address),
		.wraddress(write_address),
		.wren(write_enable),
		.q(read_data)
	);

	/*
	reg [271:0] mem [MAX_NODES-1:0] /* synthesis ramstyle = "no_rw_check, M10K" */
	/*
	always_ff @(posedge clk)
	begin
		if (write_enable) begin
			mem[write_address] <= write_data;
		end
		read_data <= mem[read_address];
	end
	*/
	
	assign queue_node = '{read_data[271:256], read_data[255:240], read_data[239:224], read_data[223:208], read_data[207:192], read_data[191:176], read_data[175:160], read_data[159:144], read_data[143:128], read_data[127:112], read_data[111:96], read_data[95:80], read_data[79:64], read_data[63:48], read_data[47:32], read_data[31:16], read_data[15:0]};
endmodule

module Queue_Minimum_Node
#(
	parameter MAX_NODES = 100
)
(
	input logic clk,
	input logic reset,
	input logic find,
	input node_info read_node,
	
	output logic finding_minimum,
	output logic [6:0] read_address,
	output node_info minimum_node,
	output logic [6:0] minimum_address,
	output logic done
);
	
	localparam IDLE 			= 3'b000;
	localparam START			= 3'b001;
	localparam SET_ADDRESS	= 3'b010;
	localparam WAIT_READ		= 3'b011;
	localparam READ			= 3'b100;
	localparam DONE			= 3'b101;

	logic [2:0] state;
	
	always_ff @(posedge clk)
	begin
		if (reset)
			state <= IDLE;
		else
			case (state)
				IDLE:
					if (find)
						state <= START;
						
				START: state <= WAIT_READ;
				WAIT_READ: state <= READ;
				READ:
					if (read_node.node_id == 16'b0)
						state <= DONE;
					else if (read_address < MAX_NODES)
						state <= SET_ADDRESS;
					else
						state <= DONE;
				SET_ADDRESS: state <= WAIT_READ;
						
				DONE: state <= IDLE;
			endcase
	end

	always_ff @(posedge clk)
	begin
		case (state)
			IDLE: begin
				done <= 1'b0;
				read_address <= 7'b0;	
			end
			START: begin
				finding_minimum <= 1'b1;
				minimum_node <= '{16'd0, 16'd0, 16'd800, 16'd800, 16'd800, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0};
				minimum_address <= 7'b0;
			end
			READ: begin
				if (read_node.current_cost < minimum_node.current_cost && read_node.node_id != 16'b0) begin
					minimum_node <= read_node;
					minimum_address <= read_address;
				end
			end
			SET_ADDRESS: begin
				read_address <= read_address + 1'b1;
			end
			DONE: begin
				finding_minimum <= 1'b0;
				done <= 1'b1;
			end
		endcase
	end
	
endmodule

module Queue_Child
#(
	parameter MAX_NODES = 100
)
(
	input logic clk,
	input logic reset,
	input logic find,
	input node_info current_child,
	input node_info read_node,
	
	output logic finding_child,
	output logic [6:0] read_address,
	output node_info child_from_queue,
	output logic child_queued,
	output logic [6:0] child_address,
	output logic done
);
	
	localparam IDLE 			= 3'b000;
	localparam START			= 3'b001;
	localparam SET_ADDRESS	= 3'b010;
	localparam WAIT_READ		= 3'b011;
	localparam READ			= 3'b100;
	localparam DONE			= 3'b101;


	logic [2:0] state;
	
	always_ff @(posedge clk)
	begin
		if (reset)
			state <= IDLE;
		else
			case (state)
				IDLE:
					if (find)
						state <= START;
						
				START: state <= WAIT_READ;
				WAIT_READ: state <= READ;
				READ:
					if (read_node.node_id == 16'b0 || read_node.node_id == current_child.node_id)
						state <= DONE;
					else if (read_address < MAX_NODES)
						state <= SET_ADDRESS;
					else
						state <= DONE;
				SET_ADDRESS: state <= WAIT_READ;
						
				DONE: state <= IDLE;
			endcase
	end

	always_ff @(posedge clk)
	begin
		case (state)
			IDLE: begin
				done <= 1'b0;
				read_address <= 7'b0;
				child_queued <= 1'b0;
				child_from_queue <= '{0, 0, 16'd800, 16'd800, 16'd800, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0, 16'd0};
				child_address <= 7'b0;
			end
			START: begin
				finding_child <= 1'b1;
			end
			READ: begin
				if (read_node.node_id == current_child.node_id && current_child.node_id != 16'd800) begin
					child_from_queue <= read_node;
					child_address <= read_address;
					child_queued = 1'b1;
				end
			end
			SET_ADDRESS: begin
				read_address <= read_address + 1'b1;
			end
			DONE: begin
				finding_child <= 1'b0;
				done <= 1'b1;
			end
		endcase
	end
	
endmodule