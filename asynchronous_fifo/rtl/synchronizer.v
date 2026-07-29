`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.07.2026 20:58:03
// Design Name: 
// Module Name: synchronizer
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



module synchronizer 
    #(parameter ADDRESS_WIDTH = 3)(
    input [ADDRESS_WIDTH:0] d_in , 
    output reg [ADDRESS_WIDTH:0] q_out,
    input clk , 
    input rst_n
    );
reg [ADDRESS_WIDTH:0] q1;

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n) begin
        q1 <= 0;
        q_out <= 0;
    end
    else begin
        q1 <= d_in;
        q_out <= q1;
    end
end
endmodule
