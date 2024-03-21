package decoder


import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec

import java.lang._

import chisel3.stage.ChiselStage


class DecoderTest extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "Decoder"
  
  it should "Should decode floating" in {
  test(new Decoder(32)) { c =>
  for (i <- 0 until 10) {

    val r = new scala.util.Random
    val float =r.nextFloat()
    //var float = 0.toFloat
    val bits = Float.floatToRawIntBits(float)
    
    val s = if((bits >> 31) == 0)  0 else 1
    val e = ((bits >> 23) & 0xff)
    val m = if(e == 0) 
                 (bits & 0x7FFFFF) << 1 else
                 (bits & 0x7FFFFF)

    c.io.bits.poke(bits)
    c.clock.step(1)

    c.io.sign.expect(s.U)
    c.io.exp.expect(e.U)
    c.io.mantissa.expect(m.U)
    println("Input values: "+ float.toString + " As decoded sign: "+ s.toString + " exponent: " + e.toString + " Mantissa: " + m.toString + " Chisel Mantissa:" + c.io.mantissa.peek().litValue)
    (new ChiselStage).emitVerilog(new Decoder(32),Array("--target-dir", "output/"))
  }
 //  
}
}
}