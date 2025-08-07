module memory(
	input clk,
	input rst,
	input mar_we,
	input ram_we,
	input[15:0] bus,
	output[7:0] out
);

reg[15:0] mar;
reg[7:0]  ram[0:255];

initial begin
	$readmemh("../program.bin", ram);
end


always @(posedge clk, posedge rst) begin
	if (rst)
		mar <= 16'b0;
	else if (mar_we)
		mar <= bus;
end

always @(posedge clk) begin
	if (ram_we)
		ram[mar] <= bus[7:0];
end

assign out = ram[mar];

endmodule

