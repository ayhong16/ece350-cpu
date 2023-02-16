module boothControl(
    output sub,
    output shift,
    output controlWE,
    input [2:0] opcode
);
    mux8_1 sub_result(sub, opcode, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0);
    mux8_1 shift_result(shift, opcode, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0);
    mux8_1 controlWE_result(controlWE, opcode, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1);

endmodule