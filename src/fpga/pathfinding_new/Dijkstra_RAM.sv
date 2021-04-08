
module Dijkstra_RAM
#(
	parameter MAX_NODES = 15
)
(
	input logic clk,
	input logic write_enable,
	input logic [8:0] write_address,
	input logic [13:0] write_data,
	input logic [8:0] read_address,
	
	output logic [13:0] read_data
);	
	
	`ifdef ALTERA_RESERVED_QIS
		node_mem mem(
			.clock(clk),
			.data(write_data),
			.rdaddress(read_address),
			.wraddress(write_address),
			.wren(write_enable),
			.q(read_data)
		);
	`else 
		reg [13:0] mem [MAX_NODES-1:0] /* synthesis ramstyle = "no_rw_check, M10K" */;

		// initial begin
		// 	if ($urandom_range(0,1) == 1) begin
		// 		$readmemh("/home/jared/Desktop/smartcart/hardware/new_nodes.txt", mem);
		// 	end
		// 	else begin
		// 		$readmemh("/home/jared/Desktop/smartcart/hardware/new_nodes_other.txt", mem);
		// 	end
		// end
		
		always_ff @(posedge clk)
		begin
			if (write_enable) begin
				mem[write_address] <= write_data;
			end
			read_data <= mem[read_address];
		end
	`endif

endmodule : Dijkstra_RAM
