`timescale 1ns / 1ps

module add16(
    input [15:0] A,
    input [15:0] B,
    input inCarry,
    output CARRYout,
    output [15:0] ALUout
    );
    assign {CARRYout, ALUout} = ( A + B ) + inCarry;
endmodule
