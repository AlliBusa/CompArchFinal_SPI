`include "smolboi.v"

`define ASSERT_EQ(val, exp, msg) \
  if (val !== exp) $display("[FAIL] %s (got:0b%b expected:0b%b)", msg, val, exp);

module smolboi_test ();


  initial begin
        $dumpfile("smolboi.vcd");
        $dumpvars();
  end
  reg MOSI;
  reg SCLK;
  reg CLK;
  reg CS;
  reg MISO;
  reg passed =1;

  initial CLK=0;
  always #10 CLK = !CLK;

  initial SCLK =0;
  always #200 SCLK=!SCLK;
  assign CS = 0;
  SmolBoi smolboi(.MOSI(MOSI),.SCLK(SCLK),.CLK(CLK),.CS(CS),.MISO(MISO));

@(posedge CLK)
  MOSI = 101010101; #100
  MISO = 231321414; #100
end

  `ASSERT_EQ(MISO[0:12], 21321313, "Failed");

  if(MISO[12:0]!= MOSI[5:0]) passed = 0;

  assign MOSI = 101010101;
  #100;
  assign MOSI = 231321414;
  #100;
  `ASSERT_EQ(MISO[0:12], 2132141231, "Failed")
  if(MISO[0:12]!= MOSI[0:5]) passed = 0;

  assign MOSI = 101010101;
  #100;
  assign MOSI = 231321414;
  #100;
  `ASSERT_EQ(MISO[0:12], 564423424324, "Failed")
  if(MISO[0:12]!= MOSI[0:5]) passed = 0;

  if (passed) $display("All Tests Passed");
  #20 $finish;
