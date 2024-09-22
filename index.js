import { step, new_chip8 } from "./build/dev/javascript/glip8/glip8.mjs"
import sdl2 from "@kmamal/sdl"

const width = 64.0 * 10.0
const height = 32.0 * 10.0

const window = sdl2.video.createWindow({title: "CHIP8 in GLEAM", width: width, height: height})
var stride = width * 4
var buffer = Buffer.alloc(stride * height)

export function render_window() {
    if(window.destroyed) return
    window.render(width, height, stride, 'rgba32', buffer)
}

export function draw_pixel(vsw, vsh, xscaled, yscaled) {
    var pixel_width = width / vsw
    var pixel_height = height / vsh
    for(let x = (xscaled * pixel_width) * 4; x < ((xscaled * pixel_width) * 4) + pixel_width * 4; x += 4) {
        for(let y = yscaled * pixel_height; y < yscaled * pixel_height + pixel_height; y++) {
            buffer[y * stride + x] = 0xff
            buffer[y * stride + x + 1] = 0xff
            buffer[y * stride + x + 2] = 0xff
            buffer[y * stride + x + 3] = 0xff
        }
    }
}

let chip8 = new_chip8()

let timer = setInterval(() => {
    if(window.destroyed) {
        clearInterval(timer)
        return
    }
    let new_emu = step(chip8)
    chip8 = new_emu
}, 0)