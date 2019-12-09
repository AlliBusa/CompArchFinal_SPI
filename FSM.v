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
 output 		nintendo, // Controls the select line of the mux
 output 		SRM, // Controls when we pLoad into the shift reg
 output reg DataFE, // Controls when we store the data input into the d flip flop
 output reg AddrFE, // Controls when we store the addr input into the d flip flop
 output reg BUF, // Controls MOSIBUFF - sending data to the smol boi
 output 		InFE, // Controls loading data received from the smol boi into the d flip flop
 input 			cs, // Chip select line - is an input
 input 			clkedge, // Serial clock positive edge from input conditioner
 input 			sout, // Serial output of the shift register sending data to smol boi
 input 			clk // Internal clock
);
	 reg 			mod_select; // 1 when in data phase, 0 when in addr phase
	 wire [8:0] count; // Counter - this stores the output of the shift reg counter
	 wire 			fCount; // MSB of the shift reg
	 reg 				csel = `CSOFF; // `CSOFF means chip select is high, `CSON means chip select is low
	 reg 				rwsig; // tells us if we're reading or writing
   wire        [1:0] modulator;
	 // Chose to use a counter because:
	 // we can just see which bit of the shift register is high to tel us what stage we're in
	 // Chose to use a 9 bit shift-reg instead of an 8-bit shift reg so that we can preload the 1
	 // i.e. The 1 is loaded into the 0-bit, which is never checked. It's considered the waiting spot.
	 // In the first cycle, it'll be shifted into the 1-bit, so on and so forth
	 // This way, we never have to specify when to shift in a 1, compared to a zero
	 // i.e. We're just always shifting zeros.
	 // The shiftreg needs to reload after eight shifts.
	 // Conveniently, the MSB of the shift reg is setup to be 1 after 8 shifts.
	 // This means we just set the mode of the shift reg to be controlled by the MSB of the shift reg.
   assign modulator = {1'b1,fCount};

   shiftregister9 counter(.clk(clk),
    													 .serialClkposedge(clkedge),
    													 .mode({1'b1,fCount}),
    													 .parallelIn(9'b1),
    													 .serialIn(1'b0),
    													 .parallelOut(count),
    													 .serialOut(fCount));
	 // InFE controls when we load the 8-bit data from MISO
	 // Here, we tell it to always load in data after 8 sclk cycles
	 // On cycles where the baby is writing, it'll load in garbage, but that doesn't matter
	 // Just don't read it on those cycles
	 assign InFE = fCount;

	 // We want to load in the stuff to send to the smol boi before each 8-bit cycle
	 // Because we control MOSIBUFF separately, we can always load stuff in
	 // Since we don't need to worry about it being sent out
	 // Whenever the 0-bit of the shift reg is one, we're at the stage right before the 8-bit cycle
	 assign SRM = count[0];

	 // Nintendo tells us when to pick the data line (because it's a switch control for the mux)
	 // Only select the data line when we want to write stuff
	 assign nintendo = rwsig;

	 // Initialize stuff
	 // Once Chip Select goes low, initialize all the stuff
	 // Load in the Data and Addr stuff into the flip flops by setting enables
	 // Tell MOSIBUFF to not send anything yet
	 // set rwsig to 0, since we don't know yet if we're writing or reading
	 // Tell the FSM to start off in `ADDRMOD (address mode)
	 always @(negedge cs) begin
			csel = `CSON;
			DataFE = 1;
			AddrFE = 1;
			BUF = 0;
			rwsig = 1;
			mod_select = `ADDRMOD;
	 end

	 // Once chip select goes back to positive, set all stuff to waiting states
	 // Tell FSM that we're in the CSOFF stage
	 // Tell MOSIBUFF to stop sending stuff
	 always @(posedge cs) begin
			csel = `CSOFF;
			BUF = 0;
	 end

	 always @(clkedge) begin
			// During operation, we no longer need to load the Data and Addr info, so stop enabling flops
			DataFE <= 0;
			AddrFE <= 0;
			// Only run FSM if we're in the `CSON stage
			if (csel == `CSON) begin
				 case(mod_select) // Select for which mode we're in, ADDRMOD or DATAMOD
					 `ADDRMOD: begin
							BUF <= 1'b1; // We're gonna send the address, so MOSIBUFF = ON
							if (fCount == 1) begin // If the MSB is 1, we've reached 8 cycles. Switch to DATAMOD.
								 mod_select <= `DATAMOD;
								 // At 8 cycles, the MSB of the shift reg sending data is on the R/W signal.
								 // Set rwsig to the serial out of the shiftreg.
								 // Use that to determine MOSIBUFF in the DATAMOD stage.
								 rwsig <= sout;
							end
					 end
					 `DATAMOD: begin
						  if (rwsig == 0) // If R/W sig is 0, then turn MOSIBUFF on -> we're writing!
								BUF <= 1;
							else // If it's not, turn MOSIBUFF off -> we're not writing :(
								BUF <= 0;
							if (fCount == 1) // If fCount is 1, we've reached 8 cycles. Switch back to ADDRMOD.
								mod_select <= `ADDRMOD;
					 end
				 endcase // case (mod_select)
			end // if (csel == `CSON)
	 end // always @ (clkedge)
