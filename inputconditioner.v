//------------------------------------------------------------------------
// Input Conditioner
//    1) Synchronizes input to clock domain
//    2) Debounces input
//    3) Creates pulses at edge transitions
//------------------------------------------------------------------------

module inputconditioner
(
input 	    clk,            // Clock domain to synchronize input to
input	    noisysignal,    // (Potentially) noisy input signal
output reg  conditioned,    // Conditioned output signal
output reg  positiveedge,   // 1 clk pulse at rising edge of conditioned
output reg  negativeedge,    // 1 clk pulse at falling edge of conditioned

output reg synchronizer0UT,
output reg synchronizer1OUT
);

    parameter counterwidth = 3; // Counter size, in bits, >= log2(waittime)
    parameter waittime = 3;     // Debounce delay, in clock cycles

    reg[counterwidth-1:0] counter = 0;
    reg synchronizer0 = 0;
    reg synchronizer1 = 0;

    always @(posedge clk ) begin
        if(conditioned == synchronizer1) begin
            counter <= 0; // reset the counter
            positiveedge <= 0; // reset the pos edge
        end

        else begin
            if( counter == waittime and conditioned != 1) begin // after timeout
                //counter <= 0; // reset counter
                //conditioned <= synchronizer1; // output the signal
                positiveedge <= 1; // trigger pos edge for one clk cycle

            end
            else if (counter == waittime and conditioned == 1) begin
            counter <= 0; // reset counter
            conditioned <= synchronizer1; // output the signal
            end
            else
                counter <= counter+1;
                positiveedge <= 0;

        end

        synchronizer0 <= noisysignal;
        synchronizer1 <= synchronizer0;
        synchronizer0UT <= synchronizer0 ;
        synchronizer1OUT <= synchronizer1;
    end
    always @(negedge clk) begin
      if(conditioned == 1 and counter == waittime)
        negativeedge <= 1;
        positiveedge <= 0;
        end

endmodule
