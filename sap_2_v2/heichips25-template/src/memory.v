module memory(
	input clk,
	input rst,
	input mar_loadh,
	input mar_loadl,
	input mdr_load,
	input ram_load,
	input ram_enh,
	input ram_enl,
	input call,
	input ret,
	input[15:0] bus,
	output[15:0] out
);

reg[7:0]  ram[0:65535];

initial begin
	$readmemh("../simulation_srcs/program.bin", ram);
end

reg[15:0] mar;
reg[15:0] mdr;

always @(posedge rst) begin
	mar <= 16'b0;
	mdr <= 16'b0;
end

always @(posedge clk) begin
	if (mar_loadh) begin
		mar[15:8] <= bus[15:8];
	end

	if (mar_loadl) begin
		mar[7:0] <= bus[7:0];
	end

	if (mdr_load) begin
		mdr[7:0] <= bus[7:0];
	end

	if (ret) begin
		mdr[15:8] <= ram[16'hFFFE];
		mdr[7:0] <= ram[16'hFFFF];
	end else if (call) begin
		ram[16'hFFFE] <= bus[15:8];
		ram[16'hFFFF] <= bus[7:0];
	end else if (ram_enh) begin
		mdr[15:8] <= ram[mar];
	end else if (ram_enl) begin
		mdr[7:0] <= ram[mar];
	end else if (ram_load) begin
		ram[mar] <= mdr;
	end
end

assign out = mdr;

endmodule

