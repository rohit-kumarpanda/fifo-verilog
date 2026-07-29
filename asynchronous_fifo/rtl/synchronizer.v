//////////////////////////////////////////////////////////////////////////////////
/******************************************************************************
 * Module Name : synchronizer
 * Author      : Rohit Kumar Panda
 * Date        : 29-Jul-2026
 *
 * Description :
 * Two-stage flip-flop synchronizer used for clock domain crossing (CDC).
 * Synchronizes Gray-coded pointers between independent clock domains in an
 * asynchronous FIFO.
 *
 * Parameters :
 *   ADDRESS_WIDTH : Width of the signal to be synchronized.
 *
 * Inputs :
 *   clk    : Destination clock.
 *   rst_n  : Active-low asynchronous reset.
 *   d_in   : Input signal from source clock domain.
 *
 * Outputs :
 *   q_out  : Synchronized output signal.
 *
 ******************************************************************************/
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
module synchronizer 
    #(parameter ADDRESS_WIDTH = 3)(
    input [ADDRESS_WIDTH:0] d_in , 
    output reg [ADDRESS_WIDTH:0] q_out,
    input clk , 
    input rst_n
    );

// Stage-1 Register
reg [ADDRESS_WIDTH:0] q1;

// Two-Flip-Flop Synchronizer
always @(posedge clk or negedge rst_n)
begin
    // Asynchronous active-low reset
    if(!rst_n) begin
        q1 <= 0;
        q_out <= 0;
    end
    else begin
        // First synchronization stage
        q1 <= d_in;
        
        // Second synchronization stage
        q_out <= q1;
    end
end
endmodule
