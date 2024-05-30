// Define records for registers, immediates, and dag names for input/output parameters
def Reg;
def Imm16;
def ins;
def outs;

// Instruction class
class Instruction <string Name, dag Inputs, dag Outputs> {
  bits<32> insn;
  string name = Name;
  dag inputs = Inputs;
  dag outputs = Outputs;
}

// R-format instruction class
class RFormatInsn <bits<6> opcode, bits<11> opcode_ext, string name, dag ins, dag outs> : Instruction<name, ins, outs> {
  bits<5> rd;
  bits<5> rs1;
  bits<5> rs2;
  let insn{5-0} = opcode;
  let insn{10-6} = rd;
  let insn{15-11} = rs1;
  let insn{20-16} = rs2;
  let insn{31-21} = opcode_ext;
}

// I-format instruction class
class IFormatInsn <bits<6> opcode, string name, dag ins, dag outs> : Instruction<name, ins, outs> {
  bits<5> rd;
  bits<5> rs1;
  bits<16> imm;
  let insn{5-0} = opcode;
  let insn{10-6} = rd;
  let insn{15-11} = rs1;
  let insn{31-16} = imm;
}


// Multiclass for defining binary ALU operations (register and immediate variants).
multiclass ALUBinaryOp <bits<6> opcode, string name> {
  defvar output = (outs Reg:$rd);
  def "" : RFormatInsn<opcode, 0b00000000000, name, (ins Reg:$rs1, Reg:$rs2), output>;
  def I  : IFormatInsn<!or(0b100000, opcode), name # "i", (ins Reg:$rs1, Imm16:$imm), output>;
}

// Define ADD and ADDI operations.
defm ADD : ALUBinaryOp<0b000101, "add">;
