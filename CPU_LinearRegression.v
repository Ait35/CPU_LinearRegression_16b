`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:05:40 03/29/2026 
// Design Name: 
// Module Name:    CPU_LinearRegression 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module CPU_LinearRegression(
	input clk
    );
	 wire [7:0] isa_wire;
    wire JNZ_en_wire,JC_en_wire, jump_en_wire, HALT_en_wire;
    wire reg_read_en_wire, reg_read_en2_wire, reg_write_en_wire;
    wire mem_read_en_wire, mem_write_en_wire,result_adder_pointer;

	Control_unit CU(
	  .isa(isa_wire), // isa form Datapath
	  .JNZ_en(JNZ_en_wire), 
	  .JC_en(JC_en_wire),
	  .jump_en(jump_en_wire),
	  .HALT_en(HALT_en_wire),
	  .regfile_read_en(reg_read_en_wire),
	  .regfile_read_en2(reg_read_en2_wire),
	  .regfile_write_en(reg_write_en_wire),
	  .mem_read_en(mem_read_en_wire),
	  .mem_write_en(mem_write_en_wire),
	  .mem_result_adder_pointer(result_adder_pointer)
	 
	);
	
	Data_path DP(
        .clk(clk),
        .isa_out_to_CU(isa_wire), // out isa in CU
        .JNZ_en(JNZ_en_wire),
		  .JC_en(JC_en_wire),
		  .jump_en(jump_en_wire),
        .HALT_en(HALT_en_wire),
        .Con_reg_read_en(reg_read_en_wire),
        .Con_reg_read_en2(reg_read_en2_wire),
        .Con_reg_write_en(reg_write_en_wire),
        .Con_mem_read_en(mem_read_en_wire),
        .Con_mem_write_en(mem_write_en_wire),
		  .mem_result_adder_pointer(result_adder_pointer)
    );
	 
endmodule
