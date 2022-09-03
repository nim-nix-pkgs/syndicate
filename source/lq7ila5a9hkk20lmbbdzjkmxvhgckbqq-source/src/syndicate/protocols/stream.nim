
import
  std/typetraits, preserves

type
  CreditAmountKind* {.pure.} = enum
    `count`, `unbounded`
  CreditAmountCount* = int
  `CreditAmount`* {.preservesOr.} = object
    case orKind*: CreditAmountKind
    of CreditAmountKind.`count`:
        `count`*: CreditAmountCount

    of CreditAmountKind.`unbounded`:
        `unbounded`* {.preservesLiteral: "unbounded".}: bool

  
  StreamError* {.preservesRecord: "error".} = object
    `message`*: string

  StreamListenerError*[E] {.preservesRecord: "stream-listener-error".} = ref object
    `spec`*: Preserve[E]
    `message`*: string

  StreamConnection*[E] {.preservesRecord: "stream-connection".} = ref object
    `source`*: Preserve[E]
    `sink`*: Preserve[E]
    `spec`*: Preserve[E]

  `LineMode`* {.preservesOr, pure.} = enum
    `lf`, `crlf`
  SourceKind* {.pure.} = enum
    `sink`, `StreamError`, `credit`
  SourceSink*[E] {.preservesRecord: "sink".} = ref object
    `controller`*: Preserve[E]

  SourceCredit*[E] {.preservesRecord: "credit".} = ref object
    `amount`*: CreditAmount
    `mode`*: Mode[E]

  `Source`*[E] {.preservesOr.} = ref object
    case orKind*: SourceKind
    of SourceKind.`sink`:
        `sink`*: SourceSink[E]

    of SourceKind.`StreamError`:
        `streamerror`*: StreamError

    of SourceKind.`credit`:
        `credit`*: SourceCredit[E]

  
  SinkKind* {.pure.} = enum
    `source`, `StreamError`, `data`, `eof`
  SinkSource*[E] {.preservesRecord: "source".} = ref object
    `controller`*: Preserve[E]

  SinkData*[E] {.preservesRecord: "data".} = ref object
    `payload`*: Preserve[E]
    `mode`*: Mode[E]

  SinkEof* {.preservesRecord: "eof".} = object
  
  `Sink`*[E] {.preservesOr.} = ref object
    case orKind*: SinkKind
    of SinkKind.`source`:
        `source`*: SinkSource[E]

    of SinkKind.`StreamError`:
        `streamerror`*: StreamError

    of SinkKind.`data`:
        `data`*: SinkData[E]

    of SinkKind.`eof`:
        `eof`*: SinkEof

  
  StreamListenerReady*[E] {.preservesRecord: "stream-listener-ready".} = ref object
    `spec`*: Preserve[E]

  ModeKind* {.pure.} = enum
    `bytes`, `lines`, `packet`, `object`
  ModePacket* {.preservesRecord: "packet".} = object
    `size`*: int

  ModeObject*[E] {.preservesRecord: "object".} = ref object
    `description`*: Preserve[E]

  `Mode`*[E] {.preservesOr.} = ref object
    case orKind*: ModeKind
    of ModeKind.`bytes`:
        `bytes`* {.preservesLiteral: "bytes".}: bool

    of ModeKind.`lines`:
        `lines`*: LineMode

    of ModeKind.`packet`:
        `packet`*: ModePacket

    of ModeKind.`object`:
        `object`*: ModeObject[E]

  
proc `$`*[E](x: StreamListenerError[E] | StreamConnection[E] | Source[E] |
    Sink[E] |
    StreamListenerReady[E] |
    Mode[E]): string =
  `$`(toPreserve(x, E))

proc encode*[E](x: StreamListenerError[E] | StreamConnection[E] | Source[E] |
    Sink[E] |
    StreamListenerReady[E] |
    Mode[E]): seq[byte] =
  encode(toPreserve(x, E))

proc `$`*(x: CreditAmount | StreamError): string =
  `$`(toPreserve(x))

proc encode*(x: CreditAmount | StreamError): seq[byte] =
  encode(toPreserve(x))
