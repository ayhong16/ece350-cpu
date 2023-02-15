module adder_8bit(Cin, A, B, sum, G, P);
  input Cin;
  input [7:0] A, B;
  output [7:0] sum;
  output G, P;

  wire [7:0] p;
  wire [7:0] g;
  wire w0, w1, w2, w3, w4, w5, w6;

  genvar i;
  for (i = 0; i < 8; i = i + 1) begin : gen_loop // calculate each pi and gi
    or p_results(p[i], A[i], B[i]);
    and g_results(g[i], A[i], B[i]);
  end

  and P0(P, p[7], p[6], p[5], p[4], p[3], p[2], p[1], p[0]); // calculates P0

  and first(w0, p[7], g[6]);
  and second(w1, p[7], p[6], g[5]);
  and third(w2, p[7], p[6], p[5], g[4]);
  and fourth(w3, p[7], p[6], p[5], p[4], g[3]);
  and fifth(w4, p[7], p[6], p[5], p[4], p[3], g[2]);
  and sixth(w5, p[7], p[6], p[5], p[4], p[3], p[2], g[1]);
  and seventh(w6, p[7], p[6], p[5], p[4], p[3], p[2], p[1], g[0]);

  or G0(G, g[7], w0, w1, w2, w3, w4, w5, w6); // calculates G0


  // calculate sums
  // 1st bit
  full_adder first_adder(sum[0], A[0], B[0], Cin);
  
  // 2nd bit
  wire carry_1, w7;
  and(w7, p[0], Cin);
  or carry_result1(carry_1, g[0], w7);
  full_adder second_adder(sum[1], A[1], B[1], carry_1);

  // 3rd bit
  wire carry_2, w8, w9;
  and(w8, p[1], g[0]);
  and(w9, p[1], p[0], Cin);
  or carry_result2(carry_2, g[1], w8, w9);
  full_adder third_adder(sum[2], A[2], B[2], carry_2);

  // 4th bit
  wire carry_3, w10, w11, w12;
  and(w10, p[2], g[1]);
  and(w11, p[2], p[1], g[0]);
  and(w12, p[2], p[1], p[0], Cin);
  or carry_result3(carry_3, g[2], w10, w11, w12);
  full_adder fourth_adder(sum[3], A[3], B[3], carry_3);

  // 5th bit
  wire carry_4, w13, w14, w15, w16;
  and(w13, p[3], g[2]);
  and(w14, p[3], p[2], g[1]);
  and(w15, p[3], p[2], p[1], g[0]);
  and(w16, p[3], p[2], p[1], p[0], Cin);
  or carry_result4(carry_4, g[3], w13, w14, w15, w16);
  full_adder fifth_adder(sum[4], A[4], B[4], carry_4);

  // 6th bit
  wire carry_5, w17, w18, w19, w20, w21;
  and(w17, p[4], g[3]);
  and(w18, p[4], p[3], g[2]);
  and(w19, p[4], p[3], p[2], g[1]);
  and(w20, p[4], p[3], p[2], p[1], g[0]);
  and(w21, p[4], p[3], p[2], p[1], p[0], Cin);
  or carry_result5(carry_5, g[4], w17, w18, w19, w20, w21);
  full_adder sixth_adder(sum[5], A[5], B[5], carry_5);

  // 7th bit
  wire carry_6, w22, w23, w24, w25, w26, w27;
  and(w22, p[5], g[4]);
  and(w23, p[5], p[4], g[3]);
  and(w24, p[5], p[4], p[3], g[2]);
  and(w25, p[5], p[4], p[3], p[2], g[1]);
  and(w26, p[5], p[4], p[3], p[2], p[1], g[0]);
  and(w27, p[5], p[4], p[3], p[2], p[1], p[0], Cin);
  or carry_result6(carry_6, g[5], w22, w23, w24, w25, w26, w27);
  full_adder seventh_adder(sum[6], A[6], B[6], carry_6);

  // 8th bit
  wire carry_7, w28, w29, w30, w31, w32, w33, w34;
  and(w28, p[6], g[5]);
  and(w29, p[6], p[5], g[4]);
  and(w30, p[6], p[5], p[4], g[3]);
  and(w31, p[6], p[5], p[4], p[3], g[2]);
  and(w32, p[6], p[5], p[4], p[3], p[2], g[1]);
  and(w33, p[6], p[5], p[4], p[3], p[2], p[1], g[0]);
  and(w34, p[6], p[5], p[4], p[3], p[2], p[1], p[0], Cin);
  or carry_result7(carry_7, g[6], w28, w29, w30, w31, w32, w33, w34);
  full_adder eighth_adder(sum[7], A[7], B[7], carry_7);
endmodule