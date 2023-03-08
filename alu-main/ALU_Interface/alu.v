module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, adder_overflow, mult_exception, div_exception, clock);
  input [31:0] data_operandA, data_operandB;
  input [4:0] ctrl_ALUopcode, ctrl_shiftamt;
  input clock;
  output [31:0] data_result;
  output isNotEqual, isLessThan, adder_overflow, mult_exception, div_exception;

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

  // Multiplication and division
  wire mult_data_resultRDY, div_data_resultRDY;
  wire[31:0] multResult, divResult;
  multdiv mult(data_operandA, data_operandB, 1'b1, 1'b0, clock, multResult, mult_exception, mult_data_resultRDY);
  multdiv div(data_operandA, data_operandB, 1'b0, 1'b1, clock, divResult, div_exception, div_data_resultRDY);

  alu_op opcode(data_result, ctrl_ALUopcode, add_data, add_data, and_data, or_data, sll_data, sra_data, multResult, divResult);
endmodule