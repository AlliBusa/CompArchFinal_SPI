`include "fsm.v"

`define ASSERT_EQ(val, exp, msg) \
  if (val !== exp) $display("[FAIL] %s (got:b%b expected:b%b)", msg, val, exp);

module testFSM();
  reg cs;
  reg done;
  reg sclk;
  reg clk;

  reg [1:0] mode;
  reg start;
  reg misobuffCNTL;

  FSMult dut (.cs(cs),
              .done(done),
              .sclk(sclk),
              .clk(clk),
              .mode(mode),
              .start(start),
              .misobuffCNTL(misobuffCNTL));

  // Generate clock
  initial clk=0;
  always #10 clk = !clk;

  // Generate sclk
  initial sclk=0;
  always #200 sclk = !sclk;

  initial begin
  cs <= 0;
  done <= 0;
  end

  initial begin
  $dumpfile("shiftreg-dump.vcd");
  $dumpvars();
  $display("Truth table test of the Shift Register");

  // test 1
  @(posedge sclk);
    cs <= 1;
  @(negedge sclk);
  // check that the state shifted
  `ASSERT_EQ(actualstate, `LOAD, "state shift WAIT>LOAD failed")

  // test 2
  #1600
  @(negedge sclk);
  // check that the state shifted
  `ASSERT_EQ(actualstate, `MULT, "state shift LOAD>MULTI failed")

  // test 3
  @(negedge sclk);
  // check that the state shifted
  `ASSERT_EQ(actualstate, `MULTRES, "state shift MULTI>MULTRES failed")

  // test 4
  #1600
  @(negedge sclk);
  // check that the state shifted
  `ASSERT_EQ(actualstate, `MISORESULT, "state shift MULTRES>MISORESULT failed")

  $finish();


  end

  endmodule
