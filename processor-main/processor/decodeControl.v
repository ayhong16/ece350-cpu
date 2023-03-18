module decodeControl(
	output [4:0] ctrl_readRegA, ctrl_readRegB,
    input [31:0] insn
);
    wire rFlag, iFlag, j1Flag, j2Flag;
    wire[4:0] opcode;
    opcodeDecoder parse(opcode, rFlag, iFlag, j1Flag, j2Flag, insn);

    // R-type and I-type
    wire [4:0] IR_readRegA, j2_readRegA;
    assign IR_readRegA = (rFlag | iFlag) ? insn[21:17] : 5'b0;
    assign ctrl_readRegB = rFlag ? insn[16:12] : 5'b0;

    // J-type
    assign j2_readRegA = j2Flag ? insn[26:22] : 5'b0;
    assign ctrl_readRegA = j2Flag ? j2_readRegA : IR_readRegA;

endmodule