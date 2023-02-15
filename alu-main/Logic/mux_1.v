module mux2_1(out, select, in0, in1);
    input select;
    input in0, in1;
    output out;
    assign out = select ? in1: in0;
endmodule

module mux4_1(out, select, in0, in1, in2, in3);
    input [1:0] select;
    input in0, in1, in2, in3;
    output out;
    wire w1, w2;
    mux2_1 first_top(w1, select[0], in0, in1);
    mux2_1 first_bottom(w2, select[0], in2, in3);
    mux2_1 second(out, select[1], w1, w2);
endmodule

module mux8_1(out, select, in0, in1, in2, in3, in4, in5, in6, in7);
    input [2:0] select;
    input in0, in1, in2, in3, in4, in5, in6, in7;
    output out;
    wire w0, w1;

    mux4_1 first_top(w1, select[1:0], in4, in5, in6, in7);
    mux4_1 first_bottom(w0, select[1:0], in0, in1, in2, in3);
    mux2_1 second(out, select[2], w0, w1);
endmodule