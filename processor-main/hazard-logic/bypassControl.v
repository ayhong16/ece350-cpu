module bypassControl(
    output[31:0] ALUinA, ALUinB, dmem_dataIn,
    input[31:0] DXinsn, XMinsn, MWinsn, XMOout, XMBout, data_writeReg, DXAout, DXBout, XM_exceptionData, MW_exceptionData
);
    wire[4:0] DX_IR_RS1, DX_IR_RS2, XM_IR_RD, MW_IR_RD, DX_IR_OP, XM_IR_OP, MW_IR_OP, XM_SW_RD;
    wire DX_rFlag, DX_iFlag, DX_j1Flag, DX_j2Flag, DX_compIFlag;
    instructionType parseDX(DX_IR_OP, DX_rFlag, DX_iFlag, DX_j1Flag, DX_j2Flag, DXinsn);

    wire XM_rFlag, XM_iFlag, XM_j1Flag, XM_j2Flag, XM_compIFlag;
    instructionType parseXM(XM_IR_OP, XM_rFlag, XM_iFlag, XM_j1Flag, XM_j2Flag, XMinsn);

    wire MW_rFlag, MW_iFlag, MW_j1Flag, MW_j2Flag, MW_compIFlag;
    instructionType parseMW(MW_IR_OP, MW_rFlag, MW_iFlag, MW_j1Flag, MW_j2Flag, MWinsn);

    wire DXhasRS1, XMhasWriteReg, MWhasWriteReg, DX_swFlag, XM_swFlag, MW_swFlag, MW_exceptionExists, XM_exceptionExists;
    assign MW_exceptionExists = MW_exceptionData != 32'b0;
    assign XM_exceptionExists = XM_exceptionData != 32'b0;
    assign DX_compIFlag = DX_IR_OP == 5'b00110 || DX_IR_OP == 5'b00010;
    assign XM_compIFlag = XM_IR_OP == 5'b00110 || XM_IR_OP == 5'b00010;
    assign MW_compIFlag = MW_IR_OP == 5'b00110 || MW_IR_OP == 5'b00010;
    assign XM_swFlag = XM_IR_OP == 5'b00111;
    assign MW_swFlag = MW_IR_OP == 5'b00111;
    assign DXhasRS1 = DX_rFlag || (DX_iFlag && ~DX_compIFlag);
    assign XMhasWriteReg = XM_rFlag || (XM_iFlag && ~XM_compIFlag && ~XM_swFlag) || XM_j2Flag;
    assign MWhasWriteReg = MW_rFlag || (MW_iFlag && ~MW_compIFlag && ~MW_swFlag) || MW_j2Flag || MW_exceptionExists;

    assign DX_IR_RS1 = DXhasRS1 ? DXinsn[21:17] : ((DX_j2Flag || DX_compIFlag) ? DXinsn[26:22] : 5'b0);
    assign DX_IR_RS2 = DX_rFlag ? DXinsn[16:12] : (DX_compIFlag ? DXinsn[21:17] : 5'b0);
    assign XM_IR_RD = XMhasWriteReg ? XMinsn[26:22] : 5'b0;
    assign MW_IR_RD = MWhasWriteReg ? MWinsn[26:22] : 5'b0;

    wire DX_RS1_Equals_XM_RD, DX_RS1_Equals_MW_RD; // bypass ALUinA
    assign DX_RS1_Equals_XM_RD = ((DXhasRS1 || DX_j2Flag || DX_compIFlag) && XMhasWriteReg && XM_IR_RD != 5'b0) ? (DX_IR_RS1 == XM_IR_RD): 1'b0;
    assign DX_RS1_Equals_MW_RD = ((DXhasRS1 || DX_j2Flag || DX_compIFlag) && MWhasWriteReg && MW_IR_RD != 5'b0) ? (DX_IR_RS1 == MW_IR_RD): 1'b0;

    wire DX_RS2_Equals_XM_RD, DX_RS2_Equals_MW_RD; // bypass ALUinB
    assign DX_RS2_Equals_XM_RD = ((DX_rFlag || DX_compIFlag) && XMhasWriteReg && XM_IR_RD != 5'b0) ? (DX_IR_RS2 == XM_IR_RD): 1'b0;
    assign DX_RS2_Equals_MW_RD = ((DX_rFlag || DX_compIFlag) && MWhasWriteReg && MW_IR_RD != 5'b0) ? (DX_IR_RS2 == MW_IR_RD): 1'b0;

    assign ALUinA = (XM_exceptionExists & DX_IR_RS1 == 5'b11110) ? XM_exceptionData : 
                    (MW_exceptionExists & DX_IR_RS1 == 5'b11110) ? MW_exceptionData : 
                    (DX_RS1_Equals_XM_RD ? XMOout : 
                    (DX_RS1_Equals_MW_RD ? data_writeReg : DXAout));
    assign ALUinB = (XM_exceptionExists & DX_IR_RS2 == 5'b11110) ? XM_exceptionData :
                    (MW_exceptionExists & DX_IR_RS2 == 5'b11110) ? MW_exceptionData : 
                    (DX_RS2_Equals_XM_RD ? XMOout : 
                    (DX_RS2_Equals_MW_RD ? data_writeReg : DXBout));

    // bypass data going into dmem iff XM is sw and MW is lw and they have same $rd
    assign XM_SW_RD = XM_swFlag ? XMinsn[26:22] : 5'b0;
    assign dmem_dataIn = (XM_swFlag && MWhasWriteReg && XM_SW_RD == MW_IR_RD) ? data_writeReg : XMBout;

endmodule