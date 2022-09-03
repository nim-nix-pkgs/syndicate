
import
  std/typetraits, preserves

type
  TimerExpired*[E] {.preservesRecord: "timer-expired".} = ref object
    `label`*: Preserve[E]
    `msecs`*: float64

  SetTimer*[E] {.preservesRecord: "set-timer".} = ref object
    `label`*: Preserve[E]
    `msecs`*: float64
    `kind`*: TimerKind

  `TimerKind`* {.preservesOr.} = enum
    `relative`, `absolute`, `clear`
  LaterThan* {.preservesRecord: "later-than".} = object
    `msecs`*: float64

proc `$`*[E](x: TimerExpired[E] | SetTimer[E]): string =
  `$`(toPreserve(x, E))

proc encode*[E](x: TimerExpired[E] | SetTimer[E]): seq[byte] =
  encode(toPreserve(x, E))

proc `$`*(x: LaterThan): string =
  `$`(toPreserve(x))

proc encode*(x: LaterThan): seq[byte] =
  encode(toPreserve(x))
