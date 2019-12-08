`timescale 1ns / 1ps

`include "multiplexer.v"

// Uncomment the `define below to enable dumping waveform traces for debugging
`define DUMP_WAVEFORM

// Macro for testing equality, prints 'msg' if val and exp are not equal
// You could also use a Verilog task for this: http://verilog.renerta.com/source/vrg00050.htm
`define ASSERT_EQ(val, exp, msg) \
  if (val !== exp) $display("[FAIL] %s (got:b%b expected:b%b)", msg, val, exp);


module test_multiplexer();


  wire [7:0] Tout;
  reg Taddress;
  reg [7:0] in0,in1;
  reg [7:0] c;

  mux8to1by8 dut(.out(Tout),
                  .address(Taddress),
                  .input0(in0),
                  .input1(in1));


  integer i;
  // Test sequence
  initial begin
    // Optionally dump waveform traces for debugging
    $dumpfile("mutli.vcd");
    $dumpvars();

    for(i=0;i<16;i=i+1) begin
      assign c = $unsigned(i);
      in0=8'b0;in1=c;Taddress=1;#20
      $display(" %b |   %b |  %b  |   %b ", Taddress, in0, in1, Tout);
    end

    for(i=0;i<16;i=i+1) begin
      assign c = $unsigned(i);
      in0=8'b0;in1=c;Taddress=0; #20
      $display(" %b |   %b |  %b  |   %b ", Taddress, in0, in1, Tout);
    end
		 $display("All tests done.");

    #20 $finish();  // End the simulation (otherwise the clock will keep running forever)
  end

endmodule
