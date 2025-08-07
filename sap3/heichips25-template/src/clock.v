module clock(
	input hlt,
	input clk_in,
	output clk_out);

//assign clk_out = (hlt) ? 1'b0 : clk_in;

sg13g2_lgcp_1 clock_gate_inst(.GCLK(clk_out), .GATE(hlt), .CLK(clk_in));


endmodule

