module right_barrel_1(
    output [31:0] shifted_out,
    input [31:0] data,
    input msb
);

    assign shifted_out[31] = msb;
    assign shifted_out[30:0] = data[31:1];

endmodule