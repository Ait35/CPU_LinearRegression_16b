`timescale 1ns / 1ps

module tb_registerFile;

	// 1. ประกาศตัวแปรสายไฟสำหรับป้อนเข้า (ใช้ reg) และรับออก (ใช้ wire)
    reg clk;
    reg reg_read_en, reg_read_en2, reg_write_en;
    reg [7:0] reg_read_addr, reg_read_addr2, reg_write_addr;
    reg [7:0] reg_write_data;
    
    wire [7:0] out_data_read;
    wire [7:0] out_data_read2;
	 
	registerFile uut (
        .clk(clk),
        .reg_read_en(reg_read_en),
        .reg_read_en2(reg_read_en2),
        .reg_write_en(reg_write_en),
        .reg_read_addr(reg_read_addr),
        .reg_read_addr2(reg_read_addr2),
        .reg_write_addr(reg_write_addr),
        .reg_write_data(reg_write_data),
        .out_data_read(out_data_read),
        .out_data_read2(out_data_read2)
    );

    // 3. สร้างเครื่องกำเนิดสัญญาณนาฬิกา (Clock Generator)
	 // ให้ไฟกะพริบขึ้นลงทุกๆ 5 หน่วยเวลา (คาบ = 10ns)
    always #5 clk = ~clk;

    // 4. บล็อกเริ่มการทดสอบ (เราจะจำลองการสับสวิตช์ตรงนี้แหละ!)
    initial begin
        // รีเซ็ตค่าเริ่มต้นทั้งหมดให้เป็น 0 ป้องกันไฟช็อต
        clk = 0;
        reg_read_en = 0; reg_read_en2 = 0; reg_write_en = 0;
        reg_read_addr = 0; reg_read_addr2 = 0; reg_write_addr = 0;
        reg_write_data = 0;

        // รอเวลานิดนึงให้ระบบนิ่ง
        #100;
		  
		  // ======================================================
        // บททดสอบที่ 1: ลองเขียนข้อมูลลงตู้ A (Addr 0)
        // ======================================================
        // เทคนิค: เราจะเปลี่ยนค่าตอน "ขอบขาลง (negedge)" เพื่อให้ข้อมูลไปเข้าตู้ตอน "ขอบขาขึ้น (posedge)" พอดี
        @(negedge clk); 
        reg_write_en = 1;          // เปิดสวิตช์อนุญาตเขียน
        reg_write_addr = 8'd0;     // ชี้ไปที่ตู้ 0 (Reg A)
        reg_write_data = 8'd15;    // ยัดเลข 15 เข้าไป
		  
		  // ======================================================
        // บททดสอบที่ 2: ลองเขียนข้อมูลลงตู้ B (Addr 1) และตู้ ACC (Addr 5)
        // ======================================================
        @(negedge clk);
        reg_write_addr = 8'd1;     // ชี้ตู้ 1 (Reg B)
        reg_write_data = 8'd99;    // ยัดเลข 99
        
        @(negedge clk);
        reg_write_addr = 8'd5;     // ชี้ตู้ 5 (Reg ACC)
        reg_write_data = 8'd250;   // ยัดเลข 250
		  
		  // ======================================================
        // บททดสอบที่ 3: ปิดโหมดเขียน แล้วลอง "อ่าน" ออกมาพร้อมกัน 2 ท่อ!
        // ======================================================
        @(negedge clk);
        reg_write_en = 0;          // ปิดสวิตช์เขียน
        reg_read_en = 1;           // เปิดก๊อกน้ำท่อที่ 1
        reg_read_en2 = 1;          // เปิดก๊อกน้ำท่อที่ 2
		  
		  reg_read_addr = 8'd0;      // ท่อ 1 ขอดูตู้ 0 (Reg A) -> ควรออกเลข 15
        reg_read_addr2 = 8'd1;     // ท่อ 2 ขอดูตู้ 1 (Reg B) -> ควรออกเลข 99
        
        // รอสักพักแล้วลองสลับไปดูตู้ ACC
        #20;
        reg_read_addr = 8'd5;      // ท่อ 1 ขอดูตู้ 5 (Reg ACC) -> ควรออกเลข 250
        reg_read_addr2 = 8'd0;     // ท่อ 2 ขอดูตู้ 0 (Reg A)   -> ควรออกเลข 15

        // จบการทดสอบ
		  #50;
        $finish; // สั่งปิดโปรแกรม
    end
      
endmodule
		  
		  