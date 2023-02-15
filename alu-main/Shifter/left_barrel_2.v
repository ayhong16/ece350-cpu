module left_barrel_2(
    output [31:0] shifted_out,
    input [31:0] data
);
    assign shifted_out[31:2] = data[29:0];
    assign shifted_out[1:0] = 1'b0;

endmodule