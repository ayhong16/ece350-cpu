module bypassMultDiv(
    output insertNop,
    input[31:0] FD_insn, MW_insn
);
    wire[4:0] FD_IR_OP, FD_IR_RS1, FD_IR_RS2, MW_IR_RD, MW_IR_OP;
    wire FD_rFlag, FD_iFlag, FD_j1Flag, FD_j2Flag;
    instructionType parseFD(FD_IR_OP, FD_rFlag, FD_iFlag, FD_j1Flag, FD_j2Flag, FD_insn);

    wire MW_rFlag, MW_iFlag, MW_j1Flag, MW_j2Flag;
    instructionType parseMW(MW_IR_OP, MW_rFlag, MW_iFlag, MW_j1Flag, MW_j2Flag, MW_insn);

    wire MWhasRD, FDhasRS1;
    assign MWhasRD = MW_rFlag || MW_iFlag || MW_j2Flag;
    assign FDhasRS1 = FD_rFlag || FD_iFlag;

    assign FD_IR_RS1 = FDhasRS1 ? FD_insn[21:17] : 5'b0;
    assign FD_IR_RS2 = FD_rFlag ? FD_insn[16:12] : 5'b0;
    assign MW_IR_RD = MWhasRD ? MW_insn[26:22] : 5'b0;

    wire FD_RS1_Equals_MW_RD, FD_RS2_Equals_MW_RD;
    assign FD_RS1_Equals_MW_RD = (FDhasRS1 && MWhasRD) ? (FD_IR_RS1 == MW_IR_RD): 1'b0;
    assign FD_RS2_Equals_MW_RD = (FD_rFlag && MWhasRD) ? (FD_IR_RS2 == MW_IR_RD): 1'b0;

    assign insertNop = FD_RS1_Equals_MW_RD || FD_RS2_Equals_MW_RD;

endmodule