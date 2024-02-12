`timescale 1ns / 1ps

module shifter16(
	input [15:0] data, 
    input [15:0] shift_amount, 
    input sel, //0 to the left
    output [15:0] result
    );

    assign result = (sel == 0) ? ( data << shift_amount )  : (data >> shift_amount );
endmodule
