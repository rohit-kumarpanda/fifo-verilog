//////////////////////////////////////////////////////////////////////////////////
/******************************************************************************
 * Module Name : fifo_memory
 * Author      : Rohit Kumar Panda
 * Date        : 29-Jul-2026
 *
 * Description :
 * Dual-port memory block for the asynchronous FIFO.
 * Supports independent write and read operations using separate clocks.
 * Data is written and read using the lower ADDRESS_WIDTH bits of the
 * binary pointers.
 *
 * Parameters :
 *   DATA_WIDTH   : Width of each FIFO data word.
 *   FIFO_DEPTH   : Number of memory locations.
 *   ADDRESS_WIDTH: Number of address bits (calculated using $clog2).
 *
 ******************************************************************************/
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
module fifo_memory #(
parameter DATA_WIDTH = 16,
parameter FIFO_DEPTH = 8,
    parameter ADDRESS_WIDTH = $clog2(FIFO_DEPTH))(
    input [DATA_WIDTH-1:0] data_in , 
    input wr_en , w_clk , full , 
    input [ADDRESS_WIDTH:0]wptr ,
    output reg [DATA_WIDTH-1:0] data_out , 
    input r_en ,
    input r_clk ,
    input [ADDRESS_WIDTH:0] rptr , 
    input empty
    );

// FIFO Memory Array
reg [DATA_WIDTH-1:0] fifo[0:FIFO_DEPTH-1];

// Write Port
// Writes data into the FIFO on the rising edge of the write clock
// when write enable is asserted and the FIFO is not full.
always @(posedge w_clk)
begin
    if(wr_en && ~full)
    fifo[wptr[ADDRESS_WIDTH-1:0]] <= data_in;
end

// Read Port
// Reads data from the FIFO on the rising edge of the read clock
// when read enable is asserted and the FIFO is not empty.
always @(posedge r_clk)
begin
    if(r_en && ~empty)
    data_out <= fifo[rptr[ADDRESS_WIDTH-1:0]];
end

endmodule
