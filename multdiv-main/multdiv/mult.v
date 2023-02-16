module mult(
    output [31:0] result,
    output overflow,
    input [31:0] multiplicand,
    input [31:0] multiplier,
    input dataReset,
    input clock,
    input [3:0] count
);
    
    wire start, resultReady;
    assign start = ~count[0] & ~count[1] & ~count[2] & ~count[3];

    wire sub, shift, controlWE;
    wire [64:0] productAfterShift, initialProduct, unshiftedNextProduct, nextProduct, selectedProduct, finalShiftedProduct;
    assign initialProduct [64:33] = 32'b0;
    assign initialProduct [32:1] = multiplier[31:0];
    assign initialProduct [0] = 1'b0;

    assign selectedProduct = start ? initialProduct : nextProduct;
    register65 afterShift(productAfterShift, selectedProduct, clock, 1'b1, dataReset);
    boothControl control(sub, shift, controlWE, productAfterShift[2:0]);
    productSelector nextCycle(nextProduct, productAfterShift, multiplicand, sub, shift, controlWE);

    assign finalShiftedProduct = $signed(productAfterShift) >>> 4;
    assign result = $signed(finalShiftedProduct[32:1]);

    wire allZeros, allOnes;
    assign allZeros = ~| finalShiftedProduct [64:33];
    assign allOnes = & finalShiftedProduct [64:33];
    assign overflow = (~allZeros & ~allOnes) | (allZeros & result[31]) | (allOnes & ~result[31]);

endmodule