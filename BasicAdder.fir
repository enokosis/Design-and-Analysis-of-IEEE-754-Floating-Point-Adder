circuit BasicAdder :
  module Preprocess :
    input clock : Clock
    input reset : Reset
    output io : { flip ma : UInt<23>, flip mb : UInt<23>, flip ea : UInt<8>, flip eb : UInt<8>, Fa : UInt<24>, Fb : UInt<24>}

    node MSB = dshl(UInt<1>("h1"), UInt<5>("h17")) @[basicAdd.scala 35:17]
    wire zeroOrMax : UInt<1> @[basicAdd.scala 36:23]
    wire zeroOrMax1 : UInt<1> @[basicAdd.scala 37:23]
    node _zeroOrMax_T = eq(io.ea, UInt<1>("h0")) @[basicAdd.scala 39:22]
    node _zeroOrMax_T_1 = eq(io.ea, UInt<8>("hff")) @[basicAdd.scala 39:39]
    node _zeroOrMax_T_2 = or(_zeroOrMax_T, _zeroOrMax_T_1) @[basicAdd.scala 39:30]
    zeroOrMax <= _zeroOrMax_T_2 @[basicAdd.scala 39:13]
    when zeroOrMax : @[basicAdd.scala 40:20]
      io.Fa <= io.ma @[basicAdd.scala 41:11]
    else :
      node _io_Fa_T = or(MSB, io.ma) @[basicAdd.scala 43:18]
      io.Fa <= _io_Fa_T @[basicAdd.scala 43:11]
    node _zeroOrMax1_T = eq(io.eb, UInt<1>("h0")) @[basicAdd.scala 46:23]
    node _zeroOrMax1_T_1 = eq(io.eb, UInt<8>("hff")) @[basicAdd.scala 46:40]
    node _zeroOrMax1_T_2 = or(_zeroOrMax1_T, _zeroOrMax1_T_1) @[basicAdd.scala 46:31]
    zeroOrMax1 <= _zeroOrMax1_T_2 @[basicAdd.scala 46:14]
    when zeroOrMax1 : @[basicAdd.scala 47:21]
      io.Fb <= io.mb @[basicAdd.scala 48:11]
    else :
      node _io_Fb_T = or(MSB, io.mb) @[basicAdd.scala 50:18]
      io.Fb <= _io_Fb_T @[basicAdd.scala 50:11]

  module ExpDiffBasic :
    input clock : Clock
    input reset : Reset
    output io : { flip Ea : UInt<8>, flip Eb : UInt<8>, EMax : UInt<8>, diff : UInt<8>, smaller : UInt<1>}

    node _difference_T = not(io.Eb) @[basicAdd.scala 66:29]
    node difference = add(io.Ea, _difference_T) @[basicAdd.scala 66:26]
    node sign_bit = bits(difference, 7, 7) @[basicAdd.scala 67:28]
    node _abs_difference_T = not(difference) @[basicAdd.scala 68:39]
    node _abs_difference_T_1 = add(difference, UInt<1>("h1")) @[basicAdd.scala 68:63]
    node _abs_difference_T_2 = tail(_abs_difference_T_1, 1) @[basicAdd.scala 68:63]
    node abs_difference = mux(sign_bit, _abs_difference_T, _abs_difference_T_2) @[basicAdd.scala 68:27]
    io.diff <= abs_difference @[basicAdd.scala 70:11]
    io.smaller <= sign_bit @[basicAdd.scala 71:14]
    node _io_EMax_T = mux(sign_bit, io.Eb, io.Ea) @[basicAdd.scala 72:17]
    io.EMax <= _io_EMax_T @[basicAdd.scala 72:11]

  module SignicandSwapper :
    input clock : Clock
    input reset : Reset
    output io : { flip Fa : UInt<24>, flip Fb : UInt<24>, flip smaller : UInt<1>, F1 : UInt<24>, F2 : UInt<24>}

    when io.smaller : @[basicAdd.scala 85:19]
      io.F1 <= io.Fb @[basicAdd.scala 86:11]
      io.F2 <= io.Fa @[basicAdd.scala 87:11]
    else :
      io.F1 <= io.Fa @[basicAdd.scala 89:11]
      io.F2 <= io.Fb @[basicAdd.scala 90:11]

  module RightShift :
    input clock : Clock
    input reset : Reset
    output io : { flip x : UInt<24>, flip n : UInt<8>, result : UInt<24>}

    node _io_result_T = dshr(io.x, io.n) @[basicAdd.scala 100:21]
    io.result <= _io_result_T @[basicAdd.scala 100:13]

  module MantissaAddSub :
    input clock : Clock
    input reset : Reset
    output io : { flip a : UInt<24>, flip b : UInt<24>, flip subtract : UInt<1>, fr : UInt<24>, overflow : UInt<1>}

    node _b_inverted_T = not(io.b) @[basicAdd.scala 132:37]
    node b_inverted = mux(io.subtract, _b_inverted_T, io.b) @[basicAdd.scala 132:23]
    node sum = add(io.a, b_inverted) @[basicAdd.scala 134:18]
    node carryout = bits(sum, 24, 24) @[basicAdd.scala 135:22]
    when io.subtract : @[basicAdd.scala 136:20]
      node _io_fr_T = add(sum, UInt<1>("h1")) @[basicAdd.scala 137:32]
      node _io_fr_T_1 = tail(_io_fr_T, 1) @[basicAdd.scala 137:32]
      node _io_fr_T_2 = not(sum) @[basicAdd.scala 137:38]
      node _io_fr_T_3 = mux(carryout, _io_fr_T_1, _io_fr_T_2) @[basicAdd.scala 137:18]
      io.fr <= _io_fr_T_3 @[basicAdd.scala 137:11]
    else :
      io.fr <= sum @[basicAdd.scala 139:11]
    io.overflow <= carryout @[basicAdd.scala 141:15]

  module LeadingOneDetector :
    input clock : Clock
    input reset : Reset
    output io : { flip number : UInt<24>, position : UInt<5>}

    wire position : UInt<5> @[basicAdd.scala 110:22]
    position <= UInt<5>("h18") @[basicAdd.scala 111:12]
    node _T = bits(io.number, 0, 0) @[basicAdd.scala 115:19]
    node _T_1 = eq(_T, UInt<1>("h1")) @[basicAdd.scala 115:23]
    when _T_1 : @[basicAdd.scala 115:32]
      position <= UInt<1>("h0") @[basicAdd.scala 116:16]
    node _T_2 = bits(io.number, 1, 1) @[basicAdd.scala 115:19]
    node _T_3 = eq(_T_2, UInt<1>("h1")) @[basicAdd.scala 115:23]
    when _T_3 : @[basicAdd.scala 115:32]
      position <= UInt<1>("h1") @[basicAdd.scala 116:16]
    node _T_4 = bits(io.number, 2, 2) @[basicAdd.scala 115:19]
    node _T_5 = eq(_T_4, UInt<1>("h1")) @[basicAdd.scala 115:23]
    when _T_5 : @[basicAdd.scala 115:32]
      position <= UInt<2>("h2") @[basicAdd.scala 116:16]
    node _T_6 = bits(io.number, 3, 3) @[basicAdd.scala 115:19]
    node _T_7 = eq(_T_6, UInt<1>("h1")) @[basicAdd.scala 115:23]
    when _T_7 : @[basicAdd.scala 115:32]
      position <= UInt<2>("h3") @[basicAdd.scala 116:16]
    node _T_8 = bits(io.number, 4, 4) @[basicAdd.scala 115:19]
    node _T_9 = eq(_T_8, UInt<1>("h1")) @[basicAdd.scala 115:23]
    when _T_9 : @[basicAdd.scala 115:32]
      position <= UInt<3>("h4") @[basicAdd.scala 116:16]
    node _T_10 = bits(io.number, 5, 5) @[basicAdd.scala 115:19]
    node _T_11 = eq(_T_10, UInt<1>("h1")) @[basicAdd.scala 115:23]
    when _T_11 : @[basicAdd.scala 115:32]
      position <= UInt<3>("h5") @[basicAdd.scala 116:16]
    node _T_12 = bits(io.number, 6, 6) @[basicAdd.scala 115:19]
    node _T_13 = eq(_T_12, UInt<1>("h1")) @[basicAdd.scala 115:23]
    when _T_13 : @[basicAdd.scala 115:32]
      position <= UInt<3>("h6") @[basicAdd.scala 116:16]
    node _T_14 = bits(io.number, 7, 7) @[basicAdd.scala 115:19]
    node _T_15 = eq(_T_14, UInt<1>("h1")) @[basicAdd.scala 115:23]
    when _T_15 : @[basicAdd.scala 115:32]
      position <= UInt<3>("h7") @[basicAdd.scala 116:16]
    node _T_16 = bits(io.number, 8, 8) @[basicAdd.scala 115:19]
    node _T_17 = eq(_T_16, UInt<1>("h1")) @[basicAdd.scala 115:23]
    when _T_17 : @[basicAdd.scala 115:32]
      position <= UInt<4>("h8") @[basicAdd.scala 116:16]
    node _T_18 = bits(io.number, 9, 9) @[basicAdd.scala 115:19]
    node _T_19 = eq(_T_18, UInt<1>("h1")) @[basicAdd.scala 115:23]
    when _T_19 : @[basicAdd.scala 115:32]
      position <= UInt<4>("h9") @[basicAdd.scala 116:16]
    node _T_20 = bits(io.number, 10, 10) @[basicAdd.scala 115:19]
    node _T_21 = eq(_T_20, UInt<1>("h1")) @[basicAdd.scala 115:23]
    when _T_21 : @[basicAdd.scala 115:32]
      position <= UInt<4>("ha") @[basicAdd.scala 116:16]
    node _T_22 = bits(io.number, 11, 11) @[basicAdd.scala 115:19]
    node _T_23 = eq(_T_22, UInt<1>("h1")) @[basicAdd.scala 115:23]
    when _T_23 : @[basicAdd.scala 115:32]
      position <= UInt<4>("hb") @[basicAdd.scala 116:16]
    node _T_24 = bits(io.number, 12, 12) @[basicAdd.scala 115:19]
    node _T_25 = eq(_T_24, UInt<1>("h1")) @[basicAdd.scala 115:23]
    when _T_25 : @[basicAdd.scala 115:32]
      position <= UInt<4>("hc") @[basicAdd.scala 116:16]
    node _T_26 = bits(io.number, 13, 13) @[basicAdd.scala 115:19]
    node _T_27 = eq(_T_26, UInt<1>("h1")) @[basicAdd.scala 115:23]
    when _T_27 : @[basicAdd.scala 115:32]
      position <= UInt<4>("hd") @[basicAdd.scala 116:16]
    node _T_28 = bits(io.number, 14, 14) @[basicAdd.scala 115:19]
    node _T_29 = eq(_T_28, UInt<1>("h1")) @[basicAdd.scala 115:23]
    when _T_29 : @[basicAdd.scala 115:32]
      position <= UInt<4>("he") @[basicAdd.scala 116:16]
    node _T_30 = bits(io.number, 15, 15) @[basicAdd.scala 115:19]
    node _T_31 = eq(_T_30, UInt<1>("h1")) @[basicAdd.scala 115:23]
    when _T_31 : @[basicAdd.scala 115:32]
      position <= UInt<4>("hf") @[basicAdd.scala 116:16]
    node _T_32 = bits(io.number, 16, 16) @[basicAdd.scala 115:19]
    node _T_33 = eq(_T_32, UInt<1>("h1")) @[basicAdd.scala 115:23]
    when _T_33 : @[basicAdd.scala 115:32]
      position <= UInt<5>("h10") @[basicAdd.scala 116:16]
    node _T_34 = bits(io.number, 17, 17) @[basicAdd.scala 115:19]
    node _T_35 = eq(_T_34, UInt<1>("h1")) @[basicAdd.scala 115:23]
    when _T_35 : @[basicAdd.scala 115:32]
      position <= UInt<5>("h11") @[basicAdd.scala 116:16]
    node _T_36 = bits(io.number, 18, 18) @[basicAdd.scala 115:19]
    node _T_37 = eq(_T_36, UInt<1>("h1")) @[basicAdd.scala 115:23]
    when _T_37 : @[basicAdd.scala 115:32]
      position <= UInt<5>("h12") @[basicAdd.scala 116:16]
    node _T_38 = bits(io.number, 19, 19) @[basicAdd.scala 115:19]
    node _T_39 = eq(_T_38, UInt<1>("h1")) @[basicAdd.scala 115:23]
    when _T_39 : @[basicAdd.scala 115:32]
      position <= UInt<5>("h13") @[basicAdd.scala 116:16]
    node _T_40 = bits(io.number, 20, 20) @[basicAdd.scala 115:19]
    node _T_41 = eq(_T_40, UInt<1>("h1")) @[basicAdd.scala 115:23]
    when _T_41 : @[basicAdd.scala 115:32]
      position <= UInt<5>("h14") @[basicAdd.scala 116:16]
    node _T_42 = bits(io.number, 21, 21) @[basicAdd.scala 115:19]
    node _T_43 = eq(_T_42, UInt<1>("h1")) @[basicAdd.scala 115:23]
    when _T_43 : @[basicAdd.scala 115:32]
      position <= UInt<5>("h15") @[basicAdd.scala 116:16]
    node _T_44 = bits(io.number, 22, 22) @[basicAdd.scala 115:19]
    node _T_45 = eq(_T_44, UInt<1>("h1")) @[basicAdd.scala 115:23]
    when _T_45 : @[basicAdd.scala 115:32]
      position <= UInt<5>("h16") @[basicAdd.scala 116:16]
    node _T_46 = bits(io.number, 23, 23) @[basicAdd.scala 115:19]
    node _T_47 = eq(_T_46, UInt<1>("h1")) @[basicAdd.scala 115:23]
    when _T_47 : @[basicAdd.scala 115:32]
      position <= UInt<5>("h17") @[basicAdd.scala 116:16]
    io.position <= position @[basicAdd.scala 120:15]

  module ControlUnit :
    input clock : Clock
    input reset : Reset
    output io : { flip number : UInt<24>, flip position : UInt<5>, flip subtract : UInt<1>, flip overflow : UInt<1>, flip exp : UInt<8>, flip baseSign : UInt<1>, sign : UInt<1>, expOut : UInt<8>, mantout : UInt<23>}

    node _posOver_T = eq(io.subtract, UInt<1>("h0")) @[basicAdd.scala 158:31]
    node posOver = and(io.overflow, _posOver_T) @[basicAdd.scala 158:29]
    node negativeSubstract = and(io.overflow, io.subtract) @[basicAdd.scala 159:39]
    wire midexp : UInt @[basicAdd.scala 161:21]
    node _shiftAmount_T = not(io.position) @[basicAdd.scala 162:27]
    node _shiftAmount_T_1 = add(UInt<5>("h18"), _shiftAmount_T) @[basicAdd.scala 162:25]
    node shiftAmount = tail(_shiftAmount_T_1, 1) @[basicAdd.scala 162:25]
    wire midterm : UInt<23> @[basicAdd.scala 163:21]
    when posOver : @[basicAdd.scala 164:17]
      node _midterm_T = shr(io.number, 1) @[basicAdd.scala 165:29]
      node _midterm_T_1 = bits(io.number, 0, 0) @[basicAdd.scala 165:49]
      node _midterm_T_2 = bits(io.number, 1, 1) @[basicAdd.scala 165:65]
      node _midterm_T_3 = and(_midterm_T_1, _midterm_T_2) @[basicAdd.scala 165:53]
      node _midterm_T_4 = add(_midterm_T, _midterm_T_3) @[basicAdd.scala 165:37]
      node _midterm_T_5 = tail(_midterm_T_4, 1) @[basicAdd.scala 165:37]
      midterm <= _midterm_T_5 @[basicAdd.scala 165:13]
      node _midexp_T = add(io.exp, UInt<1>("h1")) @[basicAdd.scala 166:22]
      node _midexp_T_1 = tail(_midexp_T, 1) @[basicAdd.scala 166:22]
      midexp <= _midexp_T_1 @[basicAdd.scala 166:12]
    else :
      node _midterm_T_6 = dshl(io.number, shiftAmount) @[basicAdd.scala 168:27]
      midterm <= _midterm_T_6 @[basicAdd.scala 168:13]
      node _midexp_T_2 = sub(io.exp, shiftAmount) @[basicAdd.scala 169:22]
      node _midexp_T_3 = tail(_midexp_T_2, 1) @[basicAdd.scala 169:22]
      midexp <= _midexp_T_3 @[basicAdd.scala 169:12]
    node _T = eq(io.position, UInt<5>("h18")) @[basicAdd.scala 171:20]
    when _T : @[basicAdd.scala 171:28]
      midexp <= UInt<1>("h0") @[basicAdd.scala 172:12]
    node _io_sign_T = eq(io.subtract, UInt<1>("h0")) @[basicAdd.scala 174:49]
    node _io_sign_T_1 = and(io.baseSign, _io_sign_T) @[basicAdd.scala 174:47]
    node _io_sign_T_2 = or(negativeSubstract, _io_sign_T_1) @[basicAdd.scala 174:32]
    io.sign <= _io_sign_T_2 @[basicAdd.scala 174:11]
    io.expOut <= midexp @[basicAdd.scala 175:13]
    io.mantout <= midterm @[basicAdd.scala 176:14]

  module BasicAdder :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip e1 : UInt<8>, flip e2 : UInt<8>, flip N1 : UInt<23>, flip N2 : UInt<23>, flip s1 : UInt<1>, flip s2 : UInt<1>, sum : UInt<32>, sigSWtst1 : UInt<24>, sigSWtst2 : UInt<24>, smr : UInt<1>, delta : UInt<8>, rgh : UInt<24>, sbsum : UInt<25>, subs : UInt<1>, test_sign_A : UInt<1>, test_sign_B : UInt<1>, loda : UInt<5>, nrS : UInt<1>, nrE : UInt<8>, nrM : UInt<23>}

    inst preprocess of Preprocess @[basicAdd.scala 209:26]
    preprocess.clock <= clock
    preprocess.reset <= reset
    inst expDiff of ExpDiffBasic @[basicAdd.scala 210:23]
    expDiff.clock <= clock
    expDiff.reset <= reset
    inst sigSwap of SignicandSwapper @[basicAdd.scala 211:23]
    sigSwap.clock <= clock
    sigSwap.reset <= reset
    inst rghtShift of RightShift @[basicAdd.scala 212:25]
    rghtShift.clock <= clock
    rghtShift.reset <= reset
    inst addSub of MantissaAddSub @[basicAdd.scala 213:22]
    addSub.clock <= clock
    addSub.reset <= reset
    inst LOD of LeadingOneDetector @[basicAdd.scala 214:19]
    LOD.clock <= clock
    LOD.reset <= reset
    inst norm of ControlUnit @[basicAdd.scala 215:20]
    norm.clock <= clock
    norm.reset <= reset
    preprocess.io.ma <= io.N1 @[basicAdd.scala 217:20]
    preprocess.io.mb <= io.N2 @[basicAdd.scala 218:20]
    preprocess.io.ea <= io.e1 @[basicAdd.scala 219:20]
    preprocess.io.eb <= io.e2 @[basicAdd.scala 220:20]
    expDiff.io.Ea <= io.e1 @[basicAdd.scala 222:17]
    expDiff.io.Eb <= io.e2 @[basicAdd.scala 223:17]
    sigSwap.io.Fa <= preprocess.io.Fa @[basicAdd.scala 225:17]
    sigSwap.io.Fb <= preprocess.io.Fb @[basicAdd.scala 226:17]
    sigSwap.io.smaller <= expDiff.io.smaller @[basicAdd.scala 227:22]
    rghtShift.io.x <= sigSwap.io.F2 @[basicAdd.scala 229:18]
    rghtShift.io.n <= expDiff.io.diff @[basicAdd.scala 230:18]
    addSub.io.a <= sigSwap.io.F1 @[basicAdd.scala 232:15]
    addSub.io.b <= rghtShift.io.result @[basicAdd.scala 233:15]
    node substract = neq(io.s1, io.s2) @[basicAdd.scala 234:25]
    addSub.io.subtract <= substract @[basicAdd.scala 235:22]
    LOD.io.number <= addSub.io.fr @[basicAdd.scala 237:17]
    norm.io.number <= addSub.io.fr @[basicAdd.scala 239:18]
    norm.io.position <= LOD.io.position @[basicAdd.scala 240:20]
    norm.io.subtract <= substract @[basicAdd.scala 241:20]
    norm.io.overflow <= addSub.io.overflow @[basicAdd.scala 242:20]
    norm.io.exp <= expDiff.io.EMax @[basicAdd.scala 243:15]
    norm.io.baseSign <= io.s1 @[basicAdd.scala 244:20]
    io.smr <= expDiff.io.smaller @[basicAdd.scala 247:10]
    io.sigSWtst1 <= sigSwap.io.F1 @[basicAdd.scala 248:16]
    io.sigSWtst2 <= sigSwap.io.F2 @[basicAdd.scala 249:16]
    io.delta <= expDiff.io.diff @[basicAdd.scala 251:12]
    io.rgh <= rghtShift.io.result @[basicAdd.scala 252:10]
    io.sbsum <= addSub.io.fr @[basicAdd.scala 254:12]
    io.subs <= substract @[basicAdd.scala 255:11]
    io.test_sign_A <= io.s1 @[basicAdd.scala 256:18]
    io.test_sign_B <= io.s2 @[basicAdd.scala 257:18]
    io.loda <= LOD.io.position @[basicAdd.scala 259:11]
    io.nrE <= norm.io.expOut @[basicAdd.scala 261:10]
    io.nrM <= norm.io.mantout @[basicAdd.scala 262:10]
    io.nrS <= norm.io.sign @[basicAdd.scala 263:10]
    io.sum <= UInt<1>("h1") @[basicAdd.scala 265:10]

