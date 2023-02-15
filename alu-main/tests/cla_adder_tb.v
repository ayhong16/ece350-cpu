`timescale 1 ns / 100 ps
module cla_adder_tb;
  wire [31:0] A, B;
  wire Cin;
  reg a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, 
  a17, a18, a19, a20, a21, a22, a23, a24, a25, a26, a27, a28, a29, a30, a31;
  reg b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12, b13, b14, b15, b16, 
  b17, b18, b19, b20, b21, b22, b23, b24, b25, b26, b27, b28, b29, b30, b31;

  wire Cout;
  wire [31:0] sum;
  cla_adder adder(sum, Cout, A, B, Cin);

  initial begin
    a0 = 0;
    a1 = 0;
    a2 = 0;
    a3 = 0;
    a4 = 0;
    a5 = 0;
    a6 = 0;
    a7 = 0;
    a8 = 0;
    a9 = 0;
    a10 = 0;
    a11 = 0;
    a12 = 0;
    a13 = 0;
    a14 = 0;
    a15 = 0;
    a16 = 0;
    a17 = 0;
    a18 = 0;
    a19 = 0;
    a20 = 0;
    a21 = 0;
    a22 = 0;
    a23 = 0;
    a24 = 0;
    a25 = 0;
    a26 = 0;
    a27 = 0;
    a28 = 0;
    a29 = 0;
    a30 = 0;
    a31 = 0;
    b0 = 0;
    b1 = 0;
    b2 = 0;
    b3 = 0;
    b4 = 0;
    b5 = 0;
    b6 = 0;
    b7 = 0;
    b8 = 0;
    b9 = 0;
    b10 = 0;
    b11 = 0;
    b12 = 0;
    b13 = 0;
    b14 = 0;
    b15 = 0;
    b16 = 0;
    b17 = 0;
    b18 = 0;
    b19 = 0;
    b20 = 0;
    b21 = 0;
    b22 = 0;
    b23 = 0;
    b24 = 0;
    b25 = 0;
    b26 = 0;
    b27 = 0;
    b28 = 0;
    b29 = 0;
    b30 = 0;
    b31 = 0;
    Cin = 0;
    #80; // time delay in ns
  end

  assign A[0] = a0;
  assign A[1] = a1;
  assign A[2] = a2;
  assign A[3] = a3;
  assign A[4] = a4;
  assign A[5] = a5;
  assign A[6] = a6;
  assign A[7] = a7;
  assign A[8] = a8;
  assign A[9] = a9;
  assign A[10] = a10;
  assign A[11] = a11;
  assign A[12] = a12;
  assign A[13] = a13;
  assign A[14] = a14;
  assign A[15] = a15;
  assign A[16] = a16;
  assign A[17] = a17;
  assign A[18] = a18;
  assign A[19] = a19;
  assign A[20] = a20;
  assign A[21] = a21;
  assign A[22] = a22;
  assign A[23] = a23;
  assign A[24] = a24;
  assign A[25] = a25;
  assign A[26] = a26;
  assign A[27] = a27;
  assign A[28] = a28;
  assign A[29] = a29;
  assign A[30] = a30;
  assign A[31] = a31;
  assign B[0] = b0;
  assign B[1] = b1;
  assign B[2] = b2;
  assign B[3] = b3;
  assign B[4] = b4;
  assign B[5] = b5;
  assign B[6] = b6;
  assign B[7] = b7;
  assign B[8] = b8;
  assign B[9] = b9;
  assign B[10] = b10;
  assign B[11] = b11;
  assign B[12] = b12;
  assign B[13] = b13;
  assign B[14] = b14;
  assign B[15] = b15;
  assign B[16] = b16;
  assign B[17] = b17;
  assign B[18] = b18;
  assign B[19] = b19;
  assign B[20] = b20;
  assign B[21] = b21;
  assign B[22] = b22;
  assign B[23] = b23;
  assign B[24] = b24;
  assign B[25] = b25;
  assign B[26] = b26;
  assign B[27] = b27;
  assign B[28] = b28;
  assign B[29] = b29;
  assign B[30] = b30;
  assign B[31] = b31;

  always
    #10 a0 = ~a0;
  always
    #20 a1 = ~a1;
  always 
    #40 a2 = ~a2;
  always
    #80 a3 = ~a3;
  always
    #160 a4 = ~a4;
  always
    #320 a5 = ~a5;
  always
    #640 a6 = ~a6;
  always
    #1280 a7 = ~a7;
  always
    #2560 a8 = ~a8;
  always
    #5120 a9 = ~a9;
  always
    #10240 a10 = ~a10;
  always
    #20480 a11 = ~a11;
  always
    #40960 a12 = ~a12;
  always
    #81920 a13 = ~a13;
  always
    #163840 a14 = ~a14;
  always
    #327680 a15 = ~a15;
  always
    #655360 a16 = ~a16;
  always
    #1310720 a17 = ~a17;
  always
    #2621440 a18 = ~a18;
  always
    #5242880 a19 = ~a19;
  always
    #10485760 a20 = ~a20;
  always
    #20971520 a21 = ~a21;
  always
    #41943040 a22 = ~a22;
  always 
    #83886080 a23 = ~a23;
  always
    #167772160 a24 = ~a24;
  always 
    #335544320 a25 = ~a25;
  always 
    #671088640 a26 = ~a26;
  always 
    #1342177280 a27 = ~a27;
  always 
    #2684354560 a28 = ~a28;
  always
    #5368709120 a29 = ~a29;
  always
    #10737418240 a30 = ~a30;
  always
    #21474836480 a31 = ~a31;
  
  always
    #15 b0 = ~b0;
  always
    #30 b1 = ~b1;
  always
    #60 b2 = ~b2;
  always
    #120 b3 = ~b3;
  always
    #240 b4 = ~b4;
always
    #480 b5 = ~b5;
  always
    #960 b6 = ~b6;
  always
    #1920 b7 = ~b7;
  always
    #3840 b8 = ~b8;
  always
    #7680 b9 = ~b9;
  always
    #15360 b10 = ~b10;
  always
    #30720 b11 = ~b11;
  always
    #61440 b12 = ~b12;
  always
    #122880 b13 = ~b13;
  always
    #245760 b14 = ~b14;
  always
    #491520 b15 = ~b15;
  always
    #983040 b16 = ~b16;
  always
    #1966080 b17 = ~b17;
  always
    #3932160 b18 = ~b18;
  always
    #7864320 b19 = ~b19;
  always
    #15728640 b20 = ~b20;
  always
    #31457280 b21 = ~b21;
  always
    #62914560 b22 = ~b22;
  always
    #125829120 b23 = ~b23;
  always
    #251658240 b24 = ~b24;
  always
    #503316480 b25 = ~b25;
  always
    #1006632960 b26 = ~b26;
  always
    #2013265920 b27 = ~b27;
  always
    #4026531840 b28 = ~b28;
  always
    #8053063680 b29 = ~b29;
  always
    #16106127360 b30 = ~b30;
  always
    #32212254720 b31 = ~b31;

  initial begin
    $dumpfile("cla_adder_waveform.vcd");
    $dumpvars(0, cla_adder_tb);
  end

  always @(A, B, sum, Cout) begin
    #1
    $display("%d + %d = %d", A, B, sum);
    if (Cout == 1)
      $finish;
  end
endmodule