module left_barrel_1(
    output [31:0] shifted_out,
    input [31:0] data
);
    assign shifted_out[31:1] = data[30:0];
    assign shifted_out[0] = 1'b0;

endmodule