module bypassControl(
    output[31:0] ALUinA, ALUinB, dmem_dataIn,
    input[31:0] DXinsn, XMinsn, MWinsn, XMOout, XMBout, data_writeReg, DXAout, DXBout
);
    wire[4:0] DX_IR_RS1, DX_IR_RS2, XM_IR_RD, MW_IR_RD, DX_IR_OP, XM_IR_OP, MW_IR_OP, XM_SW_RD;
    wire DX_rFlag, DX_iFlag, DX_j1Flag, DX_j2Flag;
    instructionType parseDX(DX_IR_OP, DX_rFlag, DX_iFlag, DX_j1Flag, DX_j2Flag, DXinsn);

    wire XM_rFlag, XM_iFlag, XM_j1Flag, XM_j2Flag;
    instructionType parseXM(XM_IR_OP, XM_rFlag, XM_iFlag, XM_j1Flag, XM_j2Flag, XMinsn);

    wire MW_rFlag, MW_iFlag, MW_j1Flag, MW_j2Flag;
    instructionType parseMW(MW_IR_OP, MW_rFlag, MW_iFlag, MW_j1Flag, MW_j2Flag, MWinsn);

    wire DXhasRS1, XMhasWriteReg, MWhasWriteReg, XM_swFlag, MW_swFlag, MW_lwFlag;
    assign XM_swFlag = XM_IR_OP == 5'b00111;
    assign MW_swFlag = MW_IR_OP == 5'b00111;
    assign MW_lwFlag = MW_IR_OP == 5'b01000;
    assign DXhasRS1 = DX_rFlag || DX_iFlag;
    assign XMhasWriteReg = XM_rFlag || (XM_iFlag && ~XM_swFlag) || XM_j2Flag;
    assign MWhasWriteReg = MW_rFlag || (MW_iFlag && ~MW_swFlag) || MW_j2Flag;

    assign DX_IR_RS1 = DXhasRS1 ? DXinsn[21:17] : (DX_j2Flag ? DXinsn[26:22] : 5'b0);
    assign DX_IR_RS2 = DX_rFlag ? DXinsn[16:12] : 5'b0;
    assign XM_IR_RD = XMhasWriteReg ? XMinsn[26:22] : 5'b0;
    assign MW_IR_RD = MWhasWriteReg ? MWinsn[26:22] : 5'b0;

    wire DX_RS1_Equals_XM_RD, DX_RS1_Equals_MW_RD; // bypass ALUinA
    assign DX_RS1_Equals_XM_RD = ((DXhasRS1 || DX_j2Flag) && XMhasWriteReg && XM_IR_RD != 5'b0) ? (DX_IR_RS1 == XM_IR_RD): 1'b0;
    assign DX_RS1_Equals_MW_RD = (DXhasRS1 && MWhasWriteReg && MW_IR_RD != 5'b0) ? (DX_IR_RS1 == MW_IR_RD): 1'b0;

    wire DX_RS2_Equals_XM_RD, DX_RS2_Equals_MW_RD; // bypass ALUinB
    assign DX_RS2_Equals_XM_RD = (DX_rFlag && XMhasWriteReg && XM_IR_RD != 5'b0) ? (DX_IR_RS2 == XM_IR_RD): 1'b0;
    assign DX_RS2_Equals_MW_RD = (DX_rFlag && MWhasWriteReg && MW_IR_RD != 5'b0) ? (DX_IR_RS2 == MW_IR_RD): 1'b0;

    assign ALUinA = DX_RS1_Equals_XM_RD ? XMOout : (DX_RS1_Equals_MW_RD ? data_writeReg : DXAout);
    assign ALUinB = DX_RS2_Equals_XM_RD ? XMOout : (DX_RS2_Equals_MW_RD ? data_writeReg : DXBout);

    // bypass data going into dmem iff XM is sw and MW is lw and they have same $rd
    assign XM_SW_RD = XM_swFlag ? XMinsn[26:22] : 5'b0;
    assign dmem_dataIn = (XM_swFlag && MWhasWriteReg && XM_SW_RD == MW_IR_RD) ? data_writeReg : XMBout;

endmodule