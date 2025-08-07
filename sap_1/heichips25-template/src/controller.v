module controller(
	input clk,
	input rst,
	input[3:0] opcode,
	output[11:0] out
);

localparam SIG_HLT       = 11;
localparam SIG_PC_INC    = 10;
localparam SIG_PC_EN     = 9;
localparam SIG_MEM_LOAD  = 8;
localparam SIG_MEM_EN    = 7;
localparam SIG_IR_LOAD   = 6;
localparam SIG_IR_EN     = 5;
localparam SIG_A_LOAD    = 4;
localparam SIG_A_EN      = 3;
localparam SIG_B_LOAD    = 2;
localparam SIG_ADDER_SUB = 1;
localparam SIG_ADDER_EN  = 0;

localparam OP_LDA = 4'b0000;
localparam OP_ADD = 4'b0001;
localparam OP_SUB = 4'b0010;
localparam OP_HLT = 4'b1111;

reg[2:0]  stage;
reg[11:0] ctrl_word;

always @(negedge clk, posedge rst) begin
	if (rst) begin
		stage <= 0;
	end else begin
		if (stage == 5) begin
			stage <= 0;
		end else begin
			stage <= stage + 1;
		end
	end
end

always @(*) begin
	ctrl_word = 12'b0;

	case (stage)
		0: begin
			ctrl_word[SIG_PC_EN] = 1;
			ctrl_word[SIG_MEM_LOAD] = 1;
		end
		1: begin
			ctrl_word[SIG_PC_INC] = 1;
		end
		2: begin
			ctrl_word[SIG_MEM_EN] = 1;
			ctrl_word[SIG_IR_LOAD] = 1;
		end
		3: begin
			case (opcode)
				OP_LDA: begin
					ctrl_word[SIG_IR_EN] = 1;
					ctrl_word[SIG_MEM_LOAD] = 1;
				end
				OP_ADD: begin
					ctrl_word[SIG_IR_EN] = 1;
					ctrl_word[SIG_MEM_LOAD] = 1;
				end
				OP_SUB: begin
					ctrl_word[SIG_IR_EN] = 1;
					ctrl_word[SIG_MEM_LOAD] = 1;
				end
				OP_HLT: begin
					ctrl_word[SIG_HLT] = 1;
				end
			endcase
		end
		4: begin
			case (opcode)
				OP_LDA: begin
					ctrl_word[SIG_MEM_EN] = 1;
					ctrl_word[SIG_A_LOAD] = 1;
				end
				OP_ADD: begin
					ctrl_word[SIG_MEM_EN] = 1;
					ctrl_word[SIG_B_LOAD] = 1;
				end
				OP_SUB: begin
					ctrl_word[SIG_MEM_EN] = 1;
					ctrl_word[SIG_B_LOAD] = 1;
				end
			endcase
		end
		5: begin
			case (opcode)
				OP_ADD: begin
					ctrl_word[SIG_ADDER_EN] = 1;
					ctrl_word[SIG_A_LOAD] = 1;
				end
				OP_SUB: begin
					ctrl_word[SIG_ADDER_SUB] = 1;
					ctrl_word[SIG_ADDER_EN] = 1;
					ctrl_word[SIG_A_LOAD] = 1;
				end
			endcase
		end
	endcase
end

assign out = ctrl_word;

endmodule

