
import
  std/typetraits, preserves, sturdy

type
  Bind*[E] {.preservesRecord: "bind".} = ref object
    `oid`*: Preserve[E]
    `key`*: seq[byte]
    `target`*: Preserve[E]

  Resolve*[E] {.preservesRecord: "resolve".} = ref object
    `sturdyref`*: sturdy.SturdyRef[E]
    `observer`*: Preserve[E]

proc `$`*[E](x: Bind[E] | Resolve[E]): string =
  `$`(toPreserve(x, E))

proc encode*[E](x: Bind[E] | Resolve[E]): seq[byte] =
  encode(toPreserve(x, E))
