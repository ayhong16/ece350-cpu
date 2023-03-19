module writebackControl(
    output ctrl_writeEnable,
    output[4:0] ctrl_writeReg,
    output[31:0] data_writeReg,
    input[31:0] dataFromDmem, dataFromAlu, insn
);
    wire rFlag, iFlag, j1Flag, j2Flag, ramOrAlu, lwFlag, swFlag, addiFlag;
    wire[4:0] opcode, aluOpcode;
    instructionType parse(opcode, rFlag, iFlag, j1Flag, j2Flag, insn);

    wire w0, w1, w2, w3, w4;
    assign w0 = opcode[0];
    assign w1 = opcode[1];
    assign w2 = opcode[2];
    assign w3 = opcode[3];
    assign w4 = opcode[4];

    assign lwFlag = iFlag & ~w4 & w3 & ~w2 & ~w1 & ~w0;
    assign swFlag = iFlag & ~w4 & ~w3 & w2 & w1 & w0;
    assign addiFlag = iFlag & ~w4 & ~w3 & w2 & ~w1 & w0;
    assign ramOrAlu = lwFlag | swFlag;

    assign ctrl_writeEnable = rFlag | lwFlag | addiFlag;
    assign ctrl_writeReg = insn[26:22];

    mux_2 aluOrDMem(data_writeReg, ramOrAlu, dataFromAlu, dataFromDmem);

endmodule