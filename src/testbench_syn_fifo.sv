`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// File name: testbench_syn_fifo.v
//
// Module Name: testbench_syn_fifo
//
// Purpose: Simple test bench to test the functionality of synchronous fifo design.
//
// Note: FIFO depth must be divisible by 2.
//
// Creator: Kiran
//
//////////////////////////////////////////////////////////////////////////////////


module testbench_syn_fifo#(parameter fifo_depth = 8, parameter fifo_width = $clog2(fifo_depth), parameter clk_pulse = 10)();

    logic clk;
    logic rst;
    logic wr_en;
    logic rd_en;
    logic [fifo_width-1:0] wdata;
    logic ful_fg;
    logic emp_fg;
    logic [fifo_width-1:0] rdata;

    syn_fifo #(.fifo_depth(8), .fifo_width($clog2(fifo_depth))) DUT (.*);

    always #(clk_pulse/2) clk = ~clk;

    always #clk_pulse wdata = wdata + 'h1;

    initial begin
        clk   = 0;
        rst   = 1;
        wr_en = 0;
        rd_en = 0;
        wdata = 'h0;
    end

    initial begin
        #clk_pulse;
        rst   = 0;
        #clk_pulse;
        wr_en = 1;
        #(8*clk_pulse);
        wr_en = 0;
        rd_en = 1;
        #(8*clk_pulse);
        $finish;
    end
endmodule
