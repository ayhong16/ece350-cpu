module multdiv(
	data_operandA, data_operandB, 
	ctrl_MULT, ctrl_DIV, 
	clock, 
	data_result, data_exception, data_resultRDY);

    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;

    // latch initial operands
    wire [31:0] latchedMultiplicand, latchedMultiplier;
    register32 latchedMultiplicandReg(latchedMultiplicand, data_operandA, clock, 1'b1, 1'b0);
    register32 latchedMultiplierReg(latchedMultiplier, data_operandB, clock, 1'b1, 1'b0);

    // deal with resetting data
    wire dataReset;
    assign dataReset = ctrl_MULT | ctrl_DIV | multResetCounter;

    // data exceptions
    wire mult_overflow, zerotoNonZero, Bis0, Ais0, resultIs0, signA, signB, signResult, signMismatch;
    assign Bis0 = ~| latchedMultiplier;
    assign Ais0 = ~| latchedMultiplicand;
    assign resultIs0 = ~| data_result;
    assign zerotoNonZero = (Bis0 | Ais0) & ~resultIs0;

    assign signA = latchedMultiplicand[31];
    assign signB = latchedMultiplier[31];
    assign signResult = data_result[31];
    assign signMismatch = (~signA & ~signB & signResult) | (~signA & signB & ~signResult) | (signA & ~signB & ~signResult) | (signA & signB & signResult);
    assign data_exception = mult_overflow | zerotoNonZero | (signMismatch & ~Bis0 & ~Ais0);

    // manage counter
    wire [4:0] count;
    wire resetCounter;
    counter32 counter(count, clock, 1'b1, dataReset);
    assign data_resultRDY = multReady;
    assign resetCounter = multResetCounter;

    // multiplier
    wire multReady, multResetCounter;
    mult multiplication(data_result, mult_overflow, multReady, multResetCounter, latchedMultiplicand, latchedMultiplier, clock, count);
endmodule