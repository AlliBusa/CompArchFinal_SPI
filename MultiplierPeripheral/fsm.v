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
  output  reg misobuffCNTL,
  output  reg [2:0] state
);
//reg [2:0] state;
//wire [2:0] state;
wire [8:0] count;
reg wrenableSTATE;
reg [1:0] countmode ;
reg doneLONG;

// Setting the enable for the state holding D flip flop
// Since the state can only change when we end it
initial begin
  wrenableSTATE <= 1;
  countmode <=  `PLOAD;
  state <= `WAIT;
  mode <= `HOLD;
  start <= 0;
  doneLONG <= 0;

end
// D Flip FLop to hold the state
// registerDFFPARA #(3) FSMstates(.q(state), .d(state), .wrenable(wrenableSTATE), .clk(sclk));

// Counter
countah #(9) counter(.parallelOut(count),
                           .clk(sclk),
                           .mode(countmode),
                           .parallelIn(9'b1),
                           .serialIn(1'b0));

always @(posedge sclk) begin
  if (cs === 1 && state == `WAIT) begin
    misobuffCNTL <= 0;
    state <= `LOAD;
    countmode <= `LEFT;
    mode <= `LEFT;


  end
  if (count[8] == 1  && state == `LOAD) begin
    state <= `MULT;
    countmode <= `HOLD;
    mode <= `HOLD;
    misobuffCNTL <= 0;



  end
  // turning start signal off
  if (state == `MULT && doneLONG != 1) begin
    start <= 1;
    countmode <= `HOLD;
  end
  // turning start signal off


  if (doneLONG === 1 && state === `MULT) begin
    misobuffCNTL <= 0;
    start <= 0;
    state <= `MULTRES;
    mode <= `PLOAD;
    countmode <= `PLOAD;

  end

  if (state == `MULTRES) begin
    misobuffCNTL <= 1;
    start <= 0;
    mode <= `LEFT;
    countmode <= `LEFT;
    state <= `MISORESULT;
    doneLONG <= 0;

  end

  if (count[8] === 1 && state == `MISORESULT) begin
      misobuffCNTL <= 0;
      mode <= `LEFT;
      state <= `WAIT;
  end
end
always @(negedge sclk) begin
  if(start == 1)
  start <= 0;
  end
always @(*) begin
  if(done==1 && state == `MULT)
  doneLONG <=1;
  end
endmodule
