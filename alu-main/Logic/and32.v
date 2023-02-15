module and32(out, A, B);
    input [31:0] A, B;
    output [31:0] out;
    
    genvar i;
    for (i = 0; i < 32; i = i + 1) begin: gen_loop
        and(out[i], A[i], B[i]);
    end

endmodule