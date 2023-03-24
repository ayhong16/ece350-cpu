module memoryControl(
    output data_we,
    output[31:0] exceptionData,
    input exception,
    input[31:0] insn
);
    wire rFlag, iFlag, j1Flag, j2Flag;
    wire[4:0] opcode, aluOpcode;
    instructionType parse(opcode, rFlag, iFlag, j1Flag, j2Flag, insn);

    wire addExceptionFlag, addiExceptionFlag, subExceptionFlag, multExceptionFlag, divExceptionFlag;
    assign aluOpcode = insn[6:2];
    assign addExceptionFlag = rFlag & aluOpcode == 5'b0 & exception;
    assign addiExceptionFlag = iFlag & opcode == 5'b00101 & exception;
    assign subExceptionFlag = rFlag & aluOpcode == 5'b00001 & exception;
    assign multExceptionFlag = rFlag & aluOpcode == 5'b00110 & exception;
    assign divExceptionFlag = rFlag & aluOpcode == 5'b00111 & exception;
    assign exceptionData = addExceptionFlag ? 32'd1 : (addiExceptionFlag ? 32'd2 : (subExceptionFlag ? 32'd3 : (multExceptionFlag ? 32'd4 : (divExceptionFlag ? 32'd5 : 32'd0))));

    assign data_we = iFlag & (opcode == 5'b00111);

endmodule