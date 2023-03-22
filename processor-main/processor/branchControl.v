module branchControl(
    output[31:0] PCafterJump,
    output ctrl_branch,
    input iFlag, j1Flag, j2Flag,
    input[31:0] insn, data_readRegA, PC
);
    wire jumpFlag, jalFlag, jrFlag;
    wire[4:0] opcode;
    assign opcode = insn[31:27];
    assign jalFlag = j1Flag && (opcode & 5'b00010);
    assign jrFlag = j2Flag && (opcode & 5'b00100);
    assign jumpFlag = j1Flag && (opcode & 5'b00001);
    assign ctrl_branch = jalFlag || jumpFlag || jrFlag; // TODO: extra check for bex, bne, and blt

    assign PCafterJump = jrFlag ? data_readRegA : PC;

endmodule
