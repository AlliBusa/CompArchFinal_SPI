// Top level module for SPI communication Smol Boi

module SmolBoi (
  input mosi,
  input sclk,
  input cs,
  output miso
  );

  //TODO make a clk

  wire MOSICon, PosEdge, NegEdge, Sout, MISOBuff;
  wire [7:0] Pin, Pout;

  shiftregister8 ShiftRegSmolBoi (.parallelOut(Pout),.clk(clk),.mode(),.parallelIn,.serialIn());
