module register64(
    output [63:0] out,
    input [63:0] data,
    input clk, write_enable, reset
);

    dffe_ref flip_flop[63:0](out, data, clk, write_enable, reset);

endmodule