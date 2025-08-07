module pc(
	input clk,
	input rst,
	input inc,
	input load,
	input[15:0] bus,
	output[15:0] out
);

reg[15:0] pc;

always @(posedge clk, posedge rst) begin
	if (rst) begin
		pc <= 16'b0;
	end else if (load) begin
		pc <= bus;
	end else if (inc) begin
		pc <= pc + 1;
	end
end

assign out = pc;

endmodule

