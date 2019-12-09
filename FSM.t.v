`include "FSM.v"
`include "inputconditioner.v"

module testBenchLute();

  reg clk;
  reg sclk;
  wire clkedge;
  reg sout;
  reg cs;
  wire ADDR_WE;
  wire DM_WE;
  wire BUF_WE;
  wire [1:0] SR_WE;
  wire conditioned;
  wire negativeedge;

  flute dut(.clk(clk),
           .sout(sout),
           .sclk(sclk),
           .cs(cs),
           .addressWE(ADDR_WE),
           .memWE(DM_WE),
           .misofuff(BUF_WE),
           .mode(SR_WE));
  //
  // inputconditioner fixItUp (.clk(clk),
  //                           .noisysignal(sclk),
  //                           .conditioned(conditioned),
  //                           .positiveedge(clkedge),
  //                           .negativeedge(negativeedge));

//reg serialclk;
// Generate clock (50MHz)
initial clk=0;
always #10 clk=!clk; // 50MHz Clock
initial sclk=0;
always #200 sclk=!sclk;

// Generate clock (50MHz)
//initial serialclk=0;
//always #200 serialclk=!serialclk;
// always #200 clkedge = 1; clkedge=0;    // 50MHz Clock

initial begin

$dumpfile("fsm_lute.vcd");
$dumpvars();

cs = 1; #200
sout = 1; #200
cs = 0; #200
#20000

$finish;

end
endmodule
