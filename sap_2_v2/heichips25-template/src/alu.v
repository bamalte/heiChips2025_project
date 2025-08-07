module alu(
	input clk,
	input rst,
	input[7:0] a,
	input[2:0] op,
	input load,
	input[15:0] bus,
	output[7:0] out
);

reg[7:0] alu;
reg[7:0] tmp;

localparam OP_ADD = 0;
localparam OP_SUB = 1;
localparam OP_AND = 2;
localparam OP_OR  = 3;
localparam OP_XOR = 4;
localparam OP_CMA = 5;
localparam OP_RAL = 6;
localparam OP_RAR = 7;

always @(posedge clk, posedge rst) begin
	if (rst) begin
		tmp <= 8'b0;
	end else if (load) begin
		tmp <= bus[7:0];
	end
end

always @(*) begin
	case (op)
		OP_ADD: begin
			alu = a + tmp;
		end
		OP_SUB: begin
			alu = a - tmp;
		end
		OP_AND: begin
			alu = a & tmp;
		end
		OP_OR: begin
			alu = a | tmp;
		end
		OP_XOR: begin
			alu = a ^ tmp;
		end
		OP_CMA: begin
			alu = ~a;
		end
		OP_RAL: begin
			alu = a << 1;
			alu[0] = a[7];
		end
		OP_RAR: begin
			alu = a >> 1;
		end
		default: begin
			alu = 0;
		end
	endcase
end

assign out = alu;

endmodule

