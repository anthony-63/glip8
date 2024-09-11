import gleam/dict
import gleam/int

pub type DataRegister {
  V0
  V1
  V2
  V3
  V4
  V5
  V6
  V7
  V8
  V9
  VA
  VB
  VC
  VD
  VE
  VF
}

pub opaque type RegisterMemory {
  RegisterMemory(
    address_register: Int,
    delay_timer: Int,
    data_registers: dict.Dict(DataRegister, Int),
  )
}

pub fn new() -> RegisterMemory {
  let data_registers =
    dict.new()
    |> dict.insert(V0, 0)
    |> dict.insert(V1, 0)
    |> dict.insert(V2, 0)
    |> dict.insert(V3, 0)
    |> dict.insert(V4, 0)
    |> dict.insert(V5, 0)
    |> dict.insert(V6, 0)
    |> dict.insert(V7, 0)
    |> dict.insert(V8, 0)
    |> dict.insert(V9, 0)
    |> dict.insert(VA, 0)
    |> dict.insert(VB, 0)
    |> dict.insert(VC, 0)
    |> dict.insert(VD, 0)
    |> dict.insert(VE, 0)
    |> dict.insert(VF, 0)

  RegisterMemory(
    address_register: 0,
    delay_timer: 0,
    data_registers: data_registers,
  )
}

fn encode8(value: Int) -> Int {
  let assert <<r>> = <<value:size(8)>>
  r
}

fn encode16(value: Int) -> Int {
  let assert <<r, r1>> = <<value:size(16)>>
  r * 256 + r1
}

pub fn get_address_register(registers: RegisterMemory) -> Int {
  registers.address_register
}

pub fn set_address_register(
  registers: RegisterMemory,
  value: Int,
) -> RegisterMemory {
  RegisterMemory(..registers, address_register: encode16(value))
}

pub fn get_delay_timer(registers: RegisterMemory) -> Int {
  registers.delay_timer
}

pub fn set_delay_timer(registers: RegisterMemory, value: Int) -> RegisterMemory {
  RegisterMemory(..registers, delay_timer: encode8(value))
}

pub fn get_data_register(
  registers: RegisterMemory,
  register: DataRegister,
) -> Int {
  let assert Ok(value) = dict.get(registers.data_registers, register)
  value
}

pub fn set_data_register(
  registers: RegisterMemory,
  register: DataRegister,
  value: Int,
) -> RegisterMemory {
  let new_registers = dict.insert(registers.data_registers, register, value)
  RegisterMemory(..registers, data_registers: new_registers)
}

pub fn decrement_delay_timer(registers: RegisterMemory) -> RegisterMemory {
  RegisterMemory(
    ..registers,
    delay_timer: int.max(0, registers.delay_timer - 1),
  )
}

pub fn to_data_register(i: Int) -> DataRegister {
  case i {
    0 -> V0
    1 -> V1
    2 -> V2
    3 -> V3
    4 -> V4
    5 -> V5
    6 -> V6
    7 -> V7
    8 -> V8
    9 -> V9
    10 -> VA
    11 -> VB
    12 -> VC
    13 -> VD
    14 -> VE
    15 -> VF
    _ -> panic as "Invalid register passed in"
  }
}

pub fn data_register_to_string(register: DataRegister) -> String {
  case register {
    V0 -> "V0"
    V1 -> "V1"
    V2 -> "V2"
    V3 -> "V3"
    V4 -> "V4"
    V5 -> "V5"
    V6 -> "V6"
    V7 -> "V7"
    V8 -> "V8"
    V9 -> "V9"
    VA -> "VA"
    VB -> "VB"
    VC -> "VC"
    VD -> "VD"
    VE -> "VE"
    VF -> "VF"
  }
}
