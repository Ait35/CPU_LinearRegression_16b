`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module ALU_control(
	input [3:0]isa_opcode,
	
	output reg[3:0]ALU_opcode
    );
	 
	always@(*) begin
		case(isa_opcode)
			// MUL
			4'b0111: ALU_opcode = 4'b0001; 
			// DEC C, DEC D ,sub
			4'b1001: ALU_opcode = 4'b0010; 
			// ADD ACC, ADD i, ADD W
			4'b1000 , 4'b1010: ALU_opcode = 4'b0000; 
			// ให้มันปล่อยค่า 0 (บวก) ไปเป็น Default  (เดี๋ยวใช้ MUX ดักเอาทีหลัง)
			default: ALU_opcode = 4'b0000;
		endcase
	end
endmodule
