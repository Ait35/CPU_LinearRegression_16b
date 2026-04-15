`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module Data_path(
	input clk,
	input HALT_en, mem_result_adder_pointer,
	input Con_reg_read_en,
	input Con_reg_read_en2,
	input Con_reg_write_en,
	input Con_mem_read_en, Con_mem_write_en,
	input JNZ_en,JC_en,jump_en,
	
	output [7:0] isa_out_to_CU
    );
	reg [4:0] pc_current = 5'd0; // index 0
	assign isa_out_to_CU = isa;
   
	//instructionMemory
	wire [4:0] pc_next;
	wire [7:0] isa; //<---only output and this wire is ir
	wire [3:0] opcode = isa[7:4];
	wire [3:0] operand = isa[3:0];
	
	//Control ALU output ,intput use opcode wire
	wire [3:0]alu_op_code ;
	
	// ALU output
	wire alu_zeroFlag, alu_carryFlag;
	wire [15:0]alu_result;
	wire [15:0]ALU_port1,ALU_port2;
	reg zeroFlag_reg ,carry_reg;
	initial begin
		zeroFlag_reg = 0; carry_reg = 0;
	end
	
	//data memory
	wire [5:0]W_mem_addr; //intput
	wire [15:0]W_mem_write_data,W_mem_read_data; //int and out
	reg [3:0]regmem_result_pointer = 4'b0;
	
	//registerFile
	wire [2:0]W_reg_read_addr1, W_reg_read_addr2, W_reg_write_addr;
	wire [15:0]W_reg_write_data;
	//output
	wire[15:0]W_out_data_read1;
	wire [15:0] W_out_data_read2;
	
	always @(posedge clk) begin
	  if (HALT_en == 1'b0) begin
			pc_current <= pc_next; 
	  end
	  
	  // DEC 1001 uo flag
	  if (opcode == 4'b1001) begin
			zeroFlag_reg <= alu_zeroFlag;
	  end
	  //ADD up flag
	  if (opcode == 4'b1000) begin
			carry_reg <= alu_carryFlag;
	  end
	  
	  if(opcode == 4'b1101 && mem_result_adder_pointer) begin
			regmem_result_pointer <= regmem_result_pointer + mem_result_adder_pointer;
	  end

	end
	
	InstructionMemory IM(
        .pc(pc_current), // เอาสายไฟ pc_current เสียบเข้าพอร์ต .pc
        .out_isa(isa) // out isa
    );
	//MUX module pc select adder 1 or jume
	assign pc_next = (JNZ_en && zeroFlag_reg == 1'b1 && operand == 4'd0) ? 5'b10010 :
						  ((JNZ_en && zeroFlag_reg == 1'b0) || jump_en) ? {1'b0, operand[3:0]} :
						  (JC_en && carry_reg == 1'b1) ?  5'b10011 ://19 
							pc_current + 1;
	 
	//----------registerfile MUX-------------
	//MUX module selection Read addr port 1
	assign W_reg_read_addr1 = 
        (opcode == 4'b0101 && operand == 4'b0000) ? 3'd4 : // isa is LOAD A -> but Read i for out data i to data memory addr 
        (opcode == 4'b0101) ? 3'd6 : // isa is LOAD B -> but Read W for out data i to data memory addr 
		  (opcode == 4'b0110 && operand == 4'b0111)? 3'b100: //MOVE read i -> i_S_round
		  (opcode == 4'b0110 && operand == 4'b0100)? 3'b111: //MOVE read i_S_round -> i
        (opcode == 4'b1101) ? 3'd5 : // STORE -> Read ACC save in Ram
        operand[2:0];
	//MUX modle selection Read addr port 2
	assign W_reg_read_addr2 = 
        (opcode == 4'b0111) ? 3'd1 : // MUL Read B to out 
        (opcode == 4'b1000) ? 3'd0 : // ADD ACC -> Read A out 
        3'd0;
	//MUX select write in register addr
	assign W_reg_write_addr = 
		(opcode == 4'b0010)? 3'b010 : //LDI C addr
		(opcode == 4'b0000)? 3'b011 : //LDI D addr
		(opcode == 4'b0001)? 3'b100 : //LDI i addr
		(opcode == 4'b0011)? 3'b110 : //LDI W addr
		(opcode == 4'b0100)? 3'b101 : //LDI ACC addr
		(opcode == 4'b0111)? 3'b000 : // MUL than wirte addr A
		operand[2:0]; //All is LOAD, ADD, DEC
	//MUX select data from LDI isa or port out from ALU 
	assign W_reg_write_data = //8 bit
		(opcode <= 4'b0100) ? {12'h000, operand} : // LDI write data with operand 
		(opcode == 4'b0101) ? W_mem_read_data: //Load need Read in Ram addr(iondex)
		(opcode == 4'b0110)? W_out_data_read1: //MOVE data
		alu_result; 
	
	registerFile RF(
		//input
		.reg_read_en(Con_reg_read_en), 
		.reg_read_en2(Con_reg_read_en2),
		.reg_write_en(Con_reg_write_en),
		.clk(clk),
		.reg_read_addr(W_reg_read_addr1), 
		.reg_read_addr2(W_reg_read_addr2), 
		.reg_write_addr(W_reg_write_addr),
		.reg_write_data(W_reg_write_data),
		//outout
		.out_data_read(W_out_data_read1),
		.out_data_read2(W_out_data_read2)
	);
	//datamemory addr in registerFile from output in reg i or w with wrie W_mem_addr if have be a data from wrie W_out_data_read1(output reg)
	assign W_mem_addr = (opcode == 4'b1101 && mem_result_adder_pointer)? 
			{2'b0 ,regmem_result_pointer}: W_out_data_read1; //is index(addr)i and is a wire not MUXb
	
	Data_memory DM(
		.clk(clk),
		.mem_read_en(Con_mem_read_en), 
		.mem_write_en(Con_mem_write_en),
		.mem_addr(W_mem_addr),
		.mem_write_data(W_mem_write_data),
		//output
		.mem_read_data(W_mem_read_data)
	);
	
	//-----------------STORE-----------------
	assign W_mem_write_data = W_out_data_read1; //wire en connect in blox module
	
	//-------------ALU MUX----------------		
	assign ALU_port1 = W_out_data_read1;//<--is wire
	//if not DCE 1 or Adder 1 is out data from Read 21
	assign ALU_port2 = ((opcode == 4'b1000 && operand != 4'b0101) || opcode == 4'b1001) ? 16'h0001 : 
							 (opcode == 4'b1010) ? 16'd6:
								W_out_data_read2; 
	
	ALU_control ALU_C(
        .isa_opcode(opcode),
        .ALU_opcode(alu_op_code)
    );
	 
	ALU myALU(
        .in1(ALU_port1),
        .in2(ALU_port2),
        .opcode(alu_op_code),
        .zeroFlag(alu_zeroFlag),
		  .carryFlag(alu_carryFlag),
        .result_ALU(alu_result)
    );
	
endmodule
