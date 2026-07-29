`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.07.2026 12:39:38
// Design Name: 
// Module Name: fifo_sync_tb
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


module fifo_sync_tb;
parameter DEPTH = 8;
parameter DATA_WIDTH = 16;
reg clk, rst, cs , wr_en , rd_en;
reg [DATA_WIDTH-1:0] data_in;
wire empty , full;
wire [DATA_WIDTH-1:0] data_out;


fifo_sync dut(.clk(clk) ,
              .rst(rst),
              .cs(cs),
              .wr_en(wr_en),
              .rd_en(rd_en),
              .data_in(data_in),
              .empty(empty),
              .full(full),
              .data_out(data_out) );
           

always #5 clk = ~clk;

task write_data(input [DATA_WIDTH-1:0] d_in);
    begin
        @(posedge clk);
        cs = 1; 
        wr_en = 1;
        data_in = d_in;
        @(posedge clk);
        cs = 1; wr_en = 0;
    end
endtask

task read_data();
    begin
        @(posedge clk);
        cs = 1; rd_en = 1;
        @(posedge clk);
        cs = 1; rd_en = 0;
    end
endtask

initial begin
    clk = 0;
    rst = 1 ; wr_en = 0; rd_en = 0;
    cs = 0;
    #6 rst = 0;
    #10 write_data(16'd54);
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
