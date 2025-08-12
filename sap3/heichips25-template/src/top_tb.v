module top_tb(
    input  wire  clk,
    input  wire [8-1:0] io_in,
    output wire [8-1:0] io_out,
    output wire [8-1:0] io_oeb
);

logic [7:0] ui_in;
logic [7:0] uo_out;
logic [7:0] uio_in;
logic [7:0] uio_out;
logic [7:0] uio_oe;
logic       rst_n;

heichips25_template heichips25_template_inst (
	.ui_in      (ui_in),
	.uo_out     (uo_out),
	.uio_in     (uio_in),
	.uio_out    (uio_out),
	.uio_oe     (uio_oe),
	.ena        (1'b1),
	.clk				(clk),
	.rst_n      (rst_n)
);

logic [ 9:0] sram_addr;
logic [31:0] sram_bm;
logic [31:0] sram_din;
logic        sram_wen;
logic        sram_men;
logic        sram_ren;
logic [31:0] sram_dout;

IHP_SRAM_1024x32_wrapper IHP_SRAM_1024x32_wrapper (
		.clk   (clk),
		.ADDR  (sram_addr),
		.BM    (sram_bm),
		.DIN   (sram_din),
		.WEN   (sram_wen),
		.MEN   (sram_men),
		.REN   (sram_ren),
		.DOUT  (sram_dout)
);

logic [7:0] received_sap_3_reg;
logic synced;
deserializer #(.WIDTH(8)) rx (
    .clk        (clk),
    .rst        (~rst_n),
    .serial_in  (uo_out[2]),
		.start      (uo_out[3]),
    .data_out   (received_sap_3_reg),
    .synced     (synced)
);

localparam WIDTH = 8;
localparam DEPTH = 12;
logic [WIDTH-1:0] rx_data;

array_deserializer #(
		.WIDTH(WIDTH),
		.DEPTH(DEPTH)
) array_deserializer_inst (
		.clk(clk),
		.rst(~rst_n),
		.serial_in(uo_out[4]),
		.start(uo_out[5]),
		.data_out(rx_data)
);

reg[15:0] mar;

always @(posedge clk) begin
if (!rst_n)
	mar <= 16'b0;
else if ( uo_out[1] ) // mem_mar_we
	mar <= {uio_oe[7:0], uio_out[7:0]};
end

assign sram_wen = uo_out[0]; // mem_ram_we
/*
always @(posedge clk) begin
if ( uo_out[0] ) // mem_ram_we
	sram_wen <= 1'b1;
else
	sram_wen <= 1'b0;
end
*/
assign rst_n = io_in[0];

assign sram_addr = mar[9:0];
assign sram_bm = {24'b0, 8'hFF};
assign sram_din = {24'b0, uio_out[7:0]};
assign sram_men = 1'b1;
assign sram_ren = ~sram_wen;

assign ui_in = sram_dout[7:0];

assign io_out[7:0] = sram_dout[7:0]; 
assign io_out[15:8] = sram_din[7:0];
assign io_out[25:16] = sram_addr;
assign io_out[31:26] = '0;

assign io_oeb[0] = 1'b1; // input
assign io_oeb[31:1] = 32'b0; // output

endmodule
