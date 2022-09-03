
import
  std/typetraits, preserves

type
  TcpLocal* {.preservesRecord: "tcp-local".} = object
    `host`*: string
    `port`*: int

  TcpPeerInfo*[E] {.preservesRecord: "tcp-peer".} = ref object
    `handle`*: Preserve[E]
    `local`*: TcpLocal
    `remote`*: TcpRemote

  TcpRemote* {.preservesRecord: "tcp-remote".} = object
    `host`*: string
    `port`*: int

proc `$`*[E](x: TcpPeerInfo[E]): string =
  `$`(toPreserve(x, E))

proc encode*[E](x: TcpPeerInfo[E]): seq[byte] =
  encode(toPreserve(x, E))

proc `$`*(x: TcpLocal | TcpRemote): string =
  `$`(toPreserve(x))

proc encode*(x: TcpLocal | TcpRemote): seq[byte] =
  encode(toPreserve(x))
