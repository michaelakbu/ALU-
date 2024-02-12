`timescale 1ns / 1ps

module subtract16(
    input [15:0] A,
    input [15:0] B,
    input inCarry,
    output reg [15:0] ALUout,
    output reg CARRYout
    );
	always @(A, B, inCarry) 
	begin
        {CARRYout, ALUout} = A - B - inCarry;
        if ( (B + inCarry) > A) 
            CARRYout = 1'b1;
        else
            CARRYout = 1'b0; 
    end
endmodule
