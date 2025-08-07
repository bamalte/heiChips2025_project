module controller(
	input clk,
	input rst,
	input[7:0] opcode,
	input[7:0] flags,
	output[32:0] out
);

localparam DISPLAY       = 32;
localparam HLT           = 31;
localparam ALU_CS        = 30;
localparam ALU_FLAGS_WE  = 29;
localparam ALU_A_WE      = 28;
localparam ALU_A_STORE   = 27;
localparam ALU_A_RESTORE = 26;
localparam ALU_TMP_WE    = 25;
localparam ALU_OP4       = 24;
localparam ALU_OP0       = 20;
localparam ALU_OE        = 19;
localparam ALU_FLAGS_OE  = 18;
localparam REG_RD_SEL4   = 17;
localparam REG_RD_SEL0   = 13;
localparam REG_WR_SEL4   = 12;
localparam REG_WR_SEL0   = 8;
localparam REG_EXT1      = 7;
localparam REG_EXT0      = 6;
localparam REG_OE        = 5;
localparam REG_WE        = 4;
localparam MEM_WE        = 3;
localparam MEM_MAR_WE    = 2;
localparam MEM_OE        = 1;
localparam IR_WE         = 0;

localparam REG_INC   = 2'b01;
localparam REG_DEC   = 2'b10;
localparam REG_INC2  = 2'b11;

localparam REG_BC    = 5'b10000;
localparam REG_BC_B  = 5'b00000;
localparam REG_BC_C  = 5'b00001;

localparam REG_DE    = 5'b10010;
localparam REG_DE_D  = 5'b00010;
localparam REG_DE_E  = 5'b00011;

localparam REG_HL    = 5'b10100;
localparam REG_HL_H  = 5'b00100;
localparam REG_HL_L  = 5'b00101;

localparam REG_WZ    = 5'b10110;
localparam REG_WZ_W  = 5'b00110;
localparam REG_WZ_Z  = 5'b00111;

localparam REG_PC    = 5'b11000;
localparam REG_PC_P  = 5'b01000;
localparam REG_PC_C  = 5'b01001;

localparam REG_SP    = 5'b11010;
localparam REG_SP_S  = 5'b01010;
localparam REG_SP_P  = 5'b01011;

reg[32:0] ctrl_word;
reg[3:0] stage;
reg stage_rst;

assign out = ctrl_word;

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
	ctrl_word = 0;
	stage_rst = 0;

	if (stage == 0) begin
		ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_PC;
		ctrl_word[REG_OE] = 1'b1;
		ctrl_word[MEM_MAR_WE] = 1'b1;
	end else if (stage == 1) begin
		ctrl_word[MEM_OE] = 1'b1;
		ctrl_word[IR_WE] = 1'b1;
	end else if (stage == 2) begin
		ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_PC;
		ctrl_word[REG_EXT1:REG_EXT0] = REG_INC;
	end else begin
		casez (opcode)
			// NOP
			8'o000: begin
				stage_rst = 1'b1;
			end

			// HLT
			8'o166: begin
				if (stage == 3) begin
					ctrl_word[HLT] = 1'b1;
				end
			end

			// MOV Rd, M
			// opcode[5:3] - Rd
			8'o1?6: begin
				if (stage == 3) begin
					ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_HL;
					ctrl_word[REG_OE] = 1'b1;
					ctrl_word[MEM_MAR_WE] = 1'b1;
				end else if (stage == 4) begin
					if (opcode[5:3] == 3'b111) begin
						ctrl_word[ALU_A_WE] = 1'b1;
					end else begin
						ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = {2'b0, opcode[5:3]};
						ctrl_word[REG_WE] = 1'b1;
					end

					ctrl_word[MEM_OE] = 1'b1;
					stage_rst = 1'b1;
				end
			end

			// MOV M, Rs
			// opcode[2:0] - Rs
			8'o16?: begin
				if (stage == 3) begin
					ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_HL;
					ctrl_word[REG_OE] = 1'b1;
					ctrl_word[MEM_MAR_WE] = 1'b1;
				end else if (stage == 4) begin
					if (opcode[2:0] == 3'b111) begin
						ctrl_word[ALU_OE] = 1'b1;
					end else begin
						ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = {2'b0, opcode[2:0]};
						ctrl_word[REG_OE] = 1'b1;
					end

					ctrl_word[MEM_WE] = 1'b1;
					stage_rst = 1'b1;
				end
			end

			// MOV Rd, Rs
			// opcode[5:3] - Rd
			// opcode[2:0] - Rs
			8'o1??: begin
				if (stage == 3) begin
					if (opcode[2:0] == 3'b111) begin
						ctrl_word[ALU_OE] = 1'b1;
					end else begin
						ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = {2'b0, opcode[2:0]};
						ctrl_word[REG_OE] = 1'b1;
					end

					if (opcode[5:3] == 3'b111) begin
						ctrl_word[ALU_A_WE] = 1'b1;
					end else begin
						ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = {2'b0, opcode[5:3]};
						ctrl_word[REG_WE] = 1'b1;
					end

					stage_rst = 1'b1;
				end
			end

			// INX, DCX
			// opcode[5:4] - 16-bit Register
			// opcode[3]   - Dec(1) / Inc (0)
			8'o0?3: begin
				if (stage == 3) begin
					if (opcode[5:4] == 2'b11)
						ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_SP;
					else
						ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = {2'b10, opcode[5:4], 1'b0};

					ctrl_word[REG_EXT1:REG_EXT0] = {opcode[3], ~opcode[3]};
					stage_rst = 1'b1;
				end
			end

			// INR/DCR M
			// opcode[5:3] - Rs
			// opcode[0]   - INR (0), DCR (1)
			8'o064: begin
				if (stage == 3) begin
					ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_HL;
					ctrl_word[REG_OE] = 1'b1;
					ctrl_word[MEM_MAR_WE] = 1'b1;
				end else if (stage == 4) begin
					ctrl_word[MEM_OE] = 1'b1;
					ctrl_word[ALU_A_STORE] = 1'b1;
					ctrl_word[ALU_A_WE] = 1'b1;
				end else if (stage == 5) begin
					ctrl_word[ALU_CS] = 1'b1;
					ctrl_word[ALU_OP4:ALU_OP0] = {4'b1000, opcode[0]};
				end else if (stage == 6) begin
					ctrl_word[ALU_OE] = 1'b1;
					ctrl_word[ALU_A_RESTORE] = 1'b1;
					ctrl_word[MEM_WE] = 1'b1;
					stage_rst = 1'b1;
				end
			end

			// INR/DCR Rs
			// opcode[5:3] - Rs
			// opcode[0]   - INR (0), DCR (1)
			8'o0?4, 8'o0?5: begin
				if (stage == 3) begin
					if (opcode[5:3] == 3'b111) begin
						ctrl_word[ALU_CS] = 1'b1;
						ctrl_word[ALU_OP4:ALU_OP0] = 5'b10000;
						stage_rst = 1'b1;
					end else begin
						ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = {2'b0, opcode[5:3]};
						ctrl_word[REG_OE] = 1'b1;
						ctrl_word[ALU_A_STORE] = 1'b1;
						ctrl_word[ALU_A_WE] = 1'b1;
					end
				end else if (stage == 4) begin
					ctrl_word[ALU_CS] = 1'b1;
					ctrl_word[ALU_OP4:ALU_OP0] = {4'b1000, opcode[0]};
				end else if (stage == 5) begin
					ctrl_word[ALU_OE] = 1'b1;
					ctrl_word[ALU_A_RESTORE] = 1'b1;
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = {2'b0, opcode[5:3]};
					ctrl_word[REG_WE] = 1'b1;
					stage_rst = 1'b1;
				end
			end

			// Arithmetic/Logic Set 0 (M)
			// opcode[5:3] - ALU Op
			8'o2?6: begin
				if (stage == 3) begin
					ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_HL;
					ctrl_word[REG_OE] = 1'b1;
					ctrl_word[MEM_MAR_WE] = 1'b1;
				end else if (stage == 4) begin
					ctrl_word[MEM_OE] = 1'b1;
					ctrl_word[ALU_TMP_WE] = 1'b1;
				end else if (stage == 5) begin
					ctrl_word[ALU_CS] = 1'b1;
					ctrl_word[ALU_OP4:ALU_OP0] = {2'b0, opcode[5:3]};
					stage_rst = 1'b1;
				end
			end

			// Arithmetic/Logic Set 0
			// opcode[2:0] - Rs
			// opcode[5:3] - ALU Op
			8'o2??: begin
				if (stage == 3) begin
					if (opcode[2:0] == 3'b111) begin
						ctrl_word[ALU_CS] = 1'b1;
						ctrl_word[ALU_OP4:ALU_OP0] = {2'b0, opcode[5:3]};
						stage_rst = 1'b1;
					end else begin
						ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = {2'b0, opcode[2:0]};
						ctrl_word[REG_OE] = 1'b1;
					end

					ctrl_word[ALU_TMP_WE] = 1'b1;
				end else if (stage == 4) begin
					ctrl_word[ALU_CS] = 1'b1;
					ctrl_word[ALU_OP4:ALU_OP0] = {2'b0, opcode[5:3]};
					stage_rst = 1'b1;
				end
			end

			// Arithmetic/Logic Set 1
			// opcode[5:3] - ALU Op
			8'o0?7: begin
				if (stage == 3) begin
					ctrl_word[ALU_CS] = 1'b1;
					ctrl_word[ALU_OP4:ALU_OP0] = {2'b01, opcode[5:3]};
					stage_rst = 1'b1;
				end
			end

			// Arithmetic/Logic Immediate
			// opcode[5:3] - ALU Op
			8'o3?6: begin
				if (stage == 3) begin
					ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_PC;
					ctrl_word[REG_OE] = 1'b1;
					ctrl_word[MEM_MAR_WE] = 1'b1;
				end else if (stage == 4) begin
					ctrl_word[MEM_OE] = 1'b1;
					ctrl_word[ALU_TMP_WE] = 1'b1;
				end else if (stage == 5) begin
					ctrl_word[ALU_CS] = 1'b1;
					ctrl_word[ALU_OP4:ALU_OP0] = {2'b0, opcode[5:3]};
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_PC;
					ctrl_word[REG_EXT1:REG_EXT0] = REG_INC;
					stage_rst = 1'b1;
				end
			end

			// MVI M, d8
			8'o066: begin
				if (stage == 3) begin
					ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_PC;
					ctrl_word[REG_OE] = 1'b1;
					ctrl_word[MEM_MAR_WE] = 1'b1;
				end else if (stage == 4) begin
					ctrl_word[MEM_OE] = 1'b1;
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = {2'b0, REG_WZ_W};
					ctrl_word[REG_WE] = 1'b1;
				end else if (stage == 5) begin
					ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_HL;
					ctrl_word[REG_OE] = 1'b1;
					ctrl_word[MEM_MAR_WE] = 1'b1;
				end else if (stage == 6) begin
					ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = {2'b0, REG_WZ_W};
					ctrl_word[REG_OE] = 1'b1;
					ctrl_word[MEM_WE] = 1'b1;
				end else if (stage == 7) begin
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_PC;
					ctrl_word[REG_EXT1:REG_EXT0] = REG_INC;
					stage_rst = 1'b1;
				end
			end

			// MVI Rd, d8
			// opcode[5:3] - Rd
			8'o0?6: begin
				if (stage == 3) begin
					ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_PC;
					ctrl_word[REG_OE] = 1'b1;
					ctrl_word[MEM_MAR_WE] = 1'b1;
				end else if (stage == 4) begin
					if (opcode[5:3] == 3'b111) begin
						ctrl_word[ALU_A_WE] = 1'b1;
					end else begin
						ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = {2'b0, opcode[5:3]};
						ctrl_word[REG_WE] = 1'b1;
					end

					ctrl_word[MEM_OE] = 1'b1;
				end else if (stage == 5) begin
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_PC;
					ctrl_word[REG_EXT1:REG_EXT0] = REG_INC;
					stage_rst = 1'b1;
				end
			end

			// LXI
			// opcode[5:4] - Extended Register
			8'o001, 8'o021, 8'o041, 8'o061: begin
				if (stage == 3) begin
					ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_PC;
					ctrl_word[REG_OE] = 1'b1;
					ctrl_word[MEM_MAR_WE] = 1'b1;
				end else if (stage == 4) begin
					ctrl_word[MEM_OE] = 1'b1;
					ctrl_word[REG_WE] = 1'b1;
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_WZ_Z;
				end else if (stage == 5) begin
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_PC;
					ctrl_word[REG_EXT1:REG_EXT0] = REG_INC;
				end else if (stage == 6) begin
					ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_PC;
					ctrl_word[REG_OE] = 1'b1;
					ctrl_word[MEM_MAR_WE] = 1'b1;
				end else if (stage == 7) begin
					ctrl_word[MEM_OE] = 1'b1;
					ctrl_word[REG_WE] = 1'b1;
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_WZ_W;
				end else if (stage == 8) begin
					if (opcode[5:4] == 2'b11)
						ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_SP;
					else
						ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = {2'b10, opcode[5:4], 1'b0};

					ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_WZ;
					ctrl_word[REG_OE] = 1'b1;
					ctrl_word[REG_WE] = 1'b1;
				end else if (stage == 9) begin
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_PC;
					ctrl_word[REG_EXT1:REG_EXT0] = REG_INC;
					stage_rst = 1'b1;
				end
			end

			// LDA/STA a16
			// opcode[3]: STA (0) / LDA (1)
			8'o062, 8'o072: begin
				if (stage == 3) begin
					ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_PC;
					ctrl_word[REG_OE] = 1'b1;
					ctrl_word[MEM_MAR_WE] = 1'b1;
				end else if (stage == 4) begin
					ctrl_word[MEM_OE] = 1'b1;
					ctrl_word[REG_WE] = 1'b1;
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_WZ_Z;
				end else if (stage == 5) begin
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_PC;
					ctrl_word[REG_EXT1:REG_EXT0] = REG_INC;
				end else if (stage == 6) begin
					ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_PC;
					ctrl_word[REG_OE] = 1'b1;
					ctrl_word[MEM_MAR_WE] = 1'b1;
				end else if (stage == 7) begin
					ctrl_word[MEM_OE] = 1'b1;
					ctrl_word[REG_WE] = 1'b1;
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_WZ_W;
				end else if (stage == 8) begin
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_PC;
					ctrl_word[REG_EXT1:REG_EXT0] = REG_INC;
				end else if (stage == 9) begin
					ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_WZ;
					ctrl_word[REG_OE] = 1'b1;
					ctrl_word[MEM_MAR_WE] = 1'b1;
				end else if (stage == 10) begin
					if (opcode[3] == 0) begin
						ctrl_word[ALU_OE] = 1'b1;
						ctrl_word[MEM_WE] = 1'b1;
					end else begin
						ctrl_word[ALU_A_WE] = 1'b1;
						ctrl_word[MEM_OE] = 1'b1;
					end

					stage_rst = 1'b1;
				end
			end

			// STAX/LDAX Rs
			// opcode[5:4] - Rs
			// opcode[3]   - STAX (0) / LDAX (1)
			8'o002, 8'o012, 8'o022, 8'o032: begin
				if (stage == 3) begin
					ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = {2'b0, opcode[5:4], 1'b0};
					ctrl_word[REG_OE] = 1'b1;
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_WZ_W;
					ctrl_word[REG_WE] = 1'b1;
				end else if (stage == 4) begin
					ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = {2'b0, opcode[5:4], 1'b1};
					ctrl_word[REG_OE] = 1'b1;
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_WZ_Z;
					ctrl_word[REG_WE] = 1'b1;
				end else if (stage == 5) begin
					ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_WZ;
					ctrl_word[REG_OE] = 1'b1;
					ctrl_word[MEM_MAR_WE] = 1'b1;
				end else if (stage == 7) begin
					if (opcode[3] == 1'b0) begin
						ctrl_word[ALU_OE] = 1'b1;
						ctrl_word[MEM_WE] = 1'b1;
					end else begin
						ctrl_word[ALU_A_WE] = 1'b1;
						ctrl_word[MEM_OE] = 1'b1;
					end

					stage_rst = 1'b1;
				end
			end

			// SHLD, LHLD
			// opcode[3] - SHLD (0) / LHLD (1)
			8'o042, 8'o052: begin
				if (stage == 3) begin
					ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_PC;
					ctrl_word[REG_OE] = 1'b1;
					ctrl_word[MEM_MAR_WE] = 1'b1;
				end else if (stage == 4) begin
					ctrl_word[MEM_OE] = 1'b1;
					ctrl_word[REG_WE] = 1'b1;
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_WZ_Z;
				end else if (stage == 5) begin
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_PC;
					ctrl_word[REG_EXT1:REG_EXT0] = REG_INC;
				end else if (stage == 6) begin
					ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_PC;
					ctrl_word[REG_OE] = 1'b1;
					ctrl_word[MEM_MAR_WE] = 1'b1;
				end else if (stage == 7) begin
					ctrl_word[MEM_OE] = 1'b1;
					ctrl_word[REG_WE] = 1'b1;
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_WZ_W;
				end else if (stage == 8) begin
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_PC;
					ctrl_word[REG_EXT1:REG_EXT0] = REG_INC;
				end else if (stage == 9) begin
					ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_WZ;
					ctrl_word[REG_OE] = 1'b1;
					ctrl_word[MEM_MAR_WE] = 1'b1;
				end else if (stage == 10) begin
					if (opcode[3] == 1'b0) begin
						ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_HL_H;
						ctrl_word[REG_OE] = 1'b1;
						ctrl_word[MEM_WE] = 1'b1;
					end else begin
						ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_HL_H;
						ctrl_word[REG_WE] = 1'b1;
						ctrl_word[MEM_OE] = 1'b1;
					end
				end else if (stage == 11) begin
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_WZ;
					ctrl_word[REG_EXT1:REG_EXT0] = REG_INC;
				end else if (stage == 12) begin
					ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_WZ;
					ctrl_word[REG_OE] = 1'b1;
					ctrl_word[MEM_MAR_WE] = 1'b1;
				end else if (stage == 13) begin
					if (opcode[3] == 1'b0) begin
						ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_HL_L;
						ctrl_word[REG_OE] = 1'b1;
						ctrl_word[MEM_WE] = 1'b1;
					end else begin
						ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_HL_L;
						ctrl_word[REG_WE] = 1'b1;
						ctrl_word[MEM_OE] = 1'b1;
					end

					stage_rst = 1'b1;
				end
			end

			// DAD
			// opcode[5:4] - Extended Register
			8'o011, 8'o031, 8'o051, 8'o071: begin
				if (stage == 3) begin
					ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_HL_L;
					ctrl_word[REG_OE] = 1'b1;
					ctrl_word[ALU_A_STORE] = 1'b1;
					ctrl_word[ALU_A_WE] = 1'b1;
				end else if (stage == 4) begin
					if (opcode[5:4] == 2'b11) begin
						ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_SP_P;
					end else begin
						ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = {2'b0, opcode[5:4], 1'b1};
					end

					ctrl_word[REG_OE] = 1'b1;
					ctrl_word[ALU_TMP_WE] = 1'b1;
				end else if (stage == 5) begin
					ctrl_word[ALU_CS] = 1'b1;
					ctrl_word[ALU_OP4:ALU_OP0] = 5'b00000; // Add
				end else if (stage == 6) begin
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_WZ_Z;
					ctrl_word[REG_WE] = 1'b1;
					ctrl_word[ALU_OE] = 1'b1;
				end else if (stage == 7) begin
					ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_HL_H;
					ctrl_word[REG_OE] = 1'b1;
					ctrl_word[ALU_A_WE] = 1'b1;
				end else if (stage == 8) begin
					if (opcode[5:4] == 2'b11) begin
						ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_SP_S;
					end else begin
						ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = {2'b0, opcode[5:4], 1'b0};
					end

					ctrl_word[REG_OE] = 1'b1;
					ctrl_word[ALU_TMP_WE] = 1'b1;
				end else if (stage == 9) begin
					ctrl_word[ALU_CS] = 1'b1;
					ctrl_word[ALU_OP4:ALU_OP0] = 5'b00001; // Add w/ Carry
				end else if (stage == 10) begin
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_WZ_W;
					ctrl_word[REG_WE] = 1'b1;
					ctrl_word[ALU_OE] = 1'b1;
					ctrl_word[ALU_A_RESTORE] = 1'b1;
				end else if (stage == 11) begin
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_HL;
					ctrl_word[REG_WE] = 1'b1;
					ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_WZ;
					ctrl_word[REG_OE] = 1'b1;
					stage_rst = 1'b1;
				end
			end

			// JMP
			8'o303: begin
				if (stage == 3) begin
					ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_PC;
					ctrl_word[REG_OE] = 1'b1;
					ctrl_word[MEM_MAR_WE] = 1'b1;
				end else if (stage == 4) begin
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_WZ_Z;
					ctrl_word[REG_WE] = 1'b1;
					ctrl_word[MEM_OE] = 1'b1;
				end else if (stage == 5) begin
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_PC;
					ctrl_word[REG_EXT1:REG_EXT0] = REG_INC;
				end else if (stage == 6) begin
					ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_PC;
					ctrl_word[REG_OE] = 1'b1;
					ctrl_word[MEM_MAR_WE] = 1'b1;
				end else if (stage == 7) begin
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_WZ_W;
					ctrl_word[REG_WE] = 1'b1;
					ctrl_word[MEM_OE] = 1'b1;
				end else if (stage == 8) begin
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_PC;
					ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_WZ;
					ctrl_word[REG_WE] = 1'b1;
					ctrl_word[REG_OE] = 1'b1;
					stage_rst = 1'b1;
				end
			end

			// Jump Conditional
			// opcode[5:4] - flag
			// opcode[3]   - set (1) / unset (0)
			8'o3?2: begin
				if (stage == 3) begin
					if (flags[opcode[5:4]] != opcode[3]) begin
						ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_PC;
						ctrl_word[REG_EXT1:REG_EXT0] = REG_INC2;
						stage_rst = 1'b1;
					end else begin
						ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_PC;
						ctrl_word[REG_OE] = 1'b1;
						ctrl_word[MEM_MAR_WE] = 1'b1;
					end
				end else if (stage == 4) begin
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_WZ_Z;
					ctrl_word[REG_WE] = 1'b1;
					ctrl_word[MEM_OE] = 1'b1;
				end else if (stage == 5) begin
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_PC;
					ctrl_word[REG_EXT1:REG_EXT0] = REG_INC;
				end else if (stage == 6) begin
					ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_PC;
					ctrl_word[REG_OE] = 1'b1;
					ctrl_word[MEM_MAR_WE] = 1'b1;
				end else if (stage == 7) begin
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_WZ_W;
					ctrl_word[REG_WE] = 1'b1;
					ctrl_word[MEM_OE] = 1'b1;
				end else if (stage == 8) begin
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_PC;
					ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_WZ;
					ctrl_word[REG_WE] = 1'b1;
					ctrl_word[REG_OE] = 1'b1;
					stage_rst = 1'b1;
				end
			end

			// Call Conditional
			// opcode[5:4] - flag
			// opcode[3]   - set (1) / unset (0)
			8'o3?4: begin
				if (stage == 3) begin
					if (flags[opcode[5:4]] != opcode[3]) begin
						ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_PC;
						ctrl_word[REG_EXT1:REG_EXT0] = REG_INC2;
						stage_rst = 1'b1;
					end else begin
						ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_PC;
						ctrl_word[REG_OE] = 1'b1;
						ctrl_word[MEM_MAR_WE] = 1'b1;
					end
				end else if (stage == 4) begin
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_WZ_Z;
					ctrl_word[REG_WE] = 1'b1;
					ctrl_word[MEM_OE] = 1'b1;
				end else if (stage == 5) begin
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_PC;
					ctrl_word[REG_EXT1:REG_EXT0] = REG_INC;
				end else if (stage == 6) begin
					ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_PC;
					ctrl_word[REG_OE] = 1'b1;
					ctrl_word[MEM_MAR_WE] = 1'b1;
				end else if (stage == 7) begin
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_WZ_W;
					ctrl_word[REG_WE] = 1'b1;
					ctrl_word[MEM_OE] = 1'b1;
				end else if (stage == 8) begin
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_PC;
					ctrl_word[REG_EXT1:REG_EXT0] = REG_INC;
				end else if (stage == 9) begin
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_SP;
					ctrl_word[REG_EXT1:REG_EXT0] = REG_DEC;
				end else if (stage == 10) begin
					ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_SP;
					ctrl_word[REG_OE] = 1'b1;
					ctrl_word[MEM_MAR_WE] = 1'b1;
				end else if (stage == 11) begin
					ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_PC_C;
					ctrl_word[REG_OE] = 1'b1;
					ctrl_word[MEM_WE] = 1'b1;
				end else if (stage == 12) begin
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_SP;
					ctrl_word[REG_EXT1:REG_EXT0] = REG_DEC;
				end else if (stage == 13) begin
					ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_SP;
					ctrl_word[REG_OE] = 1'b1;
					ctrl_word[MEM_MAR_WE] = 1'b1;
				end else if (stage == 14) begin
					ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_PC_P;
					ctrl_word[REG_OE] = 1'b1;
					ctrl_word[MEM_WE] = 1'b1;
				end else if (stage == 15) begin
					ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_WZ;
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_PC;
					ctrl_word[REG_WE] = 1'b1;
					ctrl_word[REG_OE] = 1'b1;
					stage_rst = 1'b1;
				end
			end

			// CALL
			8'o315: begin
				if (stage == 3) begin
					ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_PC;
					ctrl_word[REG_OE] = 1'b1;
					ctrl_word[MEM_MAR_WE] = 1'b1;
				end else if (stage == 4) begin
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_WZ_Z;
					ctrl_word[REG_WE] = 1'b1;
					ctrl_word[MEM_OE] = 1'b1;
				end else if (stage == 5) begin
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_PC;
					ctrl_word[REG_EXT1:REG_EXT0] = REG_INC;
				end else if (stage == 6) begin
					ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_PC;
					ctrl_word[REG_OE] = 1'b1;
					ctrl_word[MEM_MAR_WE] = 1'b1;
				end else if (stage == 7) begin
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_WZ_W;
					ctrl_word[REG_WE] = 1'b1;
					ctrl_word[MEM_OE] = 1'b1;
				end else if (stage == 8) begin
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_PC;
					ctrl_word[REG_EXT1:REG_EXT0] = REG_INC;
				end else if (stage == 9) begin
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_SP;
					ctrl_word[REG_EXT1:REG_EXT0] = REG_DEC;
				end else if (stage == 10) begin
					ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_SP;
					ctrl_word[REG_OE] = 1'b1;
					ctrl_word[MEM_MAR_WE] = 1'b1;
				end else if (stage == 11) begin
					ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_PC_C;
					ctrl_word[REG_OE] = 1'b1;
					ctrl_word[MEM_WE] = 1'b1;
				end else if (stage == 12) begin
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_SP;
					ctrl_word[REG_EXT1:REG_EXT0] = REG_DEC;
				end else if (stage == 13) begin
					ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_SP;
					ctrl_word[REG_OE] = 1'b1;
					ctrl_word[MEM_MAR_WE] = 1'b1;
				end else if (stage == 14) begin
					ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_PC_P;
					ctrl_word[REG_OE] = 1'b1;
					ctrl_word[MEM_WE] = 1'b1;
				end else if (stage == 15) begin
					ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_WZ;
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_PC;
					ctrl_word[REG_WE] = 1'b1;
					ctrl_word[REG_OE] = 1'b1;
					stage_rst = 1'b1;
				end
			end

			// Return Conditional
			// opcode[5:4] - flag
			// opcode[3]   - set (1) / unset (0)
			8'o3?0: begin
				if (stage == 3) begin
					if (flags[opcode[5:4]] != opcode[3]) begin
						stage_rst = 1'b1;
					end else begin
						ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_SP;
						ctrl_word[REG_OE] = 1'b1;
						ctrl_word[MEM_MAR_WE] = 1'b1;
					end
				end else if (stage == 4) begin
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_WZ_W;
					ctrl_word[REG_WE] = 1'b1;
					ctrl_word[MEM_OE] = 1'b1;
				end else if (stage == 5) begin
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_SP;
					ctrl_word[REG_EXT1:REG_EXT0] = REG_INC;
				end else if (stage == 6) begin
					ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_SP;
					ctrl_word[REG_OE] = 1'b1;
					ctrl_word[MEM_MAR_WE] = 1'b1;
				end else if (stage == 7) begin
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_WZ_Z;
					ctrl_word[REG_WE] = 1'b1;
					ctrl_word[MEM_OE] = 1'b1;
				end else if (stage == 8) begin
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_SP;
					ctrl_word[REG_EXT1:REG_EXT0] = REG_INC;
				end else if (stage == 9) begin
					ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_WZ;
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_PC;
					ctrl_word[REG_WE] = 1'b1;
					ctrl_word[REG_OE] = 1'b1;
					stage_rst = 1'b1;
				end
			end

			// RET
			8'o311: begin
				if (stage == 3) begin
					ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_SP;
					ctrl_word[REG_OE] = 1'b1;
					ctrl_word[MEM_MAR_WE] = 1'b1;
				end else if (stage == 4) begin
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_WZ_W;
					ctrl_word[REG_WE] = 1'b1;
					ctrl_word[MEM_OE] = 1'b1;
				end else if (stage == 5) begin
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_SP;
					ctrl_word[REG_EXT1:REG_EXT0] = REG_INC;
				end else if (stage == 6) begin
					ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_SP;
					ctrl_word[REG_OE] = 1'b1;
					ctrl_word[MEM_MAR_WE] = 1'b1;
				end else if (stage == 7) begin
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_WZ_Z;
					ctrl_word[REG_WE] = 1'b1;
					ctrl_word[MEM_OE] = 1'b1;
				end else if (stage == 8) begin
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_SP;
					ctrl_word[REG_EXT1:REG_EXT0] = REG_INC;
				end else if (stage == 9) begin
					ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_WZ;
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_PC;
					ctrl_word[REG_WE] = 1'b1;
					ctrl_word[REG_OE] = 1'b1;
					stage_rst = 1'b1;
				end
			end

			// PUSH Rs
			// opcode[5:4] - Extended Register
			8'o3?5: begin
				if (stage == 3) begin
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_SP;
					ctrl_word[REG_EXT1:REG_EXT0] = REG_DEC;
				end else if (stage == 4) begin
					ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_SP;
					ctrl_word[REG_OE] = 1'b1;
					ctrl_word[MEM_MAR_WE] = 1'b1;
				end else if (stage == 5) begin
					if (opcode[5:4] == 2'b11) begin // PSW
						ctrl_word[ALU_OE] = 1'b1;
					end else begin
						ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = {2'b0, opcode[5:4], 1'b0};
						ctrl_word[REG_OE] = 1'b1;
					end

					ctrl_word[MEM_WE] = 1'b1;
				end else if (stage == 6) begin
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_SP;
					ctrl_word[REG_EXT1:REG_EXT0] = REG_DEC;
				end else if (stage == 7) begin
					ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_SP;
					ctrl_word[REG_OE] = 1'b1;
					ctrl_word[MEM_MAR_WE] = 1'b1;
				end else if (stage == 8) begin
					if (opcode[5:4] == 2'b11) begin // PSW
						ctrl_word[ALU_FLAGS_OE] = 1'b1;
					end else begin
						ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = {2'b0, opcode[5:4], 1'b1};
						ctrl_word[REG_OE] = 1'b1;
					end

					ctrl_word[MEM_WE] = 1'b1;
					stage_rst = 1'b1;
				end
			end

			// POP Rs
			// opcode[5:4] - Extended Register
			8'o301, 8'o321, 8'o341, 8'o361: begin
				if (stage == 3) begin
					ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_SP;
					ctrl_word[REG_OE] = 1'b1;
					ctrl_word[MEM_MAR_WE] = 1'b1;
				end else if (stage == 4) begin
					if (opcode[5:4] == 2'b11) begin // PSW
						ctrl_word[ALU_FLAGS_WE] = 1'b1;
					end else begin
						ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = {2'b0, opcode[5:4], 1'b1};
						ctrl_word[REG_WE] = 1'b1;
					end

					ctrl_word[MEM_OE] = 1'b1;
				end else if (stage == 5) begin
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_SP;
					ctrl_word[REG_EXT1:REG_EXT0] = REG_INC;
				end else if (stage == 6) begin
					ctrl_word[REG_RD_SEL4:REG_RD_SEL0] = REG_SP;
					ctrl_word[REG_OE] = 1'b1;
					ctrl_word[MEM_MAR_WE] = 1'b1;
				end else if (stage == 7) begin
					if (opcode[5:4] == 2'b11) begin // PSW
						ctrl_word[ALU_A_WE] = 1'b1;
					end else begin
						ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = {2'b0, opcode[5:4], 1'b0};
						ctrl_word[REG_WE] = 1'b1;
					end

					ctrl_word[MEM_OE] = 1'b1;
				end else if (stage == 8) begin
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_SP;
					ctrl_word[REG_EXT1:REG_EXT0] = REG_INC;
					stage_rst = 1'b1;
				end
			end

			// OUT
			8'o323: begin
				if (stage == 3) begin
					ctrl_word[REG_WR_SEL4:REG_WR_SEL0] = REG_PC;
					ctrl_word[REG_EXT1:REG_EXT0] = REG_INC;
					ctrl_word[DISPLAY] = 1'b1;
					stage_rst = 1'b1;
				end
			end
		endcase
	end
end

endmodule

