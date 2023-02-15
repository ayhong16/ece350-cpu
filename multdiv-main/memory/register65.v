module register65(
    output [64:0] out,
    input [64:0] data,
    input clk, write_enable, reset
);

    dffe_ref flip_flop[64:0](out, data, clk, write_enable, reset);

endmodule