`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:28:17 03/29/2026
// Design Name:   Data_memory
// Module Name:   /home/ise/SPU_Work/CPU_LinearRegression/tb_DM.v
// Project Name:  CPU_LinearRegression
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Data_memory
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_DM;

	// Inputs
	reg clk;
	reg [5:0] mem_addr;
	reg mem_read_en;
	reg mem_write_en;
	reg [7:0] mem_write_data;

	// Outputs
	wire [7:0] mem_read_data;
	
	integer i;

	// Instantiate the Unit Under Test (UUT)
	Data_memory uut (
		.clk(clk), 
		.mem_addr(mem_addr), 
		.mem_read_en(mem_read_en), 
		.mem_write_en(mem_write_en), 
		.mem_write_data(mem_write_data), 
		.mem_read_data(mem_read_data)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		mem_addr = 0;
		mem_read_en = 0;
		mem_write_en = 0;
		mem_write_data = 0;

		// Wait 100 ns for global reset to finish
		#15; 
        
        $display("========================================");
        $display("   Start Testing Data Memory (RAM)      ");
        $display("========================================");
        
        mem_read_en = 1; // สับสวิตช์ขอเปิดอ่านตู้ RAM

        // วนลูปขอดูตู้เบอร์ 0 ถึง 11 (พารามิเตอร์ W 6 ตัว และ I 6 ตัว)
        for (i = 0; i < 12; i = i + 1) begin
            mem_addr = i; // ชี้เป้าแอดเดรส
            #10;          // รอ 1 Clock ให้ข้อมูลไหลออกมา
            $display("Time: %0t ns | Addr: %d | Data out (Binary): %b", $time, mem_addr, mem_read_data);
        end
        
        $display("========================================");
        $display("           End of Test                  ");
        $display("========================================");
		  $finish;
		// Add stimulus here

	end
      
endmodule

