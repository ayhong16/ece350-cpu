module comparator_2bit_tb;
    wire NEQprev, LTprev;
    wire [1:0] A, B;

    wire NEQ, LT;
    comparator_2bit comp(NEQ, LT, NEQprev, LTprev, A, B);

    integer i;
    assign A = i[1:0];
    assign B = i[3:2];
    assign NEQprev = i[4];
    assign LTprev = i[5];

    initial begin
        for (i = 0; i < 48; i = i + 1) begin
            #20
            $display("a = %d, b = %d, NEQprev = %b, LTprev = %b => NEQ = %b, LT = %b", A, B, NEQprev, LTprev, NEQ, LT);
        end
    end
    
endmodule