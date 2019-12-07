`include "FSM.v"

module testBenchLute();

  reg clk;
  reg clkedge;
  reg sout;
  reg cs;
  wire ADDR_WE;
  wire DM_WE;
  wire BUF_WE;
  wire SR_WE;

  lute dut(.clk(clk),
            .clkedge(clkedge),
            .sout(sout),
            .cs(cs),
            .ADDR_WE(ADDR_WE),
            .DM_WE(DM_WE),
            .BUF_WE(BUF_WE),
            .SR_WE(SR_WE));

//reg serialclk;
// Generate clock (50MHz)
initial clk=0;
always #10 clk=!clk;    // 50MHz Clock

// Generate clock (50MHz)
//initial serialclk=0;
//always #200 serialclk=!serialclk;
always #200 clkedge <= 1; clkedge<=0;    // 50MHz Clock

initial begin
