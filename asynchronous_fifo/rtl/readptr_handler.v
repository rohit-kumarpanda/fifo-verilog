`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.07.2026 22:02:31
// Design Name: 
// Module Name: readptr_handler
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


module readptr_handler #(parameter ADDRESS_WIDTH = 3)(
    input clk ,
    input rrst_n ,
    output reg [ADDRESS_WIDTH:0] b_rptr ,
    output reg [ADDRESS_WIDTH:0] g_rptr ,
    input [ADDRESS_WIDTH:0] g_wptr_sync ,
    input r_en ,
    output reg empty
    );
    
wire rempty;
wire [ADDRESS_WIDTH:0] b_rptr_nxt;
wire [ADDRESS_WIDTH:0] g_rptr_nxt;

assign b_rptr_nxt = (b_rptr) + (r_en & ~empty);
assign g_rptr_nxt = (b_rptr_nxt >> 1 ) ^ b_rptr_nxt;
assign rempty = (g_rptr_nxt == g_wptr_sync);

//Register
always @(posedge clk or negedge rrst_n) begin
    if(!rrst_n) begin
        b_rptr <= 0;
        g_rptr <= 0;
        empty <= 0;
    end
    else  begin
        b_rptr <= b_rptr_nxt;
        g_rptr <= g_rptr_nxt;
        empty <= rempty;
    end
end
endmodule
