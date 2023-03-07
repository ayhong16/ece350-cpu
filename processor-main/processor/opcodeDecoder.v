module opcodeDecoder(
    output [4:0] opcode,
    output rFlag, iFlag, j1Flag, j2Flag
    input [31:0] instruction,
    );
    assign opcode = instruction[31:27];
    assign rFlag = opcode & 5'b0;
    assign iFlag = opcode & (5'b2 | 5'b5 | 5'b6 | 5'b7 | 5'b8);
    assign j1Flag = opcode & (5'b1 | 5'b3 | 5'b22 | 5'b21);
    assign j2Flag = opcode & 5'b4;

endmodule

