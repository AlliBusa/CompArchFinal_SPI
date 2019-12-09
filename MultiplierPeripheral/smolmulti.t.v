`include "smolmulti.v"
`timescale 1ns/1ps

`define ASSERT_EQ(val, exp, msg) \
  if (val !== exp) $display("[FAIL] %s (got:b%b expected:b%b)", msg, val, exp);

module testSmolMulti();
  reg MOSI;
  reg SCLK;
  reg CLK;
  reg CS;
  wire MISO;
  reg passed =0;

  initial CLK=0;
  always #10 CLK = !CLK;

  initial SCLK =0;
  always #200 SCLK=!SCLK;

  SmolBoi multismol(.MOSI(MOSI),.SCLK(SCLK),.CLK(CLK),.CS(CS),.MISO(MISO));

  initial begin
    CS<=0;
  end

  initial begin
        $dumpfile("smolboi.vcd");
        $dumpvars();
  @(posedge SCLK);
    CS<=1;
  #400
  // Input A: 0001
  MOSI = 1'b0; #400
  MOSI = 1'b0; #400
  MOSI = 1'b0; #400
  MOSI = 1'b1; #400

  // Input B: 0110
  MOSI = 1'b0; #400
  MOSI = 1'b1; #400
  MOSI = 1'b1; #400
  MOSI = 1'b0; #400


  #1000000000
  // `ASSERT_EQ(MISO, 1'b0, "Failed"); #200
  if(MISO !== 0) begin
    $display("Failed, little boy.");
    passed = 1;
    $finish;
  end
  #200

  if(MISO !== 0) begin
    $display("Failed, little boy.");
    passed = 1;
    $finish;
  end
  #200

  if(MISO !== 0) begin
    $display("Failed, little boy.");
    passed = 1;
    $finish;
  end
  #200

  if(MISO !== 0) begin
    $display("Failed, little boy.");
    passed = 1;
    $finish;
  end
  #200

  if(MISO !== 0) begin
    $display("Failed, little boy.");
    passed = 1;
    $finish;
  end
  #200

  if(MISO !== 1) begin
    $display("Failed, little boy.");
    passed = 1;
    $finish;
  end
  #200

  if(MISO !== 1) begin
    $display("Failed, little boy.");
    passed = 1;
    $finish;
  end
  #200

  if(MISO !== 0) begin
    $display("Failed, little boy.");
    passed = 1;
    $finish;
  end
  #200
  // `ASSERT_EQ(MISO, 1'b0, "Failed"); #200
  // if(MISO == 1'b0)
  // `ASSERT_EQ(MISO, 1'b1, "Failed"); #200
  // `ASSERT_EQ(MISO, 1'b1, "Failed"); #200
  // `ASSERT_EQ(MISO, 1'b0, "Failed"); #200
  // `ASSERT_EQ(MISO, 1'b0, "Failed"); #200
  // `ASSERT_EQ(MISO, 1'b1, "Failed"); #200
  // `ASSERT_EQ(MISO, 1'b1, "Failed"); #200

  if (passed) $display("Failed.");
  #20 $finish;
  end
  endmodule
