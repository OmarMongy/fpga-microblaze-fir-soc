`timescale 1ns / 1ps

module Microblaze_bd_tb;

    // ================================================================
    // Parameters
    // ================================================================
    parameter int WIDTH = 16;
    parameter int TAP   = 51;

    parameter real SINE_FREQ   = 1500.0;
    parameter real SAMPLE_FREQ = 50000.0;

    parameter integer SINE_AMPLITUDE = 14000;

    parameter real PI = 3.14159265358979323846;


    // ================================================================
    // Clocks
    // ================================================================
    logic clk_in1_0;
    logic clk_in1_1;


    // ================================================================
    // Resets
    // ================================================================
    logic reset_0;
    logic reset_0_1;


    // ================================================================
    // S_AXIS_0 AXI-Stream INPUT
    // ================================================================
    logic [15:0] S_AXIS_0_tdata;
    wire         S_AXIS_0_tready;
    logic        S_AXIS_0_tvalid;


    // ================================================================
    // M_AXIS_0 AXI-Stream OUTPUT
    // ================================================================
    wire [31:0] M_AXIS_0_tdata;
    wire        M_AXIS_0_tlast;
    logic       M_AXIS_0_tready;
    wire [3:0]  M_AXIS_0_tstrb;
    wire        M_AXIS_0_tvalid;


    // ================================================================
    // DUT
    // ================================================================
    design_103_bd_wrapper dut (

        // ---------------- Clock 0 ----------------
        .clk_in1_0       (clk_in1_0),

        // ---------------- Clock 1 ----------------
        .clk_in1_1       (clk_in1_1),

        // ---------------- Resets ----------------
        .reset_0         (reset_0),
        .reset_0_1       (reset_0_1),

        // ---------------- AXI Stream Input ----------------
        .S_AXIS_0_tdata  (S_AXIS_0_tdata),
        .S_AXIS_0_tready (S_AXIS_0_tready),
        .S_AXIS_0_tvalid (S_AXIS_0_tvalid),

        // ---------------- AXI Stream Output ----------------
        .M_AXIS_0_tdata  (M_AXIS_0_tdata),
        .M_AXIS_0_tlast  (M_AXIS_0_tlast),
        .M_AXIS_0_tready (M_AXIS_0_tready),
        .M_AXIS_0_tstrb  (M_AXIS_0_tstrb),
        .M_AXIS_0_tvalid (M_AXIS_0_tvalid)
    );


    // ================================================================
    // Clock Generation
    // ================================================================
    // 50 MHz
    // Period = 20 ns
    // ================================================================

    initial begin
        clk_in1_0 = 1'b0;

        forever
            #10 clk_in1_0 = ~clk_in1_0;
    end


    // ------------------------------------------------
    // Clock 1
    // Same 50 MHz clock
    // ------------------------------------------------
    initial begin
        clk_in1_1 = 1'b0;

        forever
            #10 clk_in1_1 = ~clk_in1_1;
    end


    // ================================================================
    // Initial Values
    // ================================================================
    initial begin

        // Reset asserted
        reset_0   = 1'b1;
        reset_0_1 = 1'b0;

        // AXI input
        S_AXIS_0_tdata  = 16'd0;
        S_AXIS_0_tvalid = 1'b0;

        // Always ready to receive output
        M_AXIS_0_tready = 1'b1;

    end


    // ================================================================
    // Reset Sequence
    // ================================================================
    initial begin

        // Assert all resets
        reset_0   = 1'b0;
        reset_0_1 = 1'b0;

        // Hold reset for 10 clock cycles
        repeat (10)
            @(posedge clk_in1_0);

        // Release all resets
        reset_0   = 1'b0;
        reset_0_1 = 1'b1;

        $display("========================================");
        $display("Design reset released");
        $display("========================================");

    end


    // ================================================================
    // Sine Wave Generator
    // ================================================================
    wire [15:0] sine_value;

    sine_gen sg (
        clk_in1_0,
        sine_value
    );


    // ================================================================
    // AXI-Stream Input Generator
    // ================================================================
    initial begin

        // Wait until reset is released
        wait(reset_0   == 1'b0);
        wait(reset_0_1 == 1'b1);

        // Allow system to initialize
        repeat(20)
            @(posedge clk_in1_0);

        $display("========================================");
        $display("Starting 1500 Hz sine wave");
        $display("Sample Frequency = %0.0f Hz", SAMPLE_FREQ);
        $display("Sine Frequency   = %0.0f Hz", SINE_FREQ);
        $display("Amplitude        = %0d", SINE_AMPLITUDE);
        $display("========================================");


        // ============================================================
        // Input AXI Stream
        // ============================================================
        forever begin

            // Present sine sample
            S_AXIS_0_tdata  <= $rtoi(sine_value);
            S_AXIS_0_tvalid <= 1'b1;

            // Wait for clock
            @(posedge clk_in1_0);

            // AXI-Stream transfer
            if (S_AXIS_0_tvalid && S_AXIS_0_tready) begin

                $display(
                    "TIME=%0t | INPUT=%0d | INPUT_HEX=%h",
                    $time,
                    $signed(S_AXIS_0_tdata),
                    S_AXIS_0_tdata
                );

            end

        end

    end


    // ================================================================
    // Monitor AXI Input
    // ================================================================
    always @(posedge clk_in1_0) begin

        if (S_AXIS_0_tvalid && S_AXIS_0_tready) begin

            $display(
                "TIME=%0t | AXI INPUT | DATA=%0d | HEX=%h",
                $time,
                $signed(S_AXIS_0_tdata),
                S_AXIS_0_tdata
            );

        end

    end


    // ================================================================
    // Monitor FIR Output
    // ================================================================
    always @(posedge clk_in1_0) begin

        if (M_AXIS_0_tvalid && M_AXIS_0_tready) begin

            $display(
                "TIME=%0t | FIR OUTPUT=%0d | OUTPUT_HEX=%h | TLAST=%b",
                $time,
                $signed(M_AXIS_0_tdata),
                M_AXIS_0_tdata,
                M_AXIS_0_tlast
            );

        end

    end


    // ================================================================
    // Check AXI Output TSTRB
    // ================================================================
    always @(posedge clk_in1_0) begin

        if (M_AXIS_0_tvalid) begin

            if (M_AXIS_0_tstrb !== 4'b1111) begin

                $display(
                    "WARNING: Unexpected output TSTRB = %b",
                    M_AXIS_0_tstrb
                );

            end

        end

    end


    // ================================================================
    // Simulation Timeout
    // ================================================================
    initial begin

        #200000;

        $display("========================================");
        $display("Simulation finished.");
        $display("========================================");

        $stop;

    end

endmodule
