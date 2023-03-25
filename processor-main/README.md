# Processor
## Ashley Hong (ayh12)

## Description of Design
As required by the project, the Wrapper is the top level module that manages the regfile, processor, ROM, and RAM. In the processor, I split up my code into small, labeled chunks that represent the fetch stage, FD latch, decode stage, DX latch, execute state, XM latch, memory stage, MW latch, and writeback stage. All of the latches have a very simple function, which is to pass each other information and latch it on the falling edge of each clock cycle. The information passed in and out of all the latches are maintained within the processor module. I have one bypassing module that handles all variables in the execute state, which is where most bypassing occurs. For bypassing in other stages of the processor, I kept the logic either within each of the separate modules for each stage or in that section of code in the processor module. Deciding where to do the bypassing was a case-by-case choice dependent on whether other modules in the processor needed access to the bypassed values. I have one interlock module that handles the special cases. I use flags to determine the type of instruction, which is then used to parse the instruction into its corresponding segments.

## Bypassing
My bypassingControl module handles most of the bypassing that occurs. It is primarily used to bypass the values that go into the ALU's input. When bypassing occurs in other sections of the pipeline, I do the logic in the processor module.

## Stalling
The interlockDectory module finds cases where the FD latch and PC counter need to be stalled and inserts a nop into the DX latch. Another case where I need nops is when a branch is taken. My execute module outputs a ctrl_branch flag that is a 1 when a branch occurs and 0 otherwise. When the flag is 1, my fetch module selects the branched PC and nops are inserted into the FD and DX latch to flush the previous instructions. I also stall my entire pipeline for multicycle operations such as mult and div. When either of those instructions are executing and the data isn't ready, I turn off the write enable to all latches in the processor. This stalls the pipeline until the data is ready.

## Optimizations
Some of my modules are very verbose, which I would like to clean up in the future. Also, I would like to extract out more of the logic from the processor module because it contains a lot of random bypassing logic that could be moved to stage-specific modules.

## Bugs
My processor does not pass the Sort test, which is likely due to missing bypassing and interlocking cases.