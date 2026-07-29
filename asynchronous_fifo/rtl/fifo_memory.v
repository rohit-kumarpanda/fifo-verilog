`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.07.2026 00:14:10
// Design Name: 
// Module Name: fifo_memory
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fifo_memory #(
parameter DATA_WIDTH = 16,
parameter FIF0_DEPTH = 8,
parameter ADDRESS_WIDTH = $clog2(FIF0_DEPTH))(
    input [DATA_WIDTH-1:0] data_in , 
    input wr_en , w_clk , full , 
    input [ADDRESS_WIDTH:0]wptr ,
    output reg [DATA_WIDTH-1:0] data_out , 
    input r_en ,
    input r_clk ,
    input [ADDRESS_WIDTH:0] rptr , 
    input empty
    );
//input [15:0] data_in;
//input wr_en , w_clk , full , r_en , r_clk;
//output reg [15:0] data_out;
//input empty;
//input [3:0] wptr , rptr;

reg [DATA_WIDTH-1:0] fifo[0:FIF0_DEPTH-1];
always @(posedge w_clk)
begin
    if(wr_en && ~full)
    fifo[wptr[ADDRESS_WIDTH-1:0]] <= data_in;
end

always @(posedge r_clk)
begin
    if(r_en && ~empty)
    data_out <= fifo[rptr[ADDRESS_WIDTH-1:0]];
end

endmodule
