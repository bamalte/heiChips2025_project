module deserializer #(
    parameter WIDTH = 8
) (
    input  logic             clk,
    input  logic             rst,
    input  logic             serial_in,
    output logic [WIDTH-1:0] data_out,
    output logic             synced
);

    logic [$clog2(WIDTH)-1:0] bit_pos;

    typedef enum logic [1:0] {WAIT_FOR_RISE, RECEIVE} state_t;
    state_t state;

    logic [$clog2(WIDTH)-1:0] bit_cnt;
    logic [WIDTH-1:0] shift_reg;

    logic serial_in_d; // delayed signal for edge detection

    // Edge detection
    wire rising_edge = (serial_in == 1) && (serial_in_d == 0);

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            serial_in_d <= 0;
            state       <= WAIT_FOR_RISE;
            bit_cnt     <= 0;
            shift_reg   <= 0;
            data_out    <= 0;
            synced      <= 0;
        end else begin
            serial_in_d <= serial_in;

            case(state)
                WAIT_FOR_RISE: begin
                    synced <= 0;
                    bit_cnt <= 0;
                    if (rising_edge) begin
                        // Rising edge detected, start synchronization
                        state <= RECEIVE;
                        shift_reg <= 0;
                        // Count this 1-bit as the first bit (bit 0)
                        shift_reg[0] <= 1'b1;
                        bit_cnt <= 1; // index next bit
                    end
                end

                RECEIVE: begin
                    // Collect bits starting from the second bit (first is the edge)
                    shift_reg[bit_cnt] <= serial_in;
                    if (bit_cnt == WIDTH-1) begin
                        data_out <= shift_reg;
                        bit_cnt <= 0;
                    end else begin
                        bit_cnt <= bit_cnt + 1;
                    end

                    synced <= 1;
                end
            endcase

            bit_pos <= bit_cnt;
        end
    end
endmodule
