module Dijkstra_TB;
	
	localparam MAX_NODES = 15;

	logic clk;
	logic reset;
	logic start;

	logic [8:0] start_id;
	logic [13:0] table_data [MAX_NODES-1:0];

	logic write_enable [MAX_NODES-1:0];
	logic [8:0] write_address [MAX_NODES-1:0];
	logic [13:0] write_data [MAX_NODES-1:0];
	logic [8:0] read_address [MAX_NODES-1:0];

	logic [13:0] read_data [MAX_NODES-1:0];

	Dijkstra_Table #(.MAX_NODES(MAX_NODES)) dijkstra_table(
		.clk(clk),
		.write_enable(write_enable),
		.write_address(write_address),
		.write_data(write_data),
		.read_address(read_address),
		.read_data(read_data)
	);

	logic table_initialized;

	Dijkstra_Table_Init #(.MAX_NODES(MAX_NODES)) dijkstra_table_init(
		.clk(clk),
		.reset(reset),
		.start(start),
		.write_enable(write_enable),
		.write_address(write_address),
		.write_data(write_data),
		.finished(table_initialized)
	);


	logic [13:0] distance [MAX_NODES-1:0];
	logic shortest [MAX_NODES-1:0];
	logic [8:0] neighbour [MAX_NODES-1:0];

	logic init_finished;
	logic [8:0] init_table_read_address [MAX_NODES-1:0];

	Dijkstra_Init #(.MAX_NODES(MAX_NODES)) init(
		.clk(clk),
		.reset(reset),
		.start(table_initialized),
		.start_id(start_id),
		.table_data(read_data),
		.distance(distance),
		.shortest(shortest),
		.neighbour(neighbour),
		.read_address(init_table_read_address),
		.in_progress(init_in_progress),
		.finished(init_finished)
	);

	logic [8:0] loop_table_read_address [MAX_NODES-1:0];
	logic [13:0] distance_out [MAX_NODES-1:0];
	logic [8:0] neighbour_out [MAX_NODES-1:0];
	logic loop_in_progress;
	logic loop_finished;

	Big_Loop #(.MAX_NODES(MAX_NODES)) loop(
		.clk(clk),
		.reset(reset),
		.start(init_finished),
		.table_data(read_data),
		.shortest(shortest),
		.distance(distance),
		.neighbour(neighbour),
		.table_read_address(loop_table_read_address),
		.distance_out(distance_out),
		.neighbour_out(neighbour_out),
		.in_progress(loop_in_progress),
		.finished(loop_finished)
	);

	assign read_address = init_in_progress ? init_table_read_address : loop_table_read_address;

	initial
	begin
		reset = 1;
		clk = 0;
	
		forever
		begin
			#10 clk =~clk;
		end
	end

	initial
	begin
		#20;
		reset = 0;
		#10;

		start_id = 9'd0; //change this to whatever node that is in the node map, 0 - 96 rn
		start = 1'b1;
		#20;
		start = 1'b0;

		//standard graphical simulation right now, too many nodes to test automatically
	end

endmodule