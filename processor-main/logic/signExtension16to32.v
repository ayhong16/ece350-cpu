module signExtension16to32(
    output [31:0] out,
    input [15:0] in
);
    genvar i;
    for (i = 16; i < 31; i = i + 1) begin
        assign out[i] = in[15];
    end
    assign out[15:0] = in[15:0];
endmodule