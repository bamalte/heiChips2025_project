module reg_a(
	input clk,
	input rst,
	input load,
	input[7:0] bus,
	output[7:0] out
);

reg[7:0] reg_a;

always @(posedge clk, posedge rst) begin
	if (rst) begin
		reg_a <= 8'b0;
	end else if (load) begin
		reg_a <= bus;
	end
end

assign out = reg_a;

endmodule

