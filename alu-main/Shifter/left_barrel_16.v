module left_barrel_16(
    output [31:0] shifted_out,
    input [31:0] data
);
    assign shifted_out[31:16] = data[15:0];
    assign shifted_out[15:0] = 1'b0;
endmodule