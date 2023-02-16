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
    assign dataReset = ctrl_MULT | ctrl_DIV;

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
    assign data_exception = mult_overflow | zerotoNonZero | signMismatch;

    // manage counter
    wire [3:0] count;
    counter16 counter(count, clock, 1'b1, dataReset);
    assign data_resultRDY = count[0] & count[1] & count[2] & count[3];

    mult multiplication(data_result, mult_overflow, latchedMultiplicand, latchedMultiplier, dataReset, clock, count);

endmodule