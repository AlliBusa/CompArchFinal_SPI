// Top level module for SPI communication Smol Boi

`include "datamemory.v"
`include "dflipflop.v"
`include "inputconditioner.v"
`include "shiftregister.v"

module SmolBoi (
  input MOSI,
  input SCLK,
  input CLK,
  input CS,
  output MISO
  );

  wire MOSICon, MOSIPosEdge, MOSINegEdge, SCLKCon, SCLKPosEdge, SCLKNegEdge, CSCon, CSPosEdge, CSNegEdge, Sout, SoutDFF, SoutBuff;
  wire [7:0] Pin, Pout, PoutAddr;

  // TODO instantiate LUT

  inputconditioner MOSIinputConditioner (.clk(CLK),
                                         .noisysignal(MOSI),
                                         .conditioned(MOSICon),
                                         .positiveedge(MOSIPosEdge),
                                         .negativeedge(MOSINegEdge));

  inputconditioner SCLKinputConditioner (.clk(CLK),
                                         .noisysignal(SCLK),
                                         .conditioned(SCLKCon),
                                         .positiveedge(SCLKPosEdge),
                                         .negativeedge(SCLKNegEdge));

  inputconditioner CSinputConditioner (.clk(CLK),
                                         .noisysignal(CS),
                                         .conditioned(CSCon),
                                         .positiveedge(CSPosEdge),
                                         .negativeedge(CSNegEdge));


  shiftregister8 ShiftRegSmolBoi (.parallelOut(Pout),
                                  .clk(CLK),
                                  .mode(SRWE),
                                  .parallelIn(Pin),
                                  .serialIn(MOSICon));

  datamemory MemSmolBoi (.clk(CLK),
                         .dataOut(Pin),
                         .address(PoutAddr),
                         .writeEnable(DMWE),
                         .dataIn(Pout));

  registerDFF PoutRegSmolBoi (.d(Pout),
                          .wrenable(AddrWE),
                          .clk(CLK),
                          .q(PoutAddr));

  registerDFF SoutRegSmolBoi (.d(Sout),
                          .wrenable(CLK),
                          .clk(CLK),
                          .q(SoutDFF));

  and MISOBuffAnd (SoutBuff, SoutDFF, MISOBuff);

endmodule
