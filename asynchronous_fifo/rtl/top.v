`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.07.2026 00:33:53
// Design Name: 
// Module Name: top
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


module top #(
parameter DATA_WIDTH = 16,
parameter FIFO_DEPTH = 8)(
    input [DATA_WIDTH-1 :0] data_in ,
    input wr_en , w_clk , wrst_n ,
    input r_en , r_clk , rrst_n , 
    output [DATA_WIDTH-1 :0] data_out
    );
localparam ADDRESS_WIDTH = $clog2(FIFO_DEPTH);
wire empty , full;
wire [ADDRESS_WIDTH :0] b_wptr , b_rptr , g_wptr , g_rptr , g_rptr_sync , g_wptr_sync;
//wire [2:0] q1_wr , q1_rd;

synchronizer #(ADDRESS_WIDTH) WD (g_rptr , g_rptr_sync , w_clk , wrst_n);
synchronizer #(ADDRESS_WIDTH) RD (g_wptr , g_wptr_sync , r_clk , rrst_n);

writeptr_handler #(ADDRESS_WIDTH) W_handler (w_clk , wrst_n , b_wptr , g_wptr , g_rptr_sync , wr_en , full);
readptr_handler #(ADDRESS_WIDTH) R_handler (r_clk , rrst_n , b_rptr , g_rptr , g_wptr_sync ,r_en , empty);
fifo_memory #(.DATA_WIDTH(DATA_WIDTH) , .FIFO_DEPTH(FIFO_DEPTH) , .ADDRESS_WIDTH(ADDRESS_WIDTH))
            Memo(data_in , wr_en , w_clk , full , b_wptr , data_out , r_en , r_clk , b_rptr , empty);

endmodule
