//------------------------------------------------------------------------------
// Module: serializer
// Description: 
//   This module converts parallel input data into a serial output stream.
//   On each clock cycle, it outputs one bit of the input data, cycling through
//   all bits from LSB to MSB. The bit position resets after reaching the last bit
//   or when reset is asserted.
//
// Parameters:
//   WIDTH - Width of the parallel input data (default: 8)
//
// Ports:
//   clk        (input)  - Clock signal
//   rst        (input)  - Asynchronous reset signal (active high)
//   data_in    (input)  - Parallel data input of width WIDTH
//   serial_out (output) - Serial output bit
//------------------------------------------------------------------------------


module serializer #(
    parameter WIDTH = 8
) (
    input  logic             clk,
    input  logic             rst,
    input  logic [WIDTH-1:0] data_in,     // parallel data
    output logic             serial_out,  // serial output
    output logic             start        // sync pulse for deserializer
);

    typedef enum logic [1:0] {IDLE, START_PULSE, SEND_BITS} state_t;
    state_t state;

    logic [$clog2(WIDTH)-1:0] bit_pos;
    logic [WIDTH-1:0]         shadow_reg;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state       <= IDLE;
            bit_pos     <= '0;
            shadow_reg  <= '0;
            serial_out  <= 1'b0;
            start       <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    // Neues Wort ins Shadow-Register übernehmen
                    shadow_reg <= data_in;
                    start      <= 1'b1;    // Startsignal jetzt 1 Takt vor Bit 0
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
                        state <= IDLE;     // Nach letztem Bit wieder von vorne
                    end else begin
                        bit_pos    <= bit_pos + 1;
                        serial_out <= shadow_reg[bit_pos + 1];
                    end
                end
            endcase
        end
    end
endmodule
