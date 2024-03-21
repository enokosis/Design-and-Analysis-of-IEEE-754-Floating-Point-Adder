package decoder

import chisel3._
import chisel3.stage.ChiselStage
import chisel3.util.Cat


// Decodes sequence of bits into sign, exponent and mantissa

class Encoder(val w: Int) extends Module {
  val io = IO(new Bundle {
    
    val sign = Input(UInt(1.W))
    val exp = Input(UInt(8.W))
    val mantissa = Input(UInt(23.W))
    val bits = Output(UInt(w.W))
  })
  
    val inter = Cat(io.sign, io.exp)
    io.bits := Cat(inter, io.mantissa)
    
}