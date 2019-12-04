`include "datamemory.v"
`include "dflipflop.v"
`include "inputconditioner.v"
`include "LUT.v"
`include "multiplexer.v"

module baby(
  input MISO,
  // inputs from whoever is using SPI
  input CLK,
  input CS,
  input Addr,
  input Data,

  output MOSI,
  output reg SCLK,
  output CS
);

initial SCLK =0;

always #20 SCLK = !SCLK;

wire MISOCon, SCLKCon, SCLKPosEdge, SCLKNegEdge, CSCon, Sout, SoutDFF, BUF_E, dataenable, addrenable,SIN, BuffEn;
wire [7:0] Pin, Pout, PoutData, PoutAddr, PoutAddrDFF, addrcon, datacon, SPIBuffer, datasaved, addrsaved;

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
                                       .conditioned(addrcon),
                                       .positiveedge(AddrPosEdge),
                                       .negativeedge(AddrNegEdge));

inputconditioner DatainputConditioner (.clk(CLK),
                                       .noisysignal(Data),
                                       .conditioned(datacon),
                                       .positiveedge(DataPosEdge),
                                       .negativeedge(DataNegEdge));

shiftregister8 ShiftRegBaby (.parallelOut(Pout),
                             .clk(clk),
                             .mode(SRWE),
                             .parallelIn(Pin),
                             .serialIn(MOSICon));

laffy loot(.cs(CSCon), .clkedge(SCLKPosEdge), .clk(clk),
					 .nintendo(Switch), .SRM(SRWE),
					 .DataFE(dataenable), .AddrFE(addrenable), .InFE(BuffEn),
					 .BUF(MOSIBUFF));

registerDFF #(1) SoutDFF (.q(SoutDFF), .d(Sout), .wrenable(SCLKNegEdge), .clk(CLK));

registerDFF #(1) RWDFF (.q(MOSIBUFF), .d(Addr[7]), .wrenable(BUF_E), .clk(CLK));

registerDFF #(8) DATADFF (.q(datasaved), .d(datacon), .wrenable(dataenable), .clk(CLK));

registerDFF #(8) ADDRDFF (.q(addrsaved), .d(addrcon), .wrenable(addrenable), .clk(CLK));

//MOSI BUFF AND GATE

and (SoutBuff, SoutDFF, MOSIBUFF);

// BUFF to CS
buf (CS, CSCon);

// SCLK BUFF

buf (SPIBuffer, SCLKCon);

// Pout DFF
registerDFF #(8) SPIBufferer (.q(SPIBuffer), .d(MISO), .wrenable(BuffEn), .clk(CLK));

// MUX
muxnto1byn #(8) datamux (.out(Pin),
                         .address(Switch),
                         .input0(addrsaved),
                         .input1(datasaved));

buf (SCLK, MISO);
