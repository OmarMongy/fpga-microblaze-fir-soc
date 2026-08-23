module fir_filter #(
    parameter int WIDTH = 16,
    parameter int TAP   = 51
)(
    input  logic                         clk,
    input  logic                         reset_n,
    input  logic signed [WIDTH-1:0]      inp_sig,

    // Filter coefficients
    input  logic signed [WIDTH-1:0]      coff [0:TAP-1],

    output logic signed [2*WIDTH-1:0]    out_sig
);

    // ----------------------------------------------------------------
    // Delay line
    // ----------------------------------------------------------------
    logic signed [WIDTH-1:0] delay [0:TAP-1];

    // ----------------------------------------------------------------
    // Multiplication results
    // ----------------------------------------------------------------
    logic signed [2*WIDTH-1:0] mult [0:TAP-1];

    // ----------------------------------------------------------------
    // FIR accumulator
    // ----------------------------------------------------------------
    logic signed [2*WIDTH-1:0] acc;


    // ----------------------------------------------------------------
    // Delay registers
    // ----------------------------------------------------------------
    always_ff @(posedge clk or negedge reset_n) begin

        if (!reset_n) begin
            for (int i = 0; i < TAP; i = i + 1)
                delay[i] <= '0;
        end
        else begin

            // Shift previous samples
            for (int i = TAP-1; i > 0; i = i - 1)
                delay[i] <= delay[i-1];

            // Insert newest sample
            delay[0] <= inp_sig;

        end

    end

    // ----------------------------------------------------------------
    // Multipliers
    //
    // Current input uses coefficient 0.
    // delay[1] uses coefficient 1, etc.
    // ----------------------------------------------------------------
    always_comb begin

        mult[0] = inp_sig * coff[0];

        for (int i = 1; i < TAP; i = i + 1)
            mult[i] = delay[i] * coff[i];

    end

    // ----------------------------------------------------------------
    // FIR accumulation
    // ----------------------------------------------------------------
    always_comb begin

        acc = '0;

        for (int i = 0; i < TAP; i = i + 1)
            acc = acc + mult[i];

    end

    // ----------------------------------------------------------------
    // Filter output
    // ----------------------------------------------------------------
    assign out_sig = acc;
endmodule
