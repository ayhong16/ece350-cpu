module counter64_tb;
    wire [5:0] out;
    reg clk, T, clr;

    counter64 counter(out, clk, T, clr);
    
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
        if (out == 63) begin
            $display("Finished");
            $finish;
        end
    end
endmodule