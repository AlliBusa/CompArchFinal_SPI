`include "datamemory.v"
`include "dflipflop.v"
`include "inputconditioner.v"
`include "LUT.v"
`include "multiplexer.v"

module baby(
  input MISO,
  // inputs from whoever is using SPI
  input SCLK,
  input CS,
  input Addr,
  input Data,

  output MOSI,
  output SCLK,
  output CS
);

wire MISOCon, SCLKCon, SCLKPosEdge, SCLKNegEdge, CSCon, DataCon, AddrCon, Sout, SoutDFF;
wire [7:0] Pin, Pout, PoutData, PoutAddr, AddrCon, DataCon;

inputconditioner MISOinputConditioner (.clk(CLK),
                                       .noisysignal(MISO),
                                       .conditioned(MISOCon),
                                       .positiveedge(MISOPosEdge),
                                       .negativeedge(MISONegEdge));

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

inputconditioner AddrinputConditioner (.clk(CLK),
                                       .noisysignal(Addr),
                                       .conditioned(AddrCon),
                                       .positiveedge(AddrPosEdge),
                                       .negativeedge(AddrNegEdge));

inputconditioner AddrinputConditioner (.clk(CLK),
                                       .noisysignal(Data),
                                       .conditioned(DataCon),
                                       .positiveedge(DataPosEdge),
                                       .negativeedge(DataNegEdge));

shiftregister8 ShiftRegBaby (.parallelOut(Pout),
                             .clk(clk),
                             .mode(SRWE),
                             .parallelIn(Pin),
                             .serialIn(MOSICon));

datamemory MemBaby (.clk(clk),
                    .dataOut(Pin),
                    .address(PoutAddr),
                    .writeEnable(DMWE),
                    .dataIn(Pout));

muxnto1byn datamux (.out(),
                    .address(DataSelect),
                    .input0(Pout),
                    .input1(datacon))                    )

// Sout D-Flip Flip
wire SoutDFF;
wire Sout;
registerDFF SoutDFF #(1) (.q(SoutDFF), .d(Sout), .wrenable(SCLKNegEdge), .clk(CLK));

//MOSI BUFF AND GATE

and (SoutBuff, SoutDFF, MOSIBUFF);

// BUFF to CS
buf (CS, CSCon);

// SCLK BUFF

buf (SCLK, SCLKCon);

// Pout DFF
registerDFF PoutDFF #(8) (.q(PoutAddrDFF), .d(PoutAddr), .wrenable(AddrWE), .clk(CLK));

// MUX
