module fetch(
    output[31:0] insn_mem, PCplus1,
    input[31:0] PCafterJump,
    input reset, clock, wre, ctr_jump
);
    assign ctrl_jump = 0; // TODO: implement jump

    wire [31:0] PCafterAdd, PCout, PCnext;
    wire overflow;
    cla_adder adder(PCafterAdd, overflow, PCout, 32'b1, 1'b0);
    PC program_counter(PCout, PCnext, clock, reset, wre);
    mux_2 checkJump(PCnext, ctrl_jump, PCafterAdd, PCafterJump);

    assign insn_mem = PCout;
    assign PCplus1 = PCafterAdd;

endmodule