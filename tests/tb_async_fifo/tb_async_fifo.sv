`timescale 1ns/1ps

module tb_async_fifo;

localparam WIDTH = 32;

// Declare test variables
logic w_clk;
logic w_rst_n;
logic w_en;
logic [WIDTH-1:0] w_data;
logic r_clk;
logic r_rst_n;
logic r_en;
logic [WIDTH-1:0] r_data;
logic full;
logic empty;

`ifdef USE_POWER_PINS
    wire VPWR;
    wire VGND;
    assign VPWR=1;
    assign VGND=0;
`endif

// Instantiate Design 
async_fifo afifo (.*);

// Sample to drive clock
localparam W_PER = 12;
always begin
    #(W_PER/2) 
    w_clk <= ~w_clk;
end

localparam R_PER = 20;
always begin
    #(R_PER/2) 
    r_clk <= ~r_clk;
end

// Necessary to create Waveform
initial begin
    // Name as needed
    $dumpfile("tb_async_fifo.vcd");
    $dumpvars(2, tb_async_fifo);
end

task init();
    w_clk = 1;
    w_rst_n = 0;
    w_en = 0;
    w_data = 32'b0;
    r_clk = 1;
    r_rst_n = 0;
    r_en = 0;
endtask

task write();
    #(W_PER*3);

    w_rst_n = 1;

    #(W_PER*3);
    
    w_en = 1;
    
    for (int i = 0; i < 15; i++) begin
        w_data = 32'h0 + i;
        #(W_PER);
    end

    w_en = 0;

    #(W_PER*15);

    w_en = 1;
    for (int i = 0; i < 5; i++) begin
        w_data = 32'h0 + i;
        #(W_PER);
    end

    w_en = 0;
endtask

task read();
    #(R_PER*2);

    r_rst_n = 1;

    #(R_PER*14);
    r_en = 1;

    #(R_PER);
    r_en = 0;
    #(R_PER);
    r_en = 1;
endtask

always begin
    init();

    fork
        write();
        read();
    join

    #500;

    // Make sure to call finish so test exits
    $finish();
end

endmodule
