module executeControl(
    output[31:0] aluOut, PCafterJump,
    output adder_overflow, mult_exception, div_exception, ctrl_jump, overwriteReg31,
    input[31:0] dataRegA, dataRegB, insn, PC,
    input clock
);

    wire rFlag, iFlag, j1Flag, j2Flag, jumpFlag, jalFlag, jrFlag, targetFlag;
    wire[4:0] opcode, aluOpcode, shamt, jrReg;
    wire[26:0] target;
    wire [31:0] extendedTargetPC;
    opcodeDecoder parse(opcode, rFlag, iFlag, j1Flag, j2Flag, insn);
    assign aluOpcode = rFlag ? insn[6:2] : 5'b0;
    assign shamt = rFlag ? insn[11:7] : 5'b0;

    // Jump and link (j1 insn: only target)
    assign jalFlag = j1Flag && (opcode & 5'b00010);
    assign targetFlag = jalFlag || jumpFlag;

    // Jump and jump return (j1 insn: only target)
    assign jumpFlag = j1Flag && (opcode & 5'b00001);
    assign target = j1Flag ? insn[26:0] : 27'b0;
    signExtension27to32 signExtend27(extendedTargetPC, target);
    assign jrFlag = j2Flag && (opcode & 5'b00100);

    // R-type regular adding in ALU
    wire[31:0] selectedB;
    mux_2 regOrImmediate(selectedB, rFlag, immediate, dataRegB);

    // I-type sign extension for immediate
    wire[31:0] immediate;
    signExtension17to32 signExtend(immediate, insn[16:0]);

    // Determine next PC after a jump
    assign ctrl_jump = jalFlag || jumpFlag || jrFlag; // TODO: extra check for bex, bne, and blt
    assign overwriteReg31 = jalFlag;
    assign PCafterJump = dataRegA;

    // ALU
    wire isNotEqual, isLessThan;
    alu execute(dataRegA, selectedB, aluOpcode, shamt, aluOut, isNotEqual, isLessThan, adder_overflow, mult_exception, div_exception, clock);

endmodule