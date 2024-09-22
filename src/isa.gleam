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
  RandomAnd(reg: DataRegister, to_and: Int)
  Draw(x: DataRegister, y: DataRegister, addr: Int)
  SkipIfKeyPressed(reg: DataRegister)
  SkipIfKeyNotPressed(reg: DataRegister)
  DelayTimerToReg(reg: DataRegister)
  RegToDelayTimer(reg: DataRegister)
  RegToSoundTimer(reg: DataRegister)
  WaitForkKeySetReg(reg: DataRegister)
  Unknown(op: BitArray)
  Test
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
    <<8:4, x:4, y:4, 0:4>> ->
      LoadRegToReg(registers.to_data_register(y), registers.to_data_register(x))
    <<8:4, x:4, y:4, 1:4>> ->
      OrRegReg(registers.to_data_register(x), registers.to_data_register(y))
    <<8:4, x:4, y:4, 2:4>> ->
      AndRegReg(registers.to_data_register(x), registers.to_data_register(y))
    <<8:4, x:4, y:4, 3:4>> ->
      XorRegReg(registers.to_data_register(x), registers.to_data_register(y))
    <<8:4, x:4, y:4, 4:4>> ->
      AddRegReg(registers.to_data_register(x), registers.to_data_register(y))
    <<8:4, x:4, y:4, 5:4>> ->
      SubRegReg(registers.to_data_register(x), registers.to_data_register(y))
    <<8:4, x:4, _:4, 6:4>> -> ShrReg(registers.to_data_register(x))
    <<8:4, x:4, y:4, 7:4>> ->
      SubInvRegReg(registers.to_data_register(x), registers.to_data_register(y))
    <<8:4, x:4, _:4, 0xE:4>> -> ShlReg(registers.to_data_register(x))
    <<9:4, x:4, y:4, 0:4>> ->
      SkipInstructionNeqRegReg(
        registers.to_data_register(x),
        registers.to_data_register(y),
      )
    <<0xa:4, nnn:12>> -> SeTI(nnn)
    <<0xb:4, nnn:12>> -> JumpAddressAddV0(nnn)
    <<0xc:4, x:4, kk:8>> -> RandomAnd(registers.to_data_register(x), kk)
    <<0xd:4, x:4, y:4, n:4>> ->
      Draw(registers.to_data_register(x), registers.to_data_register(y), n)
    <<0xe, x:4, 0x9e:8>> -> SkipIfKeyPressed(registers.to_data_register(x))
    <<0xe, x:4, 0xa1:8>> -> SkipIfKeyNotPressed(registers.to_data_register(x))
    <<0xf, x:4, 0x07:8>> -> DelayTimerToReg(registers.to_data_register(x))
    <<0xf, x:4, 0x15:8>> -> WaitForkKeySetReg(registers.to_data_register(x))
    <<0xf, x:4, 0x15:8>> -> RegToDelayTimer(registers.to_data_register(x))
    <<0xf, x:4, 0x18:8>> -> RegToSoundTimer(registers.to_data_register(x))
    <<0xf, x:4, 0x1e:8>> -> AddIReg(registers.to_data_register(x))
    <<0xf, x:4, 0x29:8>> -> SetISpriteDigit(registers.to_data_register(x))
    <<0xf, x:4, 0x33:8>> -> RegToBCD(registers.to_data_register(x))
    <<0xf, x:4, 0x55:8>> ->
      StoreRegistersMemRecurse(registers.to_data_register(x))
    <<0xf, x:4, 0x65:8>> ->
      ReadRegistersMemRecurse(registers.to_data_register(x))
    _ -> Unknown(op)
  }
}
