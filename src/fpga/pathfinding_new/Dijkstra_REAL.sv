`define INFINITY 14'd10000

module Dijkstra_Table
#(
	parameter MAX_NODES = 10
)
(
	input logic clk,
	input logic write_enable [MAX_NODES-1:0],
	input logic [8:0] write_address [MAX_NODES-1:0],
	input logic [13:0] write_data [MAX_NODES-1:0],
	input logic [8:0] read_address [MAX_NODES-1:0],

	output logic [13:0] read_data [MAX_NODES-1:0]
);

	genvar i;
	generate
		for (i=0; i<MAX_NODES; i=i+1) begin : init
			Dijkstra_RAM RAM(
				.clk		(clk),
				.write_enable(write_enable[i]),
				.write_address(write_address[i]),
				.write_data(write_data[i]),
				.read_address(read_address[i]),
				.read_data(read_data[i])
			);
		end
	endgenerate

endmodule : Dijkstra_Table

module Dijkstra_Table_Init
#(
	parameter MAX_NODES = 10
)
(
	input logic clk,
	input logic reset,
	input logic start,

	output logic write_enable [MAX_NODES-1:0],
	output logic [8:0] write_address [MAX_NODES-1:0],
	output logic [13:0] write_data [MAX_NODES-1:0],


	output logic finished
);

	localparam IDLE = 0;
	localparam START = 1;
	localparam WRITE = 2;
	localparam SET_ADDRESS = 3;
	localparam DONE = 4;

	logic [13:0] map_value;
	logic [8:0] row;

	logic [3:0] state;

	always_ff @(posedge clk)
	begin 
		if (reset)
			state <= IDLE;
		else
			case (state)
				IDLE: 
					if (start)
						state <= START;

				START: state <= WRITE;
				WRITE: state <= SET_ADDRESS;
				SET_ADDRESS:
					if (row < MAX_NODES-1)
						state <= WRITE;
					else
						state <= DONE;

				DONE: state <= IDLE;
			endcase
	end

	always_ff @(posedge clk)
	begin 
		case (state)
			IDLE: begin 
				finished <= 1'b0;
			end
			START: begin 
				row <= 0;
			end
			SET_ADDRESS: begin 
				row <= row + 1'b1;
			end
			DONE: begin 
				finished <= 1'b1;
			end
		endcase
	end

	genvar i;
	generate
		for (i=0; i<MAX_NODES; i=i+1) begin : init
			always_ff @(posedge clk)
			begin
				case (state)
					WRITE: begin
						write_enable[i] <= 1'b1;
						write_address[i] <= row;
						if (row == i) begin 
							write_data[i] <= 0;
						end
						else if ((row == 0 && i == 1)) begin
						 	write_data[i] <= 14'h0056;
						end
						else if ((row == 0 && i == 18)) begin
						 	write_data[i] <= 14'h001f;
						end
						else if ((row == 1 && i == 0)) begin
						 	write_data[i] <= 14'h0056;
						end
						else if ((row == 1 && i == 2)) begin
						 	write_data[i] <= 14'h001f;
						end
						else if ((row == 1 && i == 30)) begin
						 	write_data[i] <= 14'h007c;
						end
						else if ((row == 2 && i == 1)) begin
						 	write_data[i] <= 14'h001f;
						end
						else if ((row == 2 && i == 3)) begin
						 	write_data[i] <= 14'h0024;
						end
						else if ((row == 2 && i == 18)) begin
						 	write_data[i] <= 14'h0056;
						end
						else if ((row == 2 && i == 31)) begin
						 	write_data[i] <= 14'h007c;
						end
						else if ((row == 2 && i == 83)) begin
						 	write_data[i] <= 14'h0031;
						end
						else if ((row == 3 && i == 2)) begin
						 	write_data[i] <= 14'h0024;
						end
						else if ((row == 3 && i == 4)) begin
						 	write_data[i] <= 14'h0023;
						end
						else if ((row == 3 && i == 19)) begin
						 	write_data[i] <= 14'h0056;
						end
						else if ((row == 3 && i == 32)) begin
						 	write_data[i] <= 14'h007c;
						end
						else if ((row == 4 && i == 3)) begin
						 	write_data[i] <= 14'h0023;
						end
						else if ((row == 4 && i == 5)) begin
						 	write_data[i] <= 14'h0025;
						end
						else if ((row == 4 && i == 20)) begin
						 	write_data[i] <= 14'h0056;
						end
						else if ((row == 4 && i == 33)) begin
						 	write_data[i] <= 14'h007c;
						end
						else if ((row == 4 && i == 84)) begin
						 	write_data[i] <= 14'h0046;
						end
						else if ((row == 5 && i == 4)) begin
						 	write_data[i] <= 14'h0025;
						end
						else if ((row == 5 && i == 6)) begin
						 	write_data[i] <= 14'h0024;
						end
						else if ((row == 5 && i == 21)) begin
						 	write_data[i] <= 14'h0056;
						end
						else if ((row == 5 && i == 34)) begin
						 	write_data[i] <= 14'h007c;
						end
						else if ((row == 5 && i == 86)) begin
						 	write_data[i] <= 14'h003b;
						end
						else if ((row == 6 && i == 5)) begin
						 	write_data[i] <= 14'h0024;
						end
						else if ((row == 6 && i == 7)) begin
						 	write_data[i] <= 14'h0024;
						end
						else if ((row == 6 && i == 22)) begin
						 	write_data[i] <= 14'h0056;
						end
						else if ((row == 6 && i == 35)) begin
						 	write_data[i] <= 14'h007c;
						end
						else if ((row == 6 && i == 89)) begin
						 	write_data[i] <= 14'h00c1;
						end
						else if ((row == 7 && i == 6)) begin
						 	write_data[i] <= 14'h0024;
						end
						else if ((row == 7 && i == 8)) begin
						 	write_data[i] <= 14'h001e;
						end
						else if ((row == 7 && i == 23)) begin
						 	write_data[i] <= 14'h0056;
						end
						else if ((row == 7 && i == 93)) begin
						 	write_data[i] <= 14'h0186;
						end
						else if ((row == 8 && i == 7)) begin
						 	write_data[i] <= 14'h001e;
						end
						else if ((row == 8 && i == 9)) begin
						 	write_data[i] <= 14'h0026;
						end
						else if ((row == 8 && i == 36)) begin
						 	write_data[i] <= 14'h005e;
						end
						else if ((row == 8 && i == 93)) begin
						 	write_data[i] <= 14'h0168;
						end
						else if ((row == 9 && i == 8)) begin
						 	write_data[i] <= 14'h0026;
						end
						else if ((row == 9 && i == 10)) begin
						 	write_data[i] <= 14'h003e;
						end
						else if ((row == 9 && i == 12)) begin
						 	write_data[i] <= 14'h002c;
						end
						else if ((row == 9 && i == 37)) begin
						 	write_data[i] <= 14'h005e;
						end
						else if ((row == 9 && i == 93)) begin
						 	write_data[i] <= 14'h016a;
						end
						else if ((row == 9 && i == 98)) begin
						 	write_data[i] <= 14'h0076;
						end
						else if ((row == 10 && i == 9)) begin
						 	write_data[i] <= 14'h003e;
						end
						else if ((row == 10 && i == 11)) begin
						 	write_data[i] <= 14'h002c;
						end
						else if ((row == 10 && i == 24)) begin
						 	write_data[i] <= 14'h0036;
						end
						else if ((row == 10 && i == 85)) begin
						 	write_data[i] <= 14'h001b;
						end
						else if ((row == 10 && i == 93)) begin
						 	write_data[i] <= 14'h01a8;
						end
						else if ((row == 10 && i == 98)) begin
						 	write_data[i] <= 14'h00b3;
						end
						else if ((row == 11 && i == 10)) begin
						 	write_data[i] <= 14'h002c;
						end
						else if ((row == 11 && i == 12)) begin
						 	write_data[i] <= 14'h003e;
						end
						else if ((row == 11 && i == 25)) begin
						 	write_data[i] <= 14'h0036;
						end
						else if ((row == 11 && i == 85)) begin
						 	write_data[i] <= 14'h001a;
						end
						else if ((row == 11 && i == 98)) begin
						 	write_data[i] <= 14'h00b2;
						end
						else if ((row == 12 && i == 9)) begin
						 	write_data[i] <= 14'h002c;
						end
						else if ((row == 12 && i == 11)) begin
						 	write_data[i] <= 14'h003e;
						end
						else if ((row == 12 && i == 13)) begin
						 	write_data[i] <= 14'h0025;
						end
						else if ((row == 12 && i == 38)) begin
						 	write_data[i] <= 14'h005e;
						end
						else if ((row == 12 && i == 98)) begin
						 	write_data[i] <= 14'h0075;
						end
						else if ((row == 13 && i == 12)) begin
						 	write_data[i] <= 14'h0025;
						end
						else if ((row == 13 && i == 17)) begin
						 	write_data[i] <= 14'h0009;
						end
						else if ((row == 13 && i == 39)) begin
						 	write_data[i] <= 14'h005e;
						end
						else if ((row == 14 && i == 15)) begin
						 	write_data[i] <= 14'h0022;
						end
						else if ((row == 14 && i == 17)) begin
						 	write_data[i] <= 14'h0020;
						end
						else if ((row == 14 && i == 27)) begin
						 	write_data[i] <= 14'h006b;
						end
						else if ((row == 14 && i == 40)) begin
						 	write_data[i] <= 14'h0067;
						end
						else if ((row == 14 && i == 87)) begin
						 	write_data[i] <= 14'h003d;
						end
						else if ((row == 15 && i == 14)) begin
						 	write_data[i] <= 14'h0022;
						end
						else if ((row == 15 && i == 16)) begin
						 	write_data[i] <= 14'h0020;
						end
						else if ((row == 15 && i == 28)) begin
						 	write_data[i] <= 14'h006b;
						end
						else if ((row == 15 && i == 41)) begin
						 	write_data[i] <= 14'h0067;
						end
						else if ((row == 16 && i == 15)) begin
						 	write_data[i] <= 14'h0020;
						end
						else if ((row == 16 && i == 29)) begin
						 	write_data[i] <= 14'h006b;
						end
						else if ((row == 16 && i == 42)) begin
						 	write_data[i] <= 14'h0067;
						end
						else if ((row == 16 && i == 96)) begin
						 	write_data[i] <= 14'h0050;
						end
						else if ((row == 17 && i == 13)) begin
						 	write_data[i] <= 14'h0009;
						end
						else if ((row == 17 && i == 14)) begin
						 	write_data[i] <= 14'h0020;
						end
						else if ((row == 17 && i == 26)) begin
						 	write_data[i] <= 14'h006b;
						end
						else if ((row == 18 && i == 0)) begin
						 	write_data[i] <= 14'h001f;
						end
						else if ((row == 18 && i == 2)) begin
						 	write_data[i] <= 14'h0056;
						end
						else if ((row == 18 && i == 19)) begin
						 	write_data[i] <= 14'h0024;
						end
						else if ((row == 18 && i == 83)) begin
						 	write_data[i] <= 14'h0027;
						end
						else if ((row == 19 && i == 3)) begin
						 	write_data[i] <= 14'h0056;
						end
						else if ((row == 19 && i == 18)) begin
						 	write_data[i] <= 14'h0024;
						end
						else if ((row == 19 && i == 20)) begin
						 	write_data[i] <= 14'h0023;
						end
						else if ((row == 20 && i == 4)) begin
						 	write_data[i] <= 14'h0056;
						end
						else if ((row == 20 && i == 19)) begin
						 	write_data[i] <= 14'h0023;
						end
						else if ((row == 20 && i == 21)) begin
						 	write_data[i] <= 14'h0025;
						end
						else if ((row == 20 && i == 84)) begin
						 	write_data[i] <= 14'h009c;
						end
						else if ((row == 21 && i == 5)) begin
						 	write_data[i] <= 14'h0056;
						end
						else if ((row == 21 && i == 20)) begin
						 	write_data[i] <= 14'h0025;
						end
						else if ((row == 21 && i == 22)) begin
						 	write_data[i] <= 14'h0024;
						end
						else if ((row == 21 && i == 86)) begin
						 	write_data[i] <= 14'h001c;
						end
						else if ((row == 22 && i == 6)) begin
						 	write_data[i] <= 14'h0056;
						end
						else if ((row == 22 && i == 21)) begin
						 	write_data[i] <= 14'h0024;
						end
						else if ((row == 22 && i == 23)) begin
						 	write_data[i] <= 14'h0024;
						end
						else if ((row == 23 && i == 7)) begin
						 	write_data[i] <= 14'h0056;
						end
						else if ((row == 23 && i == 22)) begin
						 	write_data[i] <= 14'h0024;
						end
						else if ((row == 23 && i == 24)) begin
						 	write_data[i] <= 14'h0026;
						end
						else if ((row == 23 && i == 93)) begin
						 	write_data[i] <= 14'h01dc;
						end
						else if ((row == 24 && i == 10)) begin
						 	write_data[i] <= 14'h0036;
						end
						else if ((row == 24 && i == 23)) begin
						 	write_data[i] <= 14'h0026;
						end
						else if ((row == 24 && i == 25)) begin
						 	write_data[i] <= 14'h002c;
						end
						else if ((row == 25 && i == 11)) begin
						 	write_data[i] <= 14'h0036;
						end
						else if ((row == 25 && i == 24)) begin
						 	write_data[i] <= 14'h002c;
						end
						else if ((row == 25 && i == 26)) begin
						 	write_data[i] <= 14'h0025;
						end
						else if ((row == 26 && i == 17)) begin
						 	write_data[i] <= 14'h006b;
						end
						else if ((row == 26 && i == 25)) begin
						 	write_data[i] <= 14'h0025;
						end
						else if ((row == 26 && i == 27)) begin
						 	write_data[i] <= 14'h0020;
						end
						else if ((row == 27 && i == 14)) begin
						 	write_data[i] <= 14'h006b;
						end
						else if ((row == 27 && i == 26)) begin
						 	write_data[i] <= 14'h0020;
						end
						else if ((row == 27 && i == 28)) begin
						 	write_data[i] <= 14'h0022;
						end
						else if ((row == 27 && i == 87)) begin
						 	write_data[i] <= 14'h00a8;
						end
						else if ((row == 28 && i == 15)) begin
						 	write_data[i] <= 14'h006b;
						end
						else if ((row == 28 && i == 27)) begin
						 	write_data[i] <= 14'h0022;
						end
						else if ((row == 28 && i == 29)) begin
						 	write_data[i] <= 14'h0020;
						end
						else if ((row == 29 && i == 16)) begin
						 	write_data[i] <= 14'h006b;
						end
						else if ((row == 29 && i == 28)) begin
						 	write_data[i] <= 14'h0020;
						end
						else if ((row == 29 && i == 96)) begin
						 	write_data[i] <= 14'h001b;
						end
						else if ((row == 30 && i == 1)) begin
						 	write_data[i] <= 14'h007c;
						end
						else if ((row == 30 && i == 31)) begin
						 	write_data[i] <= 14'h001f;
						end
						else if ((row == 30 && i == 78)) begin
						 	write_data[i] <= 14'h0037;
						end
						else if ((row == 30 && i == 97)) begin
						 	write_data[i] <= 14'h0034;
						end
						else if ((row == 30 && i == 98)) begin
						 	write_data[i] <= 14'h0113;
						end
						else if ((row == 31 && i == 2)) begin
						 	write_data[i] <= 14'h007c;
						end
						else if ((row == 31 && i == 30)) begin
						 	write_data[i] <= 14'h001f;
						end
						else if ((row == 31 && i == 32)) begin
						 	write_data[i] <= 14'h0024;
						end
						else if ((row == 31 && i == 83)) begin
						 	write_data[i] <= 14'h00ac;
						end
						else if ((row == 31 && i == 97)) begin
						 	write_data[i] <= 14'h001c;
						end
						else if ((row == 31 && i == 98)) begin
						 	write_data[i] <= 14'h00f4;
						end
						else if ((row == 32 && i == 3)) begin
						 	write_data[i] <= 14'h007c;
						end
						else if ((row == 32 && i == 31)) begin
						 	write_data[i] <= 14'h0024;
						end
						else if ((row == 32 && i == 33)) begin
						 	write_data[i] <= 14'h0023;
						end
						else if ((row == 32 && i == 97)) begin
						 	write_data[i] <= 14'h001e;
						end
						else if ((row == 32 && i == 98)) begin
						 	write_data[i] <= 14'h00d0;
						end
						else if ((row == 33 && i == 4)) begin
						 	write_data[i] <= 14'h007c;
						end
						else if ((row == 33 && i == 32)) begin
						 	write_data[i] <= 14'h0023;
						end
						else if ((row == 33 && i == 34)) begin
						 	write_data[i] <= 14'h0025;
						end
						else if ((row == 33 && i == 84)) begin
						 	write_data[i] <= 14'h0036;
						end
						else if ((row == 33 && i == 97)) begin
						 	write_data[i] <= 14'h003c;
						end
						else if ((row == 33 && i == 98)) begin
						 	write_data[i] <= 14'h00ad;
						end
						else if ((row == 34 && i == 5)) begin
						 	write_data[i] <= 14'h007c;
						end
						else if ((row == 34 && i == 33)) begin
						 	write_data[i] <= 14'h0025;
						end
						else if ((row == 34 && i == 35)) begin
						 	write_data[i] <= 14'h0024;
						end
						else if ((row == 34 && i == 86)) begin
						 	write_data[i] <= 14'h00b7;
						end
						else if ((row == 34 && i == 97)) begin
						 	write_data[i] <= 14'h005f;
						end
						else if ((row == 34 && i == 98)) begin
						 	write_data[i] <= 14'h0089;
						end
						else if ((row == 35 && i == 6)) begin
						 	write_data[i] <= 14'h007c;
						end
						else if ((row == 35 && i == 34)) begin
						 	write_data[i] <= 14'h0024;
						end
						else if ((row == 35 && i == 36)) begin
						 	write_data[i] <= 14'h0024;
						end
						else if ((row == 35 && i == 46)) begin
						 	write_data[i] <= 14'h0045;
						end
						else if ((row == 35 && i == 70)) begin
						 	write_data[i] <= 14'h0037;
						end
						else if ((row == 35 && i == 89)) begin
						 	write_data[i] <= 14'h0046;
						end
						else if ((row == 35 && i == 97)) begin
						 	write_data[i] <= 14'h0082;
						end
						else if ((row == 35 && i == 98)) begin
						 	write_data[i] <= 14'h0065;
						end
						else if ((row == 36 && i == 8)) begin
						 	write_data[i] <= 14'h005e;
						end
						else if ((row == 36 && i == 35)) begin
						 	write_data[i] <= 14'h0024;
						end
						else if ((row == 36 && i == 37)) begin
						 	write_data[i] <= 14'h0026;
						end
						else if ((row == 36 && i == 46)) begin
						 	write_data[i] <= 14'h0030;
						end
						else if ((row == 36 && i == 93)) begin
						 	write_data[i] <= 14'h010a;
						end
						else if ((row == 36 && i == 97)) begin
						 	write_data[i] <= 14'h00a6;
						end
						else if ((row == 36 && i == 98)) begin
						 	write_data[i] <= 14'h0042;
						end
						else if ((row == 37 && i == 9)) begin
						 	write_data[i] <= 14'h005e;
						end
						else if ((row == 37 && i == 36)) begin
						 	write_data[i] <= 14'h0026;
						end
						else if ((row == 37 && i == 38)) begin
						 	write_data[i] <= 14'h002c;
						end
						else if ((row == 37 && i == 46)) begin
						 	write_data[i] <= 14'h0033;
						end
						else if ((row == 37 && i == 97)) begin
						 	write_data[i] <= 14'h00cb;
						end
						else if ((row == 37 && i == 98)) begin
						 	write_data[i] <= 14'h0021;
						end
						else if ((row == 38 && i == 12)) begin
						 	write_data[i] <= 14'h005e;
						end
						else if ((row == 38 && i == 37)) begin
						 	write_data[i] <= 14'h002c;
						end
						else if ((row == 38 && i == 39)) begin
						 	write_data[i] <= 14'h0025;
						end
						else if ((row == 38 && i == 97)) begin
						 	write_data[i] <= 14'h00f7;
						end
						else if ((row == 38 && i == 98)) begin
						 	write_data[i] <= 14'h001c;
						end
						else if ((row == 39 && i == 13)) begin
						 	write_data[i] <= 14'h005e;
						end
						else if ((row == 39 && i == 38)) begin
						 	write_data[i] <= 14'h0025;
						end
						else if ((row == 39 && i == 40)) begin
						 	write_data[i] <= 14'h0020;
						end
						else if ((row == 39 && i == 97)) begin
						 	write_data[i] <= 14'h011c;
						end
						else if ((row == 39 && i == 98)) begin
						 	write_data[i] <= 14'h003c;
						end
						else if ((row == 40 && i == 14)) begin
						 	write_data[i] <= 14'h0067;
						end
						else if ((row == 40 && i == 39)) begin
						 	write_data[i] <= 14'h0020;
						end
						else if ((row == 40 && i == 41)) begin
						 	write_data[i] <= 14'h0022;
						end
						else if ((row == 40 && i == 87)) begin
						 	write_data[i] <= 14'h002a;
						end
						else if ((row == 40 && i == 97)) begin
						 	write_data[i] <= 14'h013c;
						end
						else if ((row == 40 && i == 98)) begin
						 	write_data[i] <= 14'h005a;
						end
						else if ((row == 41 && i == 15)) begin
						 	write_data[i] <= 14'h0067;
						end
						else if ((row == 41 && i == 40)) begin
						 	write_data[i] <= 14'h0022;
						end
						else if ((row == 41 && i == 42)) begin
						 	write_data[i] <= 14'h0020;
						end
						else if ((row == 41 && i == 43)) begin
						 	write_data[i] <= 14'h0030;
						end
						else if ((row == 41 && i == 97)) begin
						 	write_data[i] <= 14'h015e;
						end
						else if ((row == 41 && i == 98)) begin
						 	write_data[i] <= 14'h007c;
						end
						else if ((row == 42 && i == 16)) begin
						 	write_data[i] <= 14'h0067;
						end
						else if ((row == 42 && i == 41)) begin
						 	write_data[i] <= 14'h0020;
						end
						else if ((row == 42 && i == 43)) begin
						 	write_data[i] <= 14'h0032;
						end
						else if ((row == 42 && i == 96)) begin
						 	write_data[i] <= 14'h00b7;
						end
						else if ((row == 42 && i == 97)) begin
						 	write_data[i] <= 14'h017e;
						end
						else if ((row == 42 && i == 98)) begin
						 	write_data[i] <= 14'h009b;
						end
						else if ((row == 43 && i == 41)) begin
						 	write_data[i] <= 14'h0030;
						end
						else if ((row == 43 && i == 42)) begin
						 	write_data[i] <= 14'h0032;
						end
						else if ((row == 43 && i == 44)) begin
						 	write_data[i] <= 14'h001d;
						end
						else if ((row == 43 && i == 46)) begin
						 	write_data[i] <= 14'h00b7;
						end
						else if ((row == 44 && i == 43)) begin
						 	write_data[i] <= 14'h001d;
						end
						else if ((row == 44 && i == 45)) begin
						 	write_data[i] <= 14'h001c;
						end
						else if ((row == 44 && i == 47)) begin
						 	write_data[i] <= 14'h00b7;
						end
						else if ((row == 44 && i == 88)) begin
						 	write_data[i] <= 14'h0086;
						end
						else if ((row == 45 && i == 44)) begin
						 	write_data[i] <= 14'h001c;
						end
						else if ((row == 45 && i == 48)) begin
						 	write_data[i] <= 14'h00b7;
						end
						else if ((row == 45 && i == 51)) begin
						 	write_data[i] <= 14'h001f;
						end
						else if ((row == 46 && i == 35)) begin
						 	write_data[i] <= 14'h0045;
						end
						else if ((row == 46 && i == 36)) begin
						 	write_data[i] <= 14'h0030;
						end
						else if ((row == 46 && i == 37)) begin
						 	write_data[i] <= 14'h0033;
						end
						else if ((row == 46 && i == 43)) begin
						 	write_data[i] <= 14'h00b7;
						end
						else if ((row == 46 && i == 47)) begin
						 	write_data[i] <= 14'h001d;
						end
						else if ((row == 46 && i == 93)) begin
						 	write_data[i] <= 14'h00dd;
						end
						else if ((row == 47 && i == 44)) begin
						 	write_data[i] <= 14'h00b7;
						end
						else if ((row == 47 && i == 46)) begin
						 	write_data[i] <= 14'h001d;
						end
						else if ((row == 47 && i == 48)) begin
						 	write_data[i] <= 14'h001c;
						end
						else if ((row == 47 && i == 88)) begin
						 	write_data[i] <= 14'h0031;
						end
						else if ((row == 47 && i == 93)) begin
						 	write_data[i] <= 14'h00c0;
						end
						else if ((row == 48 && i == 45)) begin
						 	write_data[i] <= 14'h00b7;
						end
						else if ((row == 48 && i == 47)) begin
						 	write_data[i] <= 14'h001c;
						end
						else if ((row == 48 && i == 49)) begin
						 	write_data[i] <= 14'h001f;
						end
						else if ((row == 48 && i == 93)) begin
						 	write_data[i] <= 14'h00a4;
						end
						else if ((row == 49 && i == 48)) begin
						 	write_data[i] <= 14'h001f;
						end
						else if ((row == 49 && i == 50)) begin
						 	write_data[i] <= 14'h0068;
						end
						else if ((row == 49 && i == 61)) begin
						 	write_data[i] <= 14'h0030;
						end
						else if ((row == 49 && i == 93)) begin
						 	write_data[i] <= 14'h0085;
						end
						else if ((row == 50 && i == 49)) begin
						 	write_data[i] <= 14'h0068;
						end
						else if ((row == 50 && i == 51)) begin
						 	write_data[i] <= 14'h004f;
						end
						else if ((row == 50 && i == 60)) begin
						 	write_data[i] <= 14'h0030;
						end
						else if ((row == 51 && i == 45)) begin
						 	write_data[i] <= 14'h001f;
						end
						else if ((row == 51 && i == 50)) begin
						 	write_data[i] <= 14'h004f;
						end
						else if ((row == 51 && i == 52)) begin
						 	write_data[i] <= 14'h0013;
						end
						else if ((row == 52 && i == 51)) begin
						 	write_data[i] <= 14'h0013;
						end
						else if ((row == 52 && i == 53)) begin
						 	write_data[i] <= 14'h002a;
						end
						else if ((row == 52 && i == 96)) begin
						 	write_data[i] <= 14'h0143;
						end
						else if ((row == 53 && i == 52)) begin
						 	write_data[i] <= 14'h002a;
						end
						else if ((row == 53 && i == 54)) begin
						 	write_data[i] <= 14'h002f;
						end
						else if ((row == 53 && i == 60)) begin
						 	write_data[i] <= 14'h0061;
						end
						else if ((row == 53 && i == 94)) begin
						 	write_data[i] <= 14'h002b;
						end
						else if ((row == 53 && i == 96)) begin
						 	write_data[i] <= 14'h016d;
						end
						else if ((row == 54 && i == 53)) begin
						 	write_data[i] <= 14'h002f;
						end
						else if ((row == 54 && i == 55)) begin
						 	write_data[i] <= 14'h0031;
						end
						else if ((row == 54 && i == 59)) begin
						 	write_data[i] <= 14'h0061;
						end
						else if ((row == 54 && i == 96)) begin
						 	write_data[i] <= 14'h019c;
						end
						else if ((row == 55 && i == 54)) begin
						 	write_data[i] <= 14'h0031;
						end
						else if ((row == 55 && i == 56)) begin
						 	write_data[i] <= 14'h0027;
						end
						else if ((row == 55 && i == 58)) begin
						 	write_data[i] <= 14'h0061;
						end
						else if ((row == 55 && i == 93)) begin
						 	write_data[i] <= 14'h00d8;
						end
						else if ((row == 55 && i == 95)) begin
						 	write_data[i] <= 14'h0097;
						end
						else if ((row == 55 && i == 96)) begin
						 	write_data[i] <= 14'h01cd;
						end
						else if ((row == 56 && i == 55)) begin
						 	write_data[i] <= 14'h0027;
						end
						else if ((row == 56 && i == 57)) begin
						 	write_data[i] <= 14'h0061;
						end
						else if ((row == 56 && i == 92)) begin
						 	write_data[i] <= 14'h0124;
						end
						else if ((row == 56 && i == 96)) begin
						 	write_data[i] <= 14'h01f4;
						end
						else if ((row == 57 && i == 56)) begin
						 	write_data[i] <= 14'h0061;
						end
						else if ((row == 57 && i == 58)) begin
						 	write_data[i] <= 14'h0027;
						end
						else if ((row == 57 && i == 64)) begin
						 	write_data[i] <= 14'h0068;
						end
						else if ((row == 57 && i == 92)) begin
						 	write_data[i] <= 14'h00c3;
						end
						else if ((row == 58 && i == 55)) begin
						 	write_data[i] <= 14'h0061;
						end
						else if ((row == 58 && i == 57)) begin
						 	write_data[i] <= 14'h0027;
						end
						else if ((row == 58 && i == 59)) begin
						 	write_data[i] <= 14'h0031;
						end
						else if ((row == 58 && i == 63)) begin
						 	write_data[i] <= 14'h0068;
						end
						else if ((row == 58 && i == 93)) begin
						 	write_data[i] <= 14'h0078;
						end
						else if ((row == 58 && i == 95)) begin
						 	write_data[i] <= 14'h0037;
						end
						else if ((row == 59 && i == 54)) begin
						 	write_data[i] <= 14'h0061;
						end
						else if ((row == 59 && i == 58)) begin
						 	write_data[i] <= 14'h0031;
						end
						else if ((row == 59 && i == 60)) begin
						 	write_data[i] <= 14'h002f;
						end
						else if ((row == 59 && i == 62)) begin
						 	write_data[i] <= 14'h0068;
						end
						else if ((row == 60 && i == 50)) begin
						 	write_data[i] <= 14'h0030;
						end
						else if ((row == 60 && i == 53)) begin
						 	write_data[i] <= 14'h0061;
						end
						else if ((row == 60 && i == 59)) begin
						 	write_data[i] <= 14'h002f;
						end
						else if ((row == 60 && i == 61)) begin
						 	write_data[i] <= 14'h0068;
						end
						else if ((row == 60 && i == 94)) begin
						 	write_data[i] <= 14'h003b;
						end
						else if ((row == 61 && i == 49)) begin
						 	write_data[i] <= 14'h0030;
						end
						else if ((row == 61 && i == 60)) begin
						 	write_data[i] <= 14'h0068;
						end
						else if ((row == 61 && i == 62)) begin
						 	write_data[i] <= 14'h002f;
						end
						else if ((row == 61 && i == 68)) begin
						 	write_data[i] <= 14'h002f;
						end
						else if ((row == 61 && i == 93)) begin
						 	write_data[i] <= 14'h0055;
						end
						else if ((row == 61 && i == 94)) begin
						 	write_data[i] <= 14'h00a2;
						end
						else if ((row == 62 && i == 59)) begin
						 	write_data[i] <= 14'h0068;
						end
						else if ((row == 62 && i == 61)) begin
						 	write_data[i] <= 14'h002f;
						end
						else if ((row == 62 && i == 63)) begin
						 	write_data[i] <= 14'h0031;
						end
						else if ((row == 62 && i == 93)) begin
						 	write_data[i] <= 14'h0028;
						end
						else if ((row == 63 && i == 58)) begin
						 	write_data[i] <= 14'h0068;
						end
						else if ((row == 63 && i == 62)) begin
						 	write_data[i] <= 14'h0031;
						end
						else if ((row == 63 && i == 64)) begin
						 	write_data[i] <= 14'h0027;
						end
						else if ((row == 63 && i == 93)) begin
						 	write_data[i] <= 14'h0013;
						end
						else if ((row == 63 && i == 95)) begin
						 	write_data[i] <= 14'h0033;
						end
						else if ((row == 64 && i == 57)) begin
						 	write_data[i] <= 14'h0068;
						end
						else if ((row == 64 && i == 63)) begin
						 	write_data[i] <= 14'h0027;
						end
						else if ((row == 64 && i == 65)) begin
						 	write_data[i] <= 14'h002f;
						end
						else if ((row == 64 && i == 92)) begin
						 	write_data[i] <= 14'h005b;
						end
						else if ((row == 64 && i == 93)) begin
						 	write_data[i] <= 14'h0035;
						end
						else if ((row == 65 && i == 64)) begin
						 	write_data[i] <= 14'h002f;
						end
						else if ((row == 65 && i == 66)) begin
						 	write_data[i] <= 14'h0028;
						end
						else if ((row == 65 && i == 82)) begin
						 	write_data[i] <= 14'h00b3;
						end
						else if ((row == 65 && i == 89)) begin
						 	write_data[i] <= 14'h00f9;
						end
						else if ((row == 65 && i == 92)) begin
						 	write_data[i] <= 14'h002c;
						end
						else if ((row == 66 && i == 65)) begin
						 	write_data[i] <= 14'h0028;
						end
						else if ((row == 66 && i == 67)) begin
						 	write_data[i] <= 14'h0031;
						end
						else if ((row == 66 && i == 81)) begin
						 	write_data[i] <= 14'h00b3;
						end
						else if ((row == 66 && i == 89)) begin
						 	write_data[i] <= 14'h00d1;
						end
						else if ((row == 66 && i == 91)) begin
						 	write_data[i] <= 14'h006b;
						end
						else if ((row == 67 && i == 66)) begin
						 	write_data[i] <= 14'h0031;
						end
						else if ((row == 67 && i == 68)) begin
						 	write_data[i] <= 14'h0030;
						end
						else if ((row == 67 && i == 80)) begin
						 	write_data[i] <= 14'h00b3;
						end
						else if ((row == 67 && i == 89)) begin
						 	write_data[i] <= 14'h00a0;
						end
						else if ((row == 68 && i == 61)) begin
						 	write_data[i] <= 14'h002f;
						end
						else if ((row == 68 && i == 67)) begin
						 	write_data[i] <= 14'h0030;
						end
						else if ((row == 68 && i == 69)) begin
						 	write_data[i] <= 14'h002d;
						end
						else if ((row == 68 && i == 79)) begin
						 	write_data[i] <= 14'h00b3;
						end
						else if ((row == 68 && i == 89)) begin
						 	write_data[i] <= 14'h0071;
						end
						else if ((row == 68 && i == 94)) begin
						 	write_data[i] <= 14'h00d0;
						end
						else if ((row == 69 && i == 68)) begin
						 	write_data[i] <= 14'h002d;
						end
						else if ((row == 69 && i == 70)) begin
						 	write_data[i] <= 14'h0050;
						end
						else if ((row == 69 && i == 72)) begin
						 	write_data[i] <= 14'h002f;
						end
						else if ((row == 69 && i == 89)) begin
						 	write_data[i] <= 14'h0044;
						end
						else if ((row == 70 && i == 35)) begin
						 	write_data[i] <= 14'h0037;
						end
						else if ((row == 70 && i == 69)) begin
						 	write_data[i] <= 14'h0050;
						end
						else if ((row == 70 && i == 71)) begin
						 	write_data[i] <= 14'h002f;
						end
						else if ((row == 70 && i == 89)) begin
						 	write_data[i] <= 14'h0012;
						end
						else if ((row == 71 && i == 70)) begin
						 	write_data[i] <= 14'h002f;
						end
						else if ((row == 71 && i == 72)) begin
						 	write_data[i] <= 14'h0050;
						end
						else if ((row == 71 && i == 74)) begin
						 	write_data[i] <= 14'h0030;
						end
						else if ((row == 71 && i == 89)) begin
						 	write_data[i] <= 14'h003c;
						end
						else if ((row == 72 && i == 69)) begin
						 	write_data[i] <= 14'h002f;
						end
						else if ((row == 72 && i == 71)) begin
						 	write_data[i] <= 14'h0050;
						end
						else if ((row == 72 && i == 73)) begin
						 	write_data[i] <= 14'h0030;
						end
						else if ((row == 73 && i == 72)) begin
						 	write_data[i] <= 14'h0030;
						end
						else if ((row == 73 && i == 74)) begin
						 	write_data[i] <= 14'h0050;
						end
						else if ((row == 73 && i == 76)) begin
						 	write_data[i] <= 14'h002f;
						end
						else if ((row == 74 && i == 71)) begin
						 	write_data[i] <= 14'h0030;
						end
						else if ((row == 74 && i == 73)) begin
						 	write_data[i] <= 14'h0050;
						end
						else if ((row == 74 && i == 75)) begin
						 	write_data[i] <= 14'h002f;
						end
						else if ((row == 75 && i == 74)) begin
						 	write_data[i] <= 14'h002f;
						end
						else if ((row == 75 && i == 76)) begin
						 	write_data[i] <= 14'h0050;
						end
						else if ((row == 75 && i == 78)) begin
						 	write_data[i] <= 14'h0025;
						end
						else if ((row == 75 && i == 90)) begin
						 	write_data[i] <= 14'h0034;
						end
						else if ((row == 76 && i == 73)) begin
						 	write_data[i] <= 14'h002f;
						end
						else if ((row == 76 && i == 75)) begin
						 	write_data[i] <= 14'h0050;
						end
						else if ((row == 76 && i == 77)) begin
						 	write_data[i] <= 14'h0025;
						end
						else if ((row == 76 && i == 90)) begin
						 	write_data[i] <= 14'h0021;
						end
						else if ((row == 77 && i == 76)) begin
						 	write_data[i] <= 14'h0025;
						end
						else if ((row == 77 && i == 78)) begin
						 	write_data[i] <= 14'h0050;
						end
						else if ((row == 77 && i == 79)) begin
						 	write_data[i] <= 14'h002d;
						end
						else if ((row == 78 && i == 30)) begin
						 	write_data[i] <= 14'h0037;
						end
						else if ((row == 78 && i == 75)) begin
						 	write_data[i] <= 14'h0025;
						end
						else if ((row == 78 && i == 77)) begin
						 	write_data[i] <= 14'h0050;
						end
						else if ((row == 79 && i == 68)) begin
						 	write_data[i] <= 14'h00b3;
						end
						else if ((row == 79 && i == 77)) begin
						 	write_data[i] <= 14'h002d;
						end
						else if ((row == 79 && i == 80)) begin
						 	write_data[i] <= 14'h0030;
						end
						else if ((row == 79 && i == 94)) begin
						 	write_data[i] <= 14'h0183;
						end
						else if ((row == 80 && i == 67)) begin
						 	write_data[i] <= 14'h00b3;
						end
						else if ((row == 80 && i == 79)) begin
						 	write_data[i] <= 14'h0030;
						end
						else if ((row == 80 && i == 81)) begin
						 	write_data[i] <= 14'h0031;
						end
						else if ((row == 81 && i == 66)) begin
						 	write_data[i] <= 14'h00b3;
						end
						else if ((row == 81 && i == 80)) begin
						 	write_data[i] <= 14'h0031;
						end
						else if ((row == 81 && i == 82)) begin
						 	write_data[i] <= 14'h0028;
						end
						else if ((row == 81 && i == 91)) begin
						 	write_data[i] <= 14'h004a;
						end
						else if ((row == 82 && i == 65)) begin
						 	write_data[i] <= 14'h00b3;
						end
						else if ((row == 82 && i == 81)) begin
						 	write_data[i] <= 14'h0028;
						end
						else if ((row == 82 && i == 92)) begin
						 	write_data[i] <= 14'h0087;
						end
						else if ((row == 83 && i == 2)) begin
						 	write_data[i] <= 14'h0031;
						end
						else if ((row == 83 && i == 18)) begin
						 	write_data[i] <= 14'h0027;
						end
						else if ((row == 83 && i == 31)) begin
						 	write_data[i] <= 14'h00ac;
						end
						else if ((row == 84 && i == 4)) begin
						 	write_data[i] <= 14'h0046;
						end
						else if ((row == 84 && i == 20)) begin
						 	write_data[i] <= 14'h009c;
						end
						else if ((row == 84 && i == 33)) begin
						 	write_data[i] <= 14'h0036;
						end
						else if ((row == 85 && i == 10)) begin
						 	write_data[i] <= 14'h001b;
						end
						else if ((row == 85 && i == 11)) begin
						 	write_data[i] <= 14'h001a;
						end
						else if ((row == 86 && i == 5)) begin
						 	write_data[i] <= 14'h003b;
						end
						else if ((row == 86 && i == 21)) begin
						 	write_data[i] <= 14'h001c;
						end
						else if ((row == 86 && i == 34)) begin
						 	write_data[i] <= 14'h00b7;
						end
						else if ((row == 87 && i == 14)) begin
						 	write_data[i] <= 14'h003d;
						end
						else if ((row == 87 && i == 27)) begin
						 	write_data[i] <= 14'h00a8;
						end
						else if ((row == 87 && i == 40)) begin
						 	write_data[i] <= 14'h002a;
						end
						else if ((row == 88 && i == 44)) begin
						 	write_data[i] <= 14'h0086;
						end
						else if ((row == 88 && i == 47)) begin
						 	write_data[i] <= 14'h0031;
						end
						else if ((row == 89 && i == 6)) begin
						 	write_data[i] <= 14'h00c1;
						end
						else if ((row == 89 && i == 35)) begin
						 	write_data[i] <= 14'h0046;
						end
						else if ((row == 89 && i == 65)) begin
						 	write_data[i] <= 14'h00f9;
						end
						else if ((row == 89 && i == 66)) begin
						 	write_data[i] <= 14'h00d1;
						end
						else if ((row == 89 && i == 67)) begin
						 	write_data[i] <= 14'h00a0;
						end
						else if ((row == 89 && i == 68)) begin
						 	write_data[i] <= 14'h0071;
						end
						else if ((row == 89 && i == 69)) begin
						 	write_data[i] <= 14'h0044;
						end
						else if ((row == 89 && i == 70)) begin
						 	write_data[i] <= 14'h0012;
						end
						else if ((row == 89 && i == 71)) begin
						 	write_data[i] <= 14'h003c;
						end
						else if ((row == 90 && i == 75)) begin
						 	write_data[i] <= 14'h0034;
						end
						else if ((row == 90 && i == 76)) begin
						 	write_data[i] <= 14'h0021;
						end
						else if ((row == 91 && i == 66)) begin
						 	write_data[i] <= 14'h006b;
						end
						else if ((row == 91 && i == 81)) begin
						 	write_data[i] <= 14'h004a;
						end
						else if ((row == 92 && i == 56)) begin
						 	write_data[i] <= 14'h0124;
						end
						else if ((row == 92 && i == 57)) begin
						 	write_data[i] <= 14'h00c3;
						end
						else if ((row == 92 && i == 64)) begin
						 	write_data[i] <= 14'h005b;
						end
						else if ((row == 92 && i == 65)) begin
						 	write_data[i] <= 14'h002c;
						end
						else if ((row == 92 && i == 82)) begin
						 	write_data[i] <= 14'h0087;
						end
						else if ((row == 93 && i == 7)) begin
						 	write_data[i] <= 14'h0186;
						end
						else if ((row == 93 && i == 8)) begin
						 	write_data[i] <= 14'h0168;
						end
						else if ((row == 93 && i == 9)) begin
						 	write_data[i] <= 14'h016a;
						end
						else if ((row == 93 && i == 10)) begin
						 	write_data[i] <= 14'h01a8;
						end
						else if ((row == 93 && i == 23)) begin
						 	write_data[i] <= 14'h01dc;
						end
						else if ((row == 93 && i == 36)) begin
						 	write_data[i] <= 14'h010a;
						end
						else if ((row == 93 && i == 46)) begin
						 	write_data[i] <= 14'h00dd;
						end
						else if ((row == 93 && i == 47)) begin
						 	write_data[i] <= 14'h00c0;
						end
						else if ((row == 93 && i == 48)) begin
						 	write_data[i] <= 14'h00a4;
						end
						else if ((row == 93 && i == 49)) begin
						 	write_data[i] <= 14'h0085;
						end
						else if ((row == 93 && i == 55)) begin
						 	write_data[i] <= 14'h00d8;
						end
						else if ((row == 93 && i == 58)) begin
						 	write_data[i] <= 14'h0078;
						end
						else if ((row == 93 && i == 61)) begin
						 	write_data[i] <= 14'h0055;
						end
						else if ((row == 93 && i == 62)) begin
						 	write_data[i] <= 14'h0028;
						end
						else if ((row == 93 && i == 63)) begin
						 	write_data[i] <= 14'h0013;
						end
						else if ((row == 93 && i == 64)) begin
						 	write_data[i] <= 14'h0035;
						end
						else if ((row == 93 && i == 95)) begin
						 	write_data[i] <= 14'h0045;
						end
						else if ((row == 94 && i == 53)) begin
						 	write_data[i] <= 14'h002b;
						end
						else if ((row == 94 && i == 60)) begin
						 	write_data[i] <= 14'h003b;
						end
						else if ((row == 94 && i == 61)) begin
						 	write_data[i] <= 14'h00a2;
						end
						else if ((row == 94 && i == 68)) begin
						 	write_data[i] <= 14'h00d0;
						end
						else if ((row == 94 && i == 79)) begin
						 	write_data[i] <= 14'h0183;
						end
						else if ((row == 95 && i == 55)) begin
						 	write_data[i] <= 14'h0097;
						end
						else if ((row == 95 && i == 58)) begin
						 	write_data[i] <= 14'h0037;
						end
						else if ((row == 95 && i == 63)) begin
						 	write_data[i] <= 14'h0033;
						end
						else if ((row == 95 && i == 93)) begin
						 	write_data[i] <= 14'h0045;
						end
						else if ((row == 96 && i == 16)) begin
						 	write_data[i] <= 14'h0050;
						end
						else if ((row == 96 && i == 29)) begin
						 	write_data[i] <= 14'h001b;
						end
						else if ((row == 96 && i == 42)) begin
						 	write_data[i] <= 14'h00b7;
						end
						else if ((row == 96 && i == 52)) begin
						 	write_data[i] <= 14'h0143;
						end
						else if ((row == 96 && i == 53)) begin
						 	write_data[i] <= 14'h016d;
						end
						else if ((row == 96 && i == 54)) begin
						 	write_data[i] <= 14'h019c;
						end
						else if ((row == 96 && i == 55)) begin
						 	write_data[i] <= 14'h01cd;
						end
						else if ((row == 96 && i == 56)) begin
						 	write_data[i] <= 14'h01f4;
						end
						else if ((row == 97 && i == 30)) begin
						 	write_data[i] <= 14'h0034;
						end
						else if ((row == 97 && i == 31)) begin
						 	write_data[i] <= 14'h001c;
						end
						else if ((row == 97 && i == 32)) begin
						 	write_data[i] <= 14'h001e;
						end
						else if ((row == 97 && i == 33)) begin
						 	write_data[i] <= 14'h003c;
						end
						else if ((row == 97 && i == 34)) begin
						 	write_data[i] <= 14'h005f;
						end
						else if ((row == 97 && i == 35)) begin
						 	write_data[i] <= 14'h0082;
						end
						else if ((row == 97 && i == 36)) begin
						 	write_data[i] <= 14'h00a6;
						end
						else if ((row == 97 && i == 37)) begin
						 	write_data[i] <= 14'h00cb;
						end
						else if ((row == 97 && i == 38)) begin
						 	write_data[i] <= 14'h00f7;
						end
						else if ((row == 97 && i == 39)) begin
						 	write_data[i] <= 14'h011c;
						end
						else if ((row == 97 && i == 40)) begin
						 	write_data[i] <= 14'h013c;
						end
						else if ((row == 97 && i == 41)) begin
						 	write_data[i] <= 14'h015e;
						end
						else if ((row == 97 && i == 42)) begin
						 	write_data[i] <= 14'h017e;
						end
						else if ((row == 98 && i == 9)) begin
						 	write_data[i] <= 14'h0076;
						end
						else if ((row == 98 && i == 10)) begin
						 	write_data[i] <= 14'h00b3;
						end
						else if ((row == 98 && i == 11)) begin
						 	write_data[i] <= 14'h00b2;
						end
						else if ((row == 98 && i == 12)) begin
						 	write_data[i] <= 14'h0075;
						end
						else if ((row == 98 && i == 30)) begin
						 	write_data[i] <= 14'h0113;
						end
						else if ((row == 98 && i == 31)) begin
						 	write_data[i] <= 14'h00f4;
						end
						else if ((row == 98 && i == 32)) begin
						 	write_data[i] <= 14'h00d0;
						end
						else if ((row == 98 && i == 33)) begin
						 	write_data[i] <= 14'h00ad;
						end
						else if ((row == 98 && i == 34)) begin
						 	write_data[i] <= 14'h0089;
						end
						else if ((row == 98 && i == 35)) begin
						 	write_data[i] <= 14'h0065;
						end
						else if ((row == 98 && i == 36)) begin
						 	write_data[i] <= 14'h0042;
						end
						else if ((row == 98 && i == 37)) begin
						 	write_data[i] <= 14'h0021;
						end
						else if ((row == 98 && i == 38)) begin
						 	write_data[i] <= 14'h001c;
						end
						else if ((row == 98 && i == 39)) begin
						 	write_data[i] <= 14'h003c;
						end
						else if ((row == 98 && i == 40)) begin
						 	write_data[i] <= 14'h005a;
						end
						else if ((row == 98 && i == 41)) begin
						 	write_data[i] <= 14'h007c;
						end
						else if ((row == 98 && i == 42)) begin
						 	write_data[i] <= 14'h009b;
						end
						else begin 
							write_data[i] <= `INFINITY;
						end
					end
					SET_ADDRESS: begin 
						write_enable[i] <= 1'b0;
					end
				endcase
			end
		end
	endgenerate



endmodule : Dijkstra_Table_Init

module Dijkstra_Init
#(
	parameter MAX_NODES = 10
)
(
	input logic clk,
	input logic reset,
	input logic start,
	input logic [8:0] start_id,

	input logic [13:0] table_data [MAX_NODES-1:0],

	output logic [13:0] distance [MAX_NODES-1:0],
	output logic shortest [MAX_NODES-1:0],
	output logic [8:0] neighbour [MAX_NODES-1:0],

	output logic [8:0] read_address [MAX_NODES-1:0],

	output logic in_progress,
	output logic finished
);

	enum logic [2:0] {
		IDLE,
		START,
		WAIT_READ,
		READ,
		DONE
	} state;

	always_ff @(posedge clk)
	begin 
		if (reset)
			state <= IDLE;
		else
			case (state)
				IDLE:
					if (start)
						state <= START;

				START: state <= WAIT_READ;
				WAIT_READ: state <= READ;
				READ: state <= DONE;

				DONE: state <= IDLE;
			endcase
	end

	always_ff @(posedge clk)
	begin 
		case (state)
			IDLE: begin
				finished <= 1'b0;
			end
			START: begin 
				in_progress <= 1'b1;
			end
			DONE: begin
				finished <= 1'b1;
				in_progress <= 1'b0;
			end
		endcase
	end

	genvar i;
	generate
		for (i=0; i<MAX_NODES; i=i+1) begin : init
			always_ff @(posedge clk)
			begin
				case (state)
					START: begin 
						shortest[i] <= 1'b0;
						neighbour[i] <= start_id;
						read_address[i] <= start_id;
					end
					READ: begin
						distance[i] <= table_data[i];
					end
					DONE: begin
						if (i == start_id) begin
							shortest[i] <= 1'b1;
						end
					end
				endcase
			end
		end
	endgenerate

endmodule : Dijkstra_Init


module Big_Loop
#(
	parameter MAX_NODES = 10
)
(
	input logic clk,
	input logic reset,
	input logic start,

	input logic [13:0] table_data [MAX_NODES-1:0],

	input logic shortest [MAX_NODES-1:0],
	input logic [13:0] distance [MAX_NODES-1:0],
	input logic [8:0] neighbour [MAX_NODES-1:0],

	output logic [8:0] table_read_address [MAX_NODES-1:0],

	output logic [13:0] distance_out [MAX_NODES-1:0],
	output logic [8:0] neighbour_out [MAX_NODES-1:0],
	output logic in_progress,
	output logic finished
);

	logic start_first_loop;
	logic [8:0] new_min_cost_id;
	logic first_loop_finished;

	logic first_shortest [MAX_NODES-1:0];
	logic [13:0] first_distance [MAX_NODES-1:0];
	logic [8:0] first_neighbour [MAX_NODES-1:0];

	First_Small_Loop #(.MAX_NODES(MAX_NODES)) first_loop(
		.clk            (clk),
		.reset          (reset),
		.start          (start_first_loop),
		.shortest       (first_shortest),
		.distance       (first_distance),
		.new_min_cost_id(new_min_cost_id),
		.finished       (first_loop_finished)
	);

	logic start_second_loop;
	logic second_loop_finished;
	logic shortest_out [MAX_NODES-1:0];

	Second_Small_Loop #(.MAX_NODES(MAX_NODES)) second_loop(
		.clk               (clk),
		.reset             (reset),
		.start             (start_second_loop),
		.table_data        (table_data),
		.new_min_cost_id   (new_min_cost_id),
		.shortest          (first_shortest),
		.distance          (first_distance),
		.neighbour         (first_neighbour),
		.table_read_address(table_read_address),
		.shortest_out      (shortest_out),
		.distance_out	   (distance_out),
		.neighbour_out     (neighbour_out),
		.finished          (second_loop_finished)
	);

	always_ff @(posedge clk)
	begin 
		if (start) begin 
			first_shortest <= shortest;
			first_distance <= distance;
			first_neighbour <= neighbour;
		end
		else if (second_loop_finished) begin 
			first_shortest <= shortest_out;
			first_distance <= distance_out;
			first_neighbour <= neighbour_out;
		end
	end

	logic [8:0] i_address;

	enum logic [3:0] {
		IDLE,
		START,

		START_FIRST_LOOP_HIGH,
		START_FIRST_LOOP_LOW,
		START_FIRST_LOOP_DONE,

		START_SECOND_LOOP_HIGH,
		START_SECOND_LOOP_LOW,
		START_SECOND_LOOP_DONE,

		SET_ADDRESS,

		DONE
	} state;

	always_ff @(posedge clk)
	begin 
		if (reset)
			state <= IDLE;
		else
			case (state)
				IDLE: 
					if (start)
						state <= START;

				START: state <= START_FIRST_LOOP_HIGH;
				
				START_FIRST_LOOP_HIGH: state <= START_FIRST_LOOP_LOW;
				START_FIRST_LOOP_LOW: state <= START_FIRST_LOOP_DONE;
				START_FIRST_LOOP_DONE:
					if (first_loop_finished)
						state <= START_SECOND_LOOP_HIGH;

				START_SECOND_LOOP_HIGH: state <= START_SECOND_LOOP_LOW;
				START_SECOND_LOOP_LOW: state <= START_SECOND_LOOP_DONE;
				START_SECOND_LOOP_DONE:
					if (second_loop_finished)
						state <= SET_ADDRESS;

				SET_ADDRESS:
					if (i_address < MAX_NODES-1)
						state <= START_FIRST_LOOP_HIGH;
					else
						state <= DONE;

				DONE: state <= IDLE;
			endcase
	end

	always_ff @(posedge clk)
	begin 
		case (state)
			IDLE: begin 
				finished <= 1'b0;
			end
			START: begin 
				i_address <= 1;
				in_progress <= 1'b1;
			end

			START_FIRST_LOOP_HIGH: begin 
				start_first_loop <= 1'b1;
			end
			START_FIRST_LOOP_LOW: begin 
				start_first_loop <= 1'b0;
			end

			START_SECOND_LOOP_HIGH: begin 
				start_second_loop <= 1'b1;
			end
			START_SECOND_LOOP_LOW: begin 
				start_second_loop <= 1'b0;
			end

			SET_ADDRESS: begin 
				i_address <= i_address + 1'b1;
			end

			DONE: begin 
				finished <= 1'b1;
				in_progress <= 1'b0;
			end
		endcase // state
	end

endmodule : Big_Loop

module First_Small_Loop
#(
	parameter MAX_NODES = 10
)
(
	input logic clk,
	input logic reset,
	input logic start,

	input logic shortest [MAX_NODES-1:0],
	input logic [13:0] distance [MAX_NODES-1:0],

	output logic [8:0] new_min_cost_id,

	output logic finished
);

	enum logic [3:0] {
		IDLE,
		START,
		WAIT_READ_SHORTEST,
		READ_SHORTEST,
		WAIT_READ_DISTANCE,
		READ_DISTANCE,
		ACT,
		SET_ADDRESS,
		DONE
	} state;

	logic [8:0] j_address;
	logic shortest_j;
	logic [13:0] distance_j;
	logic [13:0] min_dist;

	always_ff @(posedge clk)
	begin 
		if (reset)
			state <= IDLE;
		else
			case (state)
				IDLE: 
					if (start)
						state <= START;

				START: state <= WAIT_READ_SHORTEST;
				WAIT_READ_SHORTEST: state <= READ_SHORTEST;
				READ_SHORTEST: state <= WAIT_READ_DISTANCE;
				WAIT_READ_DISTANCE: state <= READ_DISTANCE;
				READ_DISTANCE: state <= ACT;
				ACT: state <= SET_ADDRESS;
				SET_ADDRESS:
					if (j_address < MAX_NODES-1)
						state <= WAIT_READ_SHORTEST;
					else
						state <= DONE;

				DONE: state <= IDLE;
			endcase
	end

	always_ff @(posedge clk)
	begin 
		case (state)
			IDLE: begin 
				finished <= 1'b0;
			end
			START: begin 
				j_address <= 0;
				new_min_cost_id <= 0;
				min_dist <= `INFINITY;
			end
			READ_SHORTEST: begin 
				shortest_j <= shortest[j_address];
			end
			READ_DISTANCE: begin 
				distance_j <= distance[j_address];
			end
			ACT: begin 
				if (!shortest_j && min_dist > distance_j) begin 
					min_dist <= distance_j;
					new_min_cost_id <= j_address;
				end
			end
			SET_ADDRESS: begin 
				j_address <= j_address + 1'b1;
			end
			DONE: begin 
				finished <= 1'b1;
			end
		endcase
	end

endmodule : First_Small_Loop

module Map_new_j
#(
	parameter MAX_NODES = 10
)
(
	input logic clk,
	input logic reset,
	input logic start,
	input logic [8:0] new_min_cost_id,
	input logic [8:0] j_address,

	input logic [13:0] table_data [MAX_NODES-1:0],
	output logic [8:0] read_address [MAX_NODES-1:0],

	output logic [13:0] map_new_j,
	output logic finished
);

	enum logic [3:0] {
		IDLE,
		START,
		WAIT_READ,
		READ,
		DONE
	} state;

	always_ff @(posedge clk)
	begin 
		if (reset)
			state <= IDLE;
		else
			case (state)
				IDLE:
					if (start)
						state <= START;

				START: state <= WAIT_READ;
				WAIT_READ: state <= READ;
				READ: state <= DONE;

				DONE: state <= IDLE;
			endcase
	end

	always_ff @(posedge clk)
	begin 
		case (state)
			IDLE: begin 
				finished <= 1'b0;
			end

			DONE: begin 
				finished <= 1'b1;
			end
		endcase
	end
	
	logic [13:0] map_new_j_many [MAX_NODES-1:0];

	genvar i;
	generate
		for (i=0; i<MAX_NODES; i=i+1) begin : init
			always_ff @(posedge clk)
			begin
				case (state)
					START: begin 
						read_address[i] <= new_min_cost_id;
					end
					READ: begin
						if (i == j_address) begin 
							map_new_j_many[i] <= table_data[i];
						end
					end
				endcase
			end
		end
	endgenerate
	
	assign map_new_j = map_new_j_many[j_address];

endmodule : Map_new_j

module Second_Small_Loop
#(
	parameter MAX_NODES = 10
)
(
	input logic clk,
	input logic reset,
	input logic start,

	input logic [13:0] table_data [MAX_NODES-1:0],

	input logic [8:0] new_min_cost_id,
	input logic shortest [MAX_NODES-1:0],
	input logic [13:0] distance [MAX_NODES-1:0],
	input logic [8:0] neighbour [MAX_NODES-1:0],

	output logic [8:0] table_read_address [MAX_NODES-1:0],

	output logic shortest_out [MAX_NODES-1:0],
	output logic [13:0] distance_out [MAX_NODES-1:0],
	output logic [8:0] neighbour_out [MAX_NODES-1:0],
 
	output logic finished
);

	logic [13:0] map_new_j;
	logic [8:0] j_address;
	logic map_new_j_finished;
	logic map_new_j_start;

	Map_new_j #(.MAX_NODES(MAX_NODES)) map(
		.clk            (clk),
		.reset          (reset),
		.start          (map_new_j_start),
		.new_min_cost_id(new_min_cost_id),
		.j_address      (j_address),
		.table_data     (table_data),
		.read_address   (table_read_address),
		.map_new_j      (map_new_j),
		.finished       (map_new_j_finished)
	);

	logic shortest_j;
	logic [13:0] distance_j;
	logic [13:0] distance_new;

	enum logic [4:0] {
		IDLE,
		START,

		WRITE_SHORTEST_NEW,
		WRITE_SHORTEST_NEW_LOW,
		
		WAIT_READ_DISTANCE_NEW,
		READ_DISTANCE_NEW,

		WAIT_READ_MAP_NEW_J_HIGH,
		WAIT_READ_MAP_NEW_J_LOW,
		WAIT_READ_MAP_NEW_J_DONE,

		WAIT_READ_SHORTEST_J,
		READ_SHORTEST_J,

		WAIT_READ_DISTANCE_J,
		READ_DISTANCE_J,

		ACT,
		WRITE,

		SET_ADDRESS,

		DONE
	} state;

	always_ff @(posedge clk)
	begin 
		if (reset)
			state <= IDLE;
		else
			case (state)
				IDLE: 
					if (start)
						state <= START;

				START: state <= WRITE_SHORTEST_NEW;

				WRITE_SHORTEST_NEW: state <= WRITE_SHORTEST_NEW_LOW;
				WRITE_SHORTEST_NEW_LOW: state <= WAIT_READ_DISTANCE_NEW;
	
				WAIT_READ_DISTANCE_NEW: state <= READ_DISTANCE_NEW;
				READ_DISTANCE_NEW: state <= WAIT_READ_MAP_NEW_J_HIGH;

				WAIT_READ_MAP_NEW_J_HIGH: state <= WAIT_READ_MAP_NEW_J_LOW;
				WAIT_READ_MAP_NEW_J_LOW: state <= WAIT_READ_MAP_NEW_J_DONE;
				WAIT_READ_MAP_NEW_J_DONE:
					if (map_new_j_finished)
						state <= WAIT_READ_SHORTEST_J;

				WAIT_READ_SHORTEST_J: state <= READ_SHORTEST_J;
				READ_SHORTEST_J: state <= WAIT_READ_DISTANCE_J;

				WAIT_READ_DISTANCE_J: state <= READ_DISTANCE_J;
				READ_DISTANCE_J: state <= ACT;
				ACT:
					if ((!shortest_j && map_new_j < `INFINITY) && ((distance_new + map_new_j) < distance_j))
						state <= WRITE;
					else
						state <= SET_ADDRESS;

				WRITE: state <= SET_ADDRESS;

				SET_ADDRESS:
					if (j_address < MAX_NODES-1)
						state <= WAIT_READ_MAP_NEW_J_HIGH;
					else
						state <= DONE;
	
				DONE: state <= IDLE;
			endcase // state
	end

	always_ff @(posedge clk)
	begin 
		case (state)
			IDLE: begin 
				finished <= 1'b0;
			end

			START: begin 
				j_address <= 0;
				distance_out <= distance;
				neighbour_out <= neighbour;
				shortest_out <= shortest;
			end

			WRITE_SHORTEST_NEW: begin 
				shortest_out[new_min_cost_id] <= 1'b1;
			end

			READ_DISTANCE_NEW: begin
				distance_new <= distance[new_min_cost_id];
			end

			WAIT_READ_MAP_NEW_J_HIGH: begin 
				map_new_j_start <= 1'b1;
			end
			WAIT_READ_MAP_NEW_J_LOW: begin 
				map_new_j_start <= 1'b0;
			end

			READ_SHORTEST_J: begin 
				shortest_j <= shortest[j_address];
			end

			READ_DISTANCE_J: begin 
				distance_j <= distance[j_address];
			end

			WRITE: begin 
				distance_out[j_address] <= distance_new + map_new_j;
				neighbour_out[j_address] <= new_min_cost_id;
			end

			SET_ADDRESS: begin 
				j_address <= j_address + 1'b1;
			end

			DONE: begin 
				finished <= 1'b1;
			end
		endcase
	end

endmodule : Second_Small_Loop