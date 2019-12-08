`include "Multiplier/shiftregmodes.v"
`include "shiftregCOUNTER.v"
// `include "Multiplier/shiftregister.v"
`include "dflipflop.v"

`define WAIT 3'd0
`define LOAD 3'd1
`define MULT 3'd2
`define MULTRES 3'd3
`define MISORESULT 3'd4

module FSMult
(
  input cs,
  input done,
  input sclk,
  input clk,
  output reg  [1:0] mode,
  output  reg start,
  output  reg misobuffCNTL
);
reg [2:0] state;
wire [2:0] actualstate;
wire [8:0] count;
reg wrenableSTATE;
reg [1:0] countmode ;

// Setting the enable for the state holding D flip flop
// Since the state can only change when we end it
initial begin
  wrenableSTATE <= 1;
  countmode <=  `PLOAD;
  state <= `WAIT;
  mode <= `HOLD;

end
// D Flip FLop to hold the state
registerDFFPARA #(3) FSMstates(.q(actualstate), .d(state), .wrenable(wrenableSTATE), .clk(sclk));

// Counter
countah #(9) counter(.parallelOut(count),
                           .clk(sclk),
                           .mode(countmode),
                           .parallelIn(9'b1),
                           .serialIn(0));

always @(posedge sclk) begin
  if (cs === 1 && actualstate == `WAIT) begin
    misobuffCNTL <= 0;
    state <= `LOAD;
    countmode <= `LEFT;
    mode <= `LEFT;


  end
  if (count[8] === 1  && actualstate == `LOAD) begin
    misobuffCNTL <= 0;
    start <= 1;
    state <= `MULT;
    countmode <= `HOLD;
  end

  if (done == 1 && actualstate == `MULT) begin
    misobuffCNTL <= 0;
    start = 0;
    state <= `MULTRES;
    mode <= `HOLD;
    countmode <= `PLOAD;
  end

  if (actualstate == `MULTRES) begin
    misobuffCNTL <= 0;
    start <= 0;
    mode <= `PLOAD;
    countmode <= `LEFT;
    state <= `MISORESULT;

  end

  if (count[8] === 1 && actualstate == `MISORESULT) begin
      misobuffCNTL <= 1;
      mode <= `LEFT;
      state <= `WAIT;
  end
end
endmodule
