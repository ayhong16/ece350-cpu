module executeControl(
    output[31:0] aluOut,
    output adder_overflow, mult_exception, div_exception,
    input[31:0] dataRegA, dataRegB, insn,
    input clock
);

    wire rFlag, iFlag, j1Flag, j2Flag;
    wire[4:0] opcode, aluOpcode, shamt;
    opcodeDecoder parse(opcode, rFlag, iFlag, j1Flag, j2Flag, insn);
    assign aluOpcode = rFlag ? insn[6:2] : 5'b0;
    assign shamt = rFlag ? insn[11:7] : 5'b0;


    // R-type regular adding in ALU
    wire[31:0] selectedB;
    mux_2 regOrImmediate(selectedB, rFlag, immediate, dataRegB);

    // I-type sign extension for immediate
    wire[31:0] immediate;
    signExtension17to32 signExtend(immediate, insn[16:0]);

    // ALU
    wire isNotEqual, isLessThan;
    alu execute(dataRegA, selectedB, aluOpcode, shamt, aluOut, isNotEqual, isLessThan, adder_overflow, mult_exception, div_exception, clock);


endmodule