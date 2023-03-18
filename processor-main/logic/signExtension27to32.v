module signExtension27to32(
    output [31:0] out,
    input [26:0] in
);
    genvar i;
    for (i = 27; i <= 31; i = i + 1) begin
        assign out[i] = in[16];
    end
    assign out[26:0] = in[26:0];
endmodule