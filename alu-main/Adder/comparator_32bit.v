module comparator_32bit(
    output NEQ, LT,
    input [31:0] A, B
);

    wire EQ, LTprev, EQprev;
    wire not_B, not_A, aNotbCheck;
    not notB(not_B, B[31]);
    not notA(not_A, A[31]);
    and MSB_check(LTprev, A[31], not_B);

    // if A[31] = 0 and B[31] = 1, then A > B and EQprev = 0
    wire aEquals0Check, bEquals1Check, notEQprev;
    and MSB__checkA(aEquals0Check, not_A, 1'b1);
    and MSB__checkB(bEquals1Check, B[31], 1'b1);
    and notEQprev_result(notEQprev, aEquals0Check, bEquals1Check);
    not EQprev_result(EQprev, notEQprev);

    wire e0, e1, e2, l0, l1, l2;
    comparator_8bit comp0(e0, l0, EQprev, LTprev, A[31:24], B[31:24]);
    comparator_8bit comp1(e1, l1, e0, l0, A[23:16], B[23:16]);
    comparator_8bit comp2(e2, l2, e1, l1, A[15:8], B[15:8]);
    comparator_8bit comp3(EQ, LT, e2, l2, A[7:0], B[7:0]);
    not neq_result(NEQ, EQ);

endmodule