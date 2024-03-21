package decoder


import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec

import java.lang._

import chisel3.stage.ChiselStage


class EncoderTest extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "Encoder"
  
  it should "Should encode bits in to floating number" in {
  test(new Encoder(32)) { c =>
  for (i <- 0 until 10) {

    val r = new scala.util.Random
    val float =r.nextFloat()
    val bits = Float.floatToRawIntBits(float)

    val s = if((bits >> 31) == 0)  0 else 1
    val e = ((bits >> 23) & 0xff)
    val m = if(e == 0) 
                 (bits & 0x7FFFFF) << 1 else
                 (bits & 0x7FFFFF)

    c.io.sign.poke(s)
    c.io.exp.poke(e)
    c.io.mantissa.poke(m)
    c.clock.step(1)

    c.io.bits.expect(bits.U)
    val out = c.io.bits.peek().litValue
    
    println("Input values: "+ float.toString + " Float to raw Int: "+ bits.toString + " Encode output int: " + out.toString + " Resulted float: " + Float.intBitsToFloat(out.toInt).toString )
    
  }
  (new ChiselStage).emitVerilog(new Encoder(32))
}
}
}