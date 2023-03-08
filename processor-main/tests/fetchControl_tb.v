module fetchControl_tb;
    wire[31:0] insn_mem, PCplus1;
    reg[31:0] PCafterJump;
    reg reset, clock, wre, ctr_jump;

    fetchControl fetch_stage(insn_mem, PCplus1, PCafterJump, reset, clock, wre, ctr_jump);

    initial begin
        PCafterJump = 32'b0;
        reset = 1'b0;
        clock = 1'b0;
        wre = 1'b1;
        ctr_jump = 1'b0;
        #80; // time delay in ns
    end

    always
        #10 clock = ~clock;


    always @(PCplus1, clock) begin
        #1
        $display("next PC = %d, clock = %b", PCplus1, clock);
        if (PCplus1 == 100) begin
            $display("Test up to 100 PC done.");
            $finish;
        end
    end
endmodule