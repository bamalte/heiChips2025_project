localparam int WORD_WIDTH = 8;
localparam int ARRAY_DEPTH = 12;

module reg_file(
	input clk,
	input fast_clock,
	input rst,
	input[4:0] rd_sel,
	input[4:0] wr_sel,
	input[1:0] ext,
	input we,
	input[15:0] data_in,
	output reg [15:0] data_out,
	output serial_out,
	output start
);

// 8-bit
//           0      1
// 0000_  [  B  ][  C  ]
// 0001_  [  D  ][  E  ]
// 0010_  [  H  ][  L  ]
// 0011_  [  W  ][  Z  ]
// 0100_  [  P  ][  C  ]
// 0101_  [  S  ][  P  ]

// 16-bit (ext)
//                 
// 10000  [     BC     ]
// 10010  [     DE     ]
// 10100  [     HL     ]
// 10110  [     WZ     ]
// 11000  [     PC     ]
// 11010  [     SP     ]
reg[WORD_WIDTH-1:0] data[0:ARRAY_DEPTH-1];

reg [ARRAY_DEPTH*WORD_WIDTH-1:0] data_flat;
always @* begin
  integer i;
  for (i = 0; i < ARRAY_DEPTH; i = i + 1) begin
    data_flat[i*WORD_WIDTH +: WORD_WIDTH] = data[i];
  end
end

wire wr_ext = wr_sel[4];
wire rd_ext = rd_sel[4];
wire[3:0] wr_dst = wr_sel[3:0];
wire[3:0] rd_src = rd_sel[3:0];

localparam EXT_INC  = 2'b01;
localparam EXT_DEC  = 2'b10;
localparam EXT_INC2 = 2'b11;

array_serializer #(
	.WIDTH(8),
	.DEPTH(12)
) array_serializer_inst (
	.clk(fast_clock),
	.rst(rst),
	.data_flat(data_flat),
	.serial_out(serial_out), 
	.start(start)
);

always @(posedge clk, posedge rst) begin
	if (rst) begin
		data[0] <= 8'b0; data[1] <= 8'b0; data[2] <= 8'b0; data[3] <= 8'b0; data[4] <= 8'b0;
		data[5] <= 8'b0; data[6] <= 8'b0; data[7] <= 8'b0; data[8] <= 8'b0; data[9] <= 8'b0;
		data[10] <= 8'b0; data[11] <= 8'b0;
	end else begin
		if (ext == EXT_INC) begin
			{data[wr_dst], data[wr_dst+1]} <= {data[wr_dst], data[wr_dst+1]} + 1;
		end else if (ext == EXT_INC2) begin
			{data[wr_dst], data[wr_dst+1]} <= {data[wr_dst], data[wr_dst+1]} + 2;
		end else if (ext == EXT_DEC) begin
			{data[wr_dst], data[wr_dst+1]} <= {data[wr_dst], data[wr_dst+1]} - 1;
		end else if (we) begin
			if (wr_ext) begin
				{data[wr_dst], data[wr_dst+1]} <= data_in;
			end else begin
				data[wr_dst] <= data_in[7:0];
			end
		end
	end
end

always @(*) begin
	if (rd_ext) begin
		data_out = {data[rd_src], data[rd_src+1]};
	end else begin
		data_out = {8'b0, data[rd_src]};
	end
end

endmodule

