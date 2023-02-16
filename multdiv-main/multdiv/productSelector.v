module productSelector(
    output [64:0] nextProduct,
    input [64:0] productAfterShift,
    input [31:0] multiplicand,
    input sub,
    input shift,
    input controlWE
);
    wire [31:0] shiftedMultiplicand, addedMultiplicand, flippedMultiplicand, inputMultiplicand;
    wire overflow;
    wire [64:0] fullyAdded65;

    assign shiftedMultiplicand = shift ? multiplicand << 1 : multiplicand;
    not32 flip(flippedMultiplicand, shiftedMultiplicand);
    assign inputMultiplicand = sub ? flippedMultiplicand : shiftedMultiplicand;
    cla_adder adder(addedMultiplicand, overflow, productAfterShift[64:33], inputMultiplicand, sub);

    assign fullyAdded65[64:33] = addedMultiplicand;
    assign fullyAdded65[32:0] = productAfterShift[32:0];

    assign nextProduct = controlWE ? $signed(productAfterShift) >>> 2 : $signed(fullyAdded65) >>> 2;

endmodule