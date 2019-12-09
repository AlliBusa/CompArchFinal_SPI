`include "inputconditioner.v"
`include "fsm.v"
`include "Multiplier/multiplier.v"
`include "shiftregister.v"

module SmolBoi (
  input MOSI,
  input SCLK,
  input CLK,
  input CS,
  output MISO
);

   wire  MOSICon, MOSIPosEdge, MOSINegEdge, SCLKCon, SCLKPosEdge, SCLKNegEdge, CSCon, CSPosEdge, CSNegEdge, Sout, SoutDFF, SoutBuff;
	 wire  start,AEn,BEn, done, MISOBuff;
   wire [7:0] Pin, Pout, PoutAddr;
   wire [3:0] A, B;
   wire [1:0] mode;

   // TODO instantiate LUT
	 FSMult fsm(.sclk(SCLKPosEdge),.clk(CLK),.cs(CS),.mode(mode),
							.start(start),.misobuffCNTL(MISOBuff),.done(done));

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


   shiftregistermain ShiftRegSmolBoi (.parallelOut(Pout),
                                   .clk(CLK),
                                   .mode(mode),
                                   .parallelIn(Pin),
                                   .serialClkposedge(SCLKPosEdge),
                                   .serialIn(MOSICon),
																	 .serialOut(Sout));

   multiplier MultiSmolBoi (.clk(CLK),
													.res(Pin),
													.done(done),
                          .start(start),
													.A(Pout[3:0]),
                          .B(Pout[7:4]));

   registerDFFPARA #(1) SoutRegSmolBoi (.d(Sout),
															 .wrenable(CLK),
															 .clk(CLK),
															 .q(SoutDFF));


   and MISOBuffAnd (SoutBuff, SoutDFF, MISOBuff);

endmodule
