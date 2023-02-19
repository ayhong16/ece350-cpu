module mult(
    output [31:0] result,
    output overflow,
    output resultReady,
    output resetCounter,
    input [31:0] multiplicand,
    input [31:0] multiplier,
    input clock,
    input [4:0] count
);
    
    wire start;
    assign start = ~count[0] & ~count[1] & ~count[2] & ~count[3] & ~count[4];
    assign resultReady = ~count[0] & ~count[1] & ~count[2] & ~count[3] & count[4];
    assign resetCounter = count[0] & ~count[1] & ~count[2] & ~count[3] & count[4];

    wire sub, shift, controlWE;
    wire [64:0] productAfterShift, initialProduct, unshiftedNextProduct, nextProduct, selectedProduct, finalShiftedProduct;
    assign initialProduct [64:33] = 32'b0;
    assign initialProduct [32:1] = multiplier[31:0];
    assign initialProduct [0] = 1'b0;

    assign selectedProduct = start ? initialProduct : nextProduct;
    register65 afterShift(productAfterShift, selectedProduct, clock, 1'b1, resetCounter);
    boothControl control(sub, shift, controlWE, productAfterShift[2:0]);
    productSelector nextCycle(nextProduct, productAfterShift, multiplicand, sub, shift, controlWE);

    assign result = nextProduct [32:1];
    wire allZeros, allOnes;
    assign allZeros = ~| nextProduct [64:33];
    assign allOnes = & nextProduct [64:33];
    assign overflow = (~allZeros & ~allOnes) | (allZeros & result[31]) | (allOnes & ~result[31]);

endmodule