// SPDX-FileCopyrightText: © 2025 XXX Authors
// SPDX-License-Identifier: Apache-2.0

// Adapted from the Tiny Tapeout template

// THIS IS THE SIMULATION

`default_nettype none

module heichips25_template (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    // List all unused inputs to prevent warnings
    wire _unused = &{ena};

    wire [15:0] bus;
    wire mem_ram_we;
    wire mem_mar_we;
    wire [7:0] sap_3_outputReg;
    wire sap_3_outputReg_serial;
    wire sap_3_outputReg_start_sync;
    wire regFile_serial;
    wire regFile_serial_start;

    assign uio_out = bus[7:0]; 
    assign uio_oe = bus [15:8];
    assign uo_out[0] = mem_ram_we;
    assign uo_out[1] = mem_mar_we;
    assign uo_out[2] = sap_3_outputReg_serial;
    assign uo_out[3] = sap_3_outputReg_start_sync;
    assign uo_out[4] = regFile_serial;
    assign uo_out[5] = regFile_serial_start;
    assign uo_out[7:6] = 2'b0;

    logic clk_div_out;
    clk_div_param #(
        .DIVIDE_BY(2)
    ) clk_div_param_inst (
        .clk(clk),
        .rst_n(rst_n),
        .clk_out(clk_div_out)
    );

    top sap_3_inst (
        .CLK(clk_div_out),
        .fast_clock(clk),
        .rst(~rst_n),
        .out(sap_3_outputReg),
        .mem_out(ui_in),
        .bus(bus),
        .mem_ram_we(mem_ram_we),
        .mem_mar_we(mem_mar_we),
        .serial_out_regFile(regFile_serial),
        .serial_start_regFile(regFile_serial_start)
    );

    serializer #(.WIDTH(8)) u_ser (
        .clk        (clk),
        .rst        (~rst_n),
        .data_in    (sap_3_outputReg),
        .serial_out (sap_3_outputReg_serial),
        .start      (sap_3_outputReg_start_sync)
    );


endmodule
