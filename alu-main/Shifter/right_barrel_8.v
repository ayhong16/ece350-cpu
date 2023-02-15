module right_barrel_8(
    output [31:0] shifted_out,
    input [31:0] data,
    input msb
);
    assign shifted_out[23:0] = data[31:8];
    genvar i;
    for (i = 31; i > 23; i = i - 1) begin
        assign shifted_out[i] = msb;
    end

endmodule