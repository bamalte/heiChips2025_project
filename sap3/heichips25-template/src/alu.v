module alu(
	input clk,
	input rst,
	input cs,
	input flags_we,
	input a_we,
	input a_store,
	input a_restore,
	input tmp_we,
	input[4:0] op,
	input[7:0] bus,
	output[7:0] flags,
	output[7:0] out
);

reg carry;

wire flg_c;
wire flg_z;
wire flg_p;
wire flg_s;

reg[7:0] acc;
reg[7:0] flg;
reg[7:0] act;    // Internal
reg[7:0] tmp;    // Internal

localparam FLG_Z = 0;
localparam FLG_C = 1;
localparam FLG_P = 2;
localparam FLG_S = 3;

localparam OP_ADD = 5'b00000;
localparam OP_ADC = 5'b00001;
localparam OP_SUB = 5'b00010;
localparam OP_SBB = 5'b00011;
localparam OP_ANA = 5'b00100;
localparam OP_XRA = 5'b00101;
localparam OP_ORA = 5'b00110;
localparam OP_CMP = 5'b00111;
localparam OP_RLC = 5'b01000;
localparam OP_RRC = 5'b01001;
localparam OP_RAL = 5'b01010;
localparam OP_RAR = 5'b01011;
localparam OP_DAA = 5'b01100; // Unsupported
localparam OP_CMA = 5'b01101;
localparam OP_STC = 5'b01110;
localparam OP_CMC = 5'b01111;
localparam OP_INR = 5'b10000;
localparam OP_DCR = 5'b10001;

assign flg_c = (carry == 1'b1);
assign flg_z = (acc[7:0] == 8'b0);
assign flg_s = acc[7];
assign flg_p = ~^acc[7:0];

always @(posedge clk, posedge rst) begin
	if (rst) begin
		acc <= 8'b0;
		act <= 8'b0;
		tmp <= 8'b0;
		carry <= 1'b0;
	end else begin
		if (a_we) begin
			acc <= bus;
		end else if (a_restore) begin
			acc <= act;
		end else if (cs) begin
			case (op)
				OP_ADD: begin
					{carry, acc} <= acc + tmp;
				end
				OP_ADC: begin
					{carry, acc} <= acc + tmp + flg[FLG_C];
				end
				OP_SUB:	begin
					{carry, acc} <= acc - tmp;
				end
				OP_SBB:	begin
					{carry, acc} <= acc - tmp - flg[FLG_C];
				end
				OP_ANA: begin
					{carry, acc} <= acc & tmp;
				end
				OP_XRA: begin
					{carry, acc} <= acc ^ tmp;
				end
				OP_ORA: begin
					{carry, acc} <= acc | tmp;
				end
				OP_CMP: begin
					act <= acc - tmp;
				end
				OP_RLC: begin
					carry <= acc[7];
					acc <= acc << 1;
				end
				OP_RRC: begin
					carry <= acc[0];
					acc <= acc >> 1;
				end
				OP_RAL: begin
					carry <= acc[7];
					acc <= (acc << 1 | {7'b0, flg[FLG_C]});
				end
				OP_RAR: begin
					carry <= acc[0];
					acc <= (acc >> 1 | {flg[FLG_C], 7'b0});
				end
				OP_CMA: begin
					acc <= ~acc;
				end
				OP_STC: begin
					carry <= 1'b1;
				end
				OP_CMC: begin
					carry <= ~flg[FLG_C];
				end
				OP_INR: begin
					acc <= acc + 1;
				end
				OP_DCR: begin
					acc <= acc - 1;
				end
			endcase
		end

		if (a_store)
			act <= acc;

		if (tmp_we)
			tmp <= bus;
	end
end

always @(negedge clk, posedge rst) begin
	if (rst) begin
		flg <= 8'b0;
	end else if (flags_we) begin
		flg <= bus;
	end else begin
		if (cs) begin
			case (op)
				OP_ADD, OP_ADC, OP_SUB, OP_SBB, OP_ANA, OP_XRA, OP_ORA: begin
					flg[FLG_C] <= flg_c;
					flg[FLG_Z] <= flg_z;
					flg[FLG_S] <= flg_s;
					flg[FLG_P] <= flg_p;
				end

				OP_CMP: begin
					flg[FLG_Z] <= (act == 8'b0);
				end

				OP_INR, OP_DCR: begin
					flg[FLG_Z] <= flg_z;
					flg[FLG_S] <= flg_s;
					flg[FLG_P] <= flg_p;
				end

				OP_RLC, OP_RRC, OP_RAL, OP_RAR, OP_STC, OP_CMC: begin
					flg[FLG_C] <= flg_c;
				end
			endcase
		end
	end
end

assign flags = flg;
assign out = acc;

endmodule

