`include "shiftregister.v"
`include "dflipflop.v"

`define CSON 1'b0
`define CSOFF 1'b1
`define ADDRMOD 1'b0
`define DATAMOD 1'b1

// LUT for baby
// Switch Nintendo
// DataFE
// AddrFE
// SRM
// MOSIBUF
// InFE
module loot
(
   output nintendo,
   output SRM,
	 output DataFE,
	 output AddrFE,
	 output BUF,
	 output InFE,
   input 	clkedge,
	 input 	sclk,
	 input 	clk
);
	 
endmodule // loot

// LUT for smol boi
module lute
(
 output reg ADDR_WE,
 output reg DM_WE,
 output 		BUF_E,
 output 		SR_WE,
 input 			cs, // Chip select
 input 			sout, // Serial out of the shift register storing MOSI input
 input 			clkedge, // sclk edge from input conditioner
 input 			clk // actual clk
);
	 reg 			mod_select; // 1 when in data phase, 0 when in addr phase
	 wire [8:0] count;
	 wire 			fCount;
	 reg 				csel = `CSOFF;

   shiftregister8 #(9) dut(.clk(clk),
    											 .serialClk(clkedge),
    											 .mode(fCount),
    											 .parallelIn(9'b1),
    											 .serialIn(1'b0),
    											 .parallelOut(count),
    											 .serialOut(fCount));

	 registerDFF dffbuf(.clk(clk),
											.q(BUF_E),
											.d(sout),
											.wrenable(fCount));

	 assign SR_WE = fCount;

	 always @(negedge cs) begin
			csel = `CSON;
			DM_WE <= 0;
			ADDR_WE <= 0;
			mod_select <= `ADDRMOD;
	 end

	 always @(posedge cs) begin
			csel = `CSOFF;
			DM_WE <= 0;
			ADDR_WE <= 0;
			mod_select <= `ADDRMOD;
	 end

   always @(clkedge) begin
			if (csel == `CSON) begin
				 case(mod_select)
					 `ADDRMOD: begin
							ADDR_WE <= count[7];
							DM_WE <= 0;
							if (fCount == 1)
								mod_select <= `DATAMOD;
					 end
					 `DATAMOD: begin
							ADDR_WE <= 0;
							if (BUF_E == 0)
								DM_WE <= fCount;
							if (fCount == 1)
								mod_select <= `ADDRMOD;
					 end
				 endcase // case (mod_select)
			end // if (csel == `CSON)
	 end // always @ (posedge sclk)
endmodule // lute

