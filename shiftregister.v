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

`include "shiftregmodes.v"//include modes module so that we an reference these modes as words instead of bits in the code

module shiftregister8
#(parameter width = 8)
(
  output [width-1:0]  parallelOut,//output/result
  input               clk,
  input [1:0]         mode,//will it pload?shift right? etc.
  input [width-1:0]   parallelIn,//input value/ the string to shift
  input               serialIn//what value should we put in all the new spaces created during the shift?
);

    // Register to hold current shift register value
    // Initial value set to "width" bits of zeros using Verilog repetition operator
    reg [width-1:0]  memory={width{1'b0}};

    assign parallelOut = memory;

    always @(posedge clk) begin
        case (mode)
            `HOLD:  begin memory <= memory[width-1:0]; end //mantains what it currently has in memory
            `LEFT:  begin memory <= {memory[width-2:0], serialIn}; end //shift string to the left, fill new spaces with zeroes
            `RIGHT:  begin memory <= {serialIn,memory[width-1:1]}; end //sift string to right, fill new spaces with zeroes
            `PLOAD:  begin memory <= parallelIn; end //load in a new value that is coming in as parallelIn into the shiftreg
        endcase
    end
endmodule
