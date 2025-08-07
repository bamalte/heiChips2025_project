module memory(
	input clk,
	input rst,
	input load,
	input[7:0] bus,
	output[7:0] out
);

reg[7:0] ram[0:15];

// Synthesis-friendly RAM initialization
always @(posedge rst) begin
	if (rst) begin
		ram[0]  <= 8'h0D;
		ram[1]  <= 8'h1E;
		ram[2]  <= 8'h2F;
		ram[3]  <= 8'hF0;
		ram[4]  <= 8'h00;
		ram[5]  <= 8'h00;
		ram[6]  <= 8'h00;
		ram[7]  <= 8'h00;
		ram[8]  <= 8'h00;
		ram[9]  <= 8'h00;
		ram[10] <= 8'h00;
		ram[11] <= 8'h00;
		ram[12] <= 8'h00;
		ram[13] <= 8'h03;
		ram[14] <= 8'h04;
		ram[15] <= 8'h02;
	end
end

/*
initial begin
	$readmemh("../simulation_srcs/program.bin", ram);
end
*/
reg[3:0] mar;

always @(posedge clk, posedge rst) begin
	if (rst) begin
		mar <= 4'b0;
	end else if (load) begin
		mar <= bus[3:0];
	end
end

assign out = ram[mar];

endmodule

