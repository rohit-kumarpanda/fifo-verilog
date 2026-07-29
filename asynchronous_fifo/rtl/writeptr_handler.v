`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.07.2026 21:07:08
// Design Name: 
// Module Name: writeptr_handler
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

assign b_wptr_nxt = (b_wptr) + (wr_en & ~full);
assign g_wptr_nxt = (b_wptr_nxt >> 1) ^ b_wptr_nxt;
assign wfull = ( (g_wptr_nxt) == {~g_rptr_sync[ADDRESS_WIDTH:ADDRESS_WIDTH-1], g_rptr_sync[ADDRESS_WIDTH-2:0]} );

//Register:
always @(posedge w_clk or negedge wrst_n) begin
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
