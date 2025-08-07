
module top(
	input CLK
);

reg[7:0] bus;
wire rst;
wire hlt;
wire clk;
wire pc_inc;
wire pc_en;
wire[7:0] pc_out;
wire mar_load;
wire mem_en;
wire[7:0] mem_out;
wire a_load;
wire a_en;
wire[7:0] a_out;
wire b_load;
wire[7:0] b_out;
wire adder_sub;
wire adder_en;
wire[7:0] adder_out;
wire ir_load;
wire ir_en;
wire[7:0] ir_out;

always @(*) begin
	if (ir_en) begin
		bus = ir_out;
	end else if (adder_en) begin
		bus = adder_out;
	end else if (a_en) begin
		bus = a_out;
	end else if (mem_en) begin
		bus = mem_out;
	end else if (pc_en) begin
		bus = pc_out;
	end else begin
		bus = 8'b0;
	end
end


clock clock(
	.hlt(hlt),
	.clk_in(CLK),
	.clk_out(clk)
);

pc pc(
	.clk(clk),
	.rst(rst),
	.inc(pc_inc),
	.out(pc_out)
);


memory mem(
	.clk(clk),
	.rst(rst),
	.load(mar_load),
	.bus(bus),
	.out(mem_out)
);


reg_a reg_a(
	.clk(clk),
	.rst(rst),

	.load(a_load),
	.bus(bus),
	.out(a_out)
);


reg_b reg_b(
	.clk(clk),
	.rst(rst),
	.load(b_load),
	.bus(bus),
	.out(b_out)
);



adder adder(
	.a(a_out),
	.b(b_out),
	.sub(adder_sub),
	.out(adder_out)
);



ir ir(
	.clk(clk),
	.rst(rst),
	.load(ir_load),
	.bus(bus),
	.out(ir_out)
);

controller controller(
	.clk(clk),
	.rst(rst),
	.opcode(ir_out[7:4]),
	.out(
	{
		hlt,
		pc_inc,
		pc_en,
		mar_load,
		mem_en,
		ir_load,
		ir_en,
		a_load,
		a_en,
		b_load,
		adder_sub,
		adder_en
	})
);

endmodule

