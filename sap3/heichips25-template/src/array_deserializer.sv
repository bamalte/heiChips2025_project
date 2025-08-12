module array_deserializer #(
    parameter WIDTH = 8,
    parameter DEPTH = 12
) (
    input  logic                  clk,
    input  logic                  rst,
    input  logic                  serial_in,        // Serieller Datenstrom
    input  logic                  start,            // Startsignal (1 Takt vor Bit 0)
    output logic [WIDTH-1:0]      data_out          // Empfangene Daten
);

    typedef enum logic [1:0] {IDLE, RECEIVE, WRITE} state_t;
    state_t state;

    logic [$clog2(WIDTH)-1:0] bit_cnt;
    logic [WIDTH-1:0]         shift_reg;
    logic [$clog2(DEPTH)-1:0] word_index;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state      <= IDLE;
            bit_cnt    <= '0;
            word_index <= '0;
            shift_reg  <= '0;
            // Initialisierung data_out ist optional, je nach Anforderung
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        bit_cnt <= 0;
                        state   <= RECEIVE;
                    end
                end

                RECEIVE: begin
                    shift_reg[bit_cnt] <= serial_in;
                    if (bit_cnt == WIDTH - 1) begin
                        state <= WRITE;
                    end else begin
                        bit_cnt <= bit_cnt + 1;
                    end
                end

                WRITE: begin
                    data_out <= shift_reg;

                    if (word_index == DEPTH - 1)
                        word_index <= 0;
                    else
                        word_index <= word_index + 1;

                    state <= IDLE;
                end
            endcase
        end
    end

endmodule
