`timescale 1ns / 1ps

module nor16(
    input [15:0] A,
    input [15:0] B,
    output [15:0] Z
    );
    assign Z = ~(A | B);
endmodule
