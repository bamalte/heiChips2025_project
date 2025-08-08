// SPDX-FileCopyrightText: © 2025 XXX Authors
// SPDX-License-Identifier: Apache-2.0

// Adapted from the Tiny Tapeout template

// THIS IS THE SIMULATION

/*
`include "reg_file.v"
`include "memory.v"
`include "ir.v"
`include "controller.v"
`include "clock.v"
`include "alu.v"
`include "top.v"
*/
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
    (* keep *)wire mem_ram_we;
    (* keep *)wire mem_mar_we;

    assign uio_out = bus[7:0]; // Output the lower 8 bits of the bus to uio_out
    assign uio_oe[5:0] = bus [13:8]; // Use the upper 8 bits of the bus to control output enable
    assign uio_oe[6] = mem_ram_we;
    assign uio_oe[7] = mem_mar_we;

    top sap_3_inst (
        .CLK(clk),
        .rst(~rst_n),
        .out(uo_out),
        .mem_out(ui_in),
        .bus(bus),
        .mem_ram_we(mem_ram_we),
        .mem_mar_we(mem_mar_we)
    );


endmodule
