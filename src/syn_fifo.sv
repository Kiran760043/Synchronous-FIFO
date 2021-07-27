`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// File name: syn_fifo.v
//
// Module Name: syn_fifo
//
// Purpose: To understand the working of a synchronous FIFO.
//
// Note: FIFO depth must be divisible by 2.
//
// Creator: Kiran
//
//////////////////////////////////////////////////////////////////////////////////


module syn_fifo #(parameter fifo_depth = 8, parameter fifo_width = $clog2(fifo_depth))(
    input  logic clk,
    input  logic rst,
    input  logic wr_en,
    input  logic rd_en,
    input  logic [fifo_width-1:0] wdata,
    output logic ful_fg,
    output logic emp_fg,
    output logic [fifo_width-1:0] rdata
    );

    //memory array
    logic [fifo_width - 1: 0] fifo [fifo_depth - 1:0];

    //create write and read pointers
    logic [fifo_width :0] wr_ptr = 'h0;
    logic [fifo_width :0] rd_ptr = 'h0;

    //Full condition
    assign ful_fg = ({!wr_ptr[fifo_width],wr_ptr[fifo_width-1:0]} == rd_ptr) ? 'h1 : 'h0;

    //Empty condition
    assign emp_fg = (wr_ptr == rd_ptr) ? 'h1 : 'h0;

    //logic for write and read pointers and counter
    always_ff@(posedge clk)
        begin
            if(rst)begin
                wr_ptr <= 'h0;
                rd_ptr <= 'h0;
            end

            //////////////////////////////////////////////////////
            //                Writing data
            //Condition: Check for ful_fg, if ful_fg is low fifo
            //           is not full, you can write to fifo
            //////////////////////////////////////////////////////
            if(wr_en && !ful_fg) begin
                fifo[wr_ptr[fifo_width-1:0]] <= wdata;
                wr_ptr <= wr_ptr + 1;
            end

            //////////////////////////////////////////////////////
            //                Reading data
            //Condition: Check for emp_fg, if emp_fg is low fifo
            //           is empty, you cannot read from fifo
            //////////////////////////////////////////////////////

            if(rd_en && !emp_fg) begin
                rdata  <=fifo[rd_ptr[fifo_width-1:0]];
                rd_ptr <= rd_ptr + 1;
            end else begin
                rdata  <= 'hz;
            end

        end


endmodule
