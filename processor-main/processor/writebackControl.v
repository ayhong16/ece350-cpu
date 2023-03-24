module writebackControl(
    output ctrl_writeEnable,
    output[4:0] ctrl_writeReg,
    output[31:0] data_writeReg, exceptionData,
    input exception,
    input[31:0] dataFromDmem, dataFromAlu, insn
);
    wire rFlag, iFlag, j1Flag, j2Flag, useRamData, lwFlag, swFlag, addiFlag, jalFlag, specifiedWriteReg, setxFlag;
    wire[4:0] opcode, aluOpcode;
    instructionType parse(opcode, rFlag, iFlag, j1Flag, j2Flag, insn);

    assign lwFlag = iFlag && (opcode == 5'b01000);
    assign swFlag = iFlag && (opcode == 5'b00111);
    assign addiFlag = iFlag && (opcode == 5'b00101);
    assign jalFlag = j1Flag && (opcode == 5'b00011);
    assign setxFlag = j1Flag && (opcode == 5'b10101);
    assign useRamData = lwFlag || swFlag;

    assign specifiedWriteReg = rFlag || lwFlag || addiFlag;
    assign ctrl_writeEnable = rFlag || lwFlag || addiFlag || jalFlag || setxFlag || exception;
    assign ctrl_writeReg = exception ? 5'b11110 : (specifiedWriteReg ? insn[26:22] : (jalFlag ? 5'b11111 : (setxFlag ? 5'b11110 : 5'b0)));

    // Overwrite if exception exists
    wire[31:0] dataFromAluOrRam;
    wire addExceptionFlag, addiExceptionFlag, subExceptionFlag, multExceptionFlag, divExceptionFlag;
    assign aluOpcode = insn[6:2];
    assign addExceptionFlag = rFlag & aluOpcode == 5'b0 & exception;
    assign addiExceptionFlag = addiFlag & exception;
    assign subExceptionFlag = rFlag & aluOpcode == 5'b00001 & exception;
    assign multExceptionFlag = rFlag & aluOpcode == 5'b00110 & exception;
    assign divExceptionFlag = rFlag & aluOpcode == 5'b00111 & exception;
    assign exceptionData = addExceptionFlag ? 32'd1 : (addiExceptionFlag ? 32'd2 : (subExceptionFlag ? 32'd3 : (multExceptionFlag ? 32'd4 : (divExceptionFlag ? 32'd5 : 32'd0))));

    mux_2 aluOrDMem(dataFromAluOrRam, useRamData, dataFromAlu, dataFromDmem);
    assign data_writeReg = exception ? exceptionData : dataFromAluOrRam;

endmodule