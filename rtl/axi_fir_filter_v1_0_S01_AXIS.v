
`timescale 1 ns / 1 ps

	module axi_fir_filter_v1_0_S01_AXIS #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line

		// AXI4Stream sink: Data Width
		parameter integer C_S_AXIS_TDATA_WIDTH	= 16
	)
	(
    input  wire                         S_AXIS_ACLK,
    input  wire                         S_AXIS_ARESETN,

    output wire                         S_AXIS_TREADY,
    input  wire [C_S_AXIS_TDATA_WIDTH-1:0] S_AXIS_TDATA,
    input  wire [(C_S_AXIS_TDATA_WIDTH/8)-1:0] S_AXIS_TSTRB,
    input  wire                         S_AXIS_TLAST,
    input  wire                         S_AXIS_TVALID,

    // FIR input
    output reg signed [C_S_AXIS_TDATA_WIDTH-1:0] fir_input
);

    // Always ready to receive data
    assign S_AXIS_TREADY = 1'b1;

    // Capture FIR input when AXI transfer occurs
    always @(posedge S_AXIS_ACLK) begin
        if (!S_AXIS_ARESETN)
            fir_input       <= 0;
            //fir_input_valid <= 1'b0;
        else
            begin
           // fir_input_valid <= S_AXIS_TVALID && S_AXIS_TREADY;
            if (S_AXIS_TVALID && S_AXIS_TREADY)
                fir_input <= S_AXIS_TDATA;
        end
    end

endmodule
