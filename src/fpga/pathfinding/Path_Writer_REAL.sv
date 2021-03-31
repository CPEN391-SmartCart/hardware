typedef struct packed {
	logic [15:0] x;
	logic [15:0] y;
} coord_t;

module Path_Writer(
	input logic clk,
	input logic reset,
	input logic start,

	input coord_t path[100],
	input integer length,

	input logic received_coord,

	output logic gave_coord,
	output logic [31:0] coord,
	output logic finished
);

	enum logic [4:0] {
		IDLE,
		START,
		WRITE,
		WAIT_RECEIVED,
		INCREMENT_INDEX,
		FINISHED
	} state;

	integer index;

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
				WRITE: state <= WAIT_RECEIVED;
				WAIT_RECEIVED: 
					if (received_coord)
						state <= INCREMENT_INDEX;

				INCREMENT_INDEX: 
					if (index < length)
						state <= WRITE;
					else
						state <= FINISHED;

				FINISHED: state <= IDLE;
			endcase // state
	end

	always_ff @(posedge clk)
	begin
		case (state)
			IDLE: begin
				finished <= 1'b0;
			end

			START: begin
				index <= 0;
			end
			WRITE: begin
				coord <= path[index];
				gave_coord <= 1'b1;
			end

			INCREMENT_INDEX: begin
				gave_coord <= 1'b0;
				index <= index + 1;
			end

			FINISHED: begin
				finished <= 1'b1;
			end
		endcase
	end

endmodule