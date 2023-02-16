module mult(
    output [31:0] result,
    input [31:0] multiplicand,
    input [31:0] multiplier,
    input dataReset,
    input clock,
    input [3:0] count
);
    
    wire start, resultReady;
    assign start = ~count[0] & ~count[1] & ~count[2] & ~count[3];

    wire sub, shift, controlWE;
    wire [64:0] productAfterShift, initialProduct, nextProduct, selectedProduct;
    assign initialProduct [64:33] = 32'b0;
    assign initialProduct [32:1] = multiplier[31:0];
    assign initialProduct [0] = 1'b0;

    assign selectedProduct = start ? initialProduct >>> 2 : nextProduct;
    register65 afterShift(productAfterShift, selectedProduct, clock, 1'b1, dataReset);
    boothControl control(sub, shift, controlWE, selectedProduct[2:0]);
    productSelector nextCycle(nextProduct, productAfterShift, multiplicand, sub, shift, controlWE);

    assign result = productAfterShift[32:1];

endmodule