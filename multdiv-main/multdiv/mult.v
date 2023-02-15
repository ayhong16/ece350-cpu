module mult(
    output [31:0] result,
    output resultReady,
    input [31:0] multiplicand,
    input [31:0] multiplier,
    input dataReset,
    input clock
);

    // manage counter
    wire [3:0] count;
    wire start;
    counter16 counter(count, clock, 1'b1, dataReset);
    assign resultReady = count[0] & count[1] & count[2] & count[3];
    assign start = ~count[0] & ~count[1] & ~count[2] & ~count[3];
    
    // multiplication hardware
    wire sub, shift, controlWE;
    wire [64:0] initialProduct, productAfterShift, productBeforeShift;
    assign productBeforeShift [64:33] = start ? 32'b0 : productAfterShift[64:33];
    assign productBeforeShift [32:1] = start ? multiplier : productAfterShift[32:1];
    assign productBeforeShift [0] =  start ? 1'b0 : productAfterShift[0];
    register65 afterShift(productAfterShift, productBeforeShift >> 2, clock, 1'b1, dataReset);
    boothControl control(sub, shift, controlWE, productAfterShift[2:0]);
    productSelector nextCycle(productBeforeShift, productAfterShift, multiplicand, sub, shift, controlWE);

    assign result = resultReady ? productAfterShift[32:1] : 32'b0;

endmodule