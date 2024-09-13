import gleam/list
import ram.{type Ram}

pub opaque type Stack {
  Stack(sp: Int, mem: Ram)
}

pub fn new() -> Stack {
  Stack(sp: 0, mem: ram.new(32))
}

pub fn push(stack: Stack, data: Int) -> Stack {
  Stack(
    sp: stack.sp + 2,
    mem: stack.mem |> ram.set(stack.sp, <<data:size(16)>>),
  )
}

pub fn pop(stack: Stack) -> #(Stack, Int) {
  let assert Ok(<<value:size(16)>>) = stack.mem |> ram.read(stack.sp - 2, 2)
  #(Stack(..stack, sp: stack.sp + 2), value)
}

pub fn to_list(stack: Stack) -> List(#(Int, Int)) {
  list.range(0, 16)
  |> list.map(fn(n) {
    let addr = n * 2
    let assert Ok(<<value:size(16)>>) = stack.mem |> ram.read(addr, 2)
    #(addr, value)
  })
}
