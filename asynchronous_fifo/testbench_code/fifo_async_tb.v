//////////////////////////////////////////////////////////////////////////////////
/******************************************************************************
 * Module Name : fifo_async_tb
 * Author      : Rohit Kumar Panda
 * Date        : 29-Jul-2026
 *
 * Description :
 * Testbench for the parameterized asynchronous FIFO.
 * Verifies correct FIFO operation using independent read and write clocks.
 *
 * Test Cases :
 *   - Reset functionality
 *   - Multiple write operations
 *   - Multiple read operations
 *   - Full flag assertion
 *   - Empty flag assertion
 *   - FIFO overflow protection
 *   - FIFO underflow protection
 *   - Asynchronous clock domain operation
 *
 ******************************************************************************/
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
module fifo_async_tb;

// Testbench Signals
reg [15:0] data_in ;
reg wr_en , w_clk , wrst_n ;
reg r_en , r_clk , rrst_n ;
wire [15:0] data_out;
wire empty;
wire full;

// Device Under Test (DUT)
top dut(
    .data_in(data_in),
    .wr_en(wr_en),
    .w_clk(w_clk),
    .wrst_n(wrst_n),
    .r_en(r_en),
    .r_clk(r_clk),
    .rrst_n(rrst_n),
    .data_out(data_out),
    .empty(empty),
    .full(full)
    );

// Clock Generation
// Independent write and read clocks for asynchronous FIFO verification.
always #13 w_clk = ~w_clk;
always #29 r_clk = ~r_clk;

// Write Task
// Writes one data word into the FIFO.
task write_data(input [15:0] d_in);
    begin
        @(posedge w_clk);
        wr_en = 1;
        data_in = d_in;
        @(posedge w_clk);
        wr_en = 0;
    end
endtask

// Read Task
// Reads one data word from the FIFO.
task read_data();
    begin
        @(posedge r_clk);
        r_en = 1;
        @(posedge r_clk);
        r_en = 0;
    end
endtask

// Test Sequence
initial begin
    w_clk = 0; r_clk = 0;
    wr_en = 0; r_en = 0;
    wrst_n = 1'b0 ; rrst_n = 1'b0;
    #20 wrst_n = 1; rrst_n = 1;
    #45 write_data(16'd54);
    write_data(13);
    write_data(45);
    read_data();
    read_data();
    read_data();
    read_data();
    write_data(32);
    write_data(23);
    write_data(99);
    write_data(11);
    write_data(66);
    write_data(72);
    write_data(26);
    write_data(96);
    write_data(42);
    write_data(10);
    read_data();
    read_data();
    read_data();
    read_data();
    read_data();
    read_data();
    read_data();
    read_data();
    read_data();
    read_data();
    $finish;
end
endmodule
