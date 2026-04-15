`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:14:38 03/29/2026
// Design Name:   InstructionMemory
// Module Name:   /home/ise/SPU_Work/CPU_LinearRegression/tb_IM.v
// Project Name:  CPU_LinearRegression
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: InstructionMemory
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_IM;

	// Inputs
	reg [5:0] pc;

	// Outputs
	wire [7:0] out_isa;
	integer i;

	// Instantiate the Unit Under Test (UUT)
	InstructionMemory uut (
		.pc(pc), 
		.out_isa(out_isa)
	);

	initial begin
		#5;
        
        $display("========================================");
        $display("   Start Testing Instruction Memory     ");
        $display("========================================");
        
        // วนลูปจำลองตู้ PC วิ่งตั้งแต่บรรทัดที่ 0 ถึง 16
        for (i = 0; i <= 16; i = i + 1) begin
            pc = i; // ยัดเลขบรรทัดเข้าสายไฟ PC
            #10;    // รอ 10 ns เพื่อให้กล่องอ่านข้อมูลและปริ้นท์ออกมา
        end
		  $display("========================================");
        $display("           End of Test                  ");
        $display("========================================");
        
        $finish; // สั่งหยุดจำลองการทำงาน
	end
    
    // 4. เครื่องดักฟัง (Monitor) คอยปริ้นท์ค่าออกจอ Console
   initial begin
        // ให้มันปริ้นท์ทุกครั้งที่เวลา (Time) หรือสายไฟ (pc, out_isa) มีการเปลี่ยนแปลง
        $monitor("Time: %0t ns | PC: %d | ISA Output (Binary): %b", $time, pc, out_isa);
	end
      
endmodule

