// clk_div_param.sv
// Parameterized clock divider with async active-low reset
module clk_div_param #(
    parameter int DIVIDE_BY = 4  // division factor (must be even for 50% duty cycle)
)(
    input  logic clk,
    input  logic rst_n,
    output logic clk_out
);

    // calculate width of counter based on DIVIDE_BY
    localparam int COUNTER_WIDTH = $clog2(DIVIDE_BY);

    logic [COUNTER_WIDTH-1:0] count;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= '0;
            clk_out <= 1'b0;
        end else begin
            if (count == DIVIDE_BY/2 - 1) begin
                clk_out <= ~clk_out;
                count <= 0;
            end else begin
                count <= count + 1;
            end
        end
    end

endmodule
