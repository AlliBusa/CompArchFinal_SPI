`include "smolmulti.v"
`include "./shiftregmodes"

`define WAIT = 3'd0;
`define LOAD = 3'd1;
`define MULT = 3'd2;
`define MULTRES = 3'd3;
`define MISORESULT = 3'd4;

module FSMult
(
  input cs;
  input done;
  input sclk;
  input clk;
  output  reg [1:0] mode;
  output  reg start;
  output  reg misobuffCNTL
);
wire [2:0] state;
wire [7:0] count;
wire wrenableSTATE;
// D Flip FLop to hold the state
shiftregister #(5) FSMstates(.q(state), .d(state), .wrenable(wrenableSTATE), .clk(sclk));

// Counter
shiftregister #(8) counter(.parallelOut(count),
                           .serialOut(),
                           .clk(sclk),
                           .serialClkposedge();

always @(posedge sclk) begin
  if (cs == 1 && state == `WAIT)
    misobuffCNTL = 0;
    state = `LOAD;
    mode = `HOLD;

  end
  if (counter == 4'd8 && state == `LOAD) begin
    misobuffCNTL = 0;
    start = 1;
    state = `MULT;
    mode = `LEFT;
  end

  if (done == 1 && state == `MULT) begin
    misobuffCNTL = 0;
    start = 0;
    state = `MULTRES;
    mode = `HOLD;
  end

  if (state == `MULTRES) begin
    misobuffCNTL = 0;
    start = 0;
    mode = `PLOAD;

  end

  if (counter == 4'd8 && state = MISORESULT)
      misobuffCNTL = 1;
      mode = `LEFT;


  end
end
// at sclk posedge, check state, set the cases
