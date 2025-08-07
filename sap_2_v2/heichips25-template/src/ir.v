module ir(
	input clk,
	input rst,
	input load,
	input[15:0] bus,
	output[7:0] out
);

reg[7:0] ir;

always @(posedge clk, posedge rst) begin
	if (rst) begin
		ir <= 8'b0;
	end else if (load) begin
		ir <= bus[7:0];
	end
end

assign out = ir;

endmodule

