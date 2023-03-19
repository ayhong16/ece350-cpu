module executeControl(
    output[31:0] PCafterJump, selectedB,
    output[4:0] aluOpcode, shiftAmt,
    output ctrl_branch, isMult, isDiv,
    input[31:0] dataRegA, dataRegB, insn, PC,
    input clock
);

    wire rFlag, iFlag, j1Flag, j2Flag, jumpFlag, jalFlag, jrFlag, targetFlag;
    wire[4:0] opcode, jrReg;
    // wire[26:0] target;
    // wire [31:0] extendedTargetPC;
    instructionType parse(opcode, rFlag, iFlag, j1Flag, j2Flag, insn);
    assign aluOpcode = rFlag ? insn[6:2] : 5'b0;
    assign shiftAmt = rFlag ? insn[11:7] : 5'b0;
    assign isMult = rFlag && (aluOpcode == 5'b00110);
    assign isDiv = rFlag && (aluOpcode == 5'b00111);

    // Jump and link (j1 insn: only target)
    assign jalFlag = j1Flag && (opcode & 5'b00010);
    // assign targetFlag = jalFlag || jumpFlag;

    // Jump and jump return (j1 insn: only target)
    assign jumpFlag = j1Flag && (opcode & 5'b00001);
    // assign target = j1Flag ? insn[26:0] : 27'b0;
    // signExtension27to32 signExtend27(extendedTargetPC, target);
    assign jrFlag = j2Flag && (opcode & 5'b00100);

    // R-type regular adding in ALU
    wire[31:0] selectedB;
    mux_2 regOrImmediate(selectedB, rFlag, immediate, dataRegB);

    // I-type sign extension for immediate
    wire[31:0] immediate;
    signExtension17to32 signExtend(immediate, insn[16:0]);

    // Determine next PC after a jump
    assign ctrl_branch = jalFlag || jumpFlag || jrFlag; // TODO: extra check for bex, bne, and blt
    // assign PCafterJump = dataRegA;

endmodule