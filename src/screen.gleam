import gleam/dict.{type Dict}
import gleam/int
import gleam/list

@external(javascript, "C:/Users/antho/Documents/Code/Gleam/glip8/index.js", "draw_pixel")
pub fn draw_pixel(
  screen_width: Float,
  screen_height: Float,
  x: Float,
  y: Float,
) -> Nil

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
  screen.vmem
  |> dict.map_values(fn(k, v) {
    case v {
      OnPixel | DecayingPixel(_) ->
        draw_pixel(
          int.to_float(screen.width),
          int.to_float(screen.height),
          int.to_float(k.0),
          int.to_float(k.1),
        )
      OffPixel -> Nil
    }
  })
}
