module opcodeDecoder_tb;
    wire [4:0] opcode;
    wire rFlag, iFlag, j1Flag, j2Flag;
    wire [31:0] instruction;

    opcodeDecoder decode(opcode, rFlag, iFlag, j1Flag, j2Flag, instruction);

    integer i;
    assign instruction[31:27] = i[4:0];
    assign instruction[26:0] = 27'b0;

    initial begin
        for (i = 0; i < 48; i = i + 1) begin
            #20
            $display("opcode = %b => R = %b, I = %b, j1 = %b, j2 = %b", instruction[31:27], rFlag, iFlag, j1Flag, j2Flag);
        end
    end

endmodule