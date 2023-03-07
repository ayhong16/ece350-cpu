module PC(
    output [31:0] PCout,
    input [31:0] PCin,
    input clock, reset, wre
);

    register32 PC_reg(.out(PCout), .data(PCin), .clk(clock), .write_enable(wre), .reset(reset));
endmodule