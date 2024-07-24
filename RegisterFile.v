
module RegisterFile(
	input  reset                    , 
	(* DONT_TOUCH = "1" *)input  clk                      ,
	input  RegWrite                 ,
	input  [5 -1:0]  Read_register1 , 
	input  [5 -1:0]  Read_register2 , 
	input  [5 -1:0]  Write_register ,
	input  [32 -1:0] Write_data     ,
	output [32 -1:0] Read_data1     , 
	output [32 -1:0] Read_data2
);

	// RF_data is an array of 32 32-bit registers
	// here RF_data[0] is not defined because RF_data[0] identically equal to 0
	reg [31:0] RF_data[31:1];
    assign Read_data1 = (Read_register1 == 5'b00000)? 32'h00000000: RF_data[Read_register1];
    assign Read_data2 = (Read_register2 == 5'b00000)? 32'h00000000: RF_data[Read_register2];
        // read data from RF_data as Read_data1 and Read_data2
         
        
         integer i;
         always @(posedge reset or posedge clk) begin
           if (reset)
                   begin
                       for (i = 1; i < 32; i = i + 1)
                       begin
                           RF_data[i] <= 32'h00000000;
                       end
                   end
               else begin
               if (RegWrite && (Write_register != 5'b00000))
                           RF_data[Write_register] = Write_data;//first write
           end
           end

endmodule
			