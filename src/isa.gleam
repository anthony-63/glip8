import registers.{type DataRegister}

pub type Instruction {
  JumpInternal(addr: Int)
  ClearDisplay
  ReturnFromSubroutine
  JumpAddress(addr: Int)
  CallSubroutine(addr: Int)
  SkipInstructionEqRegInt(reg: DataRegister, data: Int)
  SkipInstructionEqRegReg(reg1: DataRegister, reg2: DataRegister)
  SkipInstructionNeqRegInt(reg: DataRegister, data: Int)
  SkipInstructionNeqRegReg(reg1: DataRegister, reg2: DataRegister)
  LoadByteToReg(reg: DataRegister, data: Int)
  LoadRegToReg(regsrc: DataRegister, regdst: DataRegister)
  AddByteToReg(reg: DataRegister, data: Int)
  OrRegReg(reg1: DataRegister, reg2: DataRegister)
  AndRegReg(reg1: DataRegister, reg2: DataRegister)
  XorRegReg(reg1: DataRegister, reg2: DataRegister)
  AddRegReg(reg1: DataRegister, reg2: DataRegister)
  SubRegReg(reg1: DataRegister, reg2: DataRegister)
  SubInvRegReg(reg1: DataRegister, reg2: DataRegister)
  ShrReg(reg: DataRegister)
  ShlReg(reg: DataRegister)
  SeTI(data: Int)
  AddIReg(reg: DataRegister)
  SetISpriteDigit(reg: DataRegister)
  RegToBCD(reg: DataRegister)
  StoreRegistersMemRecurse(end: DataRegister)
  ReadRegistersMemRecurse(end: DataRegister)
  JumpAddressAddV0(addr: Int)
  RandomAnd(reg: DataRegister)
  Draw(x: DataRegister, y: DataRegister, addr: Int)
  SkipIfKeyPressed(reg: DataRegister)
  SkipIfKeyNotPressed(reg: DataRegister)
  DelayTimerToReg(reg: DataRegister)
  RegToDelayTimer(reg: DataRegister)
  RegToSoundTimer(reg: DataRegister)
  WaitForkKeySetReg(reg: DataRegister, data: Int)
  Unknown(op: BitArray)
}

pub fn decode(op: BitArray) -> Instruction {
  case op {
    <<0:4, nnn:12>> -> JumpInternal(nnn)
    <<0x00E0>> -> ClearDisplay
    <<0x00EE>> -> ReturnFromSubroutine
    <<1:4, nnn:12>> -> JumpAddress(nnn)
    <<2:4, nnn:12>> -> CallSubroutine(nnn)
    <<3:4, x:4, kk:8>> ->
      SkipInstructionEqRegInt(registers.to_data_register(x), kk)
    <<4:4, x:4, kk:8>> ->
      SkipInstructionNeqRegInt(registers.to_data_register(x), kk)
    <<5:4, x:4, y:4, 0:4>> ->
      SkipInstructionEqRegReg(
        registers.to_data_register(x),
        registers.to_data_register(y),
      )
    <<6:4, x:4, kk:8>> -> LoadByteToReg(registers.to_data_register(x), kk)
    <<7:4, x:4, kk:8>> -> AddByteToReg(registers.to_data_register(x), kk)
    _ -> Unknown(op)
  }
}
