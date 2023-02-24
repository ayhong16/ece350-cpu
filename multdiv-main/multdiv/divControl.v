module divControl(
    output [63:0] nextAQ,
    input [63:0] shiftedAQ,
    input [31:0] divisor
);
    wire sub, overflow, zeroDivisor;
    wire [31:0] flippedDivisor, selectedDivisor, nonZeroDivisor;
    not32 flip(flippedDivisor, divisor);
    assign sub = ~shiftedAQ[63];
    assign selectedDivisor = sub ? flippedDivisor : divisor;
    assign zeroDivisor = ~| divisor;
    assign nonZeroDivisor = zeroDivisor ? divisor : selectedDivisor;
    
    assign nextAQ[31:1] = shiftedAQ[31:1];
    cla_adder adder(nextAQ[63:32], overflow, shiftedAQ[63:32], nonZeroDivisor, sub);

    assign nextAQ[0] = ~nextAQ[63];

endmodule
