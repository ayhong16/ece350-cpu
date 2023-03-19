module multdiv(
	input[31:0] data_operandA, data_operandB, 
	input ctrl_MULT, ctrl_DIV, clock, 
	output[31:0] data_result,
    output mult_data_exception, div_data_exception, data_resultRDY);

    // latch initial operands
    wire [31:0] latchedMultiplicandDividend, latchedMultiplierDivisor;
    register32 latchedMultiplicandDividendReg(latchedMultiplicandDividend, data_operandA, clock, 1'b1, 1'b0);
    register32 latchedMultiplierDivisorReg(latchedMultiplierDivisor, data_operandB, clock, 1'b1, 1'b0);

    // deal with resetting data
    wire dataReset, latchedMultOperation, latchedDivOperation;
    assign dataReset = ctrl_MULT | ctrl_DIV | resetCounter;
    register1 latchedMultOperationReg(latchedMultOperation, ctrl_MULT, clock, ctrl_DIV | ctrl_MULT, resetCounter);
    register1 latchedDivOperationReg(latchedDivOperation, ctrl_DIV, clock, ctrl_DIV | ctrl_MULT, resetCounter);


    // data exceptions
    wire mult_overflow, zerotoNonZero, Bis0, Ais0, resultIs0, signA, signB, signResult, multSignMismatch, multDataException, divDataException, data_exception;
    assign Bis0 = ~| latchedMultiplierDivisor;
    assign Ais0 = ~| latchedMultiplicandDividend;
    assign resultIs0 = ~| data_result;
    assign zerotoNonZero = (Bis0 | Ais0) & ~resultIs0;

    assign signA = latchedMultiplicandDividend[31];
    assign signB = latchedMultiplierDivisor[31];
    assign signResult = data_result[31];
    assign multSignMismatch = (~signA & ~signB & signResult) | (~signA & signB & ~signResult) | (signA & ~signB & ~signResult) | (signA & signB & signResult);
    assign multDataException = mult_overflow | zerotoNonZero | (multSignMismatch & ~Bis0 & ~Ais0);
    assign divDataException = Bis0;
    assign mult_data_exception = multDataException & latchedMultOperation;
    assign div_data_exception = divDataException & latchedDivOperation;
    assign data_exception = mult_data_exception || div_data_exception;

    // manage counter
    wire [5:0] count;
    wire resetCounter;
    counter64 counter(count, clock, 1'b1, dataReset);
    assign data_resultRDY = latchedMultOperation ? multReady : divReady;
    assign resetCounter = (multResetCounter & latchedMultOperation) | (divResetCounter & latchedDivOperation);

    // multiplier and divider
    wire multReady, multResetCounter, divReady, divResetCounter;
    wire [31:0] multResult, divResult, nonZeroDivisorResult;
    mult multiplication(multResult, mult_overflow, multReady, multResetCounter, latchedMultiplicandDividend, latchedMultiplierDivisor, clock, count);
    div division(nonZeroDivisorResult, divReady, divResetCounter, latchedMultiplicandDividend, latchedMultiplierDivisor, clock, count);
    assign divResult = Bis0 ? 32'b0 : nonZeroDivisorResult;

    assign data_result = latchedMultOperation ? multResult : divResult;
endmodule