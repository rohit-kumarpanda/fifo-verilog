`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.07.2026 01:12:59
// Design Name: 
// Module Name: fifo_sync
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


module fifo_sync(clk , rst , cs , data_in , data_out , wr_en , rd_en , empty , full);
parameter DEPTH = 8;
parameter DATA_WIDTH = 16;
input clk, rst, cs , wr_en , rd_en;
input [DATA_WIDTH-1:0] data_in;
output empty , full;
output reg [DATA_WIDTH-1:0] data_out;

reg [DATA_WIDTH-1:0] fifo[0:DEPTH-1];
reg [3:0] wr_pointer;
reg [3:0] rd_pointer;

integer i;

always @(posedge clk or posedge rst) begin
    if(rst)begin
        wr_pointer <= 0;
        for(i = 0 ; i < DEPTH ; i = i+1)
        fifo[i] <= 0;
         
    end
    else if(cs && wr_en &&!full) begin
        fifo[wr_pointer[2:0]] <= data_in; 
        wr_pointer <= wr_pointer + 1'b1;
        end
end

always @(posedge clk or posedge rst)
begin
    if(rst) 
    begin
        rd_pointer <= 0;
        data_out <= 0;
    end
    else if(cs && rd_en && !empty)begin
        data_out <= fifo[rd_pointer[2:0]];
//        fifo[rd_pointer[2:0]] <= 1'b0;
        rd_pointer <= rd_pointer + 1'b1;
  
    end
end

assign empty = (rd_pointer == wr_pointer);
assign full = (rd_pointer == {~wr_pointer[3],wr_pointer[2:0]});
endmodule
