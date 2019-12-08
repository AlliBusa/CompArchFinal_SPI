`include "Multiplier/shiftregmodes.v"
`include "shiftregCOUNTER.v"

`define WAIT = 3'd0;
`define LOAD = 3'd1;
`define MULT = 3'd2;
`define MULTRES = 3'd3;
`define MISORESULT = 3'd4;

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
wire [2:0] state;
wire [7:0] count;
reg wrenableSTATE;
reg [1:0] countmode ;

// Setting the enable for the state holding D flip flop
// Since the state can only change when we end it
initial begin
  wrenableSTATE <= 1;
  countmode <=  `PLOAD;
end
// D Flip FLop to hold the state
shiftregister #(5) FSMstates(.q(state), .d(state), .wrenable(wrenableSTATE), .clk(sclk));

// Counter
countah #(9) counter(.parallelOut(count),
                           .clk(sclk),
                           .mode(countmode),
                           .parallelIn(),
                           .serialIn(0));

always @(posedge sclk) begin
  if (cs === 1 && state == `WAIT) begin
    misobuffCNTL <= 0;
    state <= `PLOAD;
    mode <= `HOLD;

    countmode <= `PLOAD;

  end
  if (counter == 4'd8 && state == `LOAD) begin
    misobuffCNTL <= 0;
    start <= 1;
    state <= `MULT;
    mode <= `LEFT;
    countmode <= `LEFT;
  end

  if (done == 1 && state == `MULT) begin
    misobuffCNTL <= 0;
    start = 0;
    state <= `MULTRES;
    mode <= `HOLD;
    countmode <= `PLOAD;
  end

  if (state == `MULTRES) begin
    misobuffCNTL <= 0;
    start <= 0;
    mode <= `PLOAD;
    countmode <= `LEFT;`

  end

  if (counter == 4'd8 && state = MISORESULT) begin
      misobuffCNTL <= 1;
      mode <= `LEFT;
  end
end
endmodule
