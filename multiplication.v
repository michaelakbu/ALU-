`timescale 1ns / 1ps

module multiplication16(
    input [15:0] A,
    input [15:0] B,
    output [31:0] MULTout
    );
    assign MULTout = A * B;
endmodule
