//------------------------------------------------------------------------
// Shift Register test bench
//------------------------------------------------------------------------
`include "shiftregister.v"

`define ASSERT_EQ(val, exp, msg) \
  if (val !== exp) $display("[FAIL] %s (got:b%b expected:b%b)", msg, val, exp);

module tests9();

    reg             clk;
    reg             serialClkposedge;
    reg [1:0]       mode;
    wire[8:0]       parallelDataOut;
    wire            serialDataOut;
    reg[8:0]        parallelDataIn;
    reg             serialDataIn;

    // Instantiate with parameter width = 8
   shiftregister9 dut(.clk(clk),
    									.serialClkposedge(serialClkposedge),
    									.mode(mode),
    									.parallelIn(parallelDataIn),
    									.serialIn(serialDataIn),
    									.parallelOut(parallelDataOut),
    									.serialOut(serialDataOut));
 // Generate (infinite) clock
   initial clk=0;
   initial mode=00;
   always #10 clk = !clk;


    initial begin
    $dumpfile("shiftreg-dump.vcd");
    $dumpvars();
    $display("Truth table test of the Shift Register");

    // Test case 1: parallel load
   @(negedge clk);
   mode=`PLOAD; parallelDataIn = 0000000;
   @(posedge clk);
   serialClkposedge = 1;
   @(negedge clk);
   `ASSERT_EQ(parallelDataOut, 7'b0, "PLOAD failed")
   serialClkposedge = 0;
   // Test case 1.5: parallel load
  @(negedge clk);
  mode=`PLOAD; parallelDataIn = 7'b1111111;
  @(posedge clk);
  serialClkposedge = 1;
  @(negedge clk);
  `ASSERT_EQ(parallelDataOut, 7'b1111111, "PLOAD failed")
  serialClkposedge = 0;

  // Test case 1.5: parallel load
 @(negedge clk);
 mode=`PLOAD; parallelDataIn = 7'b1110111;
 @(posedge clk);
 serialClkposedge = 1;
  @(negedge clk);
 `ASSERT_EQ(parallelDataOut, 7'b1110111, "PLOAD failed")
  serialClkposedge = 0;

    // Test case 2: hold
  @(negedge clk);
    mode=`PLOAD; parallelDataIn = 7'd127; serialDataIn = 0;
    @(posedge clk);
    serialClkposedge = 1;
  @(negedge clk);
    mode=`HOLD; parallelDataIn = 7'd127;
       serialClkposedge = 0;
    $display("parallel output data to hold : b%b",parallelDataOut);
  @(negedge clk);
    serialDataIn = 1; parallelDataIn = 7'd120;
  @(posedge clk);
    serialClkposedge = 1;
    @(negedge clk);
    serialDataIn = 1;
    serialClkposedge = 0;
    @(posedge clk);
      serialClkposedge = 1;
    @(negedge clk);
    serialDataIn = 1; parallelDataIn = 7'd44;
    serialClkposedge = 0;
    @(posedge clk);
      serialClkposedge = 1;
    @(negedge clk);
    serialDataIn = 1;
    serialClkposedge = 0;

    `ASSERT_EQ(parallelDataOut, 7'd127, "HOLD failed") // saying that we're expecting 1111111 ??
    // Test case 3: left
    // tests that Pout is changing and Sout only changes when 8 (Deadly) Sins come in

    // set the correct pin
    @(negedge clk);
    mode=`PLOAD; parallelDataIn = 7'b0000100; serialDataIn = 0;
    // the pload only takes into affect when serialclk == 1
    @(posedge clk);
			 #1
			 mode=`LEFT;
      serialClkposedge = 1;
    @(negedge clk);
    $display("parallel output : b%b",parallelDataOut);

    mode=`LEFT; parallelDataIn = 7'b0000100; serialDataIn = 0;
    serialClkposedge = 0;
    $display("parallel output : b%b",parallelDataOut);
    @(posedge clk);
      serialClkposedge = 1;
      $display("parallel output : b%b",parallelDataOut);

    // tick 1, checking that Sout doesnt change but Pout does when Sin = 0
    @(negedge clk);
    serialDataIn = 0;
    @(posedge clk);
      serialClkposedge = 1; #5

    `ASSERT_EQ(serialDataOut, 1'b0, "intermediate LEFT failed: sout: 1")
    `ASSERT_EQ(parallelDataOut, 8'd16, "intermediate LEFT failed: pout 8'd8")
    // tick 2, checking that Pout changes when Sin= 1 and Sout doesn't change
    @(negedge clk);
    serialDataIn = 1; serialClkposedge = 0;
    @(posedge clk);
      serialClkposedge = 1; #5
    `ASSERT_EQ(serialDataOut, 1'b0, "intermediate LEFT failed: sout: 2")
    `ASSERT_EQ(parallelDataOut, 8'b00100001, "intermediate LEFT failed: pout 8'b00010001")
    // tick 3
    @(negedge clk);
    serialDataIn = 1; serialClkposedge = 0;
    @(posedge clk);
    serialClkposedge = 1; #5
    `ASSERT_EQ(serialDataOut, 1'b0, "intermediate LEFT failed: sout: 3")
    `ASSERT_EQ(parallelDataOut, 8'b01000011, "intermediate LEFT failed: pout 8'b00100011")
    // tick 4
    @(negedge clk); serialClkposedge = 0;
    serialDataIn = 1;
    @(posedge clk);
      serialClkposedge = 1; #5
    `ASSERT_EQ(serialDataOut, 1'b1, "intermediate LEFT failed: sout: 4")
    `ASSERT_EQ(parallelDataOut, 8'b10000111, "intermediate LEFT failed: pout 8'b01000111")
    $display("zeroth bit P[0] : b%b",parallelDataOut[0]);
    // setting the shiftregister
    @(negedge clk);
    serialDataIn = 1; serialClkposedge = 0;
    @(posedge clk);
      serialClkposedge = 1; #5
    `ASSERT_EQ(serialDataOut, 1'b0, " LEFT failed: sout: fin")
    `ASSERT_EQ(parallelDataOut, 8'b00001111, "LEFT failed: pout 8'b10001111")

    // Test case 4: right
    @(negedge clk); serialClkposedge = 0;
    mode=`PLOAD; parallelDataIn = 7'b0000000;
    @(posedge clk);
      serialClkposedge = 1;
    @(negedge clk);
    mode=`RIGHT; parallelDataIn = 7'b0000000;
    @(posedge clk);
      serialClkposedge = 1;

    @(negedge clk);
    serialDataIn = 1; serialClkposedge = 0;
    @(posedge clk);
      serialClkposedge = 1; #5
    `ASSERT_EQ(serialDataOut, 1'b1, "intermediate RIGHT failed: 1")
    @(negedge clk);
    serialDataIn = 0; serialClkposedge = 0;
    @(posedge clk);
      serialClkposedge = 1; #5
    `ASSERT_EQ(serialDataOut, 1'b0, "intermediate RIGHT failed: 2")
    @(negedge clk);
    serialDataIn = 1; serialClkposedge = 0;
    @(posedge clk);
      serialClkposedge = 1; #5
    `ASSERT_EQ(serialDataOut, 1'b1, "intermediate RIGHT failed: 3")
    @(negedge clk);
    serialDataIn = 0; serialClkposedge = 0;
    @(posedge clk);
      serialClkposedge = 1; #5
    `ASSERT_EQ(serialDataOut, 1'b0, "intermediate RIGHT failed: 4")
    @(negedge clk);
    serialDataIn = 1; serialClkposedge = 0;
    @(posedge clk);
      serialClkposedge = 1; #5
    `ASSERT_EQ(serialDataOut, 1'b1, "intermediate RIGHT failed: 5")
    @(negedge clk);
    serialDataIn = 0; serialClkposedge = 0;
    @(posedge clk);
      serialClkposedge = 1; #5
    `ASSERT_EQ(serialDataOut, 1'b0, "intermediate RIGHT failed: 6")
    @(negedge clk);
    serialDataIn = 0; serialClkposedge = 0;
    @(posedge clk);
      serialClkposedge = 1; #5
    `ASSERT_EQ(serialDataOut, 1'b0, "intermediate RIGHT failed: sout")
    `ASSERT_EQ(parallelDataOut, 8'b00101011, "intermediate FINAL failed: pout 8'b00101011")



    $finish();


    end

endmodule
