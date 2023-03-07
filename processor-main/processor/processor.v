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
    latchReset,                          // I: A latchReset signal

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
	input clock, latchReset;
	
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

    wire latchWrite;
    assign latchWrite = 1'b1; // TODO: fill in logic for writing latched data

    // Fetch stage
    wire [31:0] fetch_PC_out
	fetch fetch_stage(address_imem, fetch_PC_out, 32'b0, latchReset, clock, latchWrite, 1'b0); // TODO: implement PCafterJump and jump ctrl

    // FD Latch
    wire [31:0] FD_PCout, FD_InstOut;
    register32 FD_PCreg(.out(FD_PCout), .data(fetch_PC_out), .clk(~clock), .write_enable(latchWrite), .latchReset(latchReset));
    register32 FD_InstReg(.out(FD_InstOut), .data(q_imem), .clk(~clock), .write_enable(latchWrite), .latchReset(latchReset));

    // DX Latch
    wire [31:0] DX_PCin, DX_PCout, DX_Ain, DX_Aout, DX_Bin, DX_Bout, DX_InstIn, DX_InstOut;
    register32 DX_PCreg(.out(DX_PCout), .data(DX_PCin), .clk(~clock), .write_enable(latchWrite), .latchReset(latchReset));
    register32 DX_Areg(.out(DX_Aout), .data(DX_Ain), .clk(~clock), .write_enable(latchWrite), .latchReset(latchReset));
    register32 DX_Breg(.out(DX_Bout), .data(DX_Bin), .clk(~clock), .write_enable(latchWrite), .latchReset(latchReset));
    register32 DX_InstReg(.out(DX_InstOut), .data(DX_InstIn), .clk(~clock), .write_enable(latchWrite), .latchReset(latchReset));

    // XM Latch
    wire [31:0] XM_Oin, XM_Oout, XM_Bin, XM_Bout, XM_InstIn, XM_InstOut;
    register32 XM_Oreg(.out(XM_Oout), .data(XM_Oin), .clk(~clock), .write_enable(latchWrite), .latchReset(latchReset));
    register32 XM_Breg(.out(XM_Bout), .data(XM_Bin), .clk(~clock), .write_enable(latchWrite), .latchReset(latchReset));
    register32 XM_InstReg(.out(XM_InstOut), .data(XM_InstIn), .clk(~clock), .write_enable(latchWrite), .latchReset(latchReset));

    // MW Latch
    wire [31:0] MW_Oin, MW_Oout, MW_Din, MW_Dout, MW_InstIn, MW_InstOut;
    register32 MW_Oreg(.out(MW_Oout), .data(MW_Oin), .clk(~clock), .write_enable(latchWrite), .latchReset(latchReset));
    register32 MW_Dreg(.out(MW_Dout), .data(MW_Din), .clk(~clock), .write_enable(latchWrite), .latchReset(latchReset));
    register32 MW_InstReg(.out(MW_InstOut), .data(MW_InstIn), .clk(~clock), .write_enable(latchWrite), .latchReset(latchReset));

endmodule
