`define CSON 1'b0
`define CSOFF 1'b1
`define ADDRMOD 1'b0
`define DATAMOD 1'b1

// LUT for baby
module loot
(
   output cs,
   output modes,

   input 	clk
);
endmodule // loot

// LUT for smol boi
module lute
(
	 output reg ADDR_WE,
	 output reg DM_WE,
	 output reg BUF_E,
	 output reg SR_WE,
	 input 	cs,
	 input 	sclk,
	 input 	clk
);
	 reg 		mod_select; // 1 when in data phase, 0 when in addr phase
	 reg 		[2:0] count; // counter
	 reg 					csel = `CSOFF;
	 always @(negedge cs) begin
			csel = `CSON;
			count <= 3'b0;
			mod_select <= 0;
			SR_WE <= 0;
			DM_WE <= 0;
			BUF_E <= 0;
			ADDR_WE <= 0;
	 end

   always @(posedge sclk) begin
			case(csel)
			  `CSOFF:begin ADDR_WE=0; DM_WE=0; BUF_E=0; SR_WE=0; count=3'b0; mod_select=0; end
				`CSON: begin
					 case(mod_select)
						 `ADDRMOD: begin
								if(count == 3'b7) begin
									 
        if(conditioned == synchronizer1)
            counter <= 0;
        else begin
            if( counter == waittime) begin
                counter <= 0;
                conditioned <= synchronizer1;
            end
            else 
                counter <= counter+1;
        end
        synchronizer0 <= noisysignal;
        synchronizer1 <= synchronizer0;
			case(instruction[31:26])
    `LW: begin alucntrl =`iADD; regwr=1; memwr=0; regdst=1; alusrc=0; memtoreg=1; jump=0; regorimmu=0; jayall=0; bne=0; beq=0; buttcheek=0; end
    `SW: begin alucntrl =`iADD; regwr=0; memwr=1; regdst=1; alusrc=0; memtoreg=0; jump=0; regorimmu=0; jayall=0; bne=0; beq=0; buttcheek=0; end
    `J: begin alucntrl =`iADD; regwr=0; memwr=0; regdst=0; alusrc=0; memtoreg=0; jump=1; regorimmu=0; jayall=0; bne=0; beq=0; buttcheek=1; end
    `RTYPE: begin
      case(instruction[5:0])
      `tADD: begin alucntrl=`iADD; regwr=1; memwr=0; regdst=0; alusrc=1; memtoreg=0; jump=0; regorimmu=0;  jayall=0; bne=0; beq=0; buttcheek=1; end
      `tSUB: begin alucntrl=`iSUB; regwr=1; memwr=0; regdst=0; alusrc=1; memtoreg=0; jump=0; regorimmu=0;  jayall=0; bne=0; beq=0; buttcheek=1; end
      `tSLT: begin alucntrl=`iSLT; regwr=1; memwr=0; regdst=0; alusrc=1; memtoreg=0; jump=0; regorimmu=0; jayall=0; bne=0; beq=0; buttcheek=1; end
      `tJR: begin alucntrl=`iADD; regwr=0; memwr=0; regdst=0; alusrc=0; memtoreg=0; jump=1;  regorimmu=1; jayall=0; bne=0; beq=0; buttcheek=1; end
      endcase
    end
    `JAL: begin alucntrl=`iADD; regwr=1; memwr=0; regdst=0; alusrc=0; memtoreg=0; jump=1; regorimmu=0; jayall=1; bne=0; beq=0; buttcheek=1; rd<=linker; end
    `BEQ: begin alucntrl=`iSUB; regwr=0; memwr=0; regdst=1; alusrc=1; memtoreg=0; jump=0; regorimmu=0; jayall=0; bne=0; beq=1; buttcheek=1; end
    `BNE: begin alucntrl=`iSUB; regwr=0; memwr=0; regdst=1; alusrc=1; memtoreg=0; jump=0; regorimmu=0; jayall=0; bne=1; beq=0; buttcheek=1; end
    `XORI: begin alucntrl=`iXOR; regwr=1; memwr=0; regdst=1; alusrc=0; memtoreg=0; jump=0; regorimmu=0; jayall=0; bne=0; beq=0; buttcheek=1; end
    `ADDI: begin alucntrl=`iADD; regwr=1; memwr=0; regdst=1; alusrc=0; memtoreg=0; jump=0; regorimmu=0; jayall=0; bne=0; beq=0; buttcheek=1; end
    endcase
    end
endmodule // lute

