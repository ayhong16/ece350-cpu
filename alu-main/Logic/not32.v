module not32(result, in);
    input [31:0] in;
    output [31:0] result;

    genvar i;
    for (i = 0; i < 32; i = i + 1) begin: gen_loop
        not(result[i], in[i]);
    end
endmodule