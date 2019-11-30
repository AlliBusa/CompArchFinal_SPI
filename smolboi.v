// Top level module for SPI communication Smol Boi

`include "datamemory.v"
`include "dflipflop.v"

module SmolBoi (
  input MOSI,
  input SCLK,
  input CLK,
  input CS,
  output MISO
  );

  wire MOSICon, SCLKPosEdge, SCLKNegEdge, CSCon, Sout, SoutDFF, SoutBuff;
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
                                  .clk(clk),
                                  .mode(SRWE),
                                  .parallelIn(Pin),
                                  .serialIn(MOSICon));

  datamemory MemSmolBoi (.clk(clk),
                         .dataOut(Pin),
                         .address(PoutAddr),
                         .writeEnable(DMWE),
                         .dataIn(Pout));

  register PoutRegSmolBoi (.d(Pout),
                          .wrenable(AddrWE),
                          .clk(clk),
                          .q(PoutAddr));

  register SoutRegSmolBoi (.d(Sout),
                          .wrenable(clk),
                          .clk(clk),
                          .q(SoutDFF));

  and MISOBuffAnd (SoutBuff, SoutDFF, MISOBuff);
