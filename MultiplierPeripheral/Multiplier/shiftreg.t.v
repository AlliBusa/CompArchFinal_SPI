`timescale 1ns / 1ps

`include "shiftreg.v"
`include "shiftregmodes.v"

// Uncomment the `define below to enable dumping waveform traces for debugging
//`define DUMP_WAVEFORM

// Macro for testing equality, prints 'msg' if val and exp are not equal
// You could also use a Verilog task for this: http://verilog.renerta.com/source/vrg00050.htm
`define ASSERT_EQ(val, exp, msg) \
  if (val !== exp) $display("[FAIL] %s (got:b%b expected:b%b)", msg, val, exp);


module test_shiftreg();
  localparam W = 4;

  wire [W-1:0] pOut;
  reg clk;
  reg [1:0] mode;
  reg [W-1:0] pIn;
  reg sIn;

  shiftregister #(.width(W)) dut(.parallelOut(pOut),
                                 .clk(clk),
                                 .mode(mode),
                                 .parallelIn(pIn),
                                 .serialIn(sIn));

  // Generate (infinite) clock
  initial clk=0;
  always #10 clk = !clk;

  // Test sequence
  initial begin
    // Optionally dump waveform traces for debugging
    `ifdef DUMP_WAVEFORM
      $dumpfile("shiftreg.vcd");
      $dumpvars();
    `endif

     // Test case 1: parallel load
     //   Input new values at the falling edge of the clock (for convenience,
     //   could be anywhere within the clock period before the rising edge)
     @(negedge clk);   // Wait for negedge of clock before proceeding
     mode=`PLOAD; sIn=1'bX; pIn=4'b1010;
     @(posedge clk); #1   // Wait for just after posedge to inspect results
			 `ASSERT_EQ(pOut, 4'b1010, "Initial parallel load");

     // Test case 2: right shift
     @(negedge clk);  mode=`RIGHT; sIn=1'b1; pIn=4'bX;
     @(posedge clk); #1  `ASSERT_EQ(pOut, 4'b1101, "First right shift")

     // Test case 3: left shift
		 @(negedge clk);  mode=`LEFT; sIn=1'b0; pIn=4'bX;
     @(posedge clk); #1  `ASSERT_EQ(pOut, 4'b1010, "Left shift")

		 // Test case 4: hold state
		 @(negedge clk);  mode=`HOLD; sIn=1'b1; pIn=4'bX;
     @(posedge clk); #1  `ASSERT_EQ(pOut, 4'b1010, "Hold state")

 		 // Test case 4: hold state
		 @(negedge clk);  mode=`PLOAD; sIn=1'b1; pIn=4'b0110;
     @(posedge clk); #1  `ASSERT_EQ(pOut, 4'b0110, "Hold state")

		 // Test case 4: hold state
		 @(negedge clk);  mode=`PLOAD; sIn=1'b1; pIn=4'b0110;
     @(posedge clk); #1  `ASSERT_EQ(pOut, 4'b0110, "Hold state")

		 $display("All tests done.");

    #20 $finish();  // End the simulation (otherwise the clock will keep running forever)
  end

endmodule
