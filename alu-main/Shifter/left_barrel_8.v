module left_barrel_8(
    output [31:0] shifted_out,
    input [31:0] data
);
    assign shifted_out[31:8] = data[23:0];
    assign shifted_out[7:0] = 1'b0;
endmodule