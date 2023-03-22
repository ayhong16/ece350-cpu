module interlockDetector(
    output stall,
    input[31:0] FD_insn, DX_insn
);
    wire[4:0] DX_IR_OP, FD_IR_RS1, FD_IR_RS2, DX_IR_RD, FD_IR_OP;
    wire FD_rFlag, FD_iFlag, FD_j1Flag, FD_j2Flag;
    instructionType parseFD(FD_IR_OP, FD_rFlag, FD_iFlag, FD_j1Flag, FD_j2Flag, FD_insn);

    wire DX_rFlag, DX_iFlag, DX_j1Flag, DX_j2Flag;
    instructionType parseDX(DX_IR_OP, DX_rFlag, DX_iFlag, DX_j1Flag, DX_j2Flag, DX_insn);

    assign FD_IR_RS1 = FD_insn[21:17];
    assign DX_IR_RD = DX_insn[26:22];
    assign FD_IR_RS2 = FD_insn[16:12];

    wire FD_RS1_Equals_DX_RD, FD_RS2_Equals_DX_RD;
    assign FD_RS1_Equals_DX_RD = FD_IR_RS1 == DX_IR_RD;
    assign FD_RS2_Equals_DX_RD = FD_IR_RS2 == DX_IR_RD;

    assign stall = ((DX_IR_OP == 5'b01000) && FD_IR_RS1 == DX_IR_RD) ||
                    ((FD_IR_OP != 5'b00111) && FD_IR_RS2 == DX_IR_RD);

endmodule