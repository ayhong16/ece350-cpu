module decodeControl_tb;
    wire [4:0] ctrl_readRegA, ctrl_readRegB;
    wire [31:0] insn;

    decodeControl decode(ctrl_readRegA, ctrl_readRegB, insn);

    integer i;
    assign insn[31] = 1'b0; // i-type opcode
    assign insn[30] = 1'b0;
    assign insn[29] = 1'b0;
    assign insn[28] = 1'b0;
    assign insn[27] = 1'b1;
    assign insn[21:17] = i[4:0]; // rs
    assign insn[16:12] = i[8:5]; // rt

    initial begin
        for (i = 0; i < 512; i = i + 1) begin
            #20
            $display("rs = %d, rt = %d => ctrl_readRegA = %d, ctrl_readRegB = %d", insn[21:17], insn[16:12], ctrl_readRegA, ctrl_readRegB);
        end
    end

endmodule