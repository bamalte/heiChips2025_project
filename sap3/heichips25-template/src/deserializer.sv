module deserializer #(
    parameter WIDTH = 8
) (
    input  logic             clk,
    input  logic             rst,
    input  logic             serial_in,  // Serieller Datenstrom vom Serializer
    input  logic             start,      // Startsignal vom Serializer (1 Takt vor Bit 0)
    output logic [WIDTH-1:0] data_out,    // Parallelausgabe
    output logic             synced      // High während des Empfangs
);

    logic [$clog2(WIDTH)-1:0] bit_cnt;
    logic [WIDTH-1:0]         shift_reg;
    logic                     start_d; // verzögertes Startsignal

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            bit_cnt    <= '0;
            shift_reg  <= '0;
            data_out   <= '0;
            synced     <= 1'b0;
            start_d    <= 1'b0;
        end else begin
            start_d <= start; // für Taktversatz

            if (start) begin
                // Vorbereitung: Zähler auf 0, aber noch kein Bit übernehmen
                bit_cnt <= 0;
                synced  <= 1'b1;
            end else if (synced) begin
                // Erstes Bit kommt direkt nach Start-Puls
                shift_reg[bit_cnt] <= serial_in;

                if (bit_cnt == WIDTH-1) begin
                    data_out <= shift_reg;
                    synced   <= 1'b0; // Empfang abgeschlossen
                end else begin
                    bit_cnt <= bit_cnt + 1;
                end
            end
        end
    end

endmodule

