module multdiv(
	data_operandA, data_operandB, 
	ctrl_MULT, ctrl_DIV, 
	clock, 
	data_result, data_exception, data_resultRDY);

    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;

    wire dataReset;
    assign dataReset = 1'b0;
    mult multiplication(data_result, data_resultRDY, data_operandA, data_operandB, dataReset, clock);


endmodule