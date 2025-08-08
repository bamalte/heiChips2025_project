// SPDX-FileCopyrightText: © 2025 XXX Authors
// SPDX-License-Identifier: Apache-2.0

// Adapted from the Tiny Tapeout template

`include "reg_file.v"
`include "memory.v"
`include "ir.v"
`include "controller.v"
`include "clock.v"
`include "alu.v"
`include "top.v"

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
    wire [7:0] out_unused;
    wire temp = out_unused[0] ^ out_unused[1] ^ out_unused[2] ^ out_unused[3] ^ out_unused[4] ^ out_unused[5] ^ out_unused[6] ^ out_unused[7];

    assign uio_out = bus[7:0]; 
    assign uio_oe = bus [15:8];
    assign uo_out[0] = mem_ram_we;
    assign uo_out[1] = mem_mar_we;
    assign uo_out[2] = temp;
    assign uo_out[3:7] = 5'b0; // Unused outputs

    top sap_3_inst (
        .CLK(clk),
        .rst(~rst_n),
        .out(out_unused),
        .mem_out(ui_in),
        .bus(bus),
        .mem_ram_we(mem_ram_we),
        .mem_mar_we(mem_mar_we)
    );


endmodule
