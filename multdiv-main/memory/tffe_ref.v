module tffe_ref(q, T, clk, clr);    
    //Inputs
    input T, clk, clr;
    
    //Output
    output q;
    
    dffe_ref Tff(q, ~T & q || T & ~q, clk, 1'b1, clr);
    
endmodule