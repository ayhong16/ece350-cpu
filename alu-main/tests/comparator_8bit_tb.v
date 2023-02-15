module comparator_8bit_tb;
    wire EQprev, GTprev;
    wire [7:0] A, B;
    wire EQ, GT;

    comparator_8bit comp(EQ, GT, EQprev, GTprev, A, B);

    integer i;
    assign A = i[3:0];
    assign B = i[7:4];
    assign EQprev = i[8];
    assign GTprev = i[9];

    initial begin
        for (i = 0; i < 1024; i = i + 1) begin
            #20
            $display("a = %d, b = %d, EQprev = %b, GTprev = %b => EQ = %b, GT = %b", A, B, EQprev, GTprev, EQ, GT);
        end
    end
    
endmodule