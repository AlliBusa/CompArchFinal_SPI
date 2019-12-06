`include "datamemory.v"
`include "dflipflop.v"
`include "inputconditioner.v"
`include "shiftregister.v"
`include "FSM.v"
`include "Multiplier/multiplier.v"

module SmolBoi (
  input MOSI,
  input SCLK,
  input CLK,
  input CS,
  output MISO
);

   wire  MOSICon, MOSIPosEdge, MOSINegEdge, SCLKCon, SCLKPosEdge, SCLKNegEdge, CSCon, CSPosEdge, CSNegEdge, Sout, SoutDFF, SoutBuff;
	 wire  start,AEn,BEn, done;
   wire [7:0] Pin, Pout, PoutAddr;
   wire [3:0] A, B;

   // TODO instantiate LUT
	 luffy lute(.clk(CLK),.cs(CS),.clkedge(SCLKNegEdge),.sout(Sout),
							.ADDR_WE(AddrWe),.DM_WE(DMWE),.BUF_E(MISOBuff),.SR_WE(SRWE));

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
                                   .serialIn(MOSICon),
																	 .serialOut(Sout));

   multiplier MultiSmolBoi (.clk(CLK),
													.res(Pin),
													.done(done),
													.A(A),
                          .B(B));

   registerDFF PoutRegSmolBoi (.d(Pout),
															 .wrenable(AddrWE),
															 .clk(CLK),
															 .q(PoutAddr));

   registerDFF SoutRegSmolBoi (.d(Sout),
															 .wrenable(CLK),
															 .clk(CLK),
															 .q(SoutDFF));

   registerDFF #(4) AReg (.d(Pout),
													.wrenable(AEn),
													.clk(CLK),
													.q(A));

   registerDFF #(4) BReg (.d(Pout),
													.wrenable(BEn),
													.clk(CLK),
													.q(B));

   and MISOBuffAnd (SoutBuff, SoutDFF, MISOBuff);

endmodule
