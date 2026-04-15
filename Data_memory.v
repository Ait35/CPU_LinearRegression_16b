`timescale 1ns / 1ps
//อ่านพารามิเตอร์จาก .txt ลง arraY memory กับ ได้คำตอบเอาลง .txt
module Data_memory(
	input clk,
	input [5:0]mem_addr,
	input mem_read_en, mem_write_en,
	input [15:0] mem_write_data,
	//ค่า addr(index) จาก C เพื่อ fetch พารามิเตอร์ for index in ram
	output [15:0]mem_read_data
    );
	//create 8 bit for Ram 6 parameter and 6 weieght
	reg [15:0] memory_ram [29:0]; 
	reg [15:0] memory_result_ram [3:0]; 
	
	//AI genn
	integer i;
	integer file_id;
	initial begin
	for (i = 0; i <= 29; i = i + 1) begin
			memory_ram[i] = 16'h0000;
	end
	$readmemb("/home/ise/SPU_Work/CPU_LinearRegression_16b/dataFile.txt",memory_ram);
	
	// 1. เปิดไฟล์ (หรือสร้างใหม่ถ้าไม่มี) โหมด "w" คือเขียนทับของเก่า
	file_id = $fopen("output_result.txt", "w");
   end
	 //AI end
	 
	always@ (posedge clk) begin
		if(mem_write_en) begin
			 memory_result_ram[mem_addr] <= mem_write_data;
			//Ai gen
			// 2. เขียนข้อมูลลงไฟล์ .txt ทันทีที่มีการบันทึกลง RAM
			// $fdisplay จะทำงานเหมือน printf ในภาษา C และขึ้นบรรทัดใหม่ให้เอง
			$fdisplay(file_id, "Time: %0t | Addr: %b | Saved Data: %b", $time, mem_addr, mem_write_data);
			$fflush(file_id);
			//Ai gen End	
		end
	end
	//read parameter only for registerFile na 
	assign mem_read_data = (mem_read_en) ? memory_ram[mem_addr] : 16'h0000; //MUX
	
endmodule
