`include "datamemory.v"
`include "shiftregister.v"
`include "inputconditioner.v"

//------------------------------------------------------------------------
// SPI Memory
//------------------------------------------------------------------------

module spiMemory
(
    input           clk,        // FPGA clock
    input           sclk_pin,   // SPI clock
    input           cs_pin,     // SPI chip select
    output          miso_pin,   // SPI master in slave out
    input           mosi_pin,   // SPI master out slave in
    // output [3:0]    leds        // LEDs for debugging //TODO add back later
)

wire sin, mem_en,mosi,sclk,cs,sout
wire [6:0] mem_addr, save_data;
wire [7:0] reg_to_mem, mem_to_reg



shiftregister bee (#8)(.clk(clk), .peripheralClkEdge())


endmodule
