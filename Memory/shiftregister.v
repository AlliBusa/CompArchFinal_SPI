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

`include "Memory/shiftregmodes.v"//include modes module so that we an reference these modes as words instead of bits in the code

module shiftregister8
// #(parameter width = 8)
(
  output [7:0]  parallelOut,//output/result
  output          serialOut,
  input               clk,
  input               serialClkposedge,
  input [1:0]         mode,//will it pload?shift right? etc.
  input [7:0]   parallelIn,//input value/ the string to shift
  input               serialIn//what value should we put in all the new spaces created during the shift?
);
reg [7:0] memory;
    // Register to hold current shift register value
    // Initial value set to "width" bits of zeros using Verilog repetition operator
    initial begin
      memory=8'b0;
    end

    assign parallelOut = memory;
    assign serialOut = memory[7];

    always @(posedge clk) begin
          if (serialClkposedge == 1) begin
          case (mode)
              `HOLD:  begin memory <= memory[7:0];//mantains what it currently has in memory
                      // assign serialOut = memory[7];
                      end
              `LEFT:  begin memory <= {memory[6:0], serialIn}; //shift string to the left, fill new spaces with zeroes
                      // assign serialOut = memory[width-2];
                      end
              `RIGHT:  begin memory <= {serialIn,memory[7:1]};  //sift string to right, fill new spaces with zeroes
                      // assign serialOut = memory[serialIn];
                      end
              `PLOAD:  begin memory <= parallelIn;  //load in a new value that is coming in as parallelIn into the shiftreg
                      // assign serialOut = memory[width-1];
                      end
          endcase
          // serialOut = memory[7];
        end
    end
endmodule

module shiftregister9
// #(parameter width = 8)
(
  output [8:0]  parallelOut,//output/result
  output          serialOut,
  input               clk,
  input               serialClkposedge,
  input [1:0]         mode,//will it pload?shift right? etc.
  input [8:0]   parallelIn,//input value/ the string to shift
  input               serialIn//what value should we put in all the new spaces created during the shift?
);
reg [8:0] memory;
	 wire [1:0] tricks;
    // Register to hold current shift register value
    // Initial value set to "width" bits of zeros using Verilog repetition operator
    initial begin
      memory=9'b0;
    end

    assign parallelOut = memory;
    assign serialOut = memory[8];
	 assign tricks = mode;

    always @(posedge clk) begin
       case (tricks)
         `HOLD:  begin memory <= memory[8:0];
         end
         `LEFT:  begin
						if (serialClkposedge == 1) begin
							 memory <= {memory[7:0], serialIn};
						end
         end
         `RIGHT:  begin
						if (serialClkposedge == 1) begin
							 memory <= {serialIn,memory[8:1]};
						end
         end
         `PLOAD:  begin memory <= parallelIn;
         end
       endcase // case (mode)
    end
endmodule
