module cla_adder(result, overflow, A, B, Cin);
  input [31:0] A, B;
  input Cin;
  output overflow;
  output [31:0] result;

  wire G0, P0, G1, P1, G2, P2, G3, P3;
  wire c8, c16, c24, Cout;

  adder_8bit block0(Cin, A[7:0], B[7:0], result[7:0], G0, P0);

  // carry into second block
  wire w0;
  and carry8_1(w0, P0, Cin);
  or carry8_2(c8, G0, w0);
  adder_8bit block1(c8, A[15:8], B[15:8], result[15:8], G1, P1);

  // carry into third block
  wire w1, w2;
  and carry16_1(w1, P1, P0, Cin);
  and carry16_2(w2, P1, G0);
  or carry16_3(c16, G1, w1, w2);
  adder_8bit block2(c16, A[23:16], B[23:16], result[23:16], G2, P2);

  // carry into fourth block
  wire w3, w4, w5;
  and carry24_1(w3, P2, P1, P0, Cin);
  and carry24_2(w4, P2, P1, G0);
  and carry24_3(w5, P2, G1);
  or carry24_4(c24, G2, w3, w4, w5);
  adder_8bit block3(c24, A[31:24], B[31:24], result[31:24], G3, P3);
  
  // Calculate carry out
  wire w6, w7, w8, w9;
  and carry32_1(w6, P3, P2, P1, P0, Cin);
  and carry32_2(w7, P3, P2, P1, G0);
  and carry32_3(w8, P3, P2, G1);
  and carry32_4(w9, P3, G2);
  or carry_out(Cout, G3, w9, w8, w7, w6);


  // Calculate overflow
  wire notA, notB, notResult, c0, c1;
  not A_not(notA, A[31]);
  not B_not(notB, B[31]);
  not result_not(notResult, result[31]);
  and case1(c0, notA, notB, result[31]);
  and case2(c1, A[31], B[31], notResult);

  or overflow_result(overflow, c0, c1);

endmodule