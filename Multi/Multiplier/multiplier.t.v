//`timescale 1ns / 1ps
`include "multiplier.v"


`define ASSERT_EQ(val, exp, msg) \
  if (val !== exp) $display("[FAIL] %s (got:0b%b expected:0b%b)", msg, val, exp);

  module test_multiplier();
    localparam W = 4;

    wire [2*W-1:0] hillman;
    wire done1;
    reg clk;
    reg [W-1:0] A,B;
    reg start;
    reg[2*W-1:0] c;
    reg passed = 1;

    multiplier #(.width(W)) dut(.res(hillman),
                   .clk(clk),
                   .A(A),
                   .B(B),
                   .done(done1),
                   .start(start));

    // Generate (infinite) clock
    initial clk=0;
    always #40 clk = !clk;
    // Test sequence
    integer i,j;
    initial begin
        $dumpfile("multiplier.vcd");
        $dumpvars();
      for(i=0;i<(2**W);i=i+1) begin
        for(j=0;j<(2**W);j=j+1) begin
          @(posedge clk);
          start=1;A=$unsigned(i);B=$unsigned(j);
          //$display("Check if start is 1: %b", start);
          @(posedge clk); start=0;
          //$display("Start: %b, Done: %b", start, done1);
          //@(done1 == 0); begin
          //$display("res: %b, done: %b", hillman, done1);
          //end
          @(done1); begin
            assign c = $unsigned(i)*$unsigned(j);
            //$display("c:%b i:%b j:%b",c,i,j);
            `ASSERT_EQ(hillman, c, "Failed")
            if (hillman!==c) passed =0;
          end
        end
      end
      if(passed) $display("All Tests Passeed");

      #20 $finish();  // End the simulation (otherwise the clock will keep running forever)
    end

  endmodule