endmodule // loot

// LUT for smol boi
module lute
(
 output reg ADDR_WE, // Controls when we write to the D flip flop saving the address
 output reg DM_WE, // Controls when we write to memory
 output 		BUF_E, // Controls MISOBUFF (sending data to baby)
 output [1:0]	SR_WE, // Controls when we pLoad into shift reg
 input 			cs, // Chip select
 input 			sout, // Serial out of the shift register storing MOSI input
 input 			clkedge, // sclk edge from input conditioner
 input 			clk // actual clk
);
	 reg 			mod_select; // 1 when in data phase, 0 when in addr phase
	 wire [8:0] count;
	 wire 			fCount;
	 reg 				fcRes; // Reg that stores fCount. Helps get around init issue of fCount
	 reg 				csel = `CSOFF;

	 // Same reasoning for this shift reg as the one in loot (FSM for baby)
   shiftregister9 counter(.clk(clk),
    													 .serialClkposedge(clkedge),
    													 .mode({1'b1,fcRes}),
    													 .parallelIn(9'b1),
    													 .serialIn(1'b0),
    													 .parallelOut(count),
    													 .serialOut(fCount));

	 // It turns out that BUF_E is literally equal to the R/W signal
	 // The R/W signal is the MSB of the shift reg on the 8th cycle
	 // We'll capture that in this d flipflop, by enabling it on the 8th cycle
	 // Since fCount is only 1 on the 8th cycle, it only enables the flop on the 8th cycle
	 registerDFF storemisobuffctrl(.clk(clk),
																 .q(BUF_E),
																 .d(sout),
																 .wrenable(fcRes));

	 initial begin
			fcRes = 1;
	 end

	 // Here's a nifty thing: we don't actually need to care if we *need* to load in data from memory!
	 // Here, we just say load it after we've got all the address bits and R/W bit - after 8 cycles
	 // We do that by setting it equal to fCount - which is only true after 8 cycles
	 // Even if we didn't need to load it, it's fine, since it'll get shifted out anyways
	 // Loading doesn't affect our memory, so it works out all fine
	 assign SR_WE = {1'b1,fcRes};

	 // Initialize when chip select goes low
	 always @(negedge cs) begin
			csel = `CSON; // Tell FSM we're in the `CSON stage
			DM_WE <= 0; // Don't write anything to memory yet
			ADDR_WE <= 0; // Don't write anything to the address flop yet
			mod_select <= `ADDRMOD; // Tell FSM to start in ADDRMOD - address mode
	 end

	 // When chip select goes down, set everything to standby
	 always @(posedge cs) begin
			csel = `CSOFF; // Tell FSM we're in the CSOFF stage
			DM_WE <= 0; // Don't write anything to memory or address flop
			ADDR_WE <= 0;
			mod_select <= `ADDRMOD; // Ready FSM to start off in Address mode
	 end

	 always @(posedge clk) begin
			fcRes = fCount;
	 end

   always @(clkedge) begin // Always update on serial clock
			if (csel == `CSON) begin // Only operate when in CSON stage
				 case(mod_select) // Check if either in ADDRMOD or DATAMOD
					 `ADDRMOD: begin
							// We need to load in the address after going through 7 cycles (since 8th has R/W sig)
							// When the 7-bit of the shift reg has a 1, we've gone through 7 cycles
							// So just set the address flop enable to track the 7-bit of the shift reg
							ADDR_WE <= count[7];
							// We never write to the data memory during the memory during address stages
							DM_WE <= 0;
							if (fCount == 1) // We've reached 8 cycles if fCount is 1. Switch to DATAMOD.
								mod_select <= `DATAMOD;
					 end
					 `DATAMOD: begin
							ADDR_WE <= 0; // Never write to the address flop in the data stage.
							// If MISOBUFF is 0, then we're in the write to smol boi stage.
							// Open up the memory then - but only write after 8 cycles, when fCount is 1.
							if (BUF_E == 0)
								DM_WE <= fCount;
							if (fCount == 1) // We've reached 8 cycles if fCount is 1. Switch to ADDRMOD.
								mod_select <= `ADDRMOD;
					 end
				 endcase // case (mod_select)
			end // if (csel == `CSON)
	 end // always @ (clkedge)
endmodule // lute
