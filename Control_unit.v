`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module Control_unit(
	input[7:0] isa,
	//----------------registerfile-----------------||
	output reg JNZ_en,JC_en,jump_en,regfile_read_en, regfile_read_en2, regfile_write_en, HALT_en,//en
	//------------------data Memory----------------||
	output reg mem_read_en, mem_write_en, mem_result_adder_pointer
	
    );
	 
	always@(*) begin
		regfile_write_en = 0; 
		regfile_read_en = 0; regfile_read_en2 = 0; 
		mem_read_en = 0; mem_write_en = 0;
		HALT_en = 0; jump_en = 0;
		JNZ_en = 0; JC_en = 0;
		mem_result_adder_pointer = 0;
		
		case(isa[7:4]) //LDI
			4'b0000, 4'b0001, 4'b0010, 4'b0011, 4'b0100: begin
				regfile_write_en = 1;
			end
			4'b0101: begin //LOAD
				regfile_write_en = 1; regfile_read_en = 1; //read i (i is index addr i )
				mem_read_en = 1; //en read addr index i or w in memory control i or w by MUX
			end
			4'b0110: begin //move
				regfile_read_en = 1;
				regfile_write_en = 1; //move reg->reg
			end
			//read with go to MUL(*) for ALU
			4'b0111: begin 
				regfile_read_en = 1; regfile_read_en2 = 1; regfile_write_en = 1; 
			end
			//read with go to Adder(+) for ALU
			4'b1000 , 4'b1010: begin 
				regfile_read_en = 1; regfile_read_en2 = 1; regfile_write_en = 1; 
			end
			//read with go to DEC or sub(-) for ALU
			4'b1001: begin 
				regfile_read_en = 1; regfile_read_en2 = 1; regfile_write_en = 1; 
			end
			//jume not Zero
			4'b1100: JNZ_en = 1;
			//jump is carry
			4'b1110: JC_en = 1;
			//jump back to isa 0010 (3) and jume not Zero
			4'b1011: jump_en = 1;
			//STORE
			4'b1101: begin 
				regfile_read_en = 1;//ACC
				mem_write_en = 1;//write ACC in memory_resulte_ram
				mem_result_adder_pointer = 1;
			end
			4'b1111: HALT_en = 1;
		endcase
	end	


endmodule
