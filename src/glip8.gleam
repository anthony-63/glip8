import gleam/io
import ram.{type Ram}
import registers.{type RegisterMemory}
import screen.{type Screen}
import stack.{type Stack}

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

pub fn main() {
  let screen = screen.new(64, 32) |> screen.toggle_pixel(4, 10)
  screen |> screen.render()
  // paint.display_on_canvas(
  //   fn(config) -> paint.Picture {
  //     paint.combine([
  //       paint.rectangle(200.0, 200.0)
  //       |> paint.translate_xy(
  //         config.width /. 2.0 -. 100.0,
  //         config.height /. 2.0 -. 100.0,
  //       )
  //       |> paint.fill(paint.colour_hex("ffffff")),
  //     ])
  //   },
  //   "canvas",
  // )
  io.println("Hello from asd!")
}
