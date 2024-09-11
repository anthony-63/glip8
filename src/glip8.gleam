import gleam/io
import paint

pub fn main() {
  paint.display_on_canvas(
    fn(config) -> paint.Picture {
      paint.combine([
        paint.rectangle(200.0, 200.0)
        |> paint.translate_xy(
          config.width /. 2.0 -. 100.0,
          config.height /. 2.0 -. 100.0,
        )
        |> paint.fill(paint.colour_hex("ffffff")),
      ])
    },
    "canvas",
  )
  io.println("Hello from asd!")
}
