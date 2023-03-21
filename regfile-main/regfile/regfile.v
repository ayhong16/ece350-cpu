module regfile (
	clock,
	ctrl_writeEnable, ctrl_reset, ctrl_writeReg,
	ctrl_readRegA, ctrl_readRegB, data_writeReg,
	data_readRegA, data_readRegB
);

	input clock, ctrl_writeEnable, ctrl_reset;
	input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
	input [31:0] data_writeReg;

	output [31:0] data_readRegA, data_readRegB;

	// Set up write wire to each register
	wire [31:0] writeDecode, writePortAnd;
	decoder32 writeDecoder(writeDecode, ctrl_writeReg, ctrl_writeEnable);
	genvar i;
	for (i = 0; i < 32; i = i + 1) begin
		and writeToPort(writePortAnd[i], writeDecode[i], ctrl_writeEnable);
	end

	// Read port A to each register
	wire [31:0] readRegisterA;
	decoder32 readA(readRegisterA, ctrl_readRegA, 1'b1);

	// Read port B to each register
	wire [31:0] readRegisterB;
	decoder32 readB(readRegisterB, ctrl_readRegB, 1'b1);

	// Connect each register
	wire [31:0][31:0] registers;

	register32 set_reg0(registers[0], data_writeReg, clock, 1'b0, ctrl_reset);
	buffer32 buffer0A(data_readRegA, 32'b0, readRegisterA[0]);
	buffer32 buffer0B(data_readRegB, 32'b0, readRegisterB[0]);

	genvar j;
	for (j = 1; j < 32; j = j + 1) begin
		register32 set_reg(registers[j], data_writeReg, clock, writePortAnd[j], ctrl_reset);
		buffer32 bufferA(data_readRegA, registers[j], readRegisterA[j]);
		buffer32 bufferB(data_readRegB, registers[j], readRegisterB[j]);
	end

endmodule
