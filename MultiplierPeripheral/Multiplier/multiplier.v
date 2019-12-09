//------------------------------------------------------------------------
// Sequential multiplier
//------------------------------------------------------------------------
`include "Multiplier/shiftreg.v"
`include "Multiplier/shiftregmodes.v"
`include "Multiplier/multiplexer.v"
`include "Multiplier/adder.v"
module register8
#(parameter width = 4)
(
output reg	[width-1:0]q,
input		[width-1:0]d,
input		wrenable,
input		clk
);
    initial begin
    end
    always @(posedge clk) begin
        if(wrenable) begin
            q <= d;
        end
    end

endmodule

module multiplier
#(parameter width = 4)
(
  output [2*width-1:0]  res,   // Final result, valid when "done" is true
  output  reg               done,  // High for one cycle when result is valid/complete
  input  [width-1:0]    A, B,  // Inputs to be multiplied
  input                 clk,   // Output transitions synchronized to posedge
  input                 start  // High for one cycle when inputs A and B are valid, initiates multiplication sequence
);
  

  localparam  START = 2'b00;
  localparam  ADD = 2'b01;
  localparam  SHIFT = 2'b10;
  localparam  WAIT = 2'b11;
  reg [1:0] state = WAIT;
  wire [2*width-1:0] temp;


  reg add = 0; // enable add
  reg waiting = 1; // waiting state
  reg[1:0] SHIFTA; // operation for shift A
  reg[1:0] SHIFTB; // operation for shift B
  reg[1:0] SHIFTstate; // operation for state register
  reg [width:0] startinput={{(width+1){1'b0}},1'b1}; // the initial value for the counter

  wire [(2*width)-1:0]next_add;
  wire [(2*width)-1:0]sum;


  wire[(2*width)-1:0] AshiftedOutput; // output of register A
  wire[(2*width)-1:0] BshiftedOutput; //output of register B
  wire[width:0] StateRegOutput; // output of state register

  // initializing the registers
  shiftregister #(.width(width*2)) shiftAregister(.parallelOut(AshiftedOutput), .clk(clk), .mode(SHIFTA), .parallelIn({{width{1'b0}}, A}), .serialIn(1'b0));
  shiftregister #(.width(width*2)) shiftBregister(.parallelOut(BshiftedOutput), .clk(clk), .mode(SHIFTB), .parallelIn({{width{1'b0}}, B}), .serialIn(1'b0));

  shiftregister #(.width(width+1)) shiftSTATEregister (.parallelOut(StateRegOutput), .clk(clk), .mode(SHIFTstate), .parallelIn(startinput), .serialIn(1'b0));

  adder #(.width(2*width)) adding(.out(temp),.in0(next_add),.in1(res));
  //register8 #(.width(width*2)) Mregister(.q(res), .clk(clk), .d(mid), .wrenable(1));
  register8 #(.width(width*2)) Sregister(.q(res), .clk(clk), .d(sum), .wrenable(add));
  muxnto1byn #(.width(width*2)) starter(.address(start),.input0(temp),.input1({(2*width){1'b0}}),.out(sum));
  muxnto1byn #(.width(width*2))  decider(.address(BshiftedOutput[0]),.input0({(2*width){1'b0}}),.input1(AshiftedOutput),.out(next_add));

// at the positive edge of the clock, check for certain conditions
// if conditions are true, go to certain state
  always @(posedge clk) begin
    if (start==1 && waiting==1) begin
      state <= START;
    end
    if (add==1 && waiting==0 && done==0) begin
      state <= ADD;
    end
    else if (add==0 && done==0 && waiting==0) begin
      state <= SHIFT;
    end
    else if (add==0 && done==1) begin
      state <= WAIT;
    end
  end

  //Logic when state is set
  always @(state) begin
    case (state)

      START: begin
        waiting = 0;
        SHIFTA = `PLOAD;
        SHIFTB = `PLOAD;
        SHIFTstate = `PLOAD;
        add = 1;
      end

      ADD: begin
        SHIFTA = `HOLD;
        SHIFTB = `HOLD;
        SHIFTstate = `HOLD;
        done = StateRegOutput[width];
        add = 0;
      end

      SHIFT: begin
        SHIFTA = `LEFT;
        SHIFTB = `RIGHT;
        SHIFTstate = `LEFT;
        add=1;
      end

      WAIT: begin
        waiting=1;
        add=1;
        done =0;

      end
    endcase
    end

endmodule
