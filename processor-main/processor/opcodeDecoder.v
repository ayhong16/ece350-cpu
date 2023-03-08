module opcodeDecoder(
    output [4:0] opcode,
    output rFlag, iFlag, j1Flag, j2Flag
    input [31:0] instruction,
);

    assign opcode = instruction[31:27];
    assign rFlag = opcode & 5'b00000;
    assign iFlag = opcode & (5'b00010 | 5'b500101 | 5'b00110 | 5'b00111 | 5'b01000);
    assign j1Flag = opcode & (5'b00001 | 5'b00011 | 5'b10110 | 5'b10101);
    assign j2Flag = opcode & 5'b00100;

endmodule

