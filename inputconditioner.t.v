//------------------------------------------------------------------------
// Input Conditioner test bench
//------------------------------------------------------------------------
`include "inputconditioner.v"
`define ASSERT_EQ(val, exp, msg) \
  if (val !== exp) $display("[FAIL] %s (got:b%b expected:b%b)", msg, val, exp);

module testConditioner();

    reg clk;
    reg pin;
    wire conditioned;
    wire rising;
    wire falling;
    wire sync1;
    wire sync0;

    inputconditioner dut(.clk(clk),
    			 .noisysignal(pin),
			 .conditioned(conditioned),
			 .positiveedge(rising),
			 .negativeedge(falling)
       );


    // Generate clock (50MHz)
    initial clk=0;
    always #10 clk=!clk;    // 50MHz Clock

    initial begin
    // Your Test Code
    // Be sure to test each of the three conditioner functions:
    // Synchronization, Debouncing, Edge Detection
    $dumpfile("inputconditioner-dump.vcd");
    $dumpvars();
    // Synchronization
    // takes something not in sync with the clock and makes it in sync

    // create a signal that is not in sync with the clock
    pin = 0;
    #15;
    pin = 1;
    // check syncs after 1 sec
    #1;
    `ASSERT_EQ(sync0, 1'b1, "SYNC 0 FAILED")
    `ASSERT_EQ(sync1, 1'b0, "SYNC 1 FAILED")
    // check syncs after 1 sec
    #1;
    `ASSERT_EQ(sync0, 1'b1, "SYNC 0 FAILED")
    `ASSERT_EQ(sync1, 1'b1, "SYNC 1 FAILED")
    #20;
    pin = 0;
    // Debouncing
    // Waits for input signal to stabilize
    #100;
    // create a noisy input signal & stabilize it
    pin = 1; #1 ; pin = 0; #1; pin = 1; #1; pin = 0; #1;  pin = 1; #1; pin = 0; #1; pin = 1; #1; pin = 0;
    #1 pin = 1; #1 pin = 1; #1 pin = 1;
    // check output of input conditioner
    `ASSERT_EQ(conditioned, 1'b1, "Debounceing FAILED")

    // Edge Detection
    // detects positive edge and negative edge of conditioned output

    // send an input signal in
    pin=1;
    // wait three clock cycles for the input conditioner
    // check if posedge = 1
    `ASSERT_EQ(rising, 1'b1, "RISING FAILED")

    // end signal
    pin=0;
    //wait three clock cycles
    // check if negedge = 1
    `ASSERT_EQ(falling, 1'b1, "FAILING FAILED")

    #20 $finish();
end
endmodule
