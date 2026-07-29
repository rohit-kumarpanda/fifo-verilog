//////////////////////////////////////////////////////////////////////////////////
/******************************************************************************
 * Module Name : readptr_handler
 * Author      : Rohit Kumar Panda
 * Date        : 29-Jul-2026
 *
 * Description :
 * Generates the binary and Gray-code read pointers.
 * Detects FIFO empty condition using synchronized Gray-code write pointer.
 *
 ******************************************************************************/
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
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

// Next-state pointer calculation
assign b_rptr_nxt = (b_rptr) + (r_en & ~empty);
assign g_rptr_nxt = (b_rptr_nxt >> 1 ) ^ b_rptr_nxt;

// Empty flag generation
assign rempty = (g_rptr_nxt == g_wptr_sync);

//Register
always @(posedge clk or negedge rrst_n) begin
    
    // Asynchronous active-low reset
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
