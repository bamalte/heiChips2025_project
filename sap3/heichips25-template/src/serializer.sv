module serializer #(
    parameter WIDTH = 8
) (
    input  logic             clk,
    input  logic             rst,
    input  logic [WIDTH-1:0] data_in,    // parallel data
    output logic             serial_out  // serial output
);

  logic [$clog2(WIDTH)-1:0] bit_pos; // current bit position

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            bit_pos    <= '0;
            serial_out <= 1'b0;
        end else begin
            // output current bit
            serial_out <= data_in[bit_pos];

            // next bit position
            if (bit_pos == WIDTH-1)
                bit_pos <= 0;
            else
                bit_pos <= bit_pos + 1;
        end
    end

endmodule
