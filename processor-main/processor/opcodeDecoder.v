module opcodeDecoder(
    output [4:0] opcode,
    output rFlag, iFlag, j1Flag, j2Flag,
    input [31:0] instruction
);

    wire w0, w1, w2, w3, w4;
    assign w0 = opcode[0];
    assign w1 = opcode[1];
    assign w2 = opcode[2];
    assign w3 = opcode[3];
    assign w4 = opcode[4];

    assign opcode = instruction[31:27];
    assign rFlag = ~w4 & ~w3 & ~w2 & ~w1 & ~w0;
    assign iFlag = (~w4 & ~w3 & ~w2 & w1 & ~w0) | (~w4 & ~w3 & w2 & ~w1 & w0) | (~w4 & ~w3 & w2 & w1 & ~w0) | (~w4 & ~w3 & w2 & w1 & w0) | (~w4 & w3 & ~w2 & ~w1 & ~w0);
    assign j1Flag = (~w4 & ~w3 & ~w2 & ~w1 & w0) | (~w4 & ~w3 & ~w2 & w1 & w0) | (w4 & ~w3 & w2 & w1 & ~w0) | (w4 & ~w3 & w2 & ~w1 & w0);
    assign j2Flag = ~w4 & ~w3 & w2 & ~w1 & ~w0;

endmodule

