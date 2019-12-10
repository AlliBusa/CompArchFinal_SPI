module register8
#(parameter width = 4)
(
output reg	[width-1:0]q,
input		[width-1:0]d,
input		wrenable,
input		clk
);
    initial begin
    end
    always @(posedge clk) begin
        if(wrenable) begin
            q <= d;
        end
    end

endmodule
