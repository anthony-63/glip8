import ram.{type Ram}
import registers.{type RegisterMemory}
import screen.{type Screen}
import stack.{type Stack}

@external(javascript, "C:/Users/antho/Documents/Code/Gleam/glip8/index.js", "render_window")
pub fn render_window() -> Float

pub const rom_path = "roms/test_opcode.ch8"

pub const font_memory = <<
  240, 144, 144, 144, 240, 32, 96, 32, 32, 112, 240, 16, 240, 128, 240, 240, 16,
  240, 16, 240, 144, 144, 240, 16, 16, 240, 128, 240, 16, 240, 240, 128, 240,
  144, 240, 240, 16, 32, 64, 64, 240, 144, 240, 144, 240, 240, 144, 240, 16, 240,
  240, 144, 240, 144, 144, 224, 144, 224, 144, 224, 240, 128, 128, 128, 240, 224,
  144, 144, 144, 224, 240, 128, 240, 128, 240, 240, 128, 240, 128, 128,
>>

pub type State {
  WaitingForROM
  Running
  PollingInput
}

pub type ROM =
  BitArray

pub type Chip8 {
  Chip8(
    state: State,
    registers: RegisterMemory,
    ram: Ram,
    pc: Int,
    stack: Stack,
    screen: Screen,
  )
}

pub fn new_chip8() -> Chip8 {
  Chip8(
    state: Running,
    registers: registers.new(),
    ram: ram.new(4096),
    pc: 0,
    stack: stack.new(),
    screen: screen.new(64, 32) |> screen.toggle_pixel(63, 31),
  )
}

pub fn step(emulator: Chip8) -> Chip8 {
  let new_emulator = emulator
  //Chip8(..emulator)

  new_emulator.screen |> screen.render()
  render_window()
  new_emulator
}
