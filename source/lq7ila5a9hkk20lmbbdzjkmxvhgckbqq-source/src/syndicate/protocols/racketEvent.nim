
import
  std/typetraits, preserves

type
  RacketEvent*[E] {.preservesRecord: "racket-event".} = ref object
    `source`*: Preserve[E]
    `event`*: Preserve[E]

proc `$`*[E](x: RacketEvent[E]): string =
  `$`(toPreserve(x, E))

proc encode*[E](x: RacketEvent[E]): seq[byte] =
  encode(toPreserve(x, E))
