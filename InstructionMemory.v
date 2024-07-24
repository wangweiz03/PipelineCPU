module InstructionMemory(
	input      [32 -1:0] Address, 
	output reg [32 -1:0] Instruction
);
	
	always @(*)
		case (Address[9:2])
                
       8'd0:     Instruction <= 32'h00002821;
                       8'd1:    Instruction <= 32'h20a40004;
                       8'd2:    Instruction <= 32'h8ca50000;
                       8'd3:    Instruction <= 32'h0c10006d;
                       
                       8'd4:    Instruction <= 32'h20a50001;
                       8'd5:    Instruction <= 32'h00052880;
                       8'd6:    Instruction <= 32'h20160001;
                       8'd7:    Instruction <= 32'hacb60000;
                       
                       8'd8:    Instruction <= 32'h20a50004;
                       8'd9:    Instruction <= 32'h3c104000;
                       8'd10:    Instruction <= 32'h22100010;
                       8'd11:    Instruction <= 32'h20090050;//50´ÎÇÐ»»
                       
                       8'd12:    Instruction <= 32'h8cb10000;
                       8'd13:    Instruction <= 32'h00004020;
                       8'd14:    Instruction <= 32'h3232000f;//andi
                       8'd15:    Instruction <= 32'h21080001;
                       
                       8'd16:    Instruction <= 32'h0c10002d;
                       8'd17:    Instruction <= 32'h22730100;
                       8'd18:    Instruction <= 32'hae130000;
                       8'd19:    Instruction <= 32'h1509fffa;
                       
                       8'd20:    Instruction <= 32'h00004020;
                       8'd21:    Instruction <= 32'h323200f0;//andi
                       8'd22:    Instruction <= 32'h21080001;
                       8'd23:    Instruction <= 32'h00129102;
                       
                       8'd24:    Instruction <= 32'h0c10002d;
                       8'd25:    Instruction <= 32'h22730200;
                       8'd26:    Instruction <= 32'hae130000;
                       8'd27:    Instruction <= 32'h1509fff9;
                       
                       8'd28:    Instruction <= 32'h00004020;
                       8'd29:    Instruction <= 32'h32320f00;//andi
                       8'd30:    Instruction <= 32'h21080001;
                       8'd31:    Instruction <= 32'h00129202;
                       
                       8'd32:    Instruction <= 32'h0c10002d;
                       8'd33:    Instruction <= 32'h22730400;
                       8'd34:    Instruction <= 32'hae130000;
                       8'd35:    Instruction <= 32'h1509fff9;
                       
                       8'd36:    Instruction <= 32'h00004020;
                       8'd37:    Instruction <= 32'h3232f000;//andi
                       8'd38:    Instruction <= 32'h21080001;
                       8'd39:    Instruction <= 32'h00129302;
                       
                       8'd40:    Instruction <= 32'h0c10002d;
                       8'd41:    Instruction <= 32'h22730800;
                       8'd42:    Instruction <= 32'hae130000;
                       8'd43:    Instruction <= 32'h1509fff9;
                       
                       8'd44:    Instruction <= 32'h0810000c;
                       8'd45:    Instruction <= 32'h2001000f;
                       8'd46:    Instruction <= 32'h1032001e;
                       8'd47:    Instruction <= 32'h2001000e;
                       
                       8'd48:    Instruction <= 32'h1032001e;
                       8'd49:    Instruction <= 32'h2001000d;
                       8'd50:    Instruction <= 32'h1032001e;
                       8'd51:    Instruction <= 32'h2001000c;
                       
                       8'd52:    Instruction <= 32'h1032001e;
                       8'd53:    Instruction <= 32'h2001000b;
                       8'd54:    Instruction <= 32'h1032001e;
                       8'd55:    Instruction <= 32'h2001000a;
                       
                       8'd56:    Instruction <= 32'h1032001e;
                       8'd57:    Instruction <= 32'h20010009;
                       8'd58:    Instruction <= 32'h1032001e;
                       8'd59:    Instruction <= 32'h20010008;
                       
                       8'd60:    Instruction <= 32'h1032001e;
                       8'd61:    Instruction <= 32'h20010007;
                       8'd62:    Instruction <= 32'h1032001e;
                       8'd63:    Instruction <= 32'h20010006;
                       
                       8'd64:    Instruction <= 32'h1032001e;
                       8'd65:    Instruction <= 32'h20010005;
                       8'd66:    Instruction <= 32'h1032001e;
                       8'd67:    Instruction <= 32'h20010004;
                       
                       8'd68:    Instruction <= 32'h1032001e;
                       8'd69:    Instruction <= 32'h20010003;
                       8'd70:    Instruction <= 32'h1032001e;
                       8'd71:    Instruction <= 32'h20010002;
                       
                       8'd72:    Instruction <= 32'h1032001e;
                       8'd73:    Instruction <= 32'h20010001;
                       8'd74:    Instruction <= 32'h1032001e;
                       8'd75:    Instruction <= 32'h20010000;
                       
                       8'd76:    Instruction <= 32'h1032001e;
                       8'd77:    Instruction <= 32'h20130071;
                       8'd78:    Instruction <= 32'h03e00008;
                       8'd79:    Instruction <= 32'h20130079;
                       
                       8'd80:    Instruction <= 32'h03e00008;
                       8'd81:    Instruction <= 32'h2013005e;
                       8'd82:    Instruction <= 32'h03e00008;
                       8'd83:    Instruction <= 32'h20130039;
                       
                       8'd84:    Instruction <= 32'h03e00008;
                       8'd85:    Instruction <= 32'h2013007c;
                       8'd86:    Instruction <= 32'h03e00008;
                       8'd87:    Instruction <= 32'h20130077;
                       
                       8'd88:    Instruction <= 32'h03e00008;
                       8'd89:    Instruction <= 32'h2013006f;
                       8'd90:    Instruction <= 32'h03e00008;
                       8'd91:    Instruction <= 32'h2013007f;
                       
                       8'd92:    Instruction <= 32'h03e00008;
                       8'd93:    Instruction <= 32'h20130007;
                       8'd94:    Instruction <= 32'h03e00008;
                       8'd95:    Instruction <= 32'h2013007d;
                       
                       8'd96:    Instruction <= 32'h03e00008;
                       8'd97:    Instruction <= 32'h2013006d;
                       8'd98:    Instruction <= 32'h03e00008;
                       8'd99:    Instruction <= 32'h20130066;
                       
                       8'd100:    Instruction <= 32'h03e00008;
                       8'd101:    Instruction <= 32'h2013004f;
                       8'd102:    Instruction <= 32'h03e00008;
                       8'd103:    Instruction <= 32'h2013005b;
                       
                       8'd104:    Instruction <= 32'h03e00008;
                       8'd105:    Instruction <= 32'h20130006;
                       8'd106:    Instruction <= 32'h03e00008;
                       8'd107:    Instruction <= 32'h2013003f;
                       
                       8'd108:    Instruction <= 32'h03e00008;
                       
                       
                       8'd109:    Instruction <= 32'h20010004;
                       8'd110:    Instruction <= 32'h03a1e822;
                       8'd111:    Instruction <= 32'hafbf0000;
                       8'd112:    Instruction <= 32'h20060001;
                       
                       8'd113:    Instruction <= 32'h0c10007a;
                       8'd114:    Instruction <= 32'h0c100096;//
                       8'd115:    Instruction <= 32'h20c60001;
                       8'd116:    Instruction <= 32'h14c5fffc;
                       
                       8'd117:    Instruction <= 32'h8fbf0000;
                       8'd118:    Instruction <= 32'h23bd0004;
                       
                       8'd119:    Instruction <= 32'h00000000;
                       8'd120:    Instruction <= 32'h00000000;
                       
                       8'd121:    Instruction <= 32'h03e00008;
                       8'd122:    Instruction <= 32'h20010004;
                       
                       8'd123:    Instruction <= 32'h03a1e822;
                       8'd124:    Instruction <= 32'hafbf0000;
                       8'd125:    Instruction <= 32'h00068880;
                       8'd126:    Instruction <= 32'h00918821;
                       
                       8'd127:    Instruction <= 32'h8e280000;
                       8'd128:    Instruction <= 32'h20010001;
                       8'd129:    Instruction <= 32'h00c19022;
                       
                       8'd130:    Instruction <= 32'h00128880;
                       8'd131:    Instruction <= 32'h00918821;
                       8'd132:    Instruction <= 32'h8e290000;
                       
                       8'd133:    Instruction <= 32'h00000000;
                       8'd134:    Instruction <= 32'h00000000;
                       8'd135:    Instruction <= 32'h00000000;
                       
                       8'd136:    Instruction <= 32'h11280007;
                       
                       8'd137:    Instruction <= 32'h0128502a;
                       8'd138:    Instruction <= 32'h20010001;
                       8'd139:    Instruction <= 32'h102a0004;
                       8'd140:    Instruction <= 32'h20010001;
                       
                       8'd141:    Instruction <= 32'h02419022;
                       8'd142:    Instruction <= 32'h2001ffff;
                       8'd143:    Instruction <= 32'h1432fff2;
                       8'd144:    Instruction <= 32'h22470001;
                       
                       8'd145:    Instruction <= 32'h8fbf0000;
                       8'd146:    Instruction <= 32'h23bd0004;
                       
                       8'd147:    Instruction <= 32'h00000000;
                       8'd148:    Instruction <= 32'h00000000;
                       
                       8'd149:    Instruction <= 32'h03e00008;
                       8'd150:    Instruction <= 32'h20010004;
                       
                       8'd151:    Instruction <= 32'h03a1e822;
                       8'd152:    Instruction <= 32'hafbf0000;
                       8'd153:    Instruction <= 32'h00068880;
                       8'd154:    Instruction <= 32'h00918821;
                       
                       8'd155:    Instruction <= 32'h8e280000;
                       8'd156:    Instruction <= 32'h20010001;
                       8'd157:    Instruction <= 32'h00c19022;
                       8'd158:    Instruction <= 32'h00128880;
                       
                       8'd159:    Instruction <= 32'h00918821;
                       8'd160:    Instruction <= 32'h8e2b0000;
                       8'd161:    Instruction <= 32'h22310004;
                       8'd162:    Instruction <= 32'hae2b0000;
                       8'd163:    Instruction <= 32'h0247602a;
                       
                       8'd164:    Instruction <= 32'h20010001;
                       8'd165:    Instruction <= 32'h02419022;
                       
                       8'd166:    Instruction <= 32'h20010001;
                       
                       8'd167:    Instruction <= 32'h102c0004;
                       
                       8'd168:    Instruction <= 32'h00000000;
                       
                       8'd169:    Instruction <= 32'h1247fff4;
                       
                       8'd170:    Instruction <= 32'h00000000;
                       
                       8'd171:    Instruction <= 32'h1647fff2;
                       
                       8'd172:    Instruction <= 32'h00078880;
                       
                       8'd173:    Instruction <= 32'h00918821;
                       8'd174:    Instruction <= 32'hae280000;
                       8'd175:    Instruction <= 32'h8fbf0000;
                       8'd176:    Instruction <= 32'h23bd0004;
                       
                       8'd177:    Instruction <= 32'h00000000;
                       8'd178:    Instruction <= 32'h00000000;
                       
                       8'd179:    Instruction <= 32'h03e00008;





        
            
			// -------- Paste Binary Instruction Above
			
			default: Instruction <= 32'h00000000;
		endcase
		
endmodule
