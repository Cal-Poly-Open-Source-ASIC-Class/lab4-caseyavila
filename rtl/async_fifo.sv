`timescale 1ns/1ps

module async_fifo
    #(parameter WIDTH = 32,
      parameter AW = 4)

    (input w_clk,
     input w_rst_n,
     input w_en,
     input [WIDTH-1:0] w_data,
     input r_clk,
     input r_rst_n,
     input r_en,
     output [WIDTH-1:0] r_data,
     output full,
     output empty);

    localparam NUM_WORDS = 2**AW;

    logic [AW-1:0] w_ptr;
    logic [AW-1:0] w_ptr_gray;
    logic [AW-1:0] w_ptr_gray_sync;
    logic [AW-1:0] w_ptr_sync;

    logic [AW-1:0] r_ptr;
    logic [AW-1:0] r_ptr_gray;
    logic [AW-1:0] r_ptr_gray_sync;
    logic [AW-1:0] r_ptr_sync;

    reg [WIDTH-1:0] array[(NUM_WORDS-1):0];

    logic [AW-1:0] r_nxt;
    assign r_nxt = r_ptr + 1;
    assign empty = r_nxt == w_ptr_sync;
    assign full = w_ptr == r_ptr_sync;

    assign w_ptr_gray = w_ptr ^ (w_ptr >> 1);
    assign r_ptr_gray = r_ptr ^ (r_ptr >> 1);

    ff_sync #(AW) sync_wptr (r_clk, r_rst_n, w_ptr_gray, w_ptr_gray_sync);
    g2b #(AW) w_g2b (w_ptr_gray_sync, w_ptr_sync);
    ff_sync #(AW) sync_rptr (w_clk, w_rst_n, r_ptr_gray, r_ptr_gray_sync);
    g2b #(AW) r_g2b (r_ptr_gray_sync, r_ptr_sync);

    assign r_data = array[r_ptr];

    always_ff @(posedge w_clk or negedge w_rst_n) begin
        if (~w_rst_n) begin
            w_ptr <= 1;
        end else if (w_en & ~full) begin
            w_ptr <= w_ptr + 1;
            array[w_ptr] <= w_data;
        end
    end

    always_ff @(posedge r_clk or negedge r_rst_n) begin
        if (~r_rst_n) begin
            r_ptr <= 0;
        end else if (r_en & ~empty) begin
            r_ptr <= r_ptr + 1;
        end
    end
endmodule
