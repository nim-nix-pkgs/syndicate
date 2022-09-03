
import
  std/typetraits, preserves

type
  Says* {.preservesRecord: "Says".} = object
    `who`*: string
    `what`*: string

  Present* {.preservesRecord: "Present".} = object
    `username`*: string

proc `$`*(x: Says | Present): string =
  `$`(toPreserve(x))

proc encode*(x: Says | Present): seq[byte] =
  encode(toPreserve(x))
