module Preprocess(
  input  [22:0] io_ma,
  input  [22:0] io_mb,
  input  [7:0]  io_ea,
  input  [7:0]  io_eb,
  output [23:0] io_Fa,
  output [23:0] io_Fb
);
  wire  zeroOrMax = io_ea == 8'h0 | io_ea == 8'hff; // @[basicAdd.scala 39:30]
  wire [31:0] _GEN_2 = {{9'd0}, io_ma}; // @[basicAdd.scala 43:18]
  wire [31:0] _io_Fa_T = 32'h800000 | _GEN_2; // @[basicAdd.scala 43:18]
  wire [31:0] _GEN_0 = zeroOrMax ? {{9'd0}, io_ma} : _io_Fa_T; // @[basicAdd.scala 40:20 41:11 43:11]
  wire  zeroOrMax1 = io_eb == 8'h0 | io_eb == 8'hff; // @[basicAdd.scala 46:31]
  wire [31:0] _GEN_3 = {{9'd0}, io_mb}; // @[basicAdd.scala 50:18]
  wire [31:0] _io_Fb_T = 32'h800000 | _GEN_3; // @[basicAdd.scala 50:18]
  wire [31:0] _GEN_1 = zeroOrMax1 ? {{9'd0}, io_mb} : _io_Fb_T; // @[basicAdd.scala 47:21 48:11 50:11]
  assign io_Fa = _GEN_0[23:0];
  assign io_Fb = _GEN_1[23:0];
endmodule
module ExpDiffBasic(
  input  [7:0] io_Ea,
  input  [7:0] io_Eb,
  output [7:0] io_EMax,
  output [7:0] io_diff,
  output       io_smaller
);
  wire [7:0] _difference_T = ~io_Eb; // @[basicAdd.scala 66:29]
  wire [8:0] difference = io_Ea + _difference_T; // @[basicAdd.scala 66:26]
  wire  sign_bit = difference[7]; // @[basicAdd.scala 67:28]
  wire [8:0] _abs_difference_T = ~difference; // @[basicAdd.scala 68:39]
  wire [8:0] _abs_difference_T_2 = difference + 9'h1; // @[basicAdd.scala 68:63]
  wire [8:0] abs_difference = sign_bit ? _abs_difference_T : _abs_difference_T_2; // @[basicAdd.scala 68:27]
  assign io_EMax = sign_bit ? io_Eb : io_Ea; // @[basicAdd.scala 72:17]
  assign io_diff = abs_difference[7:0]; // @[basicAdd.scala 70:11]
  assign io_smaller = difference[7]; // @[basicAdd.scala 67:28]
endmodule
module SignicandSwapper(
  input  [23:0] io_Fa,
  input  [23:0] io_Fb,
  input         io_smaller,
  output [23:0] io_F1,
  output [23:0] io_F2
);
  assign io_F1 = io_smaller ? io_Fb : io_Fa; // @[basicAdd.scala 85:19 86:11 89:11]
  assign io_F2 = io_smaller ? io_Fa : io_Fb; // @[basicAdd.scala 85:19 87:11 90:11]
endmodule
module RightShift(
  input  [23:0] io_x,
  input  [7:0]  io_n,
  output [23:0] io_result
);
  assign io_result = io_x >> io_n; // @[basicAdd.scala 100:21]
endmodule
module MantissaAddSub(
  input  [23:0] io_a,
  input  [23:0] io_b,
  input         io_subtract,
  output [23:0] io_fr,
  output        io_overflow
);
  wire [23:0] _b_inverted_T = ~io_b; // @[basicAdd.scala 132:37]
  wire [23:0] b_inverted = io_subtract ? _b_inverted_T : io_b; // @[basicAdd.scala 132:23]
  wire [24:0] sum = io_a + b_inverted; // @[basicAdd.scala 134:18]
  wire  carryout = sum[24]; // @[basicAdd.scala 135:22]
  wire [24:0] _io_fr_T_1 = sum + 25'h1; // @[basicAdd.scala 137:32]
  wire [24:0] _io_fr_T_2 = ~sum; // @[basicAdd.scala 137:38]
  wire [24:0] _io_fr_T_3 = carryout ? _io_fr_T_1 : _io_fr_T_2; // @[basicAdd.scala 137:18]
  wire [24:0] _GEN_0 = io_subtract ? _io_fr_T_3 : sum; // @[basicAdd.scala 136:20 137:11 139:11]
  assign io_fr = _GEN_0[23:0];
  assign io_overflow = sum[24]; // @[basicAdd.scala 135:22]
endmodule
module LeadingOneDetector(
  input  [23:0] io_number,
  output [4:0]  io_position
);
  wire [4:0] _GEN_0 = io_number[0] ? 5'h0 : 5'h18; // @[basicAdd.scala 111:12 115:32 116:16]
  wire [4:0] _GEN_1 = io_number[1] ? 5'h1 : _GEN_0; // @[basicAdd.scala 115:32 116:16]
  wire [4:0] _GEN_2 = io_number[2] ? 5'h2 : _GEN_1; // @[basicAdd.scala 115:32 116:16]
  wire [4:0] _GEN_3 = io_number[3] ? 5'h3 : _GEN_2; // @[basicAdd.scala 115:32 116:16]
  wire [4:0] _GEN_4 = io_number[4] ? 5'h4 : _GEN_3; // @[basicAdd.scala 115:32 116:16]
  wire [4:0] _GEN_5 = io_number[5] ? 5'h5 : _GEN_4; // @[basicAdd.scala 115:32 116:16]
  wire [4:0] _GEN_6 = io_number[6] ? 5'h6 : _GEN_5; // @[basicAdd.scala 115:32 116:16]
  wire [4:0] _GEN_7 = io_number[7] ? 5'h7 : _GEN_6; // @[basicAdd.scala 115:32 116:16]
  wire [4:0] _GEN_8 = io_number[8] ? 5'h8 : _GEN_7; // @[basicAdd.scala 115:32 116:16]
  wire [4:0] _GEN_9 = io_number[9] ? 5'h9 : _GEN_8; // @[basicAdd.scala 115:32 116:16]
  wire [4:0] _GEN_10 = io_number[10] ? 5'ha : _GEN_9; // @[basicAdd.scala 115:32 116:16]
  wire [4:0] _GEN_11 = io_number[11] ? 5'hb : _GEN_10; // @[basicAdd.scala 115:32 116:16]
  wire [4:0] _GEN_12 = io_number[12] ? 5'hc : _GEN_11; // @[basicAdd.scala 115:32 116:16]
  wire [4:0] _GEN_13 = io_number[13] ? 5'hd : _GEN_12; // @[basicAdd.scala 115:32 116:16]
  wire [4:0] _GEN_14 = io_number[14] ? 5'he : _GEN_13; // @[basicAdd.scala 115:32 116:16]
  wire [4:0] _GEN_15 = io_number[15] ? 5'hf : _GEN_14; // @[basicAdd.scala 115:32 116:16]
  wire [4:0] _GEN_16 = io_number[16] ? 5'h10 : _GEN_15; // @[basicAdd.scala 115:32 116:16]
  wire [4:0] _GEN_17 = io_number[17] ? 5'h11 : _GEN_16; // @[basicAdd.scala 115:32 116:16]
  wire [4:0] _GEN_18 = io_number[18] ? 5'h12 : _GEN_17; // @[basicAdd.scala 115:32 116:16]
  wire [4:0] _GEN_19 = io_number[19] ? 5'h13 : _GEN_18; // @[basicAdd.scala 115:32 116:16]
  wire [4:0] _GEN_20 = io_number[20] ? 5'h14 : _GEN_19; // @[basicAdd.scala 115:32 116:16]
  wire [4:0] _GEN_21 = io_number[21] ? 5'h15 : _GEN_20; // @[basicAdd.scala 115:32 116:16]
  wire [4:0] _GEN_22 = io_number[22] ? 5'h16 : _GEN_21; // @[basicAdd.scala 115:32 116:16]
  assign io_position = io_number[23] ? 5'h17 : _GEN_22; // @[basicAdd.scala 115:32 116:16]
endmodule
module ControlUnit(
  input  [23:0] io_number,
  input  [4:0]  io_position,
  input         io_subtract,
  input         io_overflow,
  input  [7:0]  io_exp,
  input         io_baseSign,
  output        io_sign,
  output [7:0]  io_expOut,
  output [22:0] io_mantout
);
  wire  _posOver_T = ~io_subtract; // @[basicAdd.scala 158:31]
  wire  posOver = io_overflow & ~io_subtract; // @[basicAdd.scala 158:29]
  wire  negativeSubstract = io_overflow & io_subtract; // @[basicAdd.scala 159:39]
  wire [4:0] _shiftAmount_T = ~io_position; // @[basicAdd.scala 162:27]
  wire [4:0] shiftAmount = 5'h18 + _shiftAmount_T; // @[basicAdd.scala 162:25]
  wire  _midterm_T_3 = io_number[0] & io_number[1]; // @[basicAdd.scala 165:53]
  wire [22:0] _GEN_3 = {{22'd0}, _midterm_T_3}; // @[basicAdd.scala 165:37]
  wire [22:0] _midterm_T_5 = io_number[23:1] + _GEN_3; // @[basicAdd.scala 165:37]
  wire [7:0] _midexp_T_1 = io_exp + 8'h1; // @[basicAdd.scala 166:22]
  wire [54:0] _GEN_2 = {{31'd0}, io_number}; // @[basicAdd.scala 168:27]
  wire [54:0] _midterm_T_6 = _GEN_2 << shiftAmount; // @[basicAdd.scala 168:27]
  wire [7:0] _GEN_4 = {{3'd0}, shiftAmount}; // @[basicAdd.scala 169:22]
  wire [7:0] _midexp_T_3 = io_exp - _GEN_4; // @[basicAdd.scala 169:22]
  wire [54:0] _GEN_0 = posOver ? {{32'd0}, _midterm_T_5} : _midterm_T_6; // @[basicAdd.scala 164:17 165:13 168:13]
  wire [7:0] _GEN_1 = posOver ? _midexp_T_1 : _midexp_T_3; // @[basicAdd.scala 164:17 166:12 169:12]
  assign io_sign = negativeSubstract | io_baseSign & _posOver_T; // @[basicAdd.scala 174:32]
  assign io_expOut = io_position == 5'h18 ? 8'h0 : _GEN_1; // @[basicAdd.scala 171:28 172:12]
  assign io_mantout = _GEN_0[22:0]; // @[basicAdd.scala 163:21]
endmodule
module BasicAdder(
  input         clock,
  input         reset,
  input  [7:0]  io_e1,
  input  [7:0]  io_e2,
  input  [22:0] io_N1,
  input  [22:0] io_N2,
  input         io_s1,
  input         io_s2,
  output [31:0] io_sum,
  output [23:0] io_sigSWtst1,
  output [23:0] io_sigSWtst2,
  output        io_smr,
  output [7:0]  io_delta,
  output [23:0] io_rgh,
  output [24:0] io_sbsum,
  output        io_subs,
  output        io_test_sign_A,
  output        io_test_sign_B,
  output [4:0]  io_loda,
  output        io_nrS,
  output [7:0]  io_nrE,
  output [22:0] io_nrM
);
  wire [22:0] preprocess_io_ma; // @[basicAdd.scala 209:26]
  wire [22:0] preprocess_io_mb; // @[basicAdd.scala 209:26]
  wire [7:0] preprocess_io_ea; // @[basicAdd.scala 209:26]
  wire [7:0] preprocess_io_eb; // @[basicAdd.scala 209:26]
  wire [23:0] preprocess_io_Fa; // @[basicAdd.scala 209:26]
  wire [23:0] preprocess_io_Fb; // @[basicAdd.scala 209:26]
  wire [7:0] expDiff_io_Ea; // @[basicAdd.scala 210:23]
  wire [7:0] expDiff_io_Eb; // @[basicAdd.scala 210:23]
  wire [7:0] expDiff_io_EMax; // @[basicAdd.scala 210:23]
  wire [7:0] expDiff_io_diff; // @[basicAdd.scala 210:23]
  wire  expDiff_io_smaller; // @[basicAdd.scala 210:23]
  wire [23:0] sigSwap_io_Fa; // @[basicAdd.scala 211:23]
  wire [23:0] sigSwap_io_Fb; // @[basicAdd.scala 211:23]
  wire  sigSwap_io_smaller; // @[basicAdd.scala 211:23]
  wire [23:0] sigSwap_io_F1; // @[basicAdd.scala 211:23]
  wire [23:0] sigSwap_io_F2; // @[basicAdd.scala 211:23]
  wire [23:0] rghtShift_io_x; // @[basicAdd.scala 212:25]
  wire [7:0] rghtShift_io_n; // @[basicAdd.scala 212:25]
  wire [23:0] rghtShift_io_result; // @[basicAdd.scala 212:25]
  wire [23:0] addSub_io_a; // @[basicAdd.scala 213:22]
  wire [23:0] addSub_io_b; // @[basicAdd.scala 213:22]
  wire  addSub_io_subtract; // @[basicAdd.scala 213:22]
  wire [23:0] addSub_io_fr; // @[basicAdd.scala 213:22]
  wire  addSub_io_overflow; // @[basicAdd.scala 213:22]
  wire [23:0] LOD_io_number; // @[basicAdd.scala 214:19]
  wire [4:0] LOD_io_position; // @[basicAdd.scala 214:19]
  wire [23:0] norm_io_number; // @[basicAdd.scala 215:20]
  wire [4:0] norm_io_position; // @[basicAdd.scala 215:20]
  wire  norm_io_subtract; // @[basicAdd.scala 215:20]
  wire  norm_io_overflow; // @[basicAdd.scala 215:20]
  wire [7:0] norm_io_exp; // @[basicAdd.scala 215:20]
  wire  norm_io_baseSign; // @[basicAdd.scala 215:20]
  wire  norm_io_sign; // @[basicAdd.scala 215:20]
  wire [7:0] norm_io_expOut; // @[basicAdd.scala 215:20]
  wire [22:0] norm_io_mantout; // @[basicAdd.scala 215:20]
  Preprocess preprocess ( // @[basicAdd.scala 209:26]
    .io_ma(preprocess_io_ma),
    .io_mb(preprocess_io_mb),
    .io_ea(preprocess_io_ea),
    .io_eb(preprocess_io_eb),
    .io_Fa(preprocess_io_Fa),
    .io_Fb(preprocess_io_Fb)
  );
  ExpDiffBasic expDiff ( // @[basicAdd.scala 210:23]
    .io_Ea(expDiff_io_Ea),
    .io_Eb(expDiff_io_Eb),
    .io_EMax(expDiff_io_EMax),
    .io_diff(expDiff_io_diff),
    .io_smaller(expDiff_io_smaller)
  );
  SignicandSwapper sigSwap ( // @[basicAdd.scala 211:23]
    .io_Fa(sigSwap_io_Fa),
    .io_Fb(sigSwap_io_Fb),
    .io_smaller(sigSwap_io_smaller),
    .io_F1(sigSwap_io_F1),
    .io_F2(sigSwap_io_F2)
  );
  RightShift rghtShift ( // @[basicAdd.scala 212:25]
    .io_x(rghtShift_io_x),
    .io_n(rghtShift_io_n),
    .io_result(rghtShift_io_result)
  );
  MantissaAddSub addSub ( // @[basicAdd.scala 213:22]
    .io_a(addSub_io_a),
    .io_b(addSub_io_b),
    .io_subtract(addSub_io_subtract),
    .io_fr(addSub_io_fr),
    .io_overflow(addSub_io_overflow)
  );
  LeadingOneDetector LOD ( // @[basicAdd.scala 214:19]
    .io_number(LOD_io_number),
    .io_position(LOD_io_position)
  );
  ControlUnit norm ( // @[basicAdd.scala 215:20]
    .io_number(norm_io_number),
    .io_position(norm_io_position),
    .io_subtract(norm_io_subtract),
    .io_overflow(norm_io_overflow),
    .io_exp(norm_io_exp),
    .io_baseSign(norm_io_baseSign),
    .io_sign(norm_io_sign),
    .io_expOut(norm_io_expOut),
    .io_mantout(norm_io_mantout)
  );
  assign io_sum = 32'h1; // @[basicAdd.scala 265:10]
  assign io_sigSWtst1 = sigSwap_io_F1; // @[basicAdd.scala 248:16]
  assign io_sigSWtst2 = sigSwap_io_F2; // @[basicAdd.scala 249:16]
  assign io_smr = expDiff_io_smaller; // @[basicAdd.scala 247:10]
  assign io_delta = expDiff_io_diff; // @[basicAdd.scala 251:12]
  assign io_rgh = rghtShift_io_result; // @[basicAdd.scala 252:10]
  assign io_sbsum = {{1'd0}, addSub_io_fr}; // @[basicAdd.scala 254:12]
  assign io_subs = io_s1 != io_s2; // @[basicAdd.scala 234:25]
  assign io_test_sign_A = io_s1; // @[basicAdd.scala 256:18]
  assign io_test_sign_B = io_s2; // @[basicAdd.scala 257:18]
  assign io_loda = LOD_io_position; // @[basicAdd.scala 259:11]
  assign io_nrS = norm_io_sign; // @[basicAdd.scala 263:10]
  assign io_nrE = norm_io_expOut; // @[basicAdd.scala 261:10]
  assign io_nrM = norm_io_mantout; // @[basicAdd.scala 262:10]
  assign preprocess_io_ma = io_N1; // @[basicAdd.scala 217:20]
  assign preprocess_io_mb = io_N2; // @[basicAdd.scala 218:20]
  assign preprocess_io_ea = io_e1; // @[basicAdd.scala 219:20]
  assign preprocess_io_eb = io_e2; // @[basicAdd.scala 220:20]
  assign expDiff_io_Ea = io_e1; // @[basicAdd.scala 222:17]
  assign expDiff_io_Eb = io_e2; // @[basicAdd.scala 223:17]
  assign sigSwap_io_Fa = preprocess_io_Fa; // @[basicAdd.scala 225:17]
  assign sigSwap_io_Fb = preprocess_io_Fb; // @[basicAdd.scala 226:17]
  assign sigSwap_io_smaller = expDiff_io_smaller; // @[basicAdd.scala 227:22]
  assign rghtShift_io_x = sigSwap_io_F2; // @[basicAdd.scala 229:18]
  assign rghtShift_io_n = expDiff_io_diff; // @[basicAdd.scala 230:18]
  assign addSub_io_a = sigSwap_io_F1; // @[basicAdd.scala 232:15]
  assign addSub_io_b = rghtShift_io_result; // @[basicAdd.scala 233:15]
  assign addSub_io_subtract = io_s1 != io_s2; // @[basicAdd.scala 234:25]
  assign LOD_io_number = addSub_io_fr; // @[basicAdd.scala 237:17]
  assign norm_io_number = addSub_io_fr; // @[basicAdd.scala 239:18]
  assign norm_io_position = LOD_io_position; // @[basicAdd.scala 240:20]
  assign norm_io_subtract = io_s1 != io_s2; // @[basicAdd.scala 234:25]
  assign norm_io_overflow = addSub_io_overflow; // @[basicAdd.scala 242:20]
  assign norm_io_exp = expDiff_io_EMax; // @[basicAdd.scala 243:15]
  assign norm_io_baseSign = io_s1; // @[basicAdd.scala 244:20]
endmodule
