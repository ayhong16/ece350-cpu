module div(
    output[31:0] result,
    output overflow,
    output resultReady,
    output resetCounter,
    input [31:0] dividend,
    input [31:0] divisor,
    input clock,
    input [5:0] count
);
    wire start = ~count[0] & ~count[1] & ~count[2] & ~count[3] & ~count[4] & ~count[5];
    wire resultReady = ~count[0] & ~count[1] & ~count[2] & ~count[3] & ~count[4] & count[5];
    assign resetCounter = count[0] & ~count[1] & ~count[2] & ~count[3] & ~count[4] & count[5];

    wire dividendSign, divisorSign;
    register1 latchedDividendSign(dividendSign, dividend[31], clock, start, resetCounter);
    register1 latchedDivisorSign(divisorSign, divisor[31], clock, start, resetCounter);

    // Flip dividend and divisor if negative
    wire [31:0] chosenDividend, chosenDivisor, twosDividend, twosDivisor;
    wire dividendOverflow, divisorOverflow;
    twosComp32 initialtwosDividendMod(twosDividend, dividendOverflow, dividend);
    twosComp32 initialtwosDivisorMod(twosDivisor, divisorOverflow, divisor);
    assign chosenDividend = dividendSign ? twosDividend : dividend;
    assign chosenDivisor = divisorSign ? twosDivisor : divisor;
    assign overflow = (dividendOverflow & dividendSign) | (divisorOverflow & divisorSign) | unaryOverflow;

    wire [63:0] initialAQ, shiftedAQ, nextAQ, selectedAQ;
    assign initialAQ [63:32] = 32'b0;
    assign initialAQ [31:0] = chosenDividend[31:0];

    assign selectedAQ = start ? initialAQ << 1 : nextAQ << 1;
    register64 afterShift(shiftedAQ, selectedAQ, clock, 1'b1, resetCounter);
    divControl control(nextAQ, shiftedAQ, chosenDivisor);

    // Make quotient and remainder negative if necessary
    wire [31:0] intermediateResult;
    wire isPositive, unaryOverflow;
    assign isPositive = (~dividendSign & ~divisorSign) | (dividendSign & divisorSign);
    twosComp32 twosResultMod(intermediateResult, unaryOverflow, nextAQ[31:0]);
    assign result = isPositive ? intermediateResult : nextAQ[31:0];

endmodule