// Top level module for SPI communication Smol Boi

`include "Memory/datamemory.v"
`include "Memory/dflipflop.v"
`include "Memory/inputconditioner.v"
`include "Memory/shiftregister.v"
`include "Memory/FSM.v"

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
	 flute luffy(.clk(CLK),
               .cs(CS),
               .sclk(SCLKCon),
               .sout(Sout),
							 .addressWE(AddrWE),
               .memWE(DMWE),
               .misofuff(MISOBuff),
               .mode(SRWE));

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

   and MISOBuffAnd (MISO, SoutDFF, MISOBuff);

endmodule
