module buffer32(
    output [31:0] q,
    input [31:0] d,
    input enable
);

    assign q = enable ? d : 32'bz;

endmodule