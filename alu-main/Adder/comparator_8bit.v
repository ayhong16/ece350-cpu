module comparator_8bit(
    output EQ, LT,
    input EQprev, LTprev,
    input [7:0] A, B
);

    wire e0, e1, e2, l0, l1, l2;
    comparator_2bit comp0(e0, l0, EQprev, LTprev, A[7:6], B[7:6]);
    comparator_2bit comp1(e1, l1, e0, l0, A[5:4], B[5:4]);
    comparator_2bit comp2(e2, l2, e1, l1, A[3:2], B[3:2]);
    comparator_2bit comp3(EQ, LT, e2, l2, A[1:0], B[1:0]);

endmodule