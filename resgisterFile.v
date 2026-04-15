`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module registerFile(
	input clk,
	//have reg A,B,C,D,I,ACC
	input reg_read_en, reg_read_en2, reg_write_en, //control
	//Writ data in reg
	input [2:0]reg_read_addr, reg_read_addr2, reg_write_addr,
	input [15:0]reg_write_data,
	//raed than out to wrie bus to ALU
	output reg[15:0]out_data_read,
	output reg [15:0] out_data_read2
    );
	//ram
	reg [15:0]reg_A, reg_B, reg_C, reg_D, reg_I, reg_ACC, reg_W, reg_i_s_round;
	
	always @(posedge clk) begin
	  // Write
		if(reg_write_en) begin
			case(reg_write_addr)
				3'b000: reg_A <= reg_write_data;
				3'b001: reg_B <= reg_write_data;
				3'b010: reg_C <= reg_write_data;
				3'b011: reg_D <= reg_write_data;
				3'b100: reg_I <= reg_write_data;
				3'b101: reg_ACC <= reg_write_data;
				3'b110: reg_W <= reg_write_data;
				3'b111: reg_i_s_round <= reg_write_data;
				default: reg_A <= reg_write_data;
			endcase
		end
    end
	 
	 always@(*) begin
		//read
		if(reg_read_en) begin
			case(reg_read_addr)
				0: out_data_read = reg_A;
				1: out_data_read = reg_B;
				2: out_data_read = reg_C;
				3: out_data_read = reg_D;
				4: out_data_read = reg_I;
				5: out_data_read = reg_ACC;
				6: out_data_read = reg_W;
				7: out_data_read = reg_i_s_round;
				default: out_data_read = 16'h0000;
			endcase
		end else begin
			out_data_read = 16'h0000;
		end
		
		if(reg_read_en2) begin
			case(reg_read_addr2)
				0: out_data_read2 = reg_A;
				1: out_data_read2 = reg_B;
				2: out_data_read2 = reg_C;
				3: out_data_read2 = reg_D;
				4: out_data_read2 = reg_I;
				5: out_data_read2 = reg_ACC;
				6: out_data_read2 = reg_W;
				7: out_data_read2 = reg_i_s_round;
				default: out_data_read2 = 16'h0000;
			endcase
		end else begin
			out_data_read2 = 16'h0000;
		end
	 end

endmodule