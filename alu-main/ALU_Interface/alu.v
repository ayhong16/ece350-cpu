module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, adder_overflow, clock);
  input [31:0] data_operandA, data_operandB;
  input [4:0] ctrl_ALUopcode, ctrl_shiftamt;
  input clock;
  output [31:0] data_result;
  output isNotEqual, isLessThan, adder_overflow;

  // Non-adding operations
  wire [31:0] add_data, and_data, or_data, sll_data, sra_data;
  and32 andData(and_data, data_operandA, data_operandB);
  or32 orData(or_data, data_operandA, data_operandB);
  sll32 sllData(sll_data, ctrl_shiftamt, data_operandA);
  sra32 srrData(sra_data, ctrl_shiftamt, data_operandA);
  comparator_32bit compare(isNotEqual, isLessThan, data_operandA, data_operandB);

  // Adding and subtracting
  wire [31:0] add_or_sub;
  wire [31:0] negative_B;

  not32 flip(negative_B, data_operandB);
  mux_2 addSubSelector(add_or_sub, ctrl_ALUopcode[0], data_operandB, negative_B);
  cla_adder addData(add_data, adder_overflow, data_operandA, add_or_sub, ctrl_ALUopcode[0]);

  alu_op opcode(data_result, ctrl_ALUopcode, add_data, add_data, and_data, or_data, sll_data, sra_data);
endmodule