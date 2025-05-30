`timescale 1ns/1ps

module ff_sync
    #(parameter AW = 4)
    (input clk,
     input rst_n,
     input [AW-1:0] d_in,
     output logic [AW-1:0] d_out);

    reg [AW-1:0] q1;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            q1 <= 0;
            d_out <= 0;
        end else begin
            q1 <= d_in;
            d_out <= q1;
        end
    end
endmodule
