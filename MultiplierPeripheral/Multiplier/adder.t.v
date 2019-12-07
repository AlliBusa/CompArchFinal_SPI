`timescale 1ns / 1ps
`include "adder.v"


`define ASSERT_EQ(val, exp, msg) \
  if (val !== exp) $display("[FAIL] %s (got:0b%b expected:0b%b)", msg, val, exp);

  module test_adder();

  wire[7:0] output_test;
  reg[7:0] in0_test;
  reg[7:0] in1_test;


  adder dut(.out(output_test),
            .in0(in0_test),
            .in1(in1_test));

    // Test sequence

    initial begin
    `ifdef DUMP_WAVEFORM
      $dumpfile("shiftreg.vcd");
      $dumpvars();
    `endif

//    for(i=0;i<16;i=i+1) begin
//      for(j=0;j<16;j=j+1) begin
//        in0_test = i;in1_test=j;#1
//        assign c = $unsigned(i)+$unsigned(j);
//        `ASSERT_EQ(output_test,c, "Adder Doesn't Work");
//        end
//    end
    $display("Mod 4 Test Case");
    // TEST 1 : MOD 4
    in0_test = 8'b0100;in1_test=8'b0001;#1
    $display("%b <-- A\n%b <- B\n%b <-- S \n%b <-- S Expected",in0_test,in1_test,output_test,in0_test+in1_test);
    $display("Mod 8 Test Case");
    // TEST 2 : MOD 8
    in0_test = 8'b1000;in1_test=8'b0100;#1
    $display("%b <-- A\n%b <- B\n%b <-- S \n%b <-- S Expected",in0_test,in1_test,output_test,in0_test+in1_test);
    #20 $finish();  // End the simulation (otherwise the clock will keep running forever)
    end

  endmodule
