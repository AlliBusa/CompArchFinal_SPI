// Shift register has multiple behaviors based on mode signal:
//     00 - hold current state
//     01 - shift right: serialIn becomes the new MSB, LSB is dropped
//     10 - shift left:  serialIn becomes the new LSB, MSB is dropped
//     11 - parallel load: parallelIn replaces entire shift register contents

// This file uses an "include guard" (common in languages like C and Verilog
// that use a pre-processor) to prevent its contents from being defined
// multiple times (which causes an error) when imported from multiple places
// within a project.

// If this is the first time the file is included, the symbol SHIFTREGMODES_V
// will not be defined (must choose a unique symbol per file).

// Subsequent times the file is included, this symbol WILL be defined
// and the body of the ifndef...endif will not run.
`ifndef SHIFTREGMODES_V
`define SHIFTREGMODES_V

// Start of include contents
`define HOLD   2'b00
`define RIGHT   2'b01
`define LEFT  2'b10
`define PLOAD  2'b11

`endif // Ends ifndef SHIFTREGMODES_V block
