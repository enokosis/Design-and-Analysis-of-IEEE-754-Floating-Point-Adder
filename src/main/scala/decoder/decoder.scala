package decoder

import chisel3._
import chisel3.stage.ChiselStage


// Decodes sequence of bits into sign, exponent and mantissa

class Decoder(val w: Int) extends Module {
  val io = IO(new Bundle {
    val bits = Input(UInt(w.W))
    val sign = Output(UInt(1.W))
    val exp = Output(UInt(8.W))
    val mantissa = Output(UInt(23.W))
  })
    io.sign := io.bits(w-1)
    io.exp := io.bits( (w-2), (w-9))
    io.mantissa := io.bits((w-10), 0)
    
}



