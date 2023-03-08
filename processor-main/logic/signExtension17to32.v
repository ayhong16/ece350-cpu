module signExtension17to32(
    output [31:0] out,
    input [16:0] in
);
    genvar i;
    for (i = 17; i < 31; i = i + 1) begin
        assign out[i] = in[16];
    end
    assign out[16:0] = in[16:0];
endmodule