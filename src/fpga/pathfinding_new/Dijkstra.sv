
module Init_Dijkstra (
	input logic clk,
	input logic reset,
	input logic start,

	input logic [8:0] address,
	input logic [13:0] distance,

	output logic done
);

	enum logic [2:0] {
		IDLE,
		START,
		SETUP_WRITE,
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
						
				START: state <= SETUP_WRITE;
				SETUP_WRITE: state <= WRITE;
				WRITE: state <= SET_ADDRESS;
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

			SET_ADDRESS: begin
				read_address <= read_address + 1'b1;
			end
			DONE: begin
				finding_explored_index <= 1'b0;
				done <= 1'b1;
			end
		endcase
	end

endmodule : Init_Dijkstra

module Min_Distance(
	input logic clk,
	input logic reset,
	input logic start,
	
);

	enum logic [2:0] {
		IDLE,
		START,
		CONDITION,
		INCREMENT_J,
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

				START: state <= CONDITION;
				CONDITION:
					if ()
			endcase
	end

endmodule : Min_Distance

module Dijkstra
#(
	parameter MAX_NODES = 10
)
(
	input logic clk,
	input logic reset,
	input logic start,
	input logic [8:0] start_id,


	output logic finished
);

	logic [13:0] fresh_map [MAX_NODES-1:0];
	logic [13:0] distance [MAX_NODES-1:0];
	logic shortest [MAX_NODES-1:0];
	logic [8:0] neighbour [MAX_NODES-1:0];

	enum logic [5:0] {
		IDLE,
		INITIALIZE_MAP,
		INITIALIZE_ARRAYS,
		MINIMUM_COST,
		MIN_COST_WAIT,
		MIN_COST_WAIT_2,
		UPDATE_MIN_COST,
		UPDATE_DISTANCE,
		DONE
	} state;

	logic [5:0] previous_state;

	always_ff @(posedge clk)
	begin 
		previous_state <= state;
	end

	always_ff @(posedge clk)
	begin
		if (reset)
			state <= IDLE;
		else
			case (state)
				IDLE:
					if (start)
						state <= INITIALIZE_MAP;

				INITIALIZE_MAP: begin 
					if (counter == MAX_NODES) begin
						state <= INITIALIZE_ARRAYS;
						counter <= start_id;
					end
					else begin 
						counter <= counter + 1'b1;
					end
				end

				INITIALIZE_ARRAYS: begin
					state <= MIN_COST_WAIT;
					counter <= 9'd0;
				end

				MIN_COST_WAIT: state <= MIN_COST_WAIT_2;
				MIN_COST_WAIT_2: state <= FIND_MIN_COST_HIGH;

				FIND_MIN_COST_HIGH: state <= FIND_MIN_COST_LOW;
				FIND_MIN_COST_LOW: state <= FIND_MIN_COST_DONE;
				FIND_MIN_COST_DONE:
					if (found_min)
						state <= UPDATE_MIN_COST;

				UPDATE_MIN_COST: state <= UPDATE_DISTANCE;
				UPDATE_DISTANCE: 
					if (counter == MAX_NODES) begin
						state <= DONE;
					end
					else begin 
						state <= MIN_COST_WAIT;
						counter <= counter + 1'b1;
					end

				DONE: state <= IDLE;
			endcase
	end

	genvar i;
	generate
		for (i=0; i<=MAX_NODES; i=i+1) begin : map
			Dijsktra_RAM RAM(
				.clk		(clk),
				.write_enable(write_enable[i]),
				.write_address(write_address[i]),
				.write_data(write_data[i]),
				.read_address(read_address[i]),
				.read_data(read_data[i])
			);

			always_comb
			begin 
				case (state)
					INITIALIZE_MAP: begin 
						write_enable[i] = 1'b1;
						write_address[i] = counter;
						write_data[i] = fresh_map[i];
						read_address[i] = 9'dx;
					end
					INITIALIZE_ARRAYS: begin
						write_enable[i] = 1'b0;
						write_address[i] = 9'dx;
						write_data[i] = 14'dx;
						read_address[i] = counter;
					end
					UPDATE_DISTANCE: begin
						write_enable[i] = 1'b0;
						write_address[i] = 9'dx;
						write_data[i] = 14'dx;
						read_address[i] = minimum_distance_id;
					end
					default: begin
						write_enable[i] = 1'b0;
						write_address[i] = 9'dx;
						write_data[i] = 14'dx;
						read_address[i] = 9'dx;
					end
				endcase
			end

			always_ff @(posedge clk)
			begin
				case (state)
					INITIALIZE_ARRAYS: begin 
						distance[i] <= read_data[i];
						neighbour[i] <= start_id;
					end
					UPDATE_DISTANCE: begin 
						if (shortest[i] == 1'b0 && (distance[minimum_distance_id_reg] + read_data[i] < distance[i])) begin 
							distance[i] <= distance[minimum_distance_id_reg] + read_data[i];
							neighbour[i] <= minimum_distance_id_reg;
						end
					end
				endcase
			end

			always_ff @(posedge clk)
			begin
				if (previous_state == INITIALIZE_ARRAYS && start_id != i) begin
					shortest[i] <= 1'b0;
				end
				else if (previous_state == INITIALIZE_ARRAYS && start_id == i) begin
					shortest[i] <= 1'b1;
				end
				else if (state == UPDATE_MIN_COST && minimum_distance_id == i) begin
					shortest[i] <= 1'b1;
				end
			end
		end
	endgenerate

	always_ff @(posedge clk)
	begin
		minimum_distance_id_reg <= minimum_distance_id;
	end


endmodule : Dijkstra