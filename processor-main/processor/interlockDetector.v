module interlockDetector(
    output stall,
    input[31:0] FD_insn, DX_insn
);
    wire[4:0] DX_IR_OP, FD_IR_RS1, FD_IR_RS2, DX_IR_RD, FD_IR_OP;
    wire FD_rFlag, FD_iFlag, FD_j1Flag, FD_j2Flag;
    opcodeDecoder parseFD(FD_IR_OP, FD_rFlag, FD_iFlag, FD_j1Flag, FD_j2Flag, FD_insn);

    wire DX_rFlag, DX_iFlag, DX_j1Flag, DX_j2Flag;
    opcodeDecoder parseDX(DX_IR_OP, DX_rFlag, DX_iFlag, DX_j1Flag, DX_j2Flag, DX_insn);

    wire DXhasRD, FDhasRS1, FDhasRS2;
    assign DXhasRD = DX_rFlag || DX_iFlag || DX_j2Flag;
    assign FDhasRS1 = FD_rFlag || FD_iFlag;
    assign FD_IR_RS1 = FDhasRS1 ? FD_insn[21:17] : 5'b0;
    assign DX_IR_RD = DXhasRD ? DX_insn[26:22] : 5'b0;
    assign FD_IR_RS2 = FD_rFlag ? FD_insn[16:12] : 5'b0;

    wire FD_RS1_Equals_DX_RD, FD_RS2_Equals_DX_RD;
    assign FD_RS1_Equals_DX_RD = (FDhasRS1 && DXhasRD) ? (FD_IR_RS1 == DX_IR_RD): 1'b0;
    assign FD_RS2_Equals_DX_RD = (FD_rFlag && DXhasRD) ? (FD_IR_RS2 == DX_IR_RD): 1'b0;

    assign stall = ((DX_IR_OP == 5'b01000) && FD_RS1_Equals_DX_RD) ||
                    ((FD_IR_OP != 5'b00111) && FD_RS2_Equals_DX_RD);

endmodule