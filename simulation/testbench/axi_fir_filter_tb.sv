`timescale 1ns / 1ps

module axi_fir_filter_tb;

    parameter int WIDTH = 16;
    parameter int TAP   = 51;

    // ================================================================
    // Clocks and resets
    // ================================================================
    logic clk;
    logic reset_n;

    // ================================================================
    // S00 AXI-Lite
    // ================================================================
    logic [7:0]  s00_axi_awaddr;
    logic [2:0]  s00_axi_awprot;
    logic        s00_axi_awvalid;
    logic        s00_axi_awready;

    logic [31:0] s00_axi_wdata;
    logic [3:0]  s00_axi_wstrb;
    logic        s00_axi_wvalid;
    logic        s00_axi_wready;

    logic [1:0]  s00_axi_bresp;
    logic        s00_axi_bvalid;
    logic        s00_axi_bready;

    logic [7:0]  s00_axi_araddr;
    logic [2:0]  s00_axi_arprot;
    logic        s00_axi_arvalid;
    logic        s00_axi_arready;

    logic [31:0] s00_axi_rdata;
    logic [1:0]  s00_axi_rresp;
    logic        s00_axi_rvalid;
    logic        s00_axi_rready;

    // ================================================================
    // S01 AXI-Stream INPUT
    // ================================================================
    logic        s01_axi_tvalid;
    logic        s01_axi_tready;
    logic [15:0] s01_axi_tdata;
    logic [1:0]  s01_axi_tstrb;
    logic        s01_axi_tlast;

    // ================================================================
    // M02 AXI-Stream OUTPUT
    // ================================================================
    logic        m02_axi_tvalid;
    logic [31:0] m02_axi_tdata;
    logic [3:0]  m02_axi_tstrb;
    logic        m02_axi_tlast;
    logic        m02_axi_tready;

    // ================================================================
    // DUT
    // ================================================================
    axi_fir_filter_v1_0 dut (

        // ---------------- S00 AXI-Lite ----------------
        .s00_axi_aclk       (clk),
        .s00_axi_aresetn   (reset_n),

        .s00_axi_awaddr    (s00_axi_awaddr),
        .s00_axi_awprot    (s00_axi_awprot),
        .s00_axi_awvalid   (s00_axi_awvalid),
        .s00_axi_awready   (s00_axi_awready),

        .s00_axi_wdata     (s00_axi_wdata),
        .s00_axi_wstrb     (s00_axi_wstrb),
        .s00_axi_wvalid    (s00_axi_wvalid),
        .s00_axi_wready    (s00_axi_wready),

        .s00_axi_bresp     (s00_axi_bresp),
        .s00_axi_bvalid    (s00_axi_bvalid),
        .s00_axi_bready    (s00_axi_bready),

        .s00_axi_araddr    (s00_axi_araddr),
        .s00_axi_arprot    (s00_axi_arprot),
        .s00_axi_arvalid   (s00_axi_arvalid),
        .s00_axi_arready   (s00_axi_arready),

        .s00_axi_rdata     (s00_axi_rdata),
        .s00_axi_rresp     (s00_axi_rresp),
        .s00_axi_rvalid    (s00_axi_rvalid),
        .s00_axi_rready    (s00_axi_rready),

        // ---------------- M02 AXI-Stream ----------------
        .m02_axis_aclk     (clk),
        .m02_axis_aresetn  (reset_n),

        .m02_axis_tvalid   (m02_axi_tvalid),
        .m02_axis_tdata    (m02_axi_tdata),
        .m02_axis_tstrb    (m02_axi_tstrb),
        .m02_axis_tlast    (m02_axi_tlast),
        .m02_axis_tready   (m02_axi_tready),

        // ---------------- S01 AXI-Stream ----------------
        .s01_axis_aclk     (clk),
        .s01_axis_aresetn  (reset_n),

        .s01_axis_tready   (s01_axi_tready),
        .s01_axis_tdata    (s01_axi_tdata),
        .s01_axis_tstrb    (s01_axi_tstrb),
        .s01_axis_tlast    (s01_axi_tlast),
        .s01_axis_tvalid   (s01_axi_tvalid)
    );


    // ================================================================
    // Clock
    // ================================================================
    initial begin
        clk = 1'b0;

        forever #10 clk = ~clk;     // 50 MHz
    end


    // ================================================================
    // AXI-Lite coefficient write task
    // ================================================================
    task automatic axi_write(
        input [7:0]  address,
        input [31:0] data
    );
    begin

        // Address
        @(posedge clk);

        s00_axi_awaddr  <= address;
        s00_axi_awvalid <= 1'b1;

        // Data
        s00_axi_wdata   <= data;
        s00_axi_wstrb   <= 4'b1111;
        s00_axi_wvalid  <= 1'b1;

        // Wait for both address and data
        wait (s00_axi_awready && s00_axi_wready);

        @(posedge clk);

        s00_axi_awvalid <= 1'b0;
        s00_axi_wvalid  <= 1'b0;

        // Wait for write response
        s00_axi_bready <= 1'b1;

        wait (s00_axi_bvalid);

        @(posedge clk);

        s00_axi_bready <= 1'b0;

    end
    endtask


    // ================================================================
    // Coefficients
    // ================================================================
    logic signed [15:0] coff [0:TAP-1];

    initial begin

        coff[0]  = 16'h041C;
        coff[1]  = 16'h00DB;
        coff[2]  = 16'h00C8;
        coff[3]  = 16'h0090;
        coff[4]  = 16'h003B;
        coff[5]  = 16'hFFCB;
        coff[6]  = 16'hFF46;
        coff[7]  = 16'hFDFB;
        coff[8]  = 16'hFC72;
        coff[9]  = 16'hFDC8;
        coff[10] = 16'hFDD6;
        coff[11] = 16'hFBD3;
        coff[12] = 16'hFB11;
        coff[13] = 16'hFC01;
        coff[14] = 16'hFE0A;
        coff[15] = 16'hFFB7;
        coff[16] = 16'h0127;
        coff[17] = 16'h02B2;
        coff[18] = 16'h0464;
        coff[19] = 16'h0625;
        coff[20] = 16'h07D8;
        coff[21] = 16'h096C;
        coff[22] = 16'h0AC3;
        coff[23] = 16'h0BC4;
        coff[24] = 16'h0C6E;
        coff[25] = 16'h0CA0;
        coff[26] = 16'h0C6E;
        coff[27] = 16'h0BC4;
        coff[28] = 16'h0AC3;
        coff[29] = 16'h096C;
        coff[30] = 16'h07D8;
        coff[31] = 16'h0625;
        coff[32] = 16'h0464;
        coff[33] = 16'h02B2;
        coff[34] = 16'h0127;
        coff[35] = 16'hFFB7;
        coff[36] = 16'hFE0A;
        coff[37] = 16'hFC01;
        coff[38] = 16'hFB11;
        coff[39] = 16'hFBD3;
        coff[40] = 16'hFDD6;
        coff[41] = 16'hFDC8;
        coff[42] = 16'hFC72;
        coff[43] = 16'hFDFB;
        coff[44] = 16'hFF46;
        coff[45] = 16'hFFCB;
        coff[46] = 16'h003B;
        coff[47] = 16'h0090;
        coff[48] = 16'h00C8;
        coff[49] = 16'h00DB;
        coff[50] = 16'h041C;

    end


    // ================================================================
    // Initialize AXI signals
    // ================================================================
    initial begin

        s00_axi_awaddr  = 0;
        s00_axi_awprot  = 0;
        s00_axi_awvalid = 0;

        s00_axi_wdata   = 0;
        s00_axi_wstrb   = 0;
        s00_axi_wvalid  = 0;

        s00_axi_bready  = 0;

        s00_axi_araddr  = 0;
        s00_axi_arprot  = 0;
        s00_axi_arvalid = 0;
        s00_axi_rready  = 0;

        s01_axi_tvalid  = 0;
        s01_axi_tdata   = 0;
        s01_axi_tstrb   = 2'b11;
        s01_axi_tlast   = 0;

        m02_axi_tready  = 1'b1;

    end


    // ================================================================
    // Reset + coefficient loading
    // ================================================================
    integer i;

    initial begin

        reset_n = 1'b0;

        #100;

        reset_n = 1'b1;

        // Wait a few clocks
        repeat(5)
            @(posedge clk);

        // ------------------------------------------------------------
        // Write coefficients through AXI-Lite
        // ------------------------------------------------------------

        for (i = 0; i < TAP; i = i + 1) begin

            $display("Writing coefficient %0d = %h",
                     i, coff[i]);

            // AXI register address
            // slv_reg0  -> 0x00
            // slv_reg1  -> 0x04
            // ...
            // slv_reg50 -> 0xC8

            axi_write(i * 4, {16'b0, coff[i]});

        end

        $display("========================================");
        $display("All coefficients loaded.");
        $display("========================================");

    end


    // ================================================================
    // Sine-wave input
    // ================================================================

    //real sine_value;

    integer sample_number;

    parameter real PI = 3.14159265358979323846;

    parameter real SINE_FREQ = 1500.0;
    parameter real SAMPLE_FREQ = 50000.0;

    parameter integer SINE_AMPLITUDE = 14000;
    
    wire [15:0] sine_wave;
     sine_gen sinegen(.clk(clk), .sin_wave(sine_wave));
    initial begin

        sample_number = 0;

        wait(reset_n == 1'b1);

        // Wait until coefficients have been loaded
        repeat(TAP + 10)
            @(posedge clk);

        // ------------------------------------------------------------
        // Send sine-wave samples
        // ------------------------------------------------------------
        forever begin

//            sine_value =
//                SINE_AMPLITUDE *
//                $sin(2.0 * PI *
//                SINE_FREQ *
//                sample_number /
//                SAMPLE_FREQ);

            s01_axi_tdata <= $rtoi(sine_wave);

            s01_axi_tvalid <= 1'b1;

            s01_axi_tlast <= 1'b0;

            // Wait for AXI transfer
            @(posedge clk);

            if (s01_axi_tready) begin
                sample_number = sample_number + 1;
            end

        end

    end


    // ================================================================
    // Monitor AXI output
    // ================================================================
    always @(posedge clk) begin

        if (m02_axi_tvalid && m02_axi_tready) begin

            $display(
                "TIME=%0t | INPUT=%0d | FIR OUTPUT=%0d | HEX=%h",
                $time,
                $signed(s01_axi_tdata),
                $signed(m02_axi_tdata),
                m02_axi_tdata
            );

        end

    end


    // ================================================================
    // Stop simulation
    // ================================================================
    initial begin

        #200000;

        $display("========================================");
        $display("Simulation finished.");
        $display("========================================");

        $stop;

    end

endmodule
