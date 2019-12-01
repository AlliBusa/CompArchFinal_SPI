`include "datamemory.v"
`include "dflipflop.v"
`include "inputconditioner.v"
`include "LUT.v"

module baby
#(parameter width = 8)
(
  input miso,
  input address,
  output mosi,
  output reg sclk,
  output cs
);
 wire serialout, serialin, clk, memEnable, addressEnable,serial,serialEnable, misobuff;
 wire [width-1:0] parallelout,parallelin,dataout;
 wire [1:0] mode;

 initial sclk=0;
 always #100 sclk = !sclk;
 
 shiftregister8 #(width) schwifty (.clk(clk),.parallelOut(parallelout),.serialOut(serialout),.parallelIn(dataout),.mode(mode));

 testConditioner misoi (.clk(clk),.noisysignal(miso));

 testConditioner sclklk (.clk(clk),.noisysignal(sclk));

 datamemory memoi (.clk(clk),.dataOut(dataout),.address(),.writeEnable(memEnable),.dataIn(datain));

 register #(width) addressclk (.clk(clk),.q(address),.d(parallelOut),.wrenable(addressEnable));

 register #(1) addressclk (.clk(clk),.q(serial),.d(serialout),.wrenable(serialEnable));

 and (mosi,misobuff,serial);

 loot fsm(.clk(clk),.cs(cs),,modes(mode));
