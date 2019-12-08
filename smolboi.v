// Top level module for SPI communication Smol Boi

`include "datamemory.v"
// `include "dflipflop.v"
`include "inputconditioner.v"
// `include "shiftregister.v"
`include "FSM.v"

module SmolBoi (
  input MOSI,
  input SCLK,
  input CLK,
  input CS,
  output MISO
);

   wire  MOSICon, MOSIPosEdge, MOSINegEdge, SCLKCon, SCLKPosEdge, SCLKNegEdge, CSCon, CSPosEdge, CSNegEdge, Sout, SoutDFF, SoutBuff;
	 wire  AddrWE, DMWE, MISOBuff;
   wire [1:0] SRWE;
   wire [7:0] Pin, Pout;
   wire [7:0] PoutAddr;

   // TODO instantiate LUT
	 lute luffy(.clk(CLK),
              .cs(CS),
              .clkedge(SCLKNegEdge),
              .sout(Sout),
							.ADDR_WE(AddrWE),
              .DM_WE(DMWE),
              .BUF_E(MISOBuff),
              .SR_WE(SRWE));

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
                                   .serialClkposedge(SCLKPosEdge),
                                   .mode(SRWE),
                                   .parallelIn(Pin),
                                   .serialIn(MOSICon),
																	 .serialOut(Sout));

   datamemory MemSmolBoi (.clk(CLK),
													.dataOut(Pin),
													.address(PoutAddr[6:0]),
													.writeEnable(DMWE),
													.dataIn(Pout));

   // registerDFF PoutRegSmolBoi (.d(Pout),
		// 													 .wrenable(AddrWE),
		// 													 .clk(CLK),
		// 													 .q(PoutAddr));

   register8 PoutRegSmolBoi (.q(PoutAddr),
                             .clk(CLK),
                             .wrenable(AddrWE),
                             .d(Pout));

   registerDFF SoutRegSmolBoi (.d(Sout),
															 .wrenable(CLK),
															 .clk(CLK),
															 .q(SoutDFF));

   and MISOBuffAnd (SoutBuff, SoutDFF, MISOBuff);

endmodule
