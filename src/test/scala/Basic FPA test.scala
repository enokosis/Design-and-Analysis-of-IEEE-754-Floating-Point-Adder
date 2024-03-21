
import chisel3._
import chiseltest._
import org.scalatest.flatspec.AnyFlatSpec

import java.lang._

import chisel3.stage.ChiselStage



class BasicAdderTest extends AnyFlatSpec with ChiselScalatestTester {
  behavior of "Basic adder"
  def e( bits:Int ) : Int = ((bits >> 23) & 0xff)
    def s( bits:Int ) : Int = if((bits >> 31) == 0)  0 else 1
    def m( bits:Int ) : Int ={if(e(bits) == 0) 
                 (bits & 0x7FFFFF) << 1 else
                 (bits & 0x7FFFFF)}
    def pk( bits:UInt ) : String = bits.peek().litValue.toInt.toString()
    def pkb( bits:UInt ) : String = bits.peek().litValue.toInt.toBinaryString

    def findLeadingOne(input: Int): Int = {
      var position = 24

      for (i <- 31 to 0 by -1) {
        if ((input & (1 << i)) != 0) {
          position = i
          return position
        }
      }
      position
    }
      
 /*   val r = new scala.util.Random
    val float1 =r.nextFloat()
    val float2 = r.nextFloat()
    val bits1 = Float.floatToRawIntBits(float1)
    val bits2 = Float.floatToRawIntBits(float2)
    val ea= e(bits1)
    val eb = e(bits2)
    val ma =  m(bits1)  
    val mb =  m(bits2)
    val sa = s(bits1)
    val sb = s(bits2)
    println(s"F1: $float1 $sa ${ea.toBinaryString}(${ea-127}) ${ma.toBinaryString}($ma) F2: $float2 $sb ${eb.toBinaryString}(${eb-127}) ${mb.toBinaryString}($mb) ")
    var expSmr = 1==0

  it should "Should calculate exps" in {
  test(new ExpDiffBasic) { c =>
  

    c.io.Ea.poke(ea)
    c.io.Eb.poke(eb)
    c.clock.step(1)

    c.io.smaller.expect( if (ea > eb)0 else 1)
    c.io.diff.expect( (ea-eb).abs.asUInt)

  //  println(s"ExpDiff: sm ${pk(c.io.smaller)} diff ${pk(c.io.diff)}")
    expSmr = pk(c.io.smaller) ==1

}
}
  it should "Swap mantisas" in {
  test(new SignicandSwapper(23)) { c =>

    c.io.Fa.poke(ma)
    c.io.Fb.poke(mb)
    c.io.smaller.poke(if(expSmr) false.B else true.B)
    c.clock.step(1)

    c.io.F1.expect( if(expSmr) ( ma).asUInt else ( mb).asUInt)
   // println(s"SigSwap: ${pkb(c.io.F1)} ${pkb(c.io.F2)}")

  }
} 


  it should "Should do right exps" in {
  test(new NormalizationUnit(24)) { c =>
    for( i <- 0 to 255){
    val num= 0
    val pos = 23
    val sub = false
    val over = false
    val exp = i

    c.io.number.poke(num)
    c.io.position.poke(pos)
    c.io.subtract.poke(sub)
    c.io.overflow.poke(over)
    c.io.exp.poke(exp)
    c.clock.step(1)

    val rs = exp
    c.io.expOut.expect( rs.U)

    println(s"Expin $exp out ${pk(c.io.expOut)}")
    
    }
  }
} */
  it should "Should add" in {
  test(new BasicAdder) { c =>
  var z = 0
  while(z<1000){
    val r = new scala.util.Random
    val float1:Float =   r.nextFloat()
    val float2:Float =   -1F *r.nextFloat()
    val bits1 = Float.floatToRawIntBits(float1)
    val bits2 = Float.floatToRawIntBits(float2)
    val bits3 = Float.floatToRawIntBits(float1 + float2)
    val ea= e(bits1)
    val eb = e(bits2)
    val ef= e(bits3)

    val ma =  m(bits1)  
    val mb =  m(bits2)
    val mf =  m(bits3)

    val sa = s(bits1)
    val sb = s(bits2)
    val sf = s(bits3)

    println(s"${z} F1: $float1 $sa ${ea.toBinaryString}(${ea-127}) ${ma.toBinaryString}($ma) F2: $float2 $sb ${eb.toBinaryString}(${eb-127}) ${mb.toBinaryString}($mb) F3: ${float1 + float2} $sf ${ef.toBinaryString}(${ef}) ${mf.toBinaryString}($mf) ")
    
    c.io.e1.poke(ea)
    c.io.e2.poke(eb)
    c.io.N1.poke(ma)
    c.io.N2.poke(mb)
    c.io.s1.poke(sa)
    c.io.s2.poke(sb)
    c.clock.step(1)

    val zeroOrMax1 = (ea==0 || ea==255)
    val zeroOrMax2 = (eb==0 || eb==255)
    val sha = if(zeroOrMax1) ma else(1<<23) |ma
    val shb = if(zeroOrMax1) mb else (1<<23) |mb
    val shiftRes = if(pk(c.io.smr).toInt ==0) sha else shb
    c.io.sigSWtst1.expect( shiftRes.asUInt )

    val shifted = pk(c.io.sigSWtst2).toInt >> pk(c.io.delta).toInt
    c.io.rgh.expect( shifted.U )
    
    val subSummed = if(sa==sb) (shiftRes + shifted).abs & 16777215 else (shiftRes- shifted).abs
    c.io.sbsum.expect(subSummed.U)

    val LODa = findLeadingOne(subSummed)
    c.io.loda.expect(LODa.U)
    
    c.io.nrM.expect(mf.U)
    c.io.nrE.expect(ef.U)
    

    
    //println(s"Smr ${pk(c.io.smr)} Bounce: ${pk(c.io.sigSWtst1)} ${pk(c.io.sigSWtst2)}")
    //println(s"Delta ${pk(c.io.delta)} Shifted ${shifted.toString()}")
    //println(s"Sum ${pk(c.io.sbsum)}")
    println(s"Sum ${pkb(c.io.sbsum)} is subs ${pk(c.io.subs)} signs ${pk(c.io.test_sign_A)} ${pk(c.io.test_sign_B)}")
    //println(s"LOD ${pk(c.io.loda)} ${pkb(c.io.sbsum)}")
    println(s"Nrm ${pk(c.io.nrM)} ${pkb(c.io.nrM)} ${pk(c.io.nrE)} ${pk(c.io.nrS)}")
    z+=1
    }
    //(new ChiselStage).emitVerilog(new BasicAdder)
  }
  }
  
}



