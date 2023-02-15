module counter32_tb;
    wire [4:0] out;
    reg clk, T, clr;

    counter32 counter(out, clk, T, clr);
    
    initial begin
        clk = 0;
        T = 1;
        clr = 0;
    end

    always
        #10 clk = ~clk;

    always @(clk) begin
        #1
        $display("Clock: %b, T: %b, Clear: %b => Count: %d", clk, T, clr, out);
        if (out == 15) begin
            $display("Finished");
            $finish;
        end
    end
endmodule