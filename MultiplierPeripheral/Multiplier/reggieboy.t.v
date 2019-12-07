`timescale 1ns / 1ps

`include "reggieboy.v"

// Uncomment the `define below to enable dumping waveform traces for debugging
`define DUMP_WAVEFORM

// Macro for testing equality, prints 'msg' if val and exp are not equal
// You could also use a Verilog task for this: http://verilog.renerta.com/source/vrg00050.htm
`define ASSERT_EQ(val, exp, msg) \
  if (val !== exp) $display("[FAIL] %s (got:b%b expected:b%b)", msg, val, exp);


module test_shiftreg();
   localparam W=8;

   wire [W-1:0] q;
   reg 					clk;
   reg [W-1:0] 	d;
   reg 					wr;
	 reg [W-1:0] 	c;

   register8 #(.width(W)) dut(.q(q),
                              .clk(clk),
                              .d(d),
                              .wrenable(wr));

   // Generate (infinite) clock
   initial clk=0;
   always #10 clk = !clk;

	 integer 			i;

   // Test sequence
   initial begin
			// Optionally dump waveform traces for debugging
`ifdef DUMP_WAVEFORM
      $dumpfile("shiftreg.vcd");
      $dumpvars();
`endif

			for(i=0;i<16;i=i+1) begin
				 assign c = $unsigned(i);
				 d=c;wr=1'b1; #20
					 $display(" %b |   %b |  %b", wr, d, q);
			end

			$display("All tests done.");

			#20 $finish();
   end

endmodule
