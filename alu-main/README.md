# ALU

## Ashley Hong

## Description of Design
The alu.v module brings together each of my components and uses another module called alu_op.v to select between each operation depending on the opcode of the instruction.

- Adder Design: my adder is split up into 4 8-bit CLA blocks. Each 8-bit block generates its P and G values and uses eight 1-bit full adders to determine each bit of the sum. It uses the expanded recursive expressions for carry in to figure out what the Cin for each 1-bit full adder should be. In my CLA interface module called cla_adder.v, I use more expanded recursive expressions to calculate the carry in for each 8-bit CLA block.
    - The inputs to the CLA are provided in alu.v. For addition, the alu passes in 0 for the initial carry in and data_operandB. For subtraction, the alu passes in 1 for the initial carry in and a notted data_operandB.
- Comparator signals: I modified the 2-bit comparator from lab by rewriting the truth table to work with 'less than' and 'less than previous'. I kept the logic we used to find EQ, but at the very end, notted that to get NEQ. I chained together 4 2-bit comparators to make my 8-bit comparator, then chained together 4 8-bit comparators to make the 32-bit comparator.
    - The alu passes in data_operandA and data_OperandB to do the necessary comparisons and retrieve the isNotEqual and isLessThan information signals.
- Shift left logical: I made modules for each of the possible left shifts: 1, 2, 4, 8, and 16. With these shifters, any combination of shifts from 0-31 can occur. In each of these modules, I take bottom 32-n bits of the inputted data and put it into the top 32-n bits of the shifted output. Then I replace the bottom n bits of the shifted output with 0s. My sll32.v module uses the 5 barrel shifters in conjunction with 2-input muxes to determine how many shifts to perform.
- Shift Right Arithmetic: Similar to shift left logical, I have modules for 1, 2, 4, 8, and 16 bit right shifts. The primary difference is that I pass in an additional input that contains the most significant bit so that each module knows what to shift in (1 or 0). I take the top 32-n bits of the inputted data and put it into the bottom 32-n bits of the shifted output. Then I replace the top n bits of the shifted output with the most significant bit. My sra32.v module determines the MSB, inputs it into each barrel shifter, then uses 2-input muxes to determine how many shifts to do.
- And: My and32.v module uses genvar to loop through each bit of data_OperandA and data_OperandB and apply a 1-bit 'and' gate on each of their 32 bits.
- Or: My or32.v module uses genvar to loop through each bit of data_OperandA and data_OperandB and apply a 1-bit 'or' gate on each of their 32 bits.

## Bugs
As far as I can tell, there are no bugs in my code.