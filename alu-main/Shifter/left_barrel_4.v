module left_barrel_4(
    output [31:0] shifted_out,
    input [31:0] data
);
    assign shifted_out[31:4] = data[27:0];
    assign shifted_out[3:0] = 4'b0;
endmodule