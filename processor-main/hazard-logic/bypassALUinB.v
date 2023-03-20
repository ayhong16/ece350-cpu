module bypassALUinB(
    output[31:0] ALUinB,
    input[31:0] DXinsn, XMinsn, MWinsn, XMOout, data_writeReg, DXBout
);
    wire[4:0] DX_IR_RS2, XM_IR_RD, MW_IR_RD, DX_IR_OP, XM_IR_OP, MW_IR_OP;
    wire DX_rFlag, DX_iFlag, DX_j1Flag, DX_j2Flag;
    instructionType parseDX(DX_IR_OP, DX_rFlag, DX_iFlag, DX_j1Flag, DX_j2Flag, DXinsn);

    wire XM_rFlag, XM_iFlag, XM_j1Flag, XM_j2Flag;
    instructionType parseXM(XM_IR_OP, XM_rFlag, XM_iFlag, XM_j1Flag, XM_j2Flag, XMinsn);

    wire MW_rFlag, MW_iFlag, MW_j1Flag, MW_j2Flag;
    instructionType parseMW(MW_IR_OP, MW_rFlag, MW_iFlag, MW_j1Flag, MW_j2Flag, MWinsn);

    wire XMhasRD, MWhasRD;
    assign XMhasRD = XM_rFlag || XM_iFlag || XM_j2Flag;
    assign MWhasRD = MW_rFlag || MW_iFlag || MW_j2Flag;

    assign DX_IR_RS2 = DX_rFlag ? DXinsn[16:12] : 5'b0;
    assign XM_IR_RD = XMhasRD ? XMinsn[26:22] : 5'b0;
    assign MW_IR_RD = MWhasRD ? MWinsn[26:22] : 5'b0;

    wire DX_RS2_Equals_XM_RD, DX_RS2_Equals_MW_RD;
    assign DX_RS2_Equals_XM_RD = (DX_rFlag && XMhasRD) ? (DX_IR_RS2 == XM_IR_RD): 1'b0;
    assign DX_RS2_Equals_MW_RD = (DX_rFlag && MWhasRD) ? (DX_IR_RS2 == MW_IR_RD): 1'b0;

    assign ALUinB = DX_RS2_Equals_XM_RD ? XMOout : (DX_RS2_Equals_MW_RD ? data_writeReg : DXBout);

endmodule