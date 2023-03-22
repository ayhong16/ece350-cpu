module executeControl(
    output[31:0] PCafterJump, selectedA, selectedB,
    output[4:0] aluOpcode, shiftAmt,
    output ctrl_branch, isMult, isDiv, isBLT, isBNE,
    input[31:0] dataRegA, dataRegB, insn, PC,
    input clock
);

    wire rFlag, iFlag, j1Flag, j2Flag, overwriteReg31, compBranchFlag;
    wire[4:0] opcode, jrReg;
    instructionType parse(opcode, rFlag, iFlag, j1Flag, j2Flag, insn);
    assign aluOpcode = rFlag ? insn[6:2] : 5'b0;
    assign shiftAmt = rFlag ? insn[11:7] : 5'b0;
    assign isMult = rFlag && (aluOpcode == 5'b00110);
    assign isDiv = rFlag && (aluOpcode == 5'b00111);

    // R-type regular adding in ALU
    wire[31:0] selectedB;
    assign selectedB = rFlag ? dataRegB : (overwriteReg31 ? 32'b0 : immediate);
    assign selectedA = (overwriteReg31 || compBranchFlag) ? PC : dataRegA;

    // I-type sign extension for immediate
    wire[31:0] immediate;
    signExtension17to32 signExtend(immediate, insn[16:0]);

    assign compBranchFlag = isBLT || isBNE;
    branchControl branch(PCafterJump, ctrl_branch, overwriteReg31, isBLT, isBNE, iFlag, j1Flag, j2Flag, insn, dataRegA, PC);

endmodule