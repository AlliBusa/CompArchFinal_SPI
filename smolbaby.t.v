`include "Multi/smolmulti.v"
`include "Memory/smolboi.v"

`define ASSERT_EQ(val, exp, msg) \
if (val !== exp) $display("[FAIL] %s (got:b%b expected:b%b)", msg, val, exp);

module testSmolMulti();
   reg MOSI;
   reg SCLK;
   reg CLK;
   reg multCS, memCS;
   wire multMISO, memMISO;
   reg 	passed =0;
	 reg 	rc0,rc1,rc2,rc3,rc4,rc5,rc6,rc7;
	 reg 	sc0,sc1,sc2,sc3,sc4,sc5,sc6,sc7;

   initial CLK=0;
   always #10 CLK = !CLK;

   initial SCLK =0;
   always #100 SCLK=!SCLK;

   SmolMulti multismol(.MOSI(MOSI),.SCLK(SCLK),.CLK(CLK),.CS(multCS),.MISO(multMISO));
   SmolBoi smolboi(.MOSI(MOSI),.SCLK(SCLK),.CLK(CLK),.CS(memCS),.MISO(memMISO));

   initial begin
      $dumpfile("bb.vcd");
      $dumpvars();
			multCS<=0;
			memCS<=1;
			@(posedge SCLK);
			multCS<=1;
			@(posedge SCLK);
			// Input A: 0001
			MOSI = 1'b0;
      @(posedge SCLK);
			MOSI = 1'b1;
      @(posedge SCLK);
			MOSI = 1'b0;
      @(posedge SCLK);
			MOSI = 1'b0;

			// Input B: 0110
      @(posedge SCLK);
			MOSI = 1'b0;
      @(posedge SCLK);
			MOSI = 1'b1;
      @(posedge SCLK);
			MOSI = 1'b1;
      @(posedge SCLK);
			MOSI = 1'b0;

			// `ASSERT_EQ(MISO, 1'b0, "Failed"); #200
			@(posedge SCLK);
      @(posedge SCLK);
      @(posedge SCLK);
			@(posedge SCLK);
      @(posedge SCLK);
			$display("Multi test");
			if(multMISO !== 0) begin
				 $display("Failed, little boy: 1.");
         $display("MISO : %b", multMISO);
				 passed = 1;
				 $finish;
			end
			rc0=multMISO;


			@(posedge SCLK);
			if(multMISO !== 0) begin
				 $display("Failed, little boy: 2.");
				 passed = 1;
				 $finish;
			end
			rc1=multMISO;
			$display("MISO : %b", multMISO);
			@(posedge SCLK);
			if(multMISO !== 0) begin
				 $display("Failed, little boy: 3.");
				 passed = 1;
				 $finish;
			end
			rc2=multMISO;
			$display("MISO : %b", multMISO);
			@(posedge SCLK);

			if(multMISO !== 1) begin
				 $display("Failed, little boy: 4.");
				 passed = 1;
				 $finish;
			end
			rc3=multMISO;
			$display("MISO : %b", multMISO);
			@(posedge SCLK);

			if(multMISO !== 1) begin
				 $display("Failed, little boy: 5.");
				 passed = 1;
				 $finish;
			end
			rc4=multMISO;
			$display("MISO : %b", multMISO);
			@(posedge SCLK);

			if(multMISO !== 0) begin
				 $display("Failed, little boy: 6.");
				 $display("Expected MISO : 1");
				 passed = 1;
				 $finish;
			end
			rc5=multMISO;
			$display("MISO : %b", multMISO);
			@(posedge SCLK);

			if(multMISO !== 0) begin
				 $display("Failed, little boy: 7.");
				 passed = 1;
				 $finish;
			end
			rc6=multMISO;
			$display("MISO : %b", multMISO);
			@(posedge SCLK);

			if(multMISO !== 0) begin
				 $display("Failed, little boy: 8.");
				 passed = 1;
				 $finish;
			end
			rc7=multMISO;
			$display("MISO : %b", multMISO);

			if (passed) $display("Failed.");
			$display("Input to multiplier: A = 0001, B = 0110");
			$display("Result of multiplier: %b%b%b%b%b%b%b%b", rc0,rc1,rc2,rc3,rc4,rc5,rc6,rc7);
			multCS <= 0;

			@(posedge SCLK);
			memCS = 0;
			MOSI = 1'b0;
			@(posedge SCLK);
			MOSI = 1'b1;
			@(posedge SCLK);
			MOSI = 1'b0;
			@(posedge SCLK);
			MOSI = 1'b1;
			@(posedge SCLK);
			MOSI = 1'b0;
			@(posedge SCLK);
			MOSI = 1'b1;
			@(posedge SCLK);
			MOSI = 1'b0;
			@(posedge SCLK);
			MOSI = 1'b1;
			@(posedge SCLK);
			@(posedge SCLK);

			// Input number: 00110011
			MOSI = rc0;
			@(posedge SCLK);
			MOSI = rc1;
			@(posedge SCLK);
			MOSI = rc2;
			@(posedge SCLK);
			MOSI = rc3;
			@(posedge SCLK);
			MOSI = rc4;
			@(posedge SCLK);
			MOSI = rc5;
			@(posedge SCLK);
			MOSI = rc6;
			@(posedge SCLK);
			MOSI = rc7;
			@(posedge SCLK);
			@(posedge SCLK);

			// Input addr: 1(RW) + 1010101
			MOSI = 1'b1;
			@(posedge SCLK);
			MOSI = 1'b1;
			@(posedge SCLK);
			MOSI = 1'b0;
			@(posedge SCLK);
			MOSI = 1'b1;
			@(posedge SCLK);
			MOSI = 1'b0;
			@(posedge SCLK);
			MOSI = 1'b1;
			@(posedge SCLK);
			MOSI = 1'b0;
			@(posedge SCLK);
			MOSI = 1'b1;
			@(posedge SCLK);
			@(posedge SCLK);
			@(posedge SCLK);

			@(posedge SCLK);
			if(memMISO !== rc0) begin
				 $display("Failed, little boy: 0.");
				 $display("MISO: %b", memMISO);
				 passed = 1;
				 $finish;
			end
			sc0=memMISO;
			$display("MISO: %b", memMISO);

		  @(posedge SCLK);
			if(memMISO !== rc1) begin
				 $display("Failed, little boy: 1.");
				 $display("MISO: %b", memMISO);
				 passed = 1;
				 // $finish;
			end
			sc1=memMISO;
			$display("MISO: %b", memMISO);

			@(posedge SCLK);
			if(memMISO !== rc2) begin
				 $display("Failed, little boy: 2.");
				 $display("MISO: %b", memMISO);
				 passed = 1;
				 // $finish;
			end
			sc2=memMISO;
			$display("MISO: %b", memMISO);

			@(posedge SCLK);
			if(memMISO !== rc3) begin
				 $display("Failed, little boy: 3.");
				 $display("MISO: %b", memMISO);
				 passed = 1;
				 // $finish;
			end
			sc3=memMISO;
			$display("MISO: %b", memMISO);

			@(posedge SCLK);
			if(memMISO !== rc4) begin
				 $display("Failed, little boy: 4.");
				 $display("MISO: %b", memMISO);
				 passed = 1;
				 // $finish;
			end
			sc4=memMISO;
			$display("MISO: %b", memMISO);

			@(posedge SCLK);
			if(memMISO !== rc5) begin
				 $display("Failed, little boy: 5.");
				 $display("MISO: %b", memMISO);
				 passed = 1;
				 // $finish;
			end
			sc5=memMISO;
			$display("MISO: %b", memMISO);

			@(posedge SCLK);
			if(memMISO !== rc6) begin
				 $display("Failed, little boy: 6.");
				 $display("MISO: %b", memMISO);
				 passed = 1;
				 // $finish;
			end
			sc6=memMISO;
			$display("MISO: %b", memMISO);

			@(posedge SCLK);
			if(memMISO !== rc7) begin
				 $display("Failed, little boy: 7.");
				 $display("MISO: %b", memMISO);
				 passed = 1;
				 // $finish;
			end
			sc7=memMISO;
			$display("MISO: %b", memMISO);
			$display("What's stored in memory: %b%b%b%b%b%b%b%b",sc0,sc1,sc2,sc3,sc4,sc5,sc6,sc7);

			if (passed) $display("Failed.");
			else $display("Passed!");
			#20 $finish;
   end
endmodule
