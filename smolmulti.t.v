`include "Multi/smolmulti.v"
// `timescale 1ns/1ps

`define ASSERT_EQ(val, exp, msg) \
if (val !== exp) $display("[FAIL] %s (got:b%b expected:b%b)", msg, val, exp);

module testSmolMulti();
   reg MOSI;
   reg SCLK;
   reg CLK;
   reg CS;
   wire MISO;
   reg 	passed =0;
	 reg 	rc0,rc1,rc2,rc3,rc4,rc5,rc6,rc7;

   initial CLK=0;
   always #10 CLK = !CLK;

   initial SCLK =0;
   always #100 SCLK=!SCLK;

   SmolMulti multismol(.MOSI(MOSI),.SCLK(SCLK),.CLK(CLK),.CS(CS),.MISO(MISO));

   initial begin
			CS<=0;
   end

   initial begin
      $dumpfile("smolmulti.vcd");
      $dumpvars();
			@(posedge SCLK);
			CS<=1;
			@(posedge SCLK);
			// Input A: 0001
			MOSI = 1'b0;
      @(posedge SCLK);
			MOSI = 1'b0;
      @(posedge SCLK);
			MOSI = 1'b0;
      @(posedge SCLK);
			MOSI = 1'b1;

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
			if(MISO !== 0) begin
				 $display("Failed, little boy: 1.");
         $display("MISO : %b", MISO);
				 passed = 1;
				 $finish;
			end
			rc0=MISO;


			@(posedge SCLK);
			if(MISO !== 0) begin
				 $display("Failed, little boy: 2.");
				 passed = 1;
				 $finish;
			end
			rc1=MISO;
							 $display("MISO : %b", MISO);
			@(posedge SCLK);
			if(MISO !== 0) begin
				 $display("Failed, little boy: 3.");
				 passed = 1;
				 $finish;
			end
			rc2=MISO;
							 $display("MISO : %b", MISO);
			@(posedge SCLK);

			if(MISO !== 0) begin
				 $display("Failed, little boy: 4.");
				 passed = 1;
				 $finish;
			end
			rc3=MISO;
							 $display("MISO : %b", MISO);
			@(posedge SCLK);

			if(MISO !== 0) begin
				 $display("Failed, little boy: 5.");
				 passed = 1;
				 $finish;
			end
			rc4=MISO;
							 $display("MISO : %b", MISO);
			@(posedge SCLK);

			if(MISO !== 1) begin
				 $display("Failed, little boy: 6.");
				 $display("Expected MISO : 1");
				 passed = 1;
				 $finish;
			end
			rc5=MISO;
							 $display("MISO : %b", MISO);
			@(posedge SCLK);

			if(MISO !== 1) begin
				 $display("Failed, little boy: 7.");
				 passed = 1;
				 $finish;
			end
			rc6=MISO;
							 $display("MISO : %b", MISO);
			@(posedge SCLK);

			if(MISO !== 0) begin
				 $display("Failed, little boy: 8.");
				 passed = 1;
				 $finish;
			end
			rc7=MISO;
			$display("MISO : %b", MISO);
			#200
				// `ASSERT_EQ(MISO, 1'b0, "Failed"); #200
				// if(MISO == 1'b0)
				// `ASSERT_EQ(MISO, 1'b1, "Failed"); #200
				// `ASSERT_EQ(MISO, 1'b1, "Failed"); #200
				// `ASSERT_EQ(MISO, 1'b0, "Failed"); #200
				// `ASSERT_EQ(MISO, 1'b0, "Failed"); #200
				// `ASSERT_EQ(MISO, 1'b1, "Failed"); #200
				// `ASSERT_EQ(MISO, 1'b1, "Failed"); #200

				if (passed) $display("Failed.");
			$display("%b,%b,%b,%b,%b,%b,%b,%b", rc0,rc1,rc2,rc3,rc4,rc5,rc6,rc7);
			#20 $finish;
   end
endmodule
