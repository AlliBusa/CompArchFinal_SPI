//------------------------------------------------------------------------
// Shift Register
//   Parameterized width (in bits)
//   Shift register has multiple behaviors based on mode signal:
//     00 - hold current state
//     01 - shift right: serialIn becomes the new MSB, LSB is dropped
//     10 - shift left:  serialIn becomes the new LSB, MSB is dropped
//     11 - parallel load: parallelIn replaces entire shift register contents
//
//   All updates to shift register state occur on the positive edge of clk
//------------------------------------------------------------------------

`include "Multiplier/shiftregmodes.v"

module shiftregister
#(parameter width = 8)
(
  output [width-1:0]  parallelOut,
  input               clk,
  input [1:0]         mode,
  input [width-1:0]   parallelIn,
  input               serialIn
);

    // Register to hold current shift register value
    // Initial value set to "width" bits of zeros using Verilog repetition operator
    reg [width-1:0]  memory={width{1'b0}};

    assign parallelOut = memory;

    always @(posedge clk) begin
        case (mode)
          `HOLD:  begin memory <= memory; end
          `LEFT:  begin memory <= {memory[width-2:0], serialIn}; end
          `RIGHT:  begin memory <= {serialIn, memory[width-1:1]}; end
          `PLOAD:  begin memory <= parallelIn; end
        endcase
    end
endmodule
