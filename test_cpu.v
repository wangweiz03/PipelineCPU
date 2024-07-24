module test_cpu();
	
	reg reset   ;
	reg clk     ;

	reg [4 -1:0] sel;
    reg [7 -1:0] leds;
    reg done;
	
	CPU cpu1(  
		.reset              (reset              ), 
		.clkorig                (clk              ), 
		.sel(sel),
		.leds(leds),
		.done(done)
	);
	
	initial begin
		reset   = 1;
		clk     = 1;
		#100 reset = 0;
	end
	
	always #50 clk = ~clk;
		
endmodule
