module IHP_SRAM_1024x32_wrapper (
    input  logic        clk,    // Clock
    input  logic [9:0]  ADDR,   // Address (1024 entries)
    input  logic [31:0] BM,     // Byte mask (ignored)
    input  logic [31:0] DIN,    // Data in
    input  logic        WEN,    // Write enable (active high)
    input  logic        MEN,    // Memory enable (ignored)
    input  logic        REN,    // Read enable (active high)
    output logic [31:0] DOUT    // Data out
);

    // Internal memory array
    logic [31:0] mem [0:1023];

    initial begin
	$readmemh("../program.hex", mem);
    end
    
    always_ff @(posedge clk) begin
        // Write on WEN
        if (WEN)
            mem[ADDR] <= DIN;

        // Read on REN
        if (REN)
            DOUT = mem[ADDR];
        else
            DOUT = 32'b0;

    end
    
    
    

endmodule