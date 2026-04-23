module alu_fsm (
    input  logic clk,
    input  logic reset,
    input  logic start,     // ALU request signal
    output logic alu_en      // Enables ALU (power control)
);

    // ----------------------------
    // FSM State Declaration
    // ----------------------------
    typedef enum logic [1:0] {
        IDLE,       // No ALU activity (lowest power)
        LOW_PWR,    // Occasional ALU activity
        HIGH_PWR    // Continuous ALU activity
    } state_t;

    state_t current_state, next_state;

    // ----------------------------
    // Activity Counter
    // ----------------------------
    logic [3:0] activity_count;

    // ----------------------------
    // State Register
    // ----------------------------
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // ----------------------------
    // Activity Monitor (Self-Calibration)
    // ----------------------------
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            activity_count <= 4'd0;
        else if (start) begin
            if (activity_count < 4'd15)
                activity_count <= activity_count + 1;
        end else
            activity_count <= 4'd0;
    end

    // ----------------------------
    // Next-State Logic
    // ----------------------------
    always_comb begin
        next_state = current_state;

        case (current_state)
            IDLE: begin
                if (start)
                    next_state = LOW_PWR;
            end

            LOW_PWR: begin
                if (!start)
                    next_state = IDLE;
                else if (activity_count > 4)
                    next_state = HIGH_PWR;
            end

            HIGH_PWR: begin
                if (!start)
                    next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // ----------------------------
    // Output Logic (Power Control)
    // ----------------------------
    always_comb begin
        case (current_state)
            LOW_PWR,
            HIGH_PWR: alu_en = 1'b1;   // ALU ON
            default:  alu_en = 1'b0;   // ALU OFF
        endcase
    end

endmodule
