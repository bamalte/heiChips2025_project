module flags(
	input clk,
	input rst,
	input[7:0] a,
	input[7:0] b,
	input[7:0] c,
	input load_a,
	input load_b,
	input load_c,
	output[1:0] out
);

localparam FLAG_Z = 1;
localparam FLAG_S = 0;

reg[1:0] flags;

always @(negedge clk, posedge rst) begin
	if (rst) begin
		flags <= 2'b0;
	end else if (load_a) begin
		flags[FLAG_Z] <= (a == 0) ? 1'b1 : 1'b0;
		flags[FLAG_S] <= (a[7] == 1) ? 1'b1 : 1'b0;
	end else if (load_b) begin
		flags[FLAG_Z] <= (b == 0) ? 1'b1 : 1'b0;
		flags[FLAG_S] <= (b[7] == 1) ? 1'b1 : 1'b0;
	end else if (load_c) begin
		flags[FLAG_Z] <= (c == 0) ? 1'b1 : 1'b0;
		flags[FLAG_S] <= (c[7] == 1) ? 1'b1 : 1'b0;
	end
end

assign out = flags;

endmodule

