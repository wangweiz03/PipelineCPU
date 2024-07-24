module CPU(
	input  reset                        , 
	input  clkorig                          , 
	output [3:0] sel,
	output [7:0] leds,
	output done
);
    wire clk;
    clk_50M clk_50(
        .clk        (clkorig    ),
        .reset      (reset  ),
        .clk_50M     (clk )
        );
        
    wire clk_1k;//change bits
    clk_1kHz clk_1K(
    .clk        (clkorig    ),
    .reset      (reset  ),
    .clk_1K     (clk_1k )
    );
    
    wire clk_1;//change 0xabcd
    clk_1Hz clk1(
        .clk      (clk_1k    ),
        .reset    (reset     ),
        .clk_1    (clk_1     )
    );
    
    wire [11:0] digi;//generate from DMem, designed mainly using mips insts
    assign sel = digi[11:8];
    assign leds = digi[7:0];
    
	// PC register
	reg  [31 :0] PC;
	wire [31 :0] PC_next;
	wire [31 :0] PC_plus_4;reg [31 :0] IFID_PC_plus_4;

	always @(posedge reset or posedge clk)
		if (reset)
			PC <= 32'h00400000;
		else
			PC <= PC_next;
	
	// Instruction Memory
	wire [31 :0] Instruction;
	InstructionMemory instruction_memory1(
		.Address        (PC             ), 
		.Instruction    (Instruction    )
	);

	// Control IF,14
	reg  [32 -1:0] IFID_Instruction;
	wire [2 -1:0] RegDst;  reg [2 -1:0] IFID_RegDst    ;
	wire [2 -1:0] PCSrc;   reg [2 -1:0] IFID_PCSrc     ;
	wire [3 -1:0] Branch;  reg [3 -1:0] IFID_Branch    ;//more "b-type"
	wire          MemRead; reg IFID_MemRead   ;
	wire          MemWrite;reg IFID_MemWrite  ;
	wire [2 -1:0] MemtoReg;reg [2 -1:0] IFID_MemtoReg  ;
	wire          ALUSrc1; reg IFID_ALUSrc1   ;
	wire          ALUSrc2;  reg IFID_ALUSrc2   ;
	wire [4 -1:0] ALUOp;   reg [4 -1:0] IFID_ALUOp     ;
	wire          ExtOp;   reg IFID_ExtOp     ;
	wire          LuOp;    reg IFID_LuOp      ;
	wire          RegWrite;reg IFID_RegWrite  ;
	
	assign PC_plus_4 = (IFID_Branch)? IFID_PC_plus_4: (PC + 32'd4);
    
	wire nop;
	assign nop = (Instruction == 32'b0);
	
	Control control1(//2+12
		.OpCode     (Instruction[31:26] ), 
		.Funct      (Instruction[5 : 0] ),
		.PCSrc      (PCSrc              ), 
		.Branch     (Branch             ), 
		.RegWrite   (RegWrite           ), 
		.RegDst     (RegDst             ), 
		.MemRead    (MemRead            ),	
		.MemWrite   (MemWrite           ), 
		.MemtoReg   (MemtoReg           ),
		.ALUSrc1    (ALUSrc1            ), 
		.ALUSrc2    (ALUSrc2            ), 
		.ExtOp      (ExtOp              ), 
		.LuOp       (LuOp               ),	
		.ALUOp      (ALUOp              ),
		.nop        (nop                )
	);
	
	//------------------------------------------------IF/ID PLUGIN BEGIN ¡üIF---------------------------------------------------
	wire loaduse;
	wire rbranch;
	always @(posedge reset or posedge clk) begin
	   if (reset) begin
	       IFID_Instruction <= 32'b0;
	       IFID_RegDst <= 2'b00;
	       IFID_PCSrc <= 2'b00;
	       IFID_Branch <= 3'b000;
	       IFID_MemRead <= 1'b0;
	       IFID_MemWrite <= 1'b0;
	       IFID_MemtoReg <= 2'b00;
	       IFID_ALUSrc1 <= 1'b0;
	       IFID_ALUSrc2 <= 1'b0;
	       IFID_ALUOp <= 4'b0000;
	       IFID_ExtOp <= 1'b0;
	       IFID_LuOp <= 1'b0;
	       IFID_RegWrite <= 1'b0;
	       IFID_PC_plus_4 <= 32'b0;
	   end
	   else if (loaduse || rbranch) begin
	       IFID_Instruction <= 32'b0;
           IFID_RegDst <= 2'b00;
           IFID_PCSrc <= 2'b00;
           IFID_Branch <= 3'b000;
           IFID_MemRead <= 1'b0;
           IFID_MemWrite <= 1'b0;
           IFID_MemtoReg <= 2'b00;
           IFID_ALUSrc1 <= 1'b0;
           IFID_ALUSrc2 <= 1'b0;
           IFID_ALUOp <= 4'b0000;
           IFID_ExtOp <= 1'b0;
           IFID_LuOp <= 1'b0;
           IFID_RegWrite <= 1'b0;
           IFID_PC_plus_4 <= 32'b0;
	   end
	   else begin
	       IFID_Instruction <= Instruction;
	       IFID_RegDst <= RegDst;
           IFID_PCSrc <= PCSrc;
           IFID_Branch <= Branch;
           IFID_MemRead <= MemRead;
           IFID_MemWrite <= MemWrite;
           IFID_MemtoReg <= MemtoReg;
           IFID_ALUSrc1 <= ALUSrc1;
           IFID_ALUSrc2 <= ALUSrc2;
           IFID_ALUOp <= ALUOp;
           IFID_ExtOp <= ExtOp;
           IFID_LuOp <= LuOp;
           IFID_RegWrite <= RegWrite;
           IFID_PC_plus_4 <= PC_plus_4;
	   end
	end
	//--------------------------------------------------IF/ID PLUGIN END ¡ýID---------------------------------------------------
	
	// Register File new ctrls
	wire [32 -1:0] Databus1;      reg [32 -1:0] IDEX_Databus1;
	wire [32 -1:0] Databus2;      reg [32 -1:0] IDEX_Databus2;
	wire [32 -1:0] Databus3;      //reg [32 -1:0] IDEX_Databus3;//write-in bus; ¡¾write before read¡¿principle
	wire [5  -1:0] Write_register;reg [5 -1:0] IDEX_Write_register;
	
	//IF/ID old ctrls
    reg [32 -1:0] IDEX_Instruction;
    //reg [2 -1:0] IDEX_RegDst    ;
    //reg [2 -1:0] IDEX_PCSrc     ;
    //reg [3 -1:0] IDEX_Branch    ;//more "b-type"
    reg IDEX_MemRead   ;
    reg IDEX_MemWrite  ;
    reg [2 -1:0] IDEX_MemtoReg  ;
    reg IDEX_ALUSrc1   ;
    reg IDEX_ALUSrc2   ;
    //reg [4 -1:0] IDEX_ALUOp     ;
    //reg IDEX_ExtOp     ;
    //reg IDEX_LuOp      ;
    reg IDEX_RegWrite  ;
    reg [32 -1:0] IDEX_PC_plus_4;
    reg MEMWB_RegWrite;
    reg [5 -1:0] MEMWB_Write_register;
    
	assign Write_register = (IFID_RegDst == 2'b00)? IFID_Instruction[20:16]: 
	       (IFID_RegDst == 2'b01)? IFID_Instruction[15:11]: 
	       5'b11111;//prepare which to write

	RegisterFile register_file1(//write is WB stage
		.reset          (reset              ), 
		.clk            (clk                ),
		.RegWrite       (MEMWB_RegWrite           ), 
		.Read_register1 (IFID_Instruction[25:21] ), //rs
		.Read_register2 (IFID_Instruction[20:16] ), //rt
		.Write_register (MEMWB_Write_register     ),
		.Write_data     (Databus3           ), //input
		.Read_data1     (Databus1           ), 
		.Read_data2     (Databus2           )
	);
	// Extend
	wire [32 -1:0] Ext_out;
	assign Ext_out = { IFID_ExtOp? {16{IFID_Instruction[15]}}: 16'h0000, IFID_Instruction[15:0]};
	
	wire [32 -1:0] LU_out;
	assign LU_out = IFID_LuOp? {IFID_Instruction[15:0], 16'h0000}: Ext_out;
	
	reg [32 -1:0] IDEX_LU_out;//IDEX_Ext_out
	
	//Jump and Branch
    wire [32 -1:0] Jump_target;
    assign Jump_target = {IFID_PC_plus_4[31:28], IFID_Instruction[25:0], 2'b00};
    
    wire [32 -1:0] Databus1_brc,Databus2_brc;
    reg [5 -1:0] EXMEM_Write_register;
    reg [32 -1:0] EXMEM_ALU_out;
    reg EXMEM_RegWrite;
    reg [32 -1:0] MEMWB_ALU_out;
    
    assign Databus1_brc = (MEMWB_Write_register && MEMWB_RegWrite
            && MEMWB_Write_register == IFID_Instruction[25:21] && (EXMEM_Write_register != IFID_Instruction[25:21] || ~EXMEM_RegWrite))? MEMWB_ALU_out:
            (EXMEM_Write_register && EXMEM_RegWrite
            && EXMEM_Write_register == IFID_Instruction[25:21])? EXMEM_ALU_out:
            Databus1;
    assign Databus2_brc = (MEMWB_Write_register && MEMWB_RegWrite
           && MEMWB_Write_register == IFID_Instruction[20:16] && (EXMEM_Write_register != IFID_Instruction[20:16] || ~EXMEM_RegWrite))? MEMWB_ALU_out:
           (EXMEM_Write_register && EXMEM_RegWrite
           && EXMEM_Write_register == IFID_Instruction[20:16])? EXMEM_ALU_out:
           Databus2;
        
    //an incomplete alu designed for branch
    wire Zero;
    assign Zero = (Databus1_brc == Databus2_brc);
    wire ss;
    assign ss = {Databus1_brc[31], Databus2_brc[31]};
    wire lt_31;
    assign lt_31 = (Databus1_brc[30:0] < Databus2_brc[30:0]);
    wire lt_signed;
    assign lt_signed = (Databus1_brc[31] ^ Databus2_brc[31])? 
        ((ss == 2'b01)? 0: 1): lt_31;
    wire slt;
    wire          Sign  ;reg           IDEX_Sign;
    assign slt  = {31'h00000000, Sign? lt_signed: (Databus1_brc < Databus2_brc)};//for bgtz and so on
    
    wire [32 -1:0] Branch_target;
    assign Branch_target = ((IFID_Branch == 3'b001 && Zero) || (IFID_Branch == 3'b010 && ~Zero) 
           || (IFID_Branch == 3'b011 && (Zero || slt)) || (IFID_Branch == 3'b100 && (~Zero && ~slt)) 
           || (IFID_Branch == 3'b101 && slt) )? IFID_PC_plus_4 + {LU_out[29:0], 2'b00}: 
           (Branch || PCSrc == 2'b01 || PCSrc == 2'b10)? 32'hffeeffff://assign a pc with 00000000 instruction
           PC_plus_4;//is PC_plus_4!!!
    
    assign loaduse = (IFID_MemRead && IFID_Instruction[20:16] && ((IFID_Instruction[20:16] == Instruction[25:21])
    || (IFID_Instruction[20:16] == Instruction[20:16] && ~MemWrite)));//lw,sw;lw,R
    
    assign rbranch = (Branch && Write_register && 
    ((Write_register == Instruction[25:21])||(Write_register == Instruction[20:16])));
    
    assign PC_next = (loaduse || rbranch)? PC: 
    (IFID_PCSrc == 2'b00)? Branch_target: 
    (IFID_PCSrc == 2'b01)? Jump_target: 
    Databus1;//THE FINAL DECISION;JR DATABUS1
	
	
	// ALU Control
	wire [5 -1:0] ALUCtl;reg  [5 -1:0] IDEX_ALUCtl;

	ALUControl alu_control1(
		.ALUOp  (IFID_ALUOp              ), 
		.Funct  (IFID_Instruction[5:0]   ), 
		.ALUCtl (ALUCtl             ), 
		.Sign   (Sign               )
	);
		
    //--------------------------------------------------ID/EX PLUGIN BEGIN ¡üID---------------------------------------------------
	always @(posedge reset or posedge clk) begin
	   if (reset) begin
	       IDEX_Databus1 <= 32'b0;
	       IDEX_Databus2 <= 32'b0;
	       //IDEX_Databus3 <= 32'b0;
	       IDEX_Write_register <= 5'b0;
	       IDEX_Instruction <= 32'b0;
	       //IDEX_RegDst <= 2'b00;
	       IDEX_MemRead <= 1'b0;
	       IDEX_MemWrite <= 1'b0;
	       IDEX_MemtoReg <= 2'b00;
	       IDEX_ALUSrc1 <= 1'b0;
	       IDEX_ALUSrc2 <= 1'b0;
	       //IDEX_ALUOp <= 4'b0000;
	       //IDEX_LuOp <= 1'b0;
	       //IDEX_ExtOp <= 1'b0;
	       IDEX_RegWrite <= 1'b0;
	       //IDEX_Ext_out <= 32'b0;
	       IDEX_LU_out <= 32'b0;
	       IDEX_ALUCtl <= 5'b0;
	       IDEX_Sign <= 5'b0;
	       IDEX_PC_plus_4 <= 32'b0;
	   end
	   else begin
 	       IDEX_Databus1 <= Databus1_brc;//EX
           IDEX_Databus2 <= Databus2_brc;//EX
           //IDEX_Databus3 <= 32'b0;
           IDEX_Write_register <= Write_register;
           IDEX_Instruction <= IFID_Instruction;//EX
           //IDEX_RegDst <= IFID_RegDst;
           IDEX_MemRead <= IFID_MemRead;
           IDEX_MemWrite <= IFID_MemWrite;
           IDEX_MemtoReg <= IFID_MemtoReg;
           IDEX_ALUSrc1 <= IFID_ALUSrc1;//EX
           IDEX_ALUSrc2 <= IFID_ALUSrc2;//EX
           //IDEX_ALUOp <= 4'b0000;
           //IDEX_LuOp <= 1'b0;
           //IDEX_ExtOp <= 1'b0;
           IDEX_RegWrite <= IFID_RegWrite;
           //IDEX_Ext_out <= 32'b0;
           IDEX_LU_out <= LU_out;//EX
           IDEX_ALUCtl <= ALUCtl;//EX
           IDEX_Sign <= Sign;//EX
           IDEX_PC_plus_4 <= IFID_PC_plus_4;
	   end
	end
	
	//--------------------------------------------------ID/EX PLUGIN END ¡ýEX---------------------------------------------------
	
	// ALU new copies
	wire [32 -1:0] ALU_in1;
	wire [32 -1:0] ALU_in2;
	wire [32 -1:0] ALU_out;
	
    //old copies
    
    //reg [2 -1:0] EXMEM_RegDst;
    reg EXMEM_MemRead;
    reg EXMEM_MemWrite;
    reg [2 -1:0] EXMEM_MemtoReg;
    reg [32 -1:0] EXMEM_Databus2;
    reg [32 -1:0] EXMEM_PC_plus_4;
    reg [32 -1:0] EXMEM_Instruction;
    reg [32 -1:0] MEMWB_MemBus_Read_Data;
    reg MEMWB_Memory_Read;
    
	assign ALU_in1 = IDEX_ALUSrc1? {27'h00000, IDEX_Instruction[10:6]}: IDEX_Databus1;
	assign ALU_in2 = IDEX_ALUSrc2? IDEX_LU_out: IDEX_Databus2;
    
    wire [32 -1:0] in1,in2;//rs,rt forwarding
    
    assign in1 = (~IDEX_ALUSrc1 && MEMWB_Memory_Read && MEMWB_Write_register 
        && MEMWB_Write_register == IDEX_Instruction[25:21])? MEMWB_MemBus_Read_Data:
        (~IDEX_ALUSrc1 && MEMWB_RegWrite && MEMWB_Write_register && (MEMWB_Write_register == IDEX_Instruction[25:21])
        && (EXMEM_Write_register != IDEX_Instruction[25:21] || ~EXMEM_RegWrite))? MEMWB_ALU_out:
        (~IDEX_ALUSrc1 && EXMEM_RegWrite && EXMEM_Write_register
        && (EXMEM_Write_register == IDEX_Instruction[25:21]))? EXMEM_ALU_out: 
        ALU_in1;
    assign in2 = (~IDEX_ALUSrc2 && MEMWB_Memory_Read && MEMWB_Write_register 
        && MEMWB_Write_register == IDEX_Instruction[20:16])? MEMWB_MemBus_Read_Data:
        (~IDEX_ALUSrc2 && MEMWB_RegWrite && MEMWB_Write_register && (MEMWB_Write_register == IDEX_Instruction[20:16])
        && (EXMEM_Write_register != IDEX_Instruction[20:16] || ~EXMEM_RegWrite))? MEMWB_ALU_out://mind load-store
        (~IDEX_ALUSrc2 && EXMEM_RegWrite && EXMEM_Write_register
        && (EXMEM_Write_register == IDEX_Instruction[20:16]))? EXMEM_ALU_out: 
        ALU_in2;
    
    wire [32 -1:0] IDEX_Databus2_prevent_loadstore;
    assign IDEX_Databus2_prevent_loadstore = (IDEX_MemWrite && MEMWB_Write_register
        && (MEMWB_Write_register == IDEX_Instruction[20:16]))? MEMWB_MemBus_Read_Data:
        IDEX_Databus2;
    
	ALU alu1(
		.in1    (in1    ), 
		.in2    (in2    ), 
		.ALUCtl (IDEX_ALUCtl     ), 
		.Sign   (IDEX_Sign       ), 
		.out    (ALU_out    )
	);
	
    //--------------------------------------------------EX/MEM PLUGIN BEGIN ¡üEX---------------------------------------------------
    always @(posedge reset or posedge clk) begin
       if (reset) begin
            EXMEM_ALU_out <= 32'b0;
            EXMEM_Write_register <= 5'b0;
            //EXMEM_RegDst <= 2'b00;
            EXMEM_MemRead <= 1'b0;
            EXMEM_MemWrite <=1'b0;
            EXMEM_MemtoReg <= 2'b0;
            EXMEM_RegWrite <= 1'b0;
            EXMEM_Databus2 <= 32'b0;
            EXMEM_PC_plus_4 <= 32'b0;
            EXMEM_Instruction <= 32'b0;
       end
       else begin
            EXMEM_ALU_out <= ALU_out;//
            EXMEM_Write_register <= IDEX_Write_register;
            //EXMEM_RegDst <= IDEX_RegDst;
            EXMEM_MemRead <= IDEX_MemRead;//
            EXMEM_MemWrite <= IDEX_MemWrite;//
            EXMEM_MemtoReg <= IDEX_MemtoReg;//
            EXMEM_RegWrite <= IDEX_RegWrite;
            EXMEM_Databus2 <= IDEX_Databus2_prevent_loadstore;//
            EXMEM_PC_plus_4 <= IDEX_PC_plus_4;//
            EXMEM_Instruction <= IDEX_Instruction;
       end
    end
    
    //--------------------------------------------------EX/MEM PLUGIN END ¡ýMEM---------------------------------------------------
	// Data Memory
	wire [32 -1:0] Memory_Read_Data ;//reg [32 -1:0] MEMWB_Memory_Read_Data;
	wire           Memory_Read      ;
	wire           Memory_Write     ;
	wire [31:0] MemBus_Address;
    wire [31:0] MemBus_Write_Data;
	wire [32 -1:0] MemBus_Read_Data ;
	//reg [5 -1:0] MEMWB_Write_register;
	//reg [2 -1:0] MEMWB_RegDst;
	reg [2 -1:0] MEMWB_MemtoReg;
	//reg          MEMWB_RegWrite;
	
	reg [32 -1:0] MEMWB_PC_plus_4;
    
	DataMemory data_memory1(
		.reset      (reset              ), 
		.clk        (clk                ),
		//.clk_1       (clk_1               ), 
		.MemRead    (Memory_Read        ), 
        .MemWrite   (Memory_Write       ),
		.Address    (MemBus_Address     ), 
		.Write_data (MemBus_Write_Data  ), 
		.Read_data  (Memory_Read_Data   ), //out
		.done(done),
		.digi(digi)
	);
	
	assign Memory_Read          = EXMEM_MemRead ;
	assign Memory_Write         = EXMEM_MemWrite;//
	assign MemBus_Address       = EXMEM_ALU_out ;//
	assign MemBus_Write_Data    = (Memory_Write && MEMWB_Write_register 
	                               && (MEMWB_Write_register == EXMEM_Instruction[20:16]))? Databus3
	                               :EXMEM_Databus2;//for load-store special case:lw s1,x;sw s1,s1
	assign MemBus_Read_Data     = Memory_Read_Data;
	
    //--------------------------------------------------MEM/WB PLUGIN BEGIN ¡üMEM---------------------------------------------------
    always @(posedge reset or posedge clk) begin
       if (reset) begin
          //MEMWB_Memory_Read_Data <= 32'b0;
          MEMWB_Write_register <= 5'b0;
          //MEMWB_RegDst <= 2'b0;
          MEMWB_MemtoReg <= 2'b0;
          MEMWB_RegWrite <= 1'b0;
          MEMWB_ALU_out <= 32'b0;
          MEMWB_MemBus_Read_Data <= 32'b0; //MDR
          MEMWB_PC_plus_4 <= 32'b0;
          MEMWB_Memory_Read <= 1'b0;
       end
       else begin
          //MEMWB_Memory_Read_Data <= Memory_Read_Data;
          MEMWB_Write_register <= EXMEM_Write_register;
          //MEMWB_RegDst <= EXMEM_RegDst;
          MEMWB_MemtoReg <= EXMEM_MemtoReg;
          MEMWB_RegWrite <= EXMEM_RegWrite;
          MEMWB_ALU_out <= EXMEM_ALU_out;
          MEMWB_MemBus_Read_Data <= MemBus_Read_Data;
          MEMWB_PC_plus_4 <= EXMEM_PC_plus_4;
          MEMWB_Memory_Read <= Memory_Read;
       end
    end
    
    //--------------------------------------------------MEMWB PLUGIN END ¡ýWB---------------------------------------------------
	// write back
	assign Databus3 = (MEMWB_MemtoReg == 2'b00)? MEMWB_ALU_out: (MEMWB_MemtoReg == 2'b01)? MEMWB_MemBus_Read_Data: MEMWB_PC_plus_4;
	
endmodule
