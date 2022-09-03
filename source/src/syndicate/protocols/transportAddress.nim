
import
  std/typetraits, preserves

type
  WebSocket* {.preservesRecord: "ws".} = object
    `url`*: string

  Stdio* {.preservesRecord: "stdio".} = object
  
  Unix* {.preservesRecord: "unix".} = object
    `path`*: string

  Tcp* {.preservesRecord: "tcp".} = object
    `host`*: string
    `port`*: BiggestInt

proc `$`*(x: WebSocket | Stdio | Unix | Tcp): string =
  `$`(toPreserve(x))

proc encode*(x: WebSocket | Stdio | Unix | Tcp): seq[byte] =
  encode(toPreserve(x))
