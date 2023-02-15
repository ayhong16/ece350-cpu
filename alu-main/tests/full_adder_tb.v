`timescale 1 ns / 100 ps
module full_adder_tb;
    reg A, B, Cin;
    wire S, Cout;
    full_adder adder (.A(A), .B(B), .Cin(Cin), .S(S));

    initial begin
        A = 0;
        B = 0;
        Cin = 0;
        #80 // time delay in ns
        $finish;
    end

    initial begin
        $dumpfile("Full_Adder_waveform.vcd");
        $dumpvars(0, full_adder_tb);
    end

    always
        #10 A = ~A;
    always
        #20 B = ~B;
    always
        #40 Cin = ~Cin;

    always @(A, B, Cin) begin
        #1
        $display("A:%b, B:%b, Cin:%b => S:%b", A, B, Cin, S);
    end
endmodule