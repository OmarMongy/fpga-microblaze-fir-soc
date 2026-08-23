module sine_gen(
input clk,
output reg [15:0] sin_wave
);

localparam SIZE = 1002;
reg [15:0] rom [0:SIZE-1];
integer i;
initial begin
    i = 0;
    $readmemb("noisy_signal.mem", rom);
end    

always@(posedge clk) begin
    i <= i +1;
    sin_wave <= rom[i];
    
    if(i == SIZE) i <=0;
end    
endmodule
