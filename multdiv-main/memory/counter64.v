module counter64(
    output [5:0] out,
    input clk, T, clr);
    tffe_ref bit0(out[0], T, clk, clr);
    tffe_ref bit1(out[1], out[0], clk, clr);
    tffe_ref bit2(out[2], out[0] & out[1], clk, clr);
    tffe_ref bit3(out[3], out[0] & out[1] & out[2], clk, clr);
    tffe_ref bit4(out[4], out[0] & out[1] & out[2] & out[3], clk, clr);
    tffe_ref bit5(out[5], out[0] & out[1] & out[2] & out[3] & out[4], clk, clr);
endmodule
