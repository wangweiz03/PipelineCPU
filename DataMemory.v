module DataMemory(//with extdatamemory
	input  reset    , 
	input  clk      ,  
	//input  clk_1    ,//
	input  MemRead  ,
	input  MemWrite ,
	input  [32 -1:0] Address    ,
	input  [32 -1:0] Write_data ,
	output [32 -1:0] Read_data  ,
	output done,
	output reg [11:0] digi//directly control bcd
);
    
	
	// RAM size is 256 words, each word is 32 bits, valid address is 8 bits
	parameter RAM_SIZE      = 256;
	parameter RAM_SIZE_BIT  = 8;
	
	// RAM_data is an array of 8 32-bit registers
	reg [31:0] RAM_data [RAM_SIZE - 1: 0];

    assign done = RAM_data[RAM_data[0]+1];
    
	// read data from RAM_data as Read_data [9:2]
	
	//digi's addr is 40000010,extmem
	assign Read_data = //special inst: lw 40000010
	       (MemRead)? RAM_data[Address[RAM_SIZE_BIT + 1:2]]: 32'h00000000;
	
	// write Write_data to RAM_data at clock posedge
	reg [16 -1:0] counting;//fetch data
	integer i;
	parameter Hz = 50000000;
	reg [32 -1:0] cHz;
	always @(posedge reset or posedge clk)begin
		if (reset) begin
            RAM_data[0] <= 32'h00000018; //numbers=24
            
            RAM_data[1] <= 32'h00000003; // Y0 = 3
            RAM_data[2] <= 32'h00000028; // X1 = 40
            RAM_data[3] <= 32'h00000024; // Y1 = 36
            RAM_data[4] <= 32'h0000020B; // X2 = 11
            RAM_data[5] <= 32'h00003406; // Y2 = 6
            RAM_data[6] <= 32'h00000A0A; // X3 = 10
            RAM_data[7] <= 32'h0000F03A; // Y3 = 58
            RAM_data[8] <= 32'h0000001B; // X0 = 27
            
            RAM_data[9] <= 32'h00000001; // Y0 = 1
            RAM_data[10] <= 32'h00009021; // X1 = 33
            RAM_data[11] <= 32'h00000216; // Y1 = 22
            RAM_data[12] <= 32'h00000072; // X2 = 114
            RAM_data[13] <= 32'h00000059; // Y2 = 89
            RAM_data[14] <= 32'h00000007; // X3 = 7
            RAM_data[15] <= 32'h000003E1; // Y3 = 225
            RAM_data[16] <= 32'h00000B40; // X0 = 64
            
            RAM_data[17] <= 32'h00000034; // Y0 = 52
            RAM_data[18] <= 32'h0000009F; // X1 = 159
            RAM_data[19] <= 32'h000000C8; // Y1 = 200
            RAM_data[20] <= 32'h0000000D; // X2 = 13
            RAM_data[21] <= 32'h000000B1; // Y2 = 177
            RAM_data[22] <= 32'h000000E9; // X3 = 233
            RAM_data[23] <= 32'h0000003a; // Y3 = 58
            RAM_data[24] <= 32'h0000001B; // X0 = 27
        
            for (i = 25; i < RAM_SIZE; i = i + 1)
                RAM_data[i] <= 32'h00000000;
            
            cHz <= 32'h00000000;
            counting <= 16'b1;
            
            digi <= 12'b0;
		end
		else begin
		  cHz <= (cHz == Hz-32'd1) ? 32'd0 : cHz + 32'd1;
		  if (MemWrite) begin
		    if(Address == 32'h40000010)
		        digi <= Write_data[11:0];//write into digi with address 40000010(sw 40000010)
		    else
			    RAM_data[Address[RAM_SIZE_BIT + 1:2]] <= Write_data;
		  end
		  else if (cHz == 32'd0 && done) begin
		    RAM_data[26] <= RAM_data[counting];//address 26 saves the current data,can be visited in mips, auto change
                 if (counting < RAM_data[0])
                      counting <= counting+16'b1;
                 else
                      counting <= 16'b1;
		  end
		end
	end
endmodule
