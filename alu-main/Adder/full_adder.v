module full_adder(S, A, B, Cin);
  input A, B, Cin;
  output S;
  wire w1, w2, w3;
    
  xor sum_result(S, A, B, Cin);
  and A_and_B(w1, A, B);
  and A_and_Cin(w2, A, Cin);
  and B_and_Cin(w3, B, Cin);
endmodule