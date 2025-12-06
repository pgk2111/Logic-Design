module debounce (
    input logic clk,           // Input clock (e.g., 50 MHz)
    input logic button_in,     // Raw button input signal
    output logic button_out    // Debounced button output
);
    // Parameters
    parameter integer DEBOUNCE_TIME = 500_000; // 10 ms debounce time for a 50 MHz clock

    // State definitions
    typedef enum logic [1:0] {
        IDLE,          // Waiting for button press
        PRESS,         // Detecting a stable press
        RELEASE,       // Detecting a stable release
        STABLE         // Stable state, button press confirmed
    } state_t;

    state_t current_state, next_state;
    integer counter;           // Counter for debounce timing

    // State transition and output logic
    always_ff @(posedge clk) begin
        current_state <= next_state;

        // Output logic
        case (current_state)
            STABLE: button_out <= 1;
            default: button_out <= 0;
        endcase
    end

    // Next state logic and counter management
    always_comb begin
        // Default to stay in current state and reset the counter
        next_state = current_state;

        case (current_state)
            IDLE: begin
                if (button_in) begin
                    next_state = PRESS;
                end
            end

            PRESS: begin
                if (counter >= DEBOUNCE_TIME) begin
                    next_state = STABLE; // Move to stable state if button held long enough
                end else if (!button_in) begin
                    next_state = IDLE;   // Return to IDLE if button released early
                end
            end

            STABLE: begin
                if (!button_in) begin
                    next_state = RELEASE;
                end
            end

            RELEASE: begin
                if (counter >= DEBOUNCE_TIME) begin
                    next_state = IDLE;   // Move back to IDLE once button release is stable
                end else if (button_in) begin
                    next_state = STABLE; // Return to STABLE if button pressed again
                end
            end
        endcase
    end

    // Counter management
    always_ff @(posedge clk) begin
        if ((current_state == PRESS || current_state == RELEASE) && 
            (next_state == current_state)) begin
            counter <= counter + 1;
        end else begin
            counter <= 0;
        end
    end
endmodule
