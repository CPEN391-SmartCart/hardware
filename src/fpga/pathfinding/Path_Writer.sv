typedef struct packed {
	logic [15:0] x;
	logic [15:0] y;
} coord;

module Path_Writer(

	input logic clk, 
	input logic reset,

	input logic master_waitrequest, 
	input logic master_readdatavalid,
	input logic [31:0] master_readdata,

	output logic master_read, 
	output logic master_write, 
	output logic [31:0] master_address,
	output logic [31:0] master_writedata
);


endmodule


module Path_Passer(
	input logic clk,
	input logic reset,
	input logic start_pulse,

	input coord path[100],
	input integer length,

	output logic finished
);
	
	enum logic [4:0] {
		IDLE,
		START,
		WRITE,
		SET_ADDRESS,
		FINSIHED
	} state;

	logic waitrequest;
	logic write;
	logic [31:0] address;
	logic [31:0] writedata;

	Path_Writer(
		.clk(clk),
		.reset(reset),
		.master_waitrequest(waitrequest),
		.master_readdatavalid(),
		.master_readdata(),
		.master_read(1'b0),
		.master_write(write),
		.master_address(address),
		.master_writedata(writedata)
	);

	always_ff @(posedge clk)
	begin
		if (reset)
			state <= IDLE;
		else
			case (state)
				IDLE:
					if (start_pulse)
						state <= START;

				START: state <= ERASE;
				ERASE: 
					if (waitrequest == 0)
						if (address < 7'd100)
							state <= SET_ERASE_ADDRESS;
						else
							state <= START_WRITE;

				SET_ERASE_ADDRESS: state <= ERASE;
				START_WRITE: state <= WRITE;
				
				WRITE: 
					if (waitrequest == 0)
						if (address <= length)
							state <= SET_ADDRESS;
						else
							state <= FINISHED;

				SET_ADDRESS: state <= WRITE;
				FINISHED: state <= IDLE;
			endcase
	end

	always_ff @(posedge clk)
	begin 
		case (state)
			IDLE: begin
				finished <= 1'b0;
			end

			START: begin
				address <= 32'b0;
			end
			ERASE: begin
				write <= 1'b1;
			end
			SET_ERASE_ADDRESS: begin
				write <= 1'b0;
				address <= address + 1'b1;
			end

			START_WRITE: begin
				address <= 32'b0;
			end
			WRITE: begin
				WRITE <= 1'b1;
			end
			SET_ADDRESS: begin
				write <= 1'b0;
				address <= address + 1'b1;
			end

			FINISHED: begin
				finished <= 1'b1;
			end
		endcase // state
	end

endmodule