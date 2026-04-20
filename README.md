ไฟล์ TB ที่แยกโมดูลบางอันใช้ไม่ได้นะ ที่ใช้ได้แน่ๆ คือ tb_cpu เพราะใช้เทสทั้งโปรเจ็ค

รูปแบบการเก็บข้อมูฃ Ram
1.memory_ram เก็บพารามิเตอร์โดยเรียงแบบนี้0-5 คือค่า weight ส่วน 6-29 คือค่าพารามิเตอร์ต่างๆ โดยเรียง ไม่ซ้ำกันต่อกัน 6 อัน แล้ว 6 อันต่อไปจะเป็นสัปดาห์ใหม่
2.memory_resulte_ram เก็บ out แต่ละสัปดาห์  มีขนาด 16 bit ยาว 4 แถว (4สัป)

รุปแบบการทำงาน 
1. 0000 x100 LDI D,4  โหลด 4 ไปที่ register D ตัวที่ 4 แต่ในส่วนนี้สามารถเปลี่ยนได้สูงสุด 4 มันจำนวนที่ทำนาย
2. 0001 x110 LDI i,6  โหลด 6 ไป reg i ตัวที่ 5
3. 0010 x110 LDI C,6  โหลด 6 ไป reg C ตัวที่ 3
4. 0110 x111  Move i_s_Round , i 
5. 0011 x000 LDI W,0  โหลด  0ไป reg W ตัวที่ 7
6. 0100 x000 LDI ACC,0  ลง reg ACC ตัวที่ 6
7. 0101 x000 Load A,i   ส่ง mem_read_en ไป data_memory โดย mem_addr ตาม i ดึงจาก ram มาลง A
8. 0101 x001 Load B,W  ส่ง mem_read_en ไป data_memory โดยa mem_addr ตาม W ดึงจาก ram มาลง B
9. 0111 xxxx MUL  เอาข้อมูลจาก port A และ port B มาคูณกัน เก็บลง reg Temp(อยู่ ALU) ash
10. 1000 x101 Add  เอาข้อมูลจาก port A (reg A) และ port B (ACC) มาบวกกัน เก็บลง ACC
11. 1110 xxxx JC โดดไป20
12. 1000 x100 Add i,1  สับ port A เป็น i, port xx mp เป็น 1 บวกกัน เก็บลง i
13. 1000 x110 ADD W,1  สับ port A เป็น W, port B เป็น 1 บวกกัน เก็บลง W
14. 1001 x010 DEC C  เลือก port A = C, port B = 1 ลบกัน เก็บลง C
15. 1100 0110 JNZ  ไป C เทียบกับ ZeroFlag ถ้าไม่เท่ากัน ให้โดดไปที่ข้อ 7
16. 1101 0000 STORE  ใส่ +1 ค่า pointer และ กำนหด mem_addr นำค่าจาก ACC ใส่ mem_write_data ส่ง mem_write_en เขียนลง mem_resulte_ram
17. 1001 x011 DEC D,1  สับ port A = D, port B = 1 ลบกัน เก็บลง D
18. 1100 0010 JNZ D  เทียบ ZeroFlag ถ้าไม่เท่ากับ 0 โดดไปข้อ 3
19. 1111 xxxx HALT  จบการทำงาน
20. 0100 x000 LDI ACC, 0
21. 1101 0000 STORE ใส่ 0 ใน result ram แล้ว +1 pointer
22. 0110 x100 MOVE i , i_s_round 
23. 1010 x100 Add i,6  สับ port B เป็น i, ดึง i จาก port A เป็น 6 บวกกัน เก็บลง i
24. 1001 x011 DEC D อีกรอบ
25. 1100 0010 JZ D โดด/ป Halt
26. 1100 0000 Jump โดดกลับไป3
