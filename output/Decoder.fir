circuit Decoder :
  module Decoder :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip bits : UInt<32>, sign : UInt<1>, exp : UInt<8>, mantissa : UInt<23>}

    node _io_sign_T = bits(io.bits, 31, 31) @[decoder.scala 16:23]
    io.sign <= _io_sign_T @[decoder.scala 16:13]
    node _io_exp_T = bits(io.bits, 30, 23) @[decoder.scala 17:22]
    io.exp <= _io_exp_T @[decoder.scala 17:12]
    node _io_mantissa_T = bits(io.bits, 22, 0) @[decoder.scala 18:27]
    io.mantissa <= _io_mantissa_T @[decoder.scala 18:17]

