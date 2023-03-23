/**
 * READ THIS DESCRIPTION!
 *
 * This is your processor module that will contain the bulk of your code submission. You are to implement
 * a 5-stage pipelined processor in this module, accounting for hazards and implementing bypasses as
 * necessary.
 *
 * Ultimately, your processor will be tested by a master skeleton, so the
 * testbench can see which controls signal you active when. Therefore, there needs to be a way to
 * "inject" imem, dmem, and regfile interfaces from some external controller module. The skeleton
 * file, Wrapper.v, acts as a small wrapper around your processor for this purpose. Refer to Wrapper.v
 * for more details.
 *
 * As a result, this module will NOT contain the RegFile nor the memory modules. Study the inputs 
 * very carefully - the RegFile-related I/Os are merely signals to be sent to the RegFile instantiated
 * in your Wrapper module. This is the same for your memory elements. 
 *
 *
 */
module processor(
    // Control signals
    clock,                          // I: The master clock
    reset,                          // I: A reset signal

    // Imem
    address_imem,                   // O: The address of the data to get from imem
    q_imem,                         // I: The data from imem

    // Dmem
    address_dmem,                   // O: The address of the data to get or put from/to dmem
    data,                           // O: The data to write to dmem
    wren,                           // O: Write enable for dmem
    q_dmem,                         // I: The data from dmem

    // Regfile
    ctrl_writeEnable,               // O: Write enable for RegFile
    ctrl_writeReg,                  // O: Register to write to in RegFile
    ctrl_readRegA,                  // O: Register to read from port A of RegFile
    ctrl_readRegB,                  // O: Register to read from port B of RegFile
    data_writeReg,                  // O: Data to write to for RegFile
    data_readRegA,                  // I: Data from port A of RegFile
    data_readRegB                   // I: Data from port B of RegFile
	 
	);

	// Control signals
	input clock, reset;
	
	// Imem
    output [31:0] address_imem;
	input [31:0] q_imem;

	// Dmem
	output [31:0] address_dmem, data;
	output wren;
	input [31:0] q_dmem;

	// Regfile
	output ctrl_writeEnable;
	output [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	output [31:0] data_writeReg;
	input [31:0] data_readRegA, data_readRegB;

    // Stalling
    wire latchWrite;
    wire[31:0] nop;
    assign nop = 32'b0;
    assign latchWrite = ~(isMultDiv && ~data_resultRDY);

    // Bypassing
    wire[31:0] bypassA, bypassB;
    bypassControl bypass(bypassA, bypassB, data, DX_InstOut, XM_InstOut, MW_InstOut, address_dmem, XM_Bout, data_writeReg, DX_Aout, DX_Bout);

    // Fetch stage
    wire [31:0] fetch_PC_out, PCAfterJump;
	fetchControl fetch_stage(address_imem, fetch_PC_out, PCAfterJump, reset, ~clock, fetch_FD_wren, ctrl_branch); // TODO: implement PCafterJump and jump ctrl

    // FD Latch
    wire [31:0] FD_PCout, FD_InstOut, FD_branchCheck;
    wire fetch_FD_wren;
    assign fetch_FD_wren = latchWrite && ~interlock;
    mux_2 checkFDflush(FD_branchCheck, ctrl_branch, q_imem, nop);
    register32 FD_PCreg(FD_PCout, fetch_PC_out, ~clock, fetch_FD_wren, reset);
    register32 FD_InstReg(FD_InstOut, FD_branchCheck, ~clock, fetch_FD_wren, reset);

    // Decode stage
    wire interlock;
    decodeControl decode_stage(ctrl_readRegA, ctrl_readRegB, FD_InstOut);
    interlockDetector detect_interlock(interlock, FD_InstOut, DX_InstOut);

    // bypass into data_readRegA if decode insn is BEX and writeback insn is SETX;
    wire[4:0] FDopcode, MWopcode;
    wire[31:0] dataInA;
    wire BEX_SETX_exception;
    assign FDopcode = FD_InstOut[31:26];
    assign MWopcode = MW_InstOut[31:26];
    assign BEX_SETX_exception = (FDopcode == 5'b10110) && (MWopcode == 5'b10101);
    assign dataInA = BEX_SETX_exception ? data_writeReg : data_readRegA;

    // DX Latch
    wire [31:0] DX_PCout, DX_Aout, DX_Bout, DX_InstOut, DX_branchCheck;
    mux_2 checkDXFlush(DX_branchCheck, ctrl_branch || interlock, FD_InstOut, nop);
    register32 DX_PCreg(.out(DX_PCout), .data(FD_PCout), .clk(~clock), .write_enable(latchWrite), .reset(reset));
    register32 DX_Areg(.out(DX_Aout), .data(dataInA), .clk(~clock), .write_enable(latchWrite), .reset(reset));
    register32 DX_Breg(.out(DX_Bout), .data(data_readRegB), .clk(~clock), .write_enable(latchWrite), .reset(reset));
    register32 DX_InstReg(.out(DX_InstOut), .data(DX_branchCheck), .clk(~clock), .write_enable(latchWrite), .reset(reset));

    // Execute stage
    wire[31:0] aluOut, executeOut, selectedA, selectedB, AafterJal, aluOpcodeAfterJal, PCsetToTarget;
    wire[4:0] aluOpcode, shamt;
    wire adder_overflow, ctrl_branch, isNotEqual, isLessThan, isMultDiv, isBLT, isBNE, isBEX;
    executeControl execute_stage(PCsetToTarget, selectedA, selectedB, aluOpcode, shamt, ctrl_branch, isMult, isDiv, isBLT, isBNE, isBEX, bypassA, bypassB, DX_InstOut, DX_PCout, isLessThan, isNotEqual, clock);
    assign PCAfterJump = ((isBLT & isLessThan) ||(isBNE & isNotEqual) || (isBEX & isNotEqual)) ? aluOut : PCsetToTarget;

    // For Jal only: overwrite reg31 with PC+1 and use ALU adder
    wire data_resultRDY, mult_exception, div_exception, isMult, isDiv, ctrlMult, ctrlDiv, disableCtrlSignal;
    wire[31:0] multDivResult;
    assign isMultDiv = isMult || isDiv;
    assign executeOut = isMultDiv ? multDivResult : aluOut;
    assign ctrlMult = isMult & ~disableCtrlSignal & ~data_resultRDY & ~clock;
    assign ctrlDiv = isDiv & ~disableCtrlSignal & ~data_resultRDY & ~clock;
    dffe_ref disabled(disableCtrlSignal, 1'b1, clock, isMultDiv, data_resultRDY);
    multdiv multDiv(bypassA, selectedB, ctrlMult, ctrlDiv, clock, multDivResult, mult_exception, div_exception, data_resultRDY);
    alu execute(selectedA, selectedB, aluOpcode, shamt, aluOut, isNotEqual, isLessThan, adder_overflow, clock);
    // TODO: deal with data exception in $rstatus

    // XM Latch
    wire [31:0] XM_InstOut, XM_Bout;
    register32 XM_Oreg(.out(address_dmem), .data(executeOut), .clk(~clock), .write_enable(latchWrite), .reset(reset)); // address input to dmem
    register32 XM_Breg(.out(XM_Bout), .data(DX_Bout), .clk(~clock), .write_enable(latchWrite), .reset(reset)); // data input to dmem
    register32 XM_InstReg(.out(XM_InstOut), .data(DX_InstOut), .clk(~clock), .write_enable(latchWrite), .reset(reset));

    // Memory stage
    memoryControl memory_stage(wren, XM_InstOut);

    // MW Latch
    wire [31:0] MW_Oout, MW_Dout, MW_InstOut;
    register32 MW_Oreg(.out(MW_Oout), .data(address_dmem), .clk(~clock), .write_enable(latchWrite), .reset(reset));
    register32 MW_Dreg(.out(MW_Dout), .data(q_dmem), .clk(~clock), .write_enable(latchWrite), .reset(reset));
    register32 MW_InstReg(.out(MW_InstOut), .data(XM_InstOut), .clk(~clock), .write_enable(latchWrite), .reset(reset));

    // Writeback stage
    writebackControl writeback_stage(ctrl_writeEnable, ctrl_writeReg, data_writeReg, MW_Dout, MW_Oout, MW_InstOut);

endmodule
