`timescale 1ns/1ps

module testbench;

    initial begin
        $dumpfile("waveforms.fst");
        $dumpvars(0, testbench);
    end

    // Parameters
    localparam int NUM_IO = 8; // Change as needed or `define NUM_IO elsewhere

   // Testbench signals
    logic clk;
    logic [NUM_IO-1:0] io_in;
    logic [NUM_IO-1:0] io_out;
    logic [NUM_IO-1:0] io_oeb;

    // DUT instantiation
    top_tb dut (
        .clk    (clk),
        .io_in  (io_in),
        .io_out (io_out),
        .io_oeb (io_oeb)
    );
endmodule

 

 