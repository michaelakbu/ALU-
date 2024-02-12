`timescale 1ns / 1ps

`include "add.v"
`include "and.v"
`include "division.v"
`include "multiplication.v"
`include "nand.v"
`include "nor.v"
`include "not.v"
`include "or.v"
`include "shifter.v"
`include "subtract.v"
`include "xnor.v"
`include "xor.v"

module ALU16 (opcode, A, B, inCarry, ALUout, CARRYout, MULTout, REMAINDERout);
	input [3:0] opcode;
	input [15:0] A, B;
	input inCarry;
	output reg [15:0] ALUout; 
	output reg [31:0] MULTout;
	output reg CARRYout;  
	output reg [31:0] REMAINDERout;
	
	wire [15:0] addw, andw, divisionw, nandw, norw, notw, orw, shifterw, subtractw, xnorw, xorw, remainderw;
	wire [31:0] multiplicationw;
	wire coAddw, boSubw; //carry out and borrow out
	
	add16 add16(.A(A), .B(B), .inCarry(inCarry), .CARRYout(coAddw), .ALUout(addw)); //moduleName instanceName 
    subtract16 subtract16(.A(A), .B(B), .inCarry(inCarry), .CARRYout(boSubw), .ALUout(subtractw)); // arithmetic 
    
    division16 division16(.A(A), .B(B), .ALUout(divisionw), .REMAINDERout(remainderw)); // arithmetic
    multiplication16 multiplication16(.A(A), .B(B), .MULTout(multiplicationw)); // arithmetic 
    
    and16 and16(.A(A), .B(B), .Z(andw)); 
    nand16 nand16(.A(A), .B(B), .Z(nandw)); 
    nor16 nor16(.A(A), .B(B), .Z(norw)); 
    not16 not16(.A(A), .B(B), .Z(notw)); 
    or16 or16(.A(A), .B(B), .Z(orw));
    
    shifter16 shifter16(.data(A), .shift_amount(B), .sel(inCarry), .result(shifterw)); 
    
	xnor16 xnor16(.A(A), .B(B), .Z(xnorw)); 
	xor16 xor16(.A(A), .B(B), .Z(xorw)); 

	always @(*)
	begin
		ALUout <= 16'dX;
		CARRYout <= 16'dX;
		case (opcode) 
		4'd0: ALUout <= andw;
		4'd1: ALUout <= nandw;
		4'd2: ALUout <= orw;
		4'd3: ALUout <=	norw;
		4'd4: ALUout <= xorw;
		4'd5: ALUout <= xnorw;
		4'd6: ALUout <= notw;
		4'd7: ALUout <= shifterw;
		4'd8: 
			begin 
				ALUout <= addw; // arithmetic
				CARRYout <= coAddw;
			end
		4'd9: 
			begin 
				ALUout <= subtractw; // arithmetic
				CARRYout <= boSubw;
			end
		4'd10: MULTout <= multiplicationw; // arithmetic
		4'd11: 
			begin
				ALUout <= divisionw; // arithmetic
				REMAINDERout <= remainderw;
			end
		default: ALUout <= 4'hX;
		endcase       
	end
endmodule
module testbench; //testbench module
	reg [3:0] opcode;
	reg [15:0] A, B;
	reg inCarry;
	wire [15:0] ALUout;
	wire [31:0] MULTout;
	wire CARRYout;

  ALU16 uut(
    .opcode(opcode), 
    .A(A),
    .B(B), 
    .inCarry(inCarry), 
    .ALUout(ALUout), 
    .MULTout(MULTout),
    .CARRYout(CARRYout)
  );
  
    initial begin
        $dumpfile("ALU16.vcd");
        $dumpvars(0, testbench);
        $display("ALU16 simulation started.");
		
		opcode = 16'd15; #10;
		
		//// Logical Functions
		///////////////////////
		 // Test case 1: AND
        A = 16'b0000_0000_0000_0000; 
        B = 16'b0000_0000_0000_0000;  
        opcode = 4'd0; 
        #10; 	
        
        // Test case 2: AND
        A = 16'b0000_0000_0000_0000; 
        B = 16'b1111_1111_1111_1111;  
        opcode = 4'd0; 
        #10; 		
        
        // Test case 3: AND
        A = 16'b1111_0000_1111_0000; 
        B = 16'b1111_1111_0000_1111; 
        opcode = 4'd0; 
        #10; 		
        
        // Test case 4: AND
        A = 16'b0101_0101_0101_0101; 
        B = 16'b1010_1010_1010_1010;  
        opcode = 4'd0; 
        #10; 	
        ///////////////////////
        
        opcode = 4'd15; #10;
        
        ///////////////////////
         // Test case 1: NAND
        A = 16'b0000_0000_0000_0000; 
        B = 16'b0000_0000_0000_0000;  
        opcode = 4'd1; 
        #10; 	
        
        // Test case 2: NAND
        A = 16'b0000_0000_0000_0000; 
        B = 16'b1111_1111_1111_1111;  
        opcode = 4'd1; 
        #10; 		
        
        // Test case 3: NAND
        A = 16'b1111_0000_1111_0000; 
        B = 16'b1111_1111_0000_1111; 
        opcode = 4'd1; 
        #10; 		
        
        // Test case 4: NAND
        A = 16'b0101_0101_0101_0101; 
        B = 16'b1010_1010_1010_1010;  
        opcode = 4'd1; 
        #10; 	
        /////////////////////
        
		opcode = 4'd15; #10;

        
        ///////////////////////        
        // Test case 1: OR
        A = 16'b0000_0000_0000_0000; 
        B = 16'b0000_0000_0000_0000;  
        opcode = 4'd2; 
        #10; 	
        
        // Test case 2: OR
        A = 16'b0000_0000_0000_0000; 
        B = 16'b1111_1111_1111_1111;  
        opcode = 4'd2; 
        #10; 		
        
        // Test case 3: OR
        A = 16'b1111_0000_1111_0000; 
        B = 16'b1111_1111_0000_1111; 
        opcode = 4'd2; 
        #10; 		
        
        // Test case 4: OR
        A = 16'b0101_0101_0101_0101; 
        B = 16'b1010_1010_1010_1010;  
        opcode = 4'd2; 
        #10; 	
        /////////////////////
        
        opcode = 4'd15; #10;


		///////////////////////
         // Test case 1: NOR
        A = 16'b0000_0000_0000_0000; 
        B = 16'b0000_0000_0000_0000;  
        opcode = 4'd3; 
        #10; 	
        
        // Test case 2: NOR
        A = 16'b0000_0000_0000_0000; 
        B = 16'b1111_1111_1111_1111;  
        opcode = 4'd3; 
        #10; 		
        
        // Test case 3: NOR
        A = 16'b1111_0000_1111_0000; 
        B = 16'b1111_1111_0000_1111; 
        opcode = 4'd3; 
        #10; 		
        
        // Test case 4: NOR
        A = 16'b0101_0101_0101_0101; 
        B = 16'b1010_1010_1010_1010;  
        opcode = 4'd3; 
        #10; 	
        /////////////////////
        
        
        opcode = 4'd15; #10;


		///////////////////////
         // Test case 1: XOR
        A = 16'b0000_0000_0000_0000; 
        B = 16'b0000_0000_0000_0000;  
        opcode = 4'd4; 
        #10; 	
        
        // Test case 2: XOR
        A = 16'b0000_0000_0000_0000; 
        B = 16'b1111_1111_1111_1111;  
        opcode = 4'd4; 
        #10; 		
        
        // Test case 3: XOR
        A = 16'b1111_0000_1111_0000; 
        B = 16'b1111_1111_0000_1111; 
        opcode = 4'd4; 
        #10; 		
        
        // Test case 4: XOR
        A = 16'b0101_0101_0101_0101; 
        B = 16'b1010_1010_1010_1010;  
        opcode = 4'd4; 
        #10; 	
        /////////////////////
        

		opcode = 4'd15; #10;


		///////////////////////
         // Test case 1: XNOR
        A = 16'b0000_0000_0000_0000; 
        B = 16'b0000_0000_0000_0000;  
        opcode = 4'd5; 
        #10; 	
        
        // Test case 2: XNOR
        A = 16'b0000_0000_0000_0000; 
        B = 16'b1111_1111_1111_1111;  
        opcode = 4'd5; 
        #10; 		
        
        // Test case 3: XNOR
        A = 16'b1111_0000_1111_0000; 
        B = 16'b1111_1111_0000_1111; 
        opcode = 4'd5; 
        #10; 		
        
        // Test case 4: XNOR
        A = 16'b0101_0101_0101_0101; 
        B = 16'b1010_1010_1010_1010;  
        opcode = 4'd5; 
        #10; 	
        /////////////////////

        
        opcode = 4'd15; #10;


		///////////////////////
		// Test case 1: NOT
        A = 16'b0000_0000_0000_0000; 
        B = 16'b0000_0000_0000_0000;  
        opcode = 4'd6; 
        #10; 	
        
        // Test case 2: NOT
        A = 16'b0000_0000_0000_0000; 
        B = 16'b1111_1111_1111_1111;  
        opcode = 4'd6; 
        #10; 		
        
        // Test case 3: NOT
        A = 16'b1111_0000_1111_0000; 
        B = 16'b1111_1111_0000_1111; 
        opcode = 4'd6; 
        #10; 		
        
        // Test case 4: NOT
        A = 16'b0101_0101_0101_0101; 
        B = 16'b1010_1010_1010_1010;  
        opcode = 4'd6; 
        #10; 	
        /////////////////////
        
        opcode = 4'd15; #10;
        
        /////////////////////
		// Test case: shift left 1
		A = 16'b0000_0000_0000_0000;
		B = 16'd1; //shift amount
		inCarry = 1'b0; // sel == 0 so shift left (<<)
		opcode = 4'd7;
		#10;
		
		// Test case: shift left 3
		A = 16'b0101_0101_0101_0101;
		B = 16'd3; //shift amount
		inCarry = 1'b0; // sel == 0 so shift left (<<)
		opcode = 4'd7;
		#10;
		
		// Test case: shift right 5
		A = 16'b1010_1010_1010_1010;
		B = 16'd5; //shift amount
		inCarry = 1'b1; // sel == 1 so shift right (>>)
		opcode = 4'd7;
		#10;
		
		// Test case: shift right 4
		A = 16'b1000_0000_0000_0000;
		B = 16'd4; //shift amount
		inCarry = 1'b1; // sel == 1 so shift right (>>)
		opcode = 4'd7;
		#10;
		 /////////////////////
        opcode = 4'd15; #10;
        
        /////////////////////
        //// Arithmetic Functions +-*/+-*/+-*/
        
        // Test Case Add
		A= 16'd32767;
		B = 16'd32767;
		inCarry = 1'h0;
		opcode = 4'd8; 
		#10;		// expected 65534
		
		// Test Case Add with carry in
		A= 16'd65535;
		B = 16'd1;
		inCarry = 1'h1;
		opcode = 4'd8; 
		#10; 		// expected overflow to zero
		
		// Test Case Add with carry in
		A= 16'd65534;
		B = 16'd0;
		inCarry = 1'h1;
		opcode = 4'd8; 
		#10;		// expect 65535
		
		// Test Case Add with carry in
		A= 16'd65534;
		B = 16'd0;
		inCarry = 1'h1;
		opcode = 4'd8; 
		#10; 		// exxpect zero overflow
		
		/////////////////////
        opcode = 4'd15; #10;
        
        /////////////////////
		
        //Test Case Subtract with no borrow in
		A = 16'd55555;
		B = 16'd0;
		inCarry = 1'h0;
		opcode = 4'd9; 
		#10;    // Expected result: same
		
		//Test Case Subtract with borrow in
		A = 16'd30000;
		B = 16'd30000;
		inCarry = 1'h1;
		opcode = 4'd9; 
		#10;    // Expected result zero
		
		//Test Case Subtract with no borrow in
		A = 16'd65535;
		B = 16'd1;
		inCarry = 1'h0;
		opcode = 4'd9; 
		#10;    // Expected result 65534
		
		//Test Case Subtract 
		A = 16'd0;
		B = 16'd1;
		inCarry = 1'h0;
		opcode = 4'd9; 
		#10;    // Expected result -1 in 2's complement
		
		/////////////////////
        opcode = 4'd15; #10;
        
        /////////////////////
		
		//Test Case Multiplication 
		A= 16'd0;
		B = 16'd55555;
		opcode = 4'd10; 
		#10; 	//expect 0
		
		//Test Case Multiplication 
		A= 16'd1;
		B = 16'd55555;
		opcode = 4'd10; 
		#10; 	// expect same
		
		//Test Case Multiplication 
		A= 16'd25;
		B = 16'd5;
		opcode = 4'd10; 
		#10; 	// expect 125
		
		//Test Case Multiplication 
		A= 16'd256;
		B = 16'd256;
		opcode = 4'd10; 
		#10; 	// expect 65536
		
		/////////////////////
        opcode = 4'd15; #10;
        
        /////////////////////
		
		//Test Case Division
		A= 16'd55555;
		B = 16'd1;
		opcode = 4'd11; 
		#10;	// expect 55555
        
        //Test Case Division
		A= 16'd0;
		B = 16'd55555;
		opcode = 4'd11; 
		#10;	// expect 0
		
		//Test Case Division
		A= 16'd1;
		B = 16'd0;
		opcode = 4'd11; 
		#10;	// expect error or x
		
		//Test Case Division
		A= 16'd65535;
		B = 16'd2;
		opcode = 4'd11; 
		#10;	// 32767
        
        /////////////////////
        
        opcode = 4'd15; #10; // default

        $finish;
    end

endmodule
