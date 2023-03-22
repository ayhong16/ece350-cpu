module executeControl(
    output[31:0] PCafterJump, selectedB,
    output[4:0] aluOpcode, shiftAmt,
    output ctrl_branch, isMult, isDiv,
    input[31:0] dataRegA, dataRegB, insn, PC,
    input clock
);

    wire rFlag, iFlag, j1Flag, j2Flag;
    wire[4:0] opcode, jrReg;
    instructionType parse(opcode, rFlag, iFlag, j1Flag, j2Flag, insn);
    assign aluOpcode = rFlag ? insn[6:2] : 5'b0;
    assign shiftAmt = rFlag ? insn[11:7] : 5'b0;
    assign isMult = rFlag && (aluOpcode == 5'b00110);
    assign isDiv = rFlag && (aluOpcode == 5'b00111);

    // R-type regular adding in ALU
    wire[31:0] selectedB;
    mux_2 regOrImmediate(selectedB, rFlag, immediate, dataRegB);

    // I-type sign extension for immediate
    wire[31:0] immediate;
    signExtension17to32 signExtend(immediate, insn[16:0]);

    branchControl branch(PCafterJump, ctrl_branch, iFlag, j1Flag, j2Flag, insn, dataRegA, PC);

endmodule