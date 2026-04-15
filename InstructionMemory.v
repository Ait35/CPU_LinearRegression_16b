`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module InstructionMemory(
	input[4:0] pc, //1-32 use 17
	output[7:0] out_isa 
    ); 
	//Rom 8 bit
	reg [7:0] isa_mem [31:0];
	//index in array mem
	//Read file
	initial 
	begin
		$readmemb("./isaFile.txt", isa_mem);
	end
	//find index addr in array rom and out in reg ir
	assign out_isa = isa_mem[pc];
endmodule //Gu commet wai meung read duuay
