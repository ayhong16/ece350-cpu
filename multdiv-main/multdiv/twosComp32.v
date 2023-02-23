module twosComp32(
    output[31:0] twosComplement,
    output unaryOverflow,
    input[31:0] num
);
    wire[31:0] flipped;
    not32 flip(flipped, num);
    cla_adder adder(twosComplement, unaryOverflow, 32'b1, flipped, 1'b0);

endmodule