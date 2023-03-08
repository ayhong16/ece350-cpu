module alu_op(
  output [31:0] result,
  input [4:0] in, 
  input [31:0] add_data, subtract_data, and_data, or_data, sll_data, sra_data, mult_data, div_data);

  wire [2:0] select;
  assign select = in[2:0];

  mux_8 mux(result, select, add_data, subtract_data, and_data, or_data, sll_data, sra_data, mult_data, div_data);
endmodule