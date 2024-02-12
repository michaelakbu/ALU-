`timescale 1ns / 1ps

module division16(
    input [15:0] A,
    input [15:0] B,
    output [15:0] ALUout,
    output [15:0] REMAINDERout
    );
    assign ALUout = A / B;
    assign REMAINDERout = A % B;  
endmodule
