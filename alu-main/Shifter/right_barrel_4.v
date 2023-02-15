module right_barrel_4(
    output [31:0] shifted_out,
    input [31:0] data,
    input msb
);

    assign shifted_out[27:0] = data[31:4];
    genvar i;
    for (i = 31; i > 27; i = i - 1) begin
        assign shifted_out[i] = msb;
    end

endmodule