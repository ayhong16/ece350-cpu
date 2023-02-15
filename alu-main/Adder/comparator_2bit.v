module comparator_2bit(
    output EQ, LT,
    input EQprev, LTprev,
    input [1:0] A, B
);
    wire [2:0] select;
    assign select[2:1] = A;
    assign select[0] = B[1];

    wire eq_mux_result;
    wire lt_mux_result, lt_part1;

    wire not_B, not_LTprev;
    not notB(not_B, B[0]);
    not notLTprev(not_LTprev, LTprev);

    mux8_1 eq(eq_mux_result, select, ~B[0], 1'b0, B[0], 1'b0, 1'b0, ~B[0], 1'b0, B[0]);
    and final_eq(EQ, eq_mux_result, EQprev);

    mux8_1 gt(lt_mux_result, select, B[0], 1'b1, 1'b0, 1'b1, 1'b0, B[0], 1'b0, 1'b0);
    and part1(lt_part1, lt_mux_result, EQprev);
    or final_lt(LT, lt_part1, LTprev);
endmodule