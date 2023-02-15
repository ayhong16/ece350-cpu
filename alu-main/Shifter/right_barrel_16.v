module right_barrel_16(
    output [31:0] shifted_out,
    input [31:0] data,
    input msb
);
    assign shifted_out[15:0] = data[31:16];
    genvar i;
    for (i = 31; i > 15; i = i - 1) begin
        assign shifted_out[i] = msb;
    end

endmodule