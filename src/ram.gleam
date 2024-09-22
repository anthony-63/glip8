import gleam/bit_array
import gleam/io

pub opaque type Ram {
  Ram(data: BitArray)
}

pub fn new(size: Int) -> Ram {
  Ram(data: <<0:size(size)>>)
}

pub fn set(ram: Ram, address: Int, data: BitArray) -> Ram {
  let data_size = bit_array.byte_size(data)

  let assert Ok(left) =
    ram.data
    |> bit_array.slice(0, address)

  let assert Ok(right) =
    ram.data
    |> bit_array.slice(
      address + data_size,
      bit_array.byte_size(ram.data) - address - data_size,
    )

  Ram(data: left |> bit_array.append(data) |> bit_array.append(right))
}

pub fn read(ram: Ram, address: Int, length: Int) -> Result(BitArray, Nil) {
  let address = address % bit_array.byte_size(ram.data)
  ram.data
  |> bit_array.slice(address, length)
}
