module decodeControl(
	output [4:0] ctrl_readRegA, ctrl_readRegB,
    input [31:0] insn
);
    wire rFlag, iFlag, j1Flag, j2Flag, swFlag, branchI, bexFlag;
    wire[4:0] opcode;
    instructionType parse(opcode, rFlag, iFlag, j1Flag, j2Flag, insn);

    // R-type and I-type
    wire [4:0] IR_readRegA, j2_readRegA, branchI_readRegB, bex_readRegA;
    assign IR_readRegA = (rFlag | iFlag) ? insn[21:17] : (branchI ? insn[26:22] : 5'b0);
    assign ctrl_readRegB = rFlag ? insn[16:12] : (swFlag? insn[26:22] : (branchI ? insn[21:17] : 5'b0));

    // J-type
    assign j2_readRegA = j2Flag ? insn[26:22] : 5'b0;
    assign ctrl_readRegA = j2Flag ? j2_readRegA : (bexFlag ? bex_readRegA : IR_readRegA);

    // save word read rd from ctrl_readRegB
    assign swFlag = iFlag & (opcode == 5'b00111);

    // for I-type branches, read rd from ctrl_readRegA and rs from ctrl_readRegB
    assign branchI = iFlag & (opcode == 5'b00110 || opcode == 5'b00010);
    assign branchI_readRegB = branchI ? insn[26:22] : 5'b0;

    // For bex, read rstatus from ctrl_readRegA
    assign bexFlag = j1Flag & (opcode == 5'b10110);
    assign bex_readRegA = 5'b11110;

endmodule