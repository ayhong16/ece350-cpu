module sra32(output[31:0] shifted_out, input[4:0] shiftamt, input[31:0] data);
    wire msb;
    assign msb = data[31];

    wire [31:0] shift_16, shift_8, shift_4, shift_2, shift_1;
    wire [31:0] mux_result_16, mux_result_8, mux_result_4, mux_result_2;

    right_barrel_16 shifted16(shift_16, data, msb);
    mux_2 mux16(mux_result_16, shiftamt[4], data, shift_16);

    right_barrel_8 shifted8(shift_8, mux_result_16, msb);
    mux_2 mux8(mux_result_8, shiftamt[3], mux_result_16, shift_8);

    right_barrel_4 shifted4(shift_4, mux_result_8, msb);
    mux_2 mux4(mux_result_4, shiftamt[2], mux_result_8, shift_4);

    right_barrel_2 shifted2(shift_2, mux_result_4, msb);
    mux_2 mux2(mux_result_2, shiftamt[1], mux_result_4, shift_2);

    right_barrel_1 shifted1(shift_1, mux_result_2, msb);
    mux_2 mux1(shifted_out, shiftamt[0], mux_result_2, shift_1);

endmodule