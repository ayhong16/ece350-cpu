module register1(
    output out,
    input data,
    input clk, write_enable, reset
);

    dffe_ref flip_flop(out, data, clk, write_enable, reset);
endmodule