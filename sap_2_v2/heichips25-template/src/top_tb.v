module top_tb();


initial begin
	$dumpfile("top_tb.vcd");
	$dumpvars(0, top_tb);
	rst = 1;
	#1 rst = 0;
end

reg[15:0] bus;

always @(*) begin
	if (a_en) begin
		bus = a_out;
	end else if (b_en) begin
		bus = b_out;
	end else if (c_en) begin
		bus = c_out;
	end else if (alu_en) begin
		bus = alu_out;
	end else if (pc_en) begin
		bus = pc_out;
	end else if (mdr_en) begin
		bus = mem_out;
	end else begin
		bus = 16'b0;
	end
end

reg clk_in = 0;
integer i;
initial begin
	for (i = 0; i < 512; i++) begin
		#1 clk_in = ~clk_in;
	end
end

reg rst;
wire hlt;
wire clk;
clock clock(
	.hlt(hlt),
	.clk_in(clk_in),
	.clk_out(clk)
);

wire pc_inc;
wire pc_load;
wire pc_en;
wire[15:0] pc_out;
pc pc(
	.clk(clk),
	.rst(rst),
	.inc(pc_inc),
	.load(pc_load),
	.bus(bus),
	.out(pc_out)
);

wire ir_load;
wire[7:0] ir_out;
ir ir(
	.clk(clk),
	.rst(rst),
	.load(ir_load),
	.bus(bus),
	.out(ir_out)
);

wire mar_loadh;
wire mar_loadl;
wire mdr_load;
wire mdr_en;
wire ram_load;
wire ram_enh;
wire ram_enl;
wire call;
wire ret;
wire[15:0] mem_out;
memory mem(
	.clk(clk),
	.rst(rst),
	.mar_loadh(mar_loadh),
	.mar_loadl(mar_loadl),
	.mdr_load(mdr_load),
	.ram_load(ram_load),
	.ram_enh(ram_enh),
	.ram_enl(ram_enl),
	.call(call),
	.ret(ret),
	.bus(bus),
	.out(mem_out)
);

wire a_load;
wire a_en;
wire a_inc;
wire a_dec;
wire[7:0] a_out;
register reg_a(
	.clk(clk),
	.rst(rst),
	.load(a_load),
	.inc(a_inc),
	.dec(a_dec),
	.bus(bus),
	.out(a_out)
);

wire b_load;
wire b_en;
wire b_inc;
wire b_dec;
wire[7:0] b_out;
register reg_b(
	.clk(clk),
	.rst(rst),
	.load(b_load),
	.inc(b_inc),
	.dec(b_dec),
	.bus(bus),
	.out(b_out)
);

wire c_load;
wire c_en;
wire c_inc;
wire c_dec;
wire[7:0] c_out;
register reg_c(
	.clk(clk),
	.rst(rst),
	.load(c_load),
	.inc(c_inc),
	.dec(c_dec),
	.bus(bus),
	.out(c_out)
);

wire[2:0] alu_op;
wire alu_load;
wire alu_en;
wire[7:0] alu_out;
alu alu(
	.clk(clk),
	.rst(rst),
	.a(a_out),
	.load(alu_load),
	.op(alu_op),
	.bus(bus),
	.out(alu_out)
);

wire[1:0] flags_out;
wire flags_lda;
wire flags_ldb;
wire flags_ldc;
flags flags(
	.clk(clk),
	.rst(rst),
	.a(a_out),
	.b(b_out),
	.c(c_out),
	.load_a(flags_lda),
	.load_b(flags_ldb),
	.load_c(flags_ldc),
	.out(flags_out)
);

controller controller(
	.clk(clk),
	.rst(rst),
	.opcode(ir_out),
	.flags(flags_out),
	.out({
		hlt,
		a_load, a_en, a_inc, a_dec,
		b_load, b_en, b_inc, b_dec,
		c_load, c_en, c_inc, c_dec,
		flags_lda, flags_ldb, flags_ldc,
		alu_op, alu_load, alu_en,
		ir_load,
		pc_inc, pc_load, pc_en,
		mar_loadh, mar_loadl, mdr_load,
		mdr_en,
		ram_load, ram_enh, ram_enl,
		call, ret})
);

endmodule

