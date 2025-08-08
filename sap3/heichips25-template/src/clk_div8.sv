// clk_div4.sv
// Divide input clock by 4. Async active-low reset.
module clk_div8 (
    input  logic clk,     // input clock
    input  logic rst_n,   // active-low asynchronous reset
    output logic clk_out  // output clock = clk / 8 (50% duty)
);

    logic [2:0] cnt;
    logic [2:0] cnt_next;

    // next value of counter
    always_comb begin
        cnt_next = cnt + 3'd1;
    end

    // register update (async reset)
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt     <= 3'd0;
            clk_out <= 1'b0;
        end else begin
            cnt     <= cnt_next;
            clk_out <= cnt_next[2]; // MSB toggles every 4 input-clocks -> /8 overall
        end
    end

endmodule
