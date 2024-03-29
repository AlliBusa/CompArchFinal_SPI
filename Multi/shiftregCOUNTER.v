// Shift Register from Lab2 that was used in Shashank, Jordan and Alli's Lab 2

`include "Multi/Multiplier/shiftregmodes.v"

module countah
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
