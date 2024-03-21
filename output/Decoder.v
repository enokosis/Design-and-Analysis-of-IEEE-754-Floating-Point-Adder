module Decoder(
  input         clock,
  input         reset,
  input  [31:0] io_bits,
  output        io_sign,
  output [7:0]  io_exp,
  output [22:0] io_mantissa
);
  assign io_sign = io_bits[31]; // @[decoder.scala 16:23]
  assign io_exp = io_bits[30:23]; // @[decoder.scala 17:22]
  assign io_mantissa = io_bits[22:0]; // @[decoder.scala 18:27]
endmodule
