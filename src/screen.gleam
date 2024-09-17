import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import paint

pub type Vmem =
  Dict(#(Int, Int), ScreenPixel)

pub type ScreenPixel {
  OnPixel
  OffPixel
  DecayingPixel(lfetime: Float)
}

pub opaque type Screen {
  Screen(width: Int, height: Int, vmem: Vmem)
}

pub fn new(width: Int, height: Int) -> Screen {
  Screen(width: width, height: height, vmem: make_vmem_dict(width, height))
}

fn make_vmem_dict(width: Int, height: Int) -> Vmem {
  list.repeat(OffPixel, width * height)
  |> list.index_map(fn(pixel, i) {
    let x = i % width + height
    let y = i / width + height
    #(#(x, y), pixel)
  })
  |> dict.from_list
}

pub fn is_pixel_on(screen: Screen, x: Int, y: Int) -> Bool {
  case screen.vmem |> dict.get(#(x, y)) {
    Ok(OnPixel) -> True
    _ -> False
  }
}

pub fn toggle_pixel(screen: Screen, x: Int, y: Int) -> Screen {
  let p = case is_pixel_on(screen, x, y) {
    False -> OnPixel
    _ -> OffPixel
  }
  screen |> set_pixel(x, y, p)
}

pub fn set_pixel(screen: Screen, x: Int, y: Int, pixel: ScreenPixel) -> Screen {
  Screen(..screen, vmem: screen.vmem |> dict.insert(#(x, y), pixel))
}

pub fn render(screen: Screen) {
  paint.display_on_canvas(
    fn(config) -> paint.Picture {
      let pixel_width = config.width /. int.to_float(screen.width)
      let pixel_height = config.height /. int.to_float(screen.height)
      paint.combine(
        screen.vmem
        |> dict.map_values(fn(k, v) {
          paint.rectangle(pixel_width, pixel_height)
          |> paint.fill(
            paint.colour_hex(case v {
              OffPixel -> "000000"
              _ -> "ffffff"
            }),
          )
          |> paint.translate_xy(
            int.to_float(k.0) *. pixel_width,
            int.to_float(k.1) *. pixel_height,
          )
        })
        |> dict.values,
      )
    },
    "canvas",
  )
}
