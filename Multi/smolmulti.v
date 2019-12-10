`include "Multi/inputconditioner.v"
`include "Multi/fsm.v"
`include "Multi/Multiplier/multiplier.v"
`include "Multi/shiftregister.v"

module SmolMulti (
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

   inputconditionermulti MOSIinputConditioner (.clk(CLK),
																					.noisysignal(MOSI),
																					.conditioned(MOSICon),
																					.positiveedge(MOSIPosEdge),
																					.negativeedge(MOSINegEdge));

   inputconditionermulti SCLKinputConditioner (.clk(CLK),
																					.noisysignal(SCLK),
																					.conditioned(SCLKCon),
																					.positiveedge(SCLKPosEdge),
																					.negativeedge(SCLKNegEdge));

   inputconditionermulti CSinputConditioner (.clk(CLK),
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


   and MISOBuffAnd (MISO, SoutDFF, MISOBuff);

endmodule
