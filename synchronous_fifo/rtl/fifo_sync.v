/******************************************************************************
 * Module Name : fifo_sync
 * Author      : Rohit Kumar Panda
 * Date        : 29-Jul-2026
 *
 * Description :
 * Parameterized synchronous FIFO implemented in Verilog.
 * Supports single-clock read and write operations with Full and Empty
 * flag generation. Intended as a beginner-to-intermediate digital
 * design project.
 *
 * Features :
 *   - Single clock operation
 *   - Parameterized data width and FIFO depth
 *   - Binary read/write pointers
 *   - Full and Empty status flags
 *   - Asynchronous active-high reset
 *
 * Parameters :
 *   DATA_WIDTH : Width of each FIFO data word.
 *   DEPTH      : Number of FIFO entries.
 *
 * Inputs :
 *   clk      : System clock.
 *   rst      : Active-high asynchronous reset.
 *   cs       : Chip select.
 *   wr_en    : Write enable.
 *   rd_en    : Read enable.
 *   data_in  : Input data.
 *
 * Outputs :
 *   data_out : Output data.
 *   full     : FIFO full flag.
 *   empty    : FIFO empty flag.
 *
 ******************************************************************************/
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
module fifo_sync(clk , rst , cs , data_in , data_out , wr_en , rd_en , empty , full);
parameter DEPTH = 8;
parameter DATA_WIDTH = 16;
input clk ; 
input rst;
input cs ;
input wr_en, 
input rd_en;
input [DATA_WIDTH-1:0] data_in;
output empty;
output full;
output reg [DATA_WIDTH-1:0] data_out;
  
// FIFO Memory Declaration
reg [DATA_WIDTH-1:0] fifo[0:DEPTH-1];
reg [3:0] wr_pointer;
reg [3:0] rd_pointer;

integer i;
    
// Write Logic
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

//READ LOGIC
always @(posedge clk or posedge rst)
begin
    if(rst) 
    begin
        rd_pointer <= 0;
        data_out <= 0;
    end
    else if(cs && rd_en && !empty)begin
        data_out <= fifo[rd_pointer[2:0]];
        rd_pointer <= rd_pointer + 1'b1;
  
    end
end
    
// Status Flag Generation
assign empty = (rd_pointer == wr_pointer);
assign full = (rd_pointer == {~wr_pointer[3],wr_pointer[2:0]});
endmodule
