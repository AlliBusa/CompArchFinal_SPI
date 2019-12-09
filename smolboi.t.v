`include "smolboi.v"

`define ASSERT_EQ(val, exp, msg) \
  if (val !== exp) $display("[FAIL] %s (got:0b%b expected:0b%b)", msg, val, exp);

module smolboi_test ();

  reg MOSI;
  reg SCLK;
  reg CLK;
  reg CS;
  wire MISO;
  reg passed =0;
  reg [2:0] state=0;

  initial CLK=0;
  always #10 CLK = !CLK;

  initial SCLK =0;
  always #100 SCLK=!SCLK;

  SmolBoi smolboi(.MOSI(MOSI),.SCLK(SCLK),.CLK(CLK),.CS(CS),.MISO(MISO));

  initial begin
        $dumpfile("smolboi.vcd");
        $dumpvars();

		 state = 3'd0;
  CS = 0;
		 MOSI = 1'b0;

  // Input addr: 0(RW) + 1010101
		 state = 3'd3;
  MOSI = 1'b0; #200
  MOSI = 1'b1; #200
  MOSI = 1'b0; #200
  MOSI = 1'b1; #200
  MOSI = 1'b0; #200
  MOSI = 1'b1; #200
  MOSI = 1'b0; #200
  MOSI = 1'b1; #200
		state = 3'd2; #200

  // Input number: 00110011
		state = 3'd4;
  MOSI = 1'b0; #200
  MOSI = 1'b0; #200
  MOSI = 1'b1; #200
  MOSI = 1'b1; #200
  MOSI = 1'b0; #200
  MOSI = 1'b0; #200
  MOSI = 1'b1; #200
  MOSI = 1'b1; #200
		state = 3'd0; #200

  // Input addr: 1(RW) + 1010101
			state = 3'd3;
  MOSI = 1'b1; #200
  MOSI = 1'b1; #200
  MOSI = 1'b0; #200
  MOSI = 1'b1; #200
  MOSI = 1'b0; #200
  MOSI = 1'b1; #200
  MOSI = 1'b0; #200
  MOSI = 1'b1; #200
		state = 3'd2; #200
		 state = 3'd1; #200
		 state = 3'd4; #400

  // `ASSERT_EQ(MISO, 1'b0, "Failed"); #200
  if(MISO !== 1'b0) begin
    $display("Failed, little boy: 0.");
		$display("MISO: %b", MISO);
    // $display("MISO:");
    passed = 1;
    // $finish;
  end
  #200

  if(MISO !== 1'b0) begin
    $display("Failed, little boy: 1.");
		$display("MISO: %b", MISO);
    passed = 1;
    // $finish;
  end
  #200

  if(MISO !== 1'b1) begin
    $display("Failed, little boy: 2.");
		$display("MISO: %b", MISO);
    passed = 1;
    // $finish;
  end
  #200

  if(MISO !== 1'b1) begin
    $display("Failed, little boy: 3.");
		$display("MISO: %b", MISO);
    passed = 1;
    // $finish;
  end
  #200

  if(MISO !== 1'b0) begin
    $display("Failed, little boy: 4.");
		$display("MISO: %b", MISO);
    passed = 1;
    // $finish;
  end
  #200

  if(MISO !== 1'b0) begin
    $display("Failed, little boy: 5.");
		$display("MISO: %b", MISO);
    passed = 1;
    // $finish;
  end
  #200

  if(MISO !== 1'b1) begin
    $display("Failed, little boy: 6.");
		$display("MISO: %b", MISO);
    passed = 1;
    // $finish;
  end
  #200

  if(MISO !== 1'b1) begin
    $display("Failed, little boy: 7.");
		$display("MISO: %b", MISO);
    passed = 1;
    // $finish;
  end
		 #200
		 $display("MISO: %b", MISO);
		 #200
		 $display("MISO: %b", MISO);
		 #200
		 $display("MISO: %b", MISO);
		 #200
		 $display("MISO: %b", MISO);
		 #200
		 $display("MISO: %b", MISO);
  #800
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
