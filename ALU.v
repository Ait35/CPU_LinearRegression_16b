`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module ALU(
	input [15:0]in1 ,in2,
	input [3:0] opcode,
	
	output zeroFlag, carryFlag,
	output reg [15:0] result_ALU
    );
	 reg [31:0]temp;
	 reg [16:0] sumAdder;
	 
	always@(*) begin
		temp = 32'h0;
		sumAdder = 17'b0;
		case(opcode)
			4'b0000 : begin 
						sumAdder = in1 + in2; //ACC or 1
						result_ALU = sumAdder[15:0];
						end
			4'b0001 : begin 
						 temp = in1 * in2;//<--Float
						 result_ALU = temp[21:6]; //Qformat 16.16 | 8.8
						 end
			4'b0010 : result_ALU = in1 - in2; //DEC 1
			default : result_ALU = 16'h0;
		endcase
	end
	//MUX 2 to 1 select is result_ALU out is zreroFlag write input 1 and 2 is 1 and 0 
	assign zeroFlag = (result_ALU == 16'h0) ? 1 : 0;
	//have carry ?
	assign carryFlag = sumAdder[16];
endmodule
