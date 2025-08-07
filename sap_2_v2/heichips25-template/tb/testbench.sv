`timescale 1ns/1ps

module testbench;

    initial begin
        $dumpfile("waveforms.fst");
        $dumpvars(0, testbench);
    end

    logic [7:0] ui_in;
    logic [7:0] uo_out;
    logic [7:0] uio_in;
    logic [7:0] uio_out;
    logic [7:0] uio_oe;
    logic       ena;
    logic       clk;
    logic       rst_n;

    tt_um_example tt_um_example (
        .ui_in,
        .uo_out,
        .uio_in,
        .uio_out,
        .uio_oe,
        .ena,
        .clk,
        .rst_n
    );

endmodule
