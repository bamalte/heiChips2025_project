module memory(
	input clk,
	input rst,
	input load,
	input[7:0] bus,
	output[7:0] out
);

reg[7:0] ram[0:15];

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

