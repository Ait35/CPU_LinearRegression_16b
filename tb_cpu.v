`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:56:11 03/29/2026
// Design Name:   CPU_LinearRegression
// Module Name:   /home/ise/SPU_Work/CPU_LinearRegression/tb_cpu.v
// Project Name:  CPU_LinearRegression
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: CPU_LinearRegression
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_cpu;

	// Inputs
	reg clk;

	// Instantiate the Unit Under Test (UUT)
	CPU_LinearRegression uut (
		.clk(clk)
	);
	always #5 clk = ~clk;
	initial begin
        clk = 0;

        #20000;
		  $finish;

	end
	initial begin
        $monitor("Time=%0t | PC=%d | Opcode=%b | ACC (Output)=%b | ZeroFlag=%b", 
                 $time, 
                 uut.DP.pc_current,     // เจาะเข้าไปดู PC ใน Data_path (DP)
                 uut.DP.opcode,         // เจาะเข้าไปดู Opcode
                 uut.DP.RF.reg_ACC,     // เจาะเข้าไปลึกถึงตู้ ACC ใน registerFile (RF)
                 uut.DP.zeroFlag_reg);  // เจาะดู Zero Flag
    end
      
endmodule

