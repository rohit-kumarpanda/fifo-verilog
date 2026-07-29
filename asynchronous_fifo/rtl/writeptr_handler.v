//////////////////////////////////////////////////////////////////////////////////
/******************************************************************************
 * Module Name : writeptr_handler
 * Author      : Rohit Kumar Panda
 * Date        : 29-Jul-2026
 *
 * Description :
 * Generates the binary and Gray-code write pointers.
 * Detects FIFO full condition using synchronized Gray-code read pointer.
 *
 * Parameters :
 *   ADDRESS_WIDTH : Width of FIFO address.
 *
 ******************************************************************************/
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
module writeptr_handler
    #(parameter ADDRESS_WIDTH = 3)
    (
    input w_clk ,
    input wrst_n ,
    output reg [ADDRESS_WIDTH :0] b_wptr ,
    output reg [ADDRESS_WIDTH :0] g_wptr ,
    input [ADDRESS_WIDTH :0] g_rptr_sync ,
    input wr_en ,
    output reg full
);

wire wfull;
wire [ADDRESS_WIDTH :0] b_wptr_nxt;
wire [ADDRESS_WIDTH :0] g_wptr_nxt;

// Next-state pointer calculation
assign b_wptr_nxt = (b_wptr) + (wr_en & ~full);
assign g_wptr_nxt = (b_wptr_nxt >> 1) ^ b_wptr_nxt;

// Full flag generation
assign wfull = ( (g_wptr_nxt) == {~g_rptr_sync[ADDRESS_WIDTH:ADDRESS_WIDTH-1], g_rptr_sync[ADDRESS_WIDTH-2:0]} );

//Sequential Logic
always @(posedge w_clk or negedge wrst_n) begin
    // Asynchronous active-low reset
    if(!wrst_n) begin
        b_wptr <= 0;
        g_wptr <= 0;
        full <= 0;
    end
    else  begin
        b_wptr <= b_wptr_nxt;
        full <= wfull;
        g_wptr <= g_wptr_nxt;
    end
end
endmodule
