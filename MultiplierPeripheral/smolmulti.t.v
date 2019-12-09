include "smolmulti.v"

`define ASSERT_EQ(val, exp, msg) \
  if (val !== exp) $display("[FAIL] %s (got:b%b expected:b%b)", msg, val, exp);

module testSmolMulti();
  reg MOSI;
  reg SCLK;
  reg CLK;
  reg CS;
  wire MISO;
  multismol smolmulti(.MOSI(MOSI),.SCLK(SCLK),.CLK(CLK),.CS(CS),.MISO(MISO))
