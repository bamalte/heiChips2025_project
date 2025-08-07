module controller(
	input clk,
	input rst,
	input[7:0] opcode,
	input[1:0] flags,
	output[33:0] out
);

localparam SIG_END       = 34;
localparam SIG_HLT       = 33;
localparam SIG_A_LOAD    = 32;
localparam SIG_A_EN      = 31;
localparam SIG_A_INC     = 30;
localparam SIG_A_DEC     = 29;
localparam SIG_B_LOAD    = 28;
localparam SIG_B_EN      = 27;
localparam SIG_B_INC     = 26;
localparam SIG_B_DEC     = 25;
localparam SIG_C_LOAD    = 24;
localparam SIG_C_EN      = 23;
localparam SIG_C_INC     = 22;
localparam SIG_C_DEC     = 21;
localparam SIG_FLAGS_LDA = 20;
localparam SIG_FLAGS_LDB = 19;
localparam SIG_FLAGS_LDC = 18;
localparam SIG_ALU_OP2   = 17;
localparam SIG_ALU_OP1   = 16;
localparam SIG_ALU_OP0   = 15;
localparam SIG_ALU_LD    = 14;
localparam SIG_ALU_EN    = 13;
localparam SIG_IR_LOAD   = 12;
localparam SIG_PC_INC    = 11;
localparam SIG_PC_LOAD   = 10;
localparam SIG_PC_EN     = 9;
localparam SIG_MAR_LOADH = 8;
localparam SIG_MAR_LOADL = 7;
localparam SIG_MDR_LOAD  = 6;
localparam SIG_MDR_EN    = 5;
localparam SIG_RAM_LOAD  = 4;
localparam SIG_RAM_ENH   = 3;
localparam SIG_RAM_ENL   = 2;
localparam SIG_CALL      = 1;
localparam SIG_RET       = 0;

localparam OP_JZ  = 8'hCA;
localparam OP_JNZ = 8'hC2;
localparam OP_JM  = 8'hFA;

localparam FLAG_Z = 1;
localparam FLAG_S = 0;

reg[34:0] ctrl_word;

reg[34:0] ctrl_rom[0:4095];
/*
initial begin
	$readmemb("../simulation_srcs/ctrl_rom.bin", ctrl_rom);
end
*/
reg stage_rst;

reg[3:0] stage;
always @(negedge clk, posedge rst) begin
	if (rst) begin
		stage <= 0;
	end else begin
		if (stage_rst) begin
			stage <= 0;
		end else begin
			stage <= stage + 1;
		end
	end
end

always @(*) begin
	ctrl_word = ctrl_rom[{opcode, stage}];

	if ((opcode == OP_JZ  && stage == 4 && flags[FLAG_Z] == 0) ||
		(opcode == OP_JNZ && stage == 4 && flags[FLAG_Z] == 1) ||
		(opcode == OP_JM  && stage == 4 && flags[FLAG_S] == 0))
	begin
		stage_rst = 1;
	end else begin
		stage_rst = ctrl_rom[{opcode, stage}][SIG_END];
	end
end

assign out = ctrl_word;

endmodule

