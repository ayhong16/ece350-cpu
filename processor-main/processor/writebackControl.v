module writebackControl(
    output ctrl_writeEnable,
    output[4:0] ctrl_writeReg,
    output[31:0] data_writeReg,
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
    assign ctrl_writeEnable = rFlag || lwFlag || addiFlag || jalFlag || setxFlag;
    assign ctrl_writeReg = specifiedWriteReg ? insn[26:22] : (jalFlag ? 5'b11111 : (setxFlag ? 5'b11110 : 5'b0));

    mux_2 aluOrDMem(data_writeReg, useRamData, dataFromAlu, dataFromDmem);

endmodule