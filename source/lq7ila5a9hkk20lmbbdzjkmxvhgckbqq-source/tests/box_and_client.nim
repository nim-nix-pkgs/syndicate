
## Date of generation: 2021-09-01 13:32
import
  std/typetraits, preserves

type
  EmbeddedType = void
  BoxState* {.record: "box-state".} = object ## ``<box-state @value int>``
    `value`*: BiggestInt

  SetBox* {.record: "set-box".} = object ## ``<set-box @value int>``
    `value`*: BiggestInt

proc prsBoxState*(value: Preserve | BiggestInt): Preserve =
  initRecord[EmbeddedType](symbol("box-state", EmbeddedType),
                           toPreserve(value, EmbeddedType))

proc prsSetBox*(value: Preserve | BiggestInt): Preserve =
  initRecord[EmbeddedType](symbol("set-box", EmbeddedType),
                           toPreserve(value, EmbeddedType))
