`include "smolmulti.v"
`timescale 1ns/1ps

`define ASSERT_EQ(val, exp, msg) \
if (val !== exp) $display("[FAIL] %s (got:b%b expected:b%b)", msg, val, exp);

module testSmolMulti();
   reg MOSI;
   reg SCLK;
   reg CLK;
   reg CS;
   wire MISO;
   reg 	passed =0;

   initial CLK=0;
   always #10 CLK = !CLK;

   initial SCLK =0;
   always #200 SCLK=!SCLK;

   SmolBoi multismol(.MOSI(MOSI),.SCLK(SCLK),.CLK(CLK),.CS(CS),.MISO(MISO));

   initial begin
			CS<=0;
   end

   initial begin
      $dumpfile("smolmulti.vcd");
      $dumpvars();
			@(posedge SCLK);
			CS<=1;
			#400
			// Input A: 0001
			MOSI = 1'b0; #400
			MOSI = 1'b0; #400
			MOSI = 1'b0; #400
			MOSI = 1'b1; #400

			// Input B: 0110
			MOSI = 1'b0; #400
			MOSI = 1'b1; #400
			MOSI = 1'b1; #400
			MOSI = 1'b0; #400
 #10000
				 $display("MISO : %b", MISO); #400
				 $display("MISO : %b", MISO); #400
				 $display("MISO : %b", MISO); #400
				 $display("MISO : %b", MISO); #400
				 $display("MISO : %b", MISO); #400
				 $display("MISO : %b", MISO); #400
				 $display("MISO : %b", MISO); #400
				 $display("MISO : %b", MISO); #400
			// `ASSERT_EQ(MISO, 1'b0, "Failed"); #200
			@(posedge SCLK);
			if(MISO !== 0) begin
				 $display("Failed, little boy: 1.");
				 passed = 1;
				 // $finish;
			end
							 $display("MISO : %b", MISO);

			@(posedge SCLK);
			if(MISO !== 0) begin
				 $display("Failed, little boy: 2.");
				 passed = 1;
				 // $finish;
			end
							 $display("MISO : %b", MISO);
			@(posedge SCLK);
			if(MISO !== 0) begin
				 $display("Failed, little boy: 3.");
				 passed = 1;
				 // $finish;
			end
							 $display("MISO : %b", MISO);
			@(posedge SCLK);

			if(MISO !== 0) begin
				 $display("Failed, little boy: 4.");
				 passed = 1;
				 // $finish;
			end
							 $display("MISO : %b", MISO);
			@(posedge SCLK);

			if(MISO !== 0) begin
				 $display("Failed, little boy: 5.");
				 passed = 1;
				 // $finish;
			end
							 $display("MISO : %b", MISO);
			@(posedge SCLK);

			if(MISO !== 1) begin
				 $display("Failed, little boy: 6.");
				 $display("Expected MISO : 1");
				 passed = 1;
				 // $finish;
			end
							 $display("MISO : %b", MISO);
			@(posedge SCLK);

			if(MISO !== 1) begin
				 $display("Failed, little boy: 7.");
				 passed = 1;
				 // $finish;
			end
							 $display("MISO : %b", MISO);
			@(posedge SCLK);

			if(MISO !== 0) begin
				 $display("Failed, little boy: 8.");
				 passed = 1;
				 // $finish;
			end
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
			#20 $finish;
   end
endmodule
