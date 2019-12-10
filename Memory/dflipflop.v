// Single-bit D Flip-Flop with enable
//   Positive edge triggered

module registerDFF
(
output reg	q,
input		d,
input		wrenable,
input		clk
);

    always @(posedge clk) begin
        if(wrenable) begin
            q <= d;
        end
    end

endmodule

module register8
(
output reg [7:0] q,
input       [7:0] d,
input       wrenable,
input       clk
);
//genvar i;
//generate
//for (i=0;i<32;i=i+1)begin
    always @(posedge clk) begin
        if(wrenable) begin
            q<= d;
        end
    end
  //  end
endmodule

// module registerDFF8
// #(parameter width =8),
// )
// (
// output reg	[width-1:0] q,
// input [width-1:0]		d,
// input		wrenable,
// input		clk
// );
//
//     always @(posedge clk) begin
//         if(wrenable) begin
//             q <= d;
//         end
//     end
//
// endmodule
