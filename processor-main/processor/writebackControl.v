module writebackControl(
    output ctrl_writeEnable,
    output[4:0] ctrl_writeReg,
    output[31:0] data_writeReg,
    input[31:0] dataFromDmem, dataFromAlu, insn
);
    wire rFlag, iFlag, j1Flag, j2Flag, ramOrAlu, lwFlag, swFlag;
    wire[4:0] opcode, aluOpcode;
    opccodeDecoder parse(opcode, rFlag, iFlag, j1Flag, j2Flag, insn);

    assign lwFlag = iFlag & (opcode == 5'b01000);
    assign swFlag = iFlag & (opcode == 5'b00111);
    assign ramOrAlu = lwFlag | swFlag;

    assign ctrl_writeEnable = rFlag | lwFlag;
    assign ctrl_writeReg = insn[26:22];

    mux_2 aluOrDMem(data_writeReg, ramOrAlu, dataFromAlu, dataFromDmem);

endmodule