module branchControl(
    output[31:0] PCafterJump,
    output ctrl_branch, overwriteReg31, isBLT, isBNE, isBEX, isSETX,
    input iFlag, j1Flag, j2Flag,
    input[31:0] insn, data_readRegA, PC
);
    wire jumpFlag, jalFlag, jrFlag, comparisonBranchFlag;
    wire[4:0] opcode;
    assign opcode = insn[31:27];
    assign jalFlag = j1Flag && (opcode & 5'b00011);
    assign jrFlag = j2Flag && (opcode & 5'b00100);
    assign jumpFlag = j1Flag && (opcode & 5'b00001);
    assign isBLT = iFlag && (opcode == 5'b00110);
    assign isBNE = iFlag && (opcode == 5'b00010);
    assign isBEX = j1Flag && (opcode == 5'b10110);
    assign isSETX = j1Flag && (opcode == 5'b10101);
    assign ctrl_branch = jalFlag || jumpFlag || jrFlag; // TODO: extra check for bex, bne, and blt

    wire[26:0] target;
    wire[31:0] extendedTarget;
    assign target = insn[26:0];
    signExtension27to32 signExtend(extendedTarget, target);

    assign PCafterJump = jrFlag ? data_readRegA : ((jalFlag || jumpFlag || isBEX || isSETX) ? extendedTarget : PC);
    assign overwriteReg31 = jalFlag;

endmodule
