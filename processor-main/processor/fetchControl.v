module fetchControl(
    output[31:0] insn_mem, PCplus1,
    input[31:0] PCafterJump,
    input reset, clock, wre, ctrl_branch
);

    wire [31:0] PCafterAdd, PCnext;
    wire overflow;
    cla_adder adder(PCafterAdd, overflow, insn_mem, 32'b1, 1'b0);
    PC program_counter(insn_mem, PCnext, clock, reset, wre);
    mux_2 checkJump(PCnext, ctrl_branch, PCafterAdd, PCafterJump);

    assign PCplus1 = PCafterAdd;

endmodule