import chisel3._
import chisel3.util._


class Preprocess(val w: Int) extends Module {
  val io = IO(new Bundle {
    val ma = Input(UInt(w.W))
    val mb = Input(UInt(w.W))
    val ea = Input(UInt(8.W))  // Assuming 8-bit exponent
    val eb = Input(UInt(8.W))  // Assuming 8-bit exponent
    val Fa = Output(UInt((w+1).W))
    val Fb = Output(UInt((w+1).W))
  })

  val MSB = 1.U << w.U
  val zeroOrMax = Wire(Bool())
  val zeroOrMax1= Wire(Bool())
  
  zeroOrMax := io.ea === 0.U || io.ea === 255.U
  when (zeroOrMax) {
    io.Fa := io.ma
  } .otherwise {
    io.Fa := MSB | io.ma
  }
  
  zeroOrMax1 := io.eb === 0.U || io.eb === 255.U
  when (zeroOrMax1) {
    io.Fb := io.mb
  } .otherwise {
    io.Fb := MSB | io.mb
  }
}



class ExpDiffBasic extends Module {
  val io = IO(new Bundle {
  val Ea = Input(UInt(8.W))
  val Eb = Input(UInt(8.W))

  val EMax = Output(UInt(8.W))
  val diff = Output(UInt(8.W))
  val smaller = Output(Bool())
  })

  val difference = io.Ea +& ~io.Eb
  val sign_bit = difference(7)
  val abs_difference = Mux(sign_bit,  ~difference , difference+1.U  )

  io.diff := abs_difference
  io.smaller := sign_bit
  io.EMax := Mux(sign_bit,  io.Eb, io.Ea  )
}

class SignicandSwapper(val w: Int) extends Module {
  val io = IO(new Bundle {
    val Fa = Input(UInt(w.W))
    val Fb = Input(UInt(w.W))
    val smaller = Input(Bool())
    
    val F1 = Output(UInt(w.W))
    val F2 = Output(UInt(w.W))
  })

  when(io.smaller){
    io.F1 := io.Fb
    io.F2 := io.Fa
  } .otherwise{
    io.F1 := io.Fa
    io.F2 := io.Fb
  }
}

class RightShift(val w: Int)  extends Module {
  val io = IO(new Bundle {
   val x = Input(UInt(w.W))
  val n = Input(UInt(8.W))
  val result = Output(UInt(w.W))
  })
  io.result := io.x >> io.n
}

class LeadingOneDetector(val w: Int) extends Module {
  val io = IO(new Bundle {
     val number = Input(UInt(w.W))
    val position = Output(UInt(5.W))
  })

  // Initialize position to zero
  val position = Wire(UInt(5.W))
  position := w.U

  // Loop through the bits of the number to find the position of the first one
  for (i <- 0 to 23) {
    when(io.number(i) === 1.U) {
      position := i.U
    }
  }

  io.position := position
}

class MantissaAddSub(val w: Int) extends Module {
  val io = IO(new Bundle {
    val a = Input(UInt(w.W))
    val b = Input(UInt(w.W))
    val subtract = Input(Bool())
    val fr = Output(UInt((w).W))
    val overflow = Output(Bool()) 
  })

  val b_inverted = Mux(io.subtract, ~io.b, io.b)

  val sum = io.a +& b_inverted
  val carryout =  sum(24)
  when(io.subtract){
    io.fr :=  Mux(carryout, sum+1.U, ~sum )
  } .otherwise {
    io.fr := sum
  }
  io.overflow := carryout
}

class ControlUnit(val w: Int) extends Module {
  val io = IO(new Bundle {
    val number = Input(UInt(w.W))
    val position = Input(UInt(5.W))
    val subtract = Input(Bool())
    val overflow = Input(Bool())
    val exp = Input(UInt(8.W))
    val baseSign = Input(Bool())

    val sign = Output(Bool())
    val expOut = Output(UInt(8.W))
    val mantout = Output(UInt(23.W))
  })

  val posOver = io.overflow & !io.subtract
  val negativeSubstract = io.overflow & io.subtract

  val midexp = Wire ( UInt ()) 
  val shiftAmount = w.U + ~io.position
  val midterm = Wire(UInt(23.W))
  when(posOver) {
    midterm := ( (io.number >> 1) ) + (io.number(0) && io.number(1)) 
    midexp := io.exp +1.U
  } .otherwise {
    midterm := (io.number << shiftAmount) 
    midexp := io.exp -shiftAmount
  }
  when(io.position === w.U){
    midexp := 0.U
  }
  io.sign := negativeSubstract || (io.baseSign & !io.subtract)
  io.expOut := midexp
  io.mantout := midterm
}


class AdderIO extends Bundle {
  val e1 = Input(UInt(8.W))
  val e2 = Input(UInt(8.W))
  val N1 = Input(UInt(23.W))
  val N2 = Input(UInt(23.W))
  val s1 = Input(Bool())
  val s2 = Input(Bool())

  val nrS =  Output(Bool())
  val nrE = Output(UInt(8.W))
  val nrM = Output(UInt(23.W))

  //test I/O
  val sum = Output(UInt(32.W))

  val sigSWtst1 = Output(UInt(24.W))
  val sigSWtst2 = Output(UInt(24.W))
  val smr = Output(Bool())
  val delta = Output(UInt(8.W))
  val rgh = Output(UInt(24.W))

  
  val sbsum =Output(UInt(25.W))
  val subs =  Output(Bool())
  val test_sign_A = Output(Bool())
  val test_sign_B = Output(Bool())
  
  val loda = Output(UInt(5.W))
  
}
class BasicAdder extends Module {
  val io = IO(new AdderIO)

  val preprocess = Module(new Preprocess(23))
  val expDiff = Module(new ExpDiffBasic)
  val sigSwap = Module(new SignicandSwapper(24))
  val rghtShift = Module(new RightShift(24))
  val addSub = Module(new MantissaAddSub(24))
  val LOD = Module(new LeadingOneDetector(24))
  val norm = Module(new ControlUnit(24))

  preprocess.io.ma := io.N1
  preprocess.io.mb := io.N2
  preprocess.io.ea := io.e1
  preprocess.io.eb := io.e2

  expDiff.io.Ea := io.e1
  expDiff.io.Eb := io.e2

  sigSwap.io.Fa := preprocess.io.Fa
  sigSwap.io.Fb := preprocess.io.Fb
  sigSwap.io.smaller := expDiff.io.smaller

  rghtShift.io.x := sigSwap.io.F2
  rghtShift.io.n := expDiff.io.diff

  addSub.io.a := sigSwap.io.F1
  addSub.io.b := rghtShift.io.result
  val substract = io.s1 =/= io.s2
  addSub.io.subtract := substract

  LOD.io.number := addSub.io.fr
  
  norm.io.number :=addSub.io.fr
  norm.io.position := LOD.io.position
  norm.io.subtract :=  substract
  norm.io.overflow := addSub.io.overflow
  norm.io.exp := expDiff.io.EMax
  norm.io.baseSign := io.s1

  //test side
  io.smr := expDiff.io.smaller
  io.sigSWtst1 := sigSwap.io.F1
  io.sigSWtst2 := sigSwap.io.F2

  io.delta := expDiff.io.diff
  io.rgh := rghtShift.io.result

  io.sbsum := addSub.io.fr
  io.subs := substract
  io.test_sign_A := io.s1
  io.test_sign_B := io.s2

  io.loda := LOD.io.position
  
  io.nrE := norm.io.expOut
  io.nrM := norm.io.mantout
  io.nrS := norm.io.sign

  io.sum := 1.U
}