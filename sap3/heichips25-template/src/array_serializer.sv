module array_serializer #(
    parameter WIDTH = 8,
    parameter DEPTH = 12
) (
    input  logic                  clk,
    input  logic                  rst,
    input  logic [DEPTH*WIDTH-1:0] data_flat,
    output logic                  serial_out,        // serieller Ausgang
    output logic                  start              // Start-Puls vor jedem Byte
);

    typedef enum logic [1:0] {IDLE, START_PULSE, SEND_BITS} state_t;
    state_t state;

    logic [$clog2(WIDTH)-1:0] bit_pos;
    logic [WIDTH-1:0]         shadow_reg;
    logic [$clog2(DEPTH)-1:0] word_index; // aktueller Index im Array

    logic [WIDTH-1:0] data [0:DEPTH-1];
    genvar i;
    generate
      for (i = 0; i < DEPTH; i = i + 1) begin
        assign data[i] = data_flat[i*WIDTH +: WIDTH];
      end
    endgenerate

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state       <= IDLE;
            bit_pos     <= '0;
            shadow_reg  <= '0;
            serial_out  <= 1'b0;
            start       <= 1'b0;
            word_index  <= '0;
        end else begin
            case (state)
                IDLE: begin
                    // Neues Wort ins Shadow-Register übernehmen
                    shadow_reg <= data[word_index];
                    start      <= 1'b1;    // Startsignal 1 Takt vor Bit 0
                    state      <= START_PULSE;
                end

                START_PULSE: begin
                    start      <= 1'b0;    // Start-Puls wieder aus
                    bit_pos    <= 0;       // Zähler zurücksetzen
                    serial_out <= shadow_reg[0];
                    state      <= SEND_BITS;
                end

                SEND_BITS: begin
                    if (bit_pos == WIDTH-1) begin
                        // Nächstes Wort vorbereiten (kontinuierlich)
                        if (word_index == DEPTH-1)
                            word_index <= 0;
                        else
                            word_index <= word_index + 1;

                        state <= IDLE; // direkt wieder neues Wort starten
                    end else begin
                        bit_pos    <= bit_pos + 1;
                        serial_out <= shadow_reg[bit_pos + 1];
                    end
                end
            endcase
        end
    end

endmodule
