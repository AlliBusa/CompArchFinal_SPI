// `include "shiftregister.v"
`include "shiftregmodes.v"
// `include "dflipflop.v"

// `define CSON 1'b0
// `define CSOFF 1'b1
// `define ADDRMOD 1'b0
// `define DATAMOD 1'b1

`define WAIT 3'd0
`define LOAD 3'd1
`define LOADADDR 3'd2
`define ADDR 3'd3
`define DATA 3'd4

module flute
(
//  output reg ADDR_WE, // Controls when we write to the D flip flop saving the address
//  output reg DM_WE, // Controls when we write to memory
//  output 		BUF_E, // Controls MISOBUFF (sending data to baby)
//  output [1:0]	SR_WE, // Controls when we pLoad into shift reg
//  input 			cs, // Chip select
//  input 			sout, // Serial out of the shift register storing MOSI input
//  input 			clkedge, // sclk edge from input conditioner
//  input 			clk // actual clk
// );
//
//  reg 			mod_select; // 1 when in data phase, 0 when in addr phase
//  wire [8:0] count;
//  wire 			fCount;
//  reg 				fcRes; // Reg that stores fCount. Helps get around init issue of fCount
//  reg 				csel = `CSOFF;

input cs,
input sclk,
input clk,
input sout,
output reg  [1:0] mode,
output  reg misofuff,
output reg addressWE,
output reg memWE
);
reg [2:0] actualstate;
//wire [2:0] actualstate;
// wire [8:0] count;
reg wrenableSTATE;
reg [1:0] countmode;
reg rw;
reg [2:0] count;
// Setting the enable for the state holding D flip flop
// Since the state can only change when we end it
initial begin
wrenableSTATE <= 1;
countmode <=  `PLOAD;
actualstate <= `WAIT;
mode <= `HOLD;

end
// D Flip FLop to hold the state
// registerDFFPARA #(3) FSMstates(.q(actualstate),
                               // .d(state), .wrenable(wrenableSTATE), .clk(sclk));
initial count = 0;

// // Counter
// countah #(9) counter(.parallelOut(count),
//                          .clk(sclk),
//                          .mode(countmode),
//                          .parallelIn(9'b1),
//                          .serialIn(0));

always @(posedge sclk) begin
if (cs === 0 && actualstate == `WAIT) begin
  if (cs === 0) begin
    misofuff <= 0;
    actualstate <= `ADDR;
    countmode <= `LEFT;
    mode <= `LEFT; //shift bits into shift register
    addressWE = 0;
    memWE = 0;
    count = 3'd0;
  end
  else begin
    misofuff <= 0;
    actualstate <= `WAIT;
    countmode <= `HOLD;
    mode <= `HOLD; //shift bits into shift register
    addressWE = 0;
    memWE = 0;
    count = 3'd0;
  end
end

if (actualstate == `ADDR) begin
  if (count === 3'd7) begin
    misofuff <= 0;
    actualstate <= `LOADADDR;
    countmode <= `PLOAD;
    mode <= `HOLD; //shift bits into shift register
    addressWE = 1;
    memWE = 0;
    rw = sout;
  end
  else begin count = count + 1; end
end

if (actualstate == `LOADADDR) begin
  count = 3'd0;
  if (rw === 0) begin // write state, so pass data to memory
    misofuff <= 0;
    actualstate <= `DATA;
    countmode <= `LEFT;
    mode <= `LEFT;
    addressWE = 0;
    memWE = 0;
  end
  else begin         // read state, so load data from memory
    misofuff <= 0;
    actualstate <= `LOAD;
    countmode <= `HOLD;
    mode <= `PLOAD;
    addressWE = 0;
    memWE = 0;
  end
end

if (actualstate == `LOAD) begin
  misofuff <= 1;
  actualstate <= `DATA;
  countmode <= `LEFT;
  mode <= `HOLD;
  addressWE = 0;
  memWE = 0;
end

if (actualstate == `DATA) begin
  if (count === 3'd7) begin
    misofuff <= 0;
    actualstate <= `WAIT;
    mode <= `HOLD;
    countmode <= `HOLD;
    addressWE = 0;
    if (rw === 0) begin
      memWE = 1;
    end
    else begin
      memWE = 0;
    end
  end
  else begin
  mode <= `LEFT;
  count = count + 1;
  end
end

end

endmodule
