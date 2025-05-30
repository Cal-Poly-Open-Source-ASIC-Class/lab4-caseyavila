`timescale 1ns/1ps

/* stolen from user 'ads-ee' on edaboard.com */

module g2b
    #(parameter AW = 4)
    (input [AW-1:0] g,
     output [AW-1:0] b);

    generate genvar i;
        for (i = 0; i < AW; i = i + 1) begin : gen_bin
            assign b[i] = ^g[AW-1:i];
        end
    endgenerate
endmodule
