typedef struct packed {
	logic [15:0] x;
	logic [15:0] y;
} coord_t;

module Path_Writer(
	input logic success,
	input coord_t path[100],
	input logic [15:0] length,

	input logic [15:0] address,
	input logic io_enable,
	input logic write_enable,
	
	output logic [15:0] data_out
);

	always_comb
	begin
		data_out = 16'bZZZZZZZZZZZZZZZZ;
		
		if (!io_enable && write_enable) begin
			if (address[15:1] == 15'b0000_0001_0000_000)
				if (success)
					data_out = length;
				else
					data_out = 16'hFFFF;
			else if (address[15:1] == 15'b0000_0001_0000_001)
				data_out = path[0].x;
			else if (address[15:1] == 15'b0000_0001_0000_010)
				data_out = path[0].y;
			else if (address[15:1] == 15'b0000_0001_0000_011)
				data_out = path[1].x;
			else if (address[15:1] == 15'b0000_0001_0000_100)
				data_out = path[1].y;
			else if (address[15:1] == 15'b0000_0001_0000_101)
				data_out = path[2].x;
			else if (address[15:1] == 15'b0000_0001_0000_110)
				data_out = path[2].y;
			else if (address[15:1] == 15'b0000_0001_0000_111)
				data_out = path[3].x;
			else if (address[15:1] == 15'b0000_0001_0001_000)
				data_out = path[3].y;
			else if (address[15:1] == 15'b0000_0001_0001_001)
				data_out = path[4].x;
			else if (address[15:1] == 15'b0000_0001_0001_010)
				data_out = path[4].y;
			else if (address[15:1] == 15'b0000_0001_0001_011)
				data_out = path[5].x;
			else if (address[15:1] == 15'b0000_0001_0001_100)
				data_out = path[5].y;
			else if (address[15:1] == 15'b0000_0001_0001_101)
				data_out = path[6].x;
			else if (address[15:1] == 15'b0000_0001_0001_110)
				data_out = path[6].y;
			else if (address[15:1] == 15'b0000_0001_0001_111)
				data_out = path[7].x;
			else if (address[15:1] == 15'b0000_0001_0010_000)
				data_out = path[7].y;
			else if (address[15:1] == 15'b0000_0001_0010_001)
				data_out = path[8].x;
			else if (address[15:1] == 15'b0000_0001_0010_010)
				data_out = path[8].y;
			else if (address[15:1] == 15'b0000_0001_0010_011)
				data_out = path[9].x;
			else if (address[15:1] == 15'b0000_0001_0010_100)
				data_out = path[9].y;
			else if (address[15:1] == 15'b0000_0001_0010_101)
				data_out = path[10].x;
			else if (address[15:1] == 15'b0000_0001_0010_110)
				data_out = path[10].y;
			else if (address[15:1] == 15'b0000_0001_0010_111)
				data_out = path[11].x;
			else if (address[15:1] == 15'b0000_0001_0011_000)
				data_out = path[11].y;
			else if (address[15:1] == 15'b0000_0001_0011_001)
				data_out = path[12].x;
			else if (address[15:1] == 15'b0000_0001_0011_010)
				data_out = path[12].y;
			else if (address[15:1] == 15'b0000_0001_0011_011)
				data_out = path[13].x;
			else if (address[15:1] == 15'b0000_0001_0011_100)
				data_out = path[13].y;
			else if (address[15:1] == 15'b0000_0001_0011_101)
				data_out = path[14].x;
			else if (address[15:1] == 15'b0000_0001_0011_110)
				data_out = path[14].y;
			else if (address[15:1] == 15'b0000_0001_0011_111)
				data_out = path[15].x;
			else if (address[15:1] == 15'b0000_0001_0100_000)
				data_out = path[15].y;
			else if (address[15:1] == 15'b0000_0001_0100_001)
				data_out = path[16].x;
			else if (address[15:1] == 15'b0000_0001_0100_010)
				data_out = path[16].y;
			else if (address[15:1] == 15'b0000_0001_0100_011)
				data_out = path[17].x;
			else if (address[15:1] == 15'b0000_0001_0100_100)
				data_out = path[17].y;
			else if (address[15:1] == 15'b0000_0001_0100_101)
				data_out = path[18].x;
			else if (address[15:1] == 15'b0000_0001_0100_110)
				data_out = path[18].y;
			else if (address[15:1] == 15'b0000_0001_0100_111)
				data_out = path[19].x;
			else if (address[15:1] == 15'b0000_0001_0101_000)
				data_out = path[19].y;
			else if (address[15:1] == 15'b0000_0001_0101_001)
				data_out = path[20].x;
			else if (address[15:1] == 15'b0000_0001_0101_010)
				data_out = path[20].y;
			else if (address[15:1] == 15'b0000_0001_0101_011)
				data_out = path[21].x;
			else if (address[15:1] == 15'b0000_0001_0101_100)
				data_out = path[21].y;
			else if (address[15:1] == 15'b0000_0001_0101_101)
				data_out = path[22].x;
			else if (address[15:1] == 15'b0000_0001_0101_110)
				data_out = path[22].y;
			else if (address[15:1] == 15'b0000_0001_0101_111) // 47
				data_out = path[23].x;
			else if (address[15:1] == 15'b0000_0001_0110_000)
				data_out = path[23].y;
			else if (address[15:1] == 15'b0000_0001_0110_001)
				data_out = path[24].x;
			else if (address[15:1] == 15'b0000_0001_0110_010)
				data_out = path[24].y;
			else if (address[15:1] == 15'b0000_0001_0110_011)
				data_out = path[25].x;
			else if (address[15:1] == 15'b0000_0001_0110_100)
				data_out = path[25].y;
			else if (address[15:1] == 15'b0000_0001_0110_101)
				data_out = path[26].x;
			else if (address[15:1] == 15'b0000_0001_0110_110)
				data_out = path[26].y;
			else if (address[15:1] == 15'b0000_0001_0110_111)
				data_out = path[27].x;
			else if (address[15:1] == 15'b0000_0001_0111_000)
				data_out = path[27].y;
			else if (address[15:1] == 15'b0000_0001_0111_001)
				data_out = path[28].x;
			else if (address[15:1] == 15'b0000_0001_0111_010)
				data_out = path[28].y;
			else if (address[15:1] == 15'b0000_0001_0111_011)
				data_out = path[29].x;
			else if (address[15:1] == 15'b0000_0001_0111_100)
				data_out = path[29].y;
			else if (address[15:1] == 15'b0000_0001_0111_101)
				data_out = path[30].x;
			else if (address[15:1] == 15'b0000_0001_0111_110)
				data_out = path[30].y;
			else if (address[15:1] == 15'b0000_0001_0111_111)
				data_out = path[31].x;
			else if (address[15:1] == 15'b0000_0001_1000_000)
				data_out = path[31].y;
			else if (address[15:1] == 15'b0000_0001_1000_001)
				data_out = path[32].x;
			else if (address[15:1] == 15'b0000_0001_1000_010)
				data_out = path[32].y;
			else if (address[15:1] == 15'b0000_0001_1000_011)
				data_out = path[33].x;
			else if (address[15:1] == 15'b0000_0001_1000_100)
				data_out = path[33].y;
			else if (address[15:1] == 15'b0000_0001_1000_101)
				data_out = path[34].x;
			else if (address[15:1] == 15'b0000_0001_1000_110)
				data_out = path[34].y;
			else if (address[15:1] == 15'b0000_0001_1000_111)
				data_out = path[35].x;
			else if (address[15:1] == 15'b0000_0001_1001_000)
				data_out = path[35].y;
			else if (address[15:1] == 15'b0000_0001_1001_001)
				data_out = path[36].x;
			else if (address[15:1] == 15'b0000_0001_1001_010)
				data_out = path[36].y;
			else if (address[15:1] == 15'b0000_0001_1001_011)
				data_out = path[37].x;
			else if (address[15:1] == 15'b0000_0001_1001_100)
				data_out = path[37].y;
			else if (address[15:1] == 15'b0000_0001_1001_101)
				data_out = path[38].x;
			else if (address[15:1] == 15'b0000_0001_1001_110)
				data_out = path[38].y;
			else if (address[15:1] == 15'b0000_0001_1001_111)
				data_out = path[39].x;
			else if (address[15:1] == 15'b0000_0001_1010_000)
				data_out = path[39].y;
			else if (address[15:1] == 15'b0000_0001_1010_001)
				data_out = path[40].x;
			else if (address[15:1] == 15'b0000_0001_1010_010)
				data_out = path[40].y;
			else if (address[15:1] == 15'b0000_0001_1010_011)
				data_out = path[41].x;
			else if (address[15:1] == 15'b0000_0001_1010_100)
				data_out = path[41].y;
			else if (address[15:1] == 15'b0000_0001_1010_101)
				data_out = path[42].x;
			else if (address[15:1] == 15'b0000_0001_1010_110)
				data_out = path[42].y;
			else if (address[15:1] == 15'b0000_0001_1010_111)
				data_out = path[43].x;
			else if (address[15:1] == 15'b0000_0001_1011_000)
				data_out = path[43].y;
			else if (address[15:1] == 15'b0000_0001_1011_001)
				data_out = path[44].x;
			else if (address[15:1] == 15'b0000_0001_1011_010)
				data_out = path[44].y;
			else if (address[15:1] == 15'b0000_0001_1011_011)
				data_out = path[45].x;
			else if (address[15:1] == 15'b0000_0001_1011_100)
				data_out = path[45].y;
			else if (address[15:1] == 15'b0000_0001_1011_101)
				data_out = path[46].x;
			else if (address[15:1] == 15'b0000_0001_1011_110)
				data_out = path[46].y;
			else if (address[15:1] == 15'b0000_0001_1011_111) //95
				data_out = path[47].x;
			else if (address[15:1] == 15'b0000_0001_1100_000)
				data_out = path[47].y;
			else if (address[15:1] == 15'b0000_0001_1100_001)
				data_out = path[48].x;
			else if (address[15:1] == 15'b0000_0001_1100_010)
				data_out = path[48].y;
			else if (address[15:1] == 15'b0000_0001_1100_011)
				data_out = path[49].x;
			else if (address[15:1] == 15'b0000_0001_1100_100) //100
				data_out = path[49].y;
			else if (address[15:1] == 15'b0000_0001_1100_101)
				data_out = path[50].x;
			else if (address[15:1] == 15'b0000_0001_1100_110)
				data_out = path[50].y;
			else if (address[15:1] == 15'b0000_0001_1100_111)
				data_out = path[51].x;
			else if (address[15:1] == 15'b0000_0001_1101_000)
				data_out = path[51].y;
			else if (address[15:1] == 15'b0000_0001_1101_001)
				data_out = path[52].x;
			else if (address[15:1] == 15'b0000_0001_1101_010)
				data_out = path[52].y;
			else if (address[15:1] == 15'b0000_0001_1101_011)
				data_out = path[53].x;
			else if (address[15:1] == 15'b0000_0001_1101_100)
				data_out = path[53].y;
			else if (address[15:1] == 15'b0000_0001_1101_101)
				data_out = path[54].x;
			else if (address[15:1] == 15'b0000_0001_1101_110)
				data_out = path[54].y;
			else if (address[15:1] == 15'b0000_0001_1101_111)
				data_out = path[55].x;
			else if (address[15:1] == 15'b0000_0001_1110_000)
				data_out = path[55].y;
			else if (address[15:1] == 15'b0000_0001_1110_001)
				data_out = path[56].x;
			else if (address[15:1] == 15'b0000_0001_1110_010)
				data_out = path[56].y;
			else if (address[15:1] == 15'b0000_0001_1110_011)
				data_out = path[57].x;
			else if (address[15:1] == 15'b0000_0001_1110_100)
				data_out = path[57].y;
			else if (address[15:1] == 15'b0000_0001_1110_101)
				data_out = path[58].x;
			else if (address[15:1] == 15'b0000_0001_1110_110)
				data_out = path[58].y;
			else if (address[15:1] == 15'b0000_0001_1110_111)
				data_out = path[59].x;
			else if (address[15:1] == 15'b0000_0001_1111_000)
				data_out = path[59].y;
			else if (address[15:1] == 15'b0000_0001_1111_001)
				data_out = path[60].x;
			else if (address[15:1] == 15'b0000_0001_1111_010)
				data_out = path[60].y;
			else if (address[15:1] == 15'b0000_0001_1111_011)
				data_out = path[61].x;
			else if (address[15:1] == 15'b0000_0001_1111_100)
				data_out = path[61].y;
			else if (address[15:1] == 15'b0000_0001_1111_101)
				data_out = path[62].x;
			else if (address[15:1] == 15'b0000_0001_1111_110)
				data_out = path[62].y;
			else if (address[15:1] == 15'b0000_0001_1111_111)
				data_out = path[63].x;
			else if (address[15:1] == 15'b0000_0010_0000_000)
				data_out = path[63].y;
			else if (address[15:1] == 15'b0000_0010_0000_001)
				data_out = path[64].x;
			else if (address[15:1] == 15'b0000_0010_0000_010)
				data_out = path[64].y;
			else if (address[15:1] == 15'b0000_0010_0000_011)
				data_out = path[65].x;
			else if (address[15:1] == 15'b0000_0010_0000_100)
				data_out = path[65].y;
			else if (address[15:1] == 15'b0000_0010_0000_101)
				data_out = path[66].x;
			else if (address[15:1] == 15'b0000_0010_0000_110)
				data_out = path[66].y;
			else if (address[15:1] == 15'b0000_0010_0000_111)
				data_out = path[67].x;
			else if (address[15:1] == 15'b0000_0010_0001_000)
				data_out = path[67].y;
			else if (address[15:1] == 15'b0000_0010_0001_001)
				data_out = path[68].x;
			else if (address[15:1] == 15'b0000_0010_0001_010)
				data_out = path[68].y;
			else if (address[15:1] == 15'b0000_0010_0001_011)
				data_out = path[69].x;
			else if (address[15:1] == 15'b0000_0010_0001_100)
				data_out = path[69].y;
			else if (address[15:1] == 15'b0000_0010_0001_101)
				data_out = path[70].x;
			else if (address[15:1] == 15'b0000_0010_0001_110)
				data_out = path[70].y;
			else if (address[15:1] == 15'b0000_0010_0001_111)
				data_out = path[71].x;
			else if (address[15:1] == 15'b0000_0010_0010_000)
				data_out = path[71].y;
			else if (address[15:1] == 15'b0000_0010_0010_001)
				data_out = path[72].x;
			else if (address[15:1] == 15'b0000_0010_0010_010)
				data_out = path[72].y;
			else if (address[15:1] == 15'b0000_0010_0010_011)
				data_out = path[73].x;
			else if (address[15:1] == 15'b0000_0010_0010_100)
				data_out = path[73].y;
			else if (address[15:1] == 15'b0000_0010_0010_101)
				data_out = path[74].x;
			else if (address[15:1] == 15'b0000_0010_0010_110)
				data_out = path[74].y;
			else if (address[15:1] == 15'b0000_0010_0010_111)
				data_out = path[75].x;
			else if (address[15:1] == 15'b0000_0010_0011_000)
				data_out = path[75].y;
			else if (address[15:1] == 15'b0000_0010_0011_001)
				data_out = path[76].x;
			else if (address[15:1] == 15'b0000_0010_0011_010)
				data_out = path[76].y;
			else if (address[15:1] == 15'b0000_0010_0011_011)
				data_out = path[77].x;
			else if (address[15:1] == 15'b0000_0010_0011_100)
				data_out = path[77].y;
			else if (address[15:1] == 15'b0000_0010_0011_101)
				data_out = path[78].x;
			else if (address[15:1] == 15'b0000_0010_0011_110)
				data_out = path[78].y;
			else if (address[15:1] == 15'b0000_0010_0011_111)
				data_out = path[79].x;
			else if (address[15:1] == 15'b0000_0010_0100_000)
				data_out = path[79].y;
			else if (address[15:1] == 15'b0000_0010_0100_001)
				data_out = path[80].x;
			else if (address[15:1] == 15'b0000_0010_0100_010)
				data_out = path[80].y;
			else if (address[15:1] == 15'b0000_0010_0100_011)
				data_out = path[81].x;
			else if (address[15:1] == 15'b0000_0010_0100_100)
				data_out = path[81].y;
			else if (address[15:1] == 15'b0000_0010_0100_101)
				data_out = path[82].x;
			else if (address[15:1] == 15'b0000_0010_0100_110)
				data_out = path[82].y;
			else if (address[15:1] == 15'b0000_0010_0100_111)
				data_out = path[83].x;
			else if (address[15:1] == 15'b0000_0010_0101_000)
				data_out = path[83].y;
			else if (address[15:1] == 15'b0000_0010_0101_001)
				data_out = path[84].x;
			else if (address[15:1] == 15'b0000_0010_0101_010)
				data_out = path[84].y;
			else if (address[15:1] == 15'b0000_0010_0101_011)
				data_out = path[85].x;
			else if (address[15:1] == 15'b0000_0010_0101_100)
				data_out = path[85].y;
			else if (address[15:1] == 15'b0000_0010_0101_101)
				data_out = path[86].x;
			else if (address[15:1] == 15'b0000_0010_0101_110)
				data_out = path[86].y;
			else if (address[15:1] == 15'b0000_0010_0101_111)
				data_out = path[87].x;
			else if (address[15:1] == 15'b0000_0010_0110_000)
				data_out = path[87].y;
			else if (address[15:1] == 15'b0000_0010_0110_001)
				data_out = path[88].x;
			else if (address[15:1] == 15'b0000_0010_0110_010)
				data_out = path[88].y;
			else if (address[15:1] == 15'b0000_0010_0110_011)
				data_out = path[89].x;
			else if (address[15:1] == 15'b0000_0010_0110_100)
				data_out = path[89].y;
			else if (address[15:1] == 15'b0000_0010_0110_101)
				data_out = path[90].x;
			else if (address[15:1] == 15'b0000_0010_0110_110)
				data_out = path[90].y;
			else if (address[15:1] == 15'b0000_0010_0110_111)
				data_out = path[91].x;
			else if (address[15:1] == 15'b0000_0010_0111_000)
				data_out = path[91].y;
			else if (address[15:1] == 15'b0000_0010_0111_001)
				data_out = path[92].x;
			else if (address[15:1] == 15'b0000_0010_0111_010)
				data_out = path[92].y;
			else if (address[15:1] == 15'b0000_0010_0111_011)
				data_out = path[93].x;
			else if (address[15:1] == 15'b0000_0010_0111_100)
				data_out = path[93].y;
			else if (address[15:1] == 15'b0000_0010_0111_101)
				data_out = path[94].x;
			else if (address[15:1] == 15'b0000_0010_0111_110)
				data_out = path[94].y;
			else if (address[15:1] == 15'b0000_0010_0111_111)
				data_out = path[95].x;
			else if (address[15:1] == 15'b0000_0010_1000_000)
				data_out = path[95].y;
			else if (address[15:1] == 15'b0000_0010_1000_001)
				data_out = path[96].x;
			else if (address[15:1] == 15'b0000_0010_1000_010)
				data_out = path[96].y;
			else if (address[15:1] == 15'b0000_0010_1000_011)
				data_out = path[97].x;
			else if (address[15:1] == 15'b0000_0010_1000_100)
				data_out = path[97].y;
			else if (address[15:1] == 15'b0000_0010_1000_101)
				data_out = path[98].x;
			else if (address[15:1] == 15'b0000_0010_1000_110)
				data_out = path[98].y;
			else if (address[15:1] == 15'b0000_0010_1000_111)
				data_out = path[99].x;
			else if (address[15:1] == 15'b0000_0010_1001_000) //200
				data_out = path[99].y;
		end
		
	end

endmodule