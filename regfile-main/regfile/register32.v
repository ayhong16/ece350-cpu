module register32(
    output [31:0] out,
    input [31:0] data,
    input clk, write_enable, reset
);

    dffe_ref flip_flop[31:0](out, data, clk, write_enable, reset);

endmodule