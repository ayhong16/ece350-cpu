module instructionType(
    output [4:0] opcode,
    output rFlag, iFlag, j1Flag, j2Flag,
    input [31:0] instruction
);
    wire[31:0] nop;
    assign nop = 32'b0;

    assign opcode = instruction[31:27];
    assign rFlag = (opcode == 5'b0 && instruction != nop);
    assign iFlag = (opcode == 5'b00010) || (opcode == 5'b00101) || (opcode == 5'b00110) || (opcode == 5'b00111) || (opcode == 5'b01000);
    assign j1Flag = (opcode == 5'b00001) || (opcode == 5'b00011) || (opcode == 5'b10110) || (opcode == 5'b10101);
    assign j2Flag = opcode == 5'b00100;

endmodule

