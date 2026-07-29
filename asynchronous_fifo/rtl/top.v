//////////////////////////////////////////////////////////////////////////////////
/******************************************************************************
 * Module Name : top
 * Author      : Rohit Kumar Panda
 * Date        : 29-Jul-2026
 *
 * Description :
 * Top-level parameterized asynchronous FIFO.
 * Integrates the synchronizers, write pointer handler, read pointer handler,
 * and dual-port memory to implement an asynchronous FIFO with independent
 * read and write clock domains.
 *
 * Features :
 *   - Parameterized data width and FIFO depth
 *   - Gray-code pointer synchronization
 *   - Two-stage synchronizers for CDC
 *   - Full and Empty flag generation
 *   - Dual-port memory with independent clocks
 *
 ******************************************************************************/
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
module top #(
parameter DATA_WIDTH = 16,
parameter FIFO_DEPTH = 8)(
    input [DATA_WIDTH-1 :0] data_in ,
    input wr_en , w_clk , wrst_n ,
    input r_en , r_clk , rrst_n , 
    output [DATA_WIDTH-1 :0] data_out
    );

// Local Parameters
localparam ADDRESS_WIDTH = $clog2(FIFO_DEPTH);

// Internal Signals
wire empty , full;
wire [ADDRESS_WIDTH :0] b_wptr , b_rptr ;
wire [ADDRESS_WIDTH :0] g_wptr , g_rptr ;
wire [ADDRESS_WIDTH :0] g_rptr_sync , g_wptr_sync;

// Gray Pointer Synchronizers
// Synchronize Gray-coded pointers across clock domains.
synchronizer #(ADDRESS_WIDTH) WD (g_rptr , g_rptr_sync , w_clk , wrst_n);
synchronizer #(ADDRESS_WIDTH) RD (g_wptr , g_wptr_sync , r_clk , rrst_n);

// Write Pointer and Full Flag Logic
writeptr_handler #(ADDRESS_WIDTH) W_handler (w_clk , wrst_n , b_wptr , g_wptr , g_rptr_sync , wr_en , full);

// Read Pointer and Empty Flag Logic
readptr_handler #(ADDRESS_WIDTH) R_handler (r_clk , rrst_n , b_rptr , g_rptr , g_wptr_sync ,r_en , empty);

// Dual-Port FIFO Memory
fifo_memory #(.DATA_WIDTH(DATA_WIDTH) , .FIFO_DEPTH(FIFO_DEPTH) , .ADDRESS_WIDTH(ADDRESS_WIDTH))
            Memo(data_in , wr_en , w_clk , full , b_wptr , data_out , r_en , r_clk , b_rptr , empty);

endmodule
