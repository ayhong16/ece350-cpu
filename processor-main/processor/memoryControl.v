module memoryControl(
    output data_we,
    input[31:0] insn
);
    wire rFlag, iFlag, j1Flag, j2Flag;
    wire[4:0] opcode;
    opccodeDecoder parse(opcode, rFlag, iFlag, j1Flag, j2Flag, insn);

    assign data_we = iFlag & (opcode == 5'b7);

endmodule