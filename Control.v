//IF
module Control(
	input  [6 -1:0] OpCode   ,
	input  [6 -1:0] Funct    ,
	output [2 -1:0] PCSrc    ,
	output [3 -1:0] Branch            ,
	output RegWrite          ,
	output [2 -1:0] RegDst   ,
	output MemRead           ,
	output MemWrite          ,
	output [2 -1:0] MemtoReg ,
	output ALUSrc1           ,
	output ALUSrc2           ,
	output ExtOp             ,
	output LuOp              ,
	output [4 -1:0] ALUOp    ,
	input  nop
);
	//set PCSrc
	assign PCSrc[1:0] = 
		(OpCode == 6'h02 || OpCode == 6'h03)? 2'b01:
		(OpCode == 6'h00 && (Funct == 6'h08 || Funct == 6'h09))? 2'b10:
		2'b00;//01:jump,jal 10:jr,jalr 00:else
	//set Branch
	assign Branch = 
		(OpCode == 6'h04)? 3'b001:
		(OpCode == 6'h05)? 3'b010://bne
		(OpCode == 6'h06)? 3'b011://blez
		(OpCode == 6'h07)? 3'b100://bgtz
		(OpCode == 6'h01)? 3'b101://bltz
		3'b000;
	//set RegWrite
	assign RegWrite = 
		(OpCode == 6'h2b || OpCode == 6'h04 || OpCode == 6'h02 || OpCode == 6'h05
		|| (OpCode == 6'h00 && (Funct == 6'h08)) || nop)? 1'b0://jal,jalr need write, jr08 no need
		1'b1;//00000also regwrite,mind it
	//set RegDst
	assign RegDst[1:0] = 
		(OpCode == 6'h03 || (OpCode == 6'h00 && (Funct == 6'h09)))? 2'b10:
		(OpCode == 6'h23 || OpCode == 6'h0f || OpCode == 6'h08
		|| OpCode == 6'h09 || OpCode == 6'h0c 
		|| OpCode == 6'h0a || OpCode == 6'h0b)? 2'b00:
		2'b01;
	//set MemRead
	assign MemRead = (OpCode == 6'h23)? 1'b1:1'b0;
	//set MemWrite
	assign MemWrite = (OpCode == 6'h2b)? 1'b1:1'b0;
	//set MemtoReg
	assign MemtoReg[1:0] = 
		(OpCode == 6'h23)? 2'b01:
		(OpCode == 6'h03 || (OpCode == 6'h00 && (Funct == 6'h09)))? 2'b10://jal,jalr need write,save to 31
		2'b00;
	//set ALUSrc2
	assign ALUSrc2 = 
		(OpCode == 6'h23 || OpCode == 6'h2b ||
		OpCode == 6'h0f || OpCode == 6'h08 ||
		OpCode == 6'h09 || OpCode == 6'h0c || 
		OpCode == 6'h0a || OpCode == 6'h0b)? 1'b1:
		1'b0;
	//set ALUSrc1
	assign ALUSrc1 = 
		(OpCode == 6'h00 && (Funct == 6'h00 || Funct == 6'h02 
		|| Funct == 6'h03))? 1'b1:
		1'b0;
	//set ExtOp
	assign ExtOp = 
		(OpCode == 6'h0c)? 1'b0:
		1'b1;
    //set LuOp
	assign LuOp = 
	    (OpCode == 6'h0f)? 1'b1:
	    1'b0;
	// set ALUOp
	assign ALUOp[2:0] = 
		(OpCode == 6'h00)? 3'b010: 
		(OpCode == 6'h04 || OpCode == 6'h05)? 3'b001: 
		(OpCode == 6'h0c)? 3'b100: 
		(OpCode == 6'h0a || OpCode == 6'h0b || OpCode == 6'h06 || OpCode == 6'h07 || OpCode == 6'h01)? 3'b101: //slt
		(OpCode == 6'h1c && Funct == 6'h02)? 3'b110:
		3'b000; //mul
		
	assign ALUOp[3] = OpCode[0];
endmodule