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

wire MISOCon, SCLKCon, SCLKPosEdge, SCLKNegEdge, CSCon, DataCon, AddrCon, Sout, SoutDFF, BUF_E;
wire [7:0] Pin, Pout, PoutData, PoutAddr, PoutAddrDFF, AddrCon, DataCon;

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
                    .address(PoutAddrDFF),
                    .writeEnable(DMWE),
                    .dataIn(PoutData));

muxnto1byn datamux (.out(PoutData),
                    .address(DataSelect),
                    .input0(Pout),
                    .input1(datacon));

muxnto1byn addrmux (.out(PoutAddr),
                    .address(AddrSelect),
                    .input0(Pout),
                    .input1(addcon));

loot LUT (.ADDr_WE(AddrWE),
          .DM_WE(DMWE),
          .BUF_E(BUF_E),
          .SR_WE(),
          .cs()
          .sclk(),
          );
          
registerDFF SoutDFF #(1) (.q(SoutDFF), .d(Sout), .wrenable(SCLKNegEdge), .clk(CLK));

registerDFF RWDFF #(1) (.q(MOSIBUFF), .d(Addr[7]), .wrenable(BUF_E), .clk(CLK));

//MOSI BUFF AND GATE

and (SoutBuff, SoutDFF, MOSIBUFF);

// BUFF to CS
buf (CS, CSCon);

// SCLK BUFF

buf (SCLK, SCLKCon);

// Pout DFF
registerDFF PoutDFF #(8) (.q(PoutAddrDFF), .d(PoutAddr), .wrenable(AddrWE), .clk(CLK));

// MUX
