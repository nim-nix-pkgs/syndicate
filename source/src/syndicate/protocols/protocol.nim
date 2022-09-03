
import
  std/typetraits, preserves

type
  Error*[E] {.preservesRecord: "error".} = ref object
    `message`*: string
    `detail`*: Preserve[E]

  Turn*[E] = seq[TurnEvent[E]]
  Message*[E] {.preservesRecord: "message".} = ref object
    `body`*: Assertion[E]

  Retract* {.preservesRecord: "retract".} = object
    `handle`*: Handle

  Assert*[E] {.preservesRecord: "assert".} = ref object
    `assertion`*: Assertion[E]
    `handle`*: Handle

  Sync*[E] {.preservesRecord: "sync".} = ref object
    `peer`*: Preserve[E]

  TurnEvent*[E] {.preservesTuple.} = ref object
    `oid`*: Oid
    `event`*: Event[E]

  Oid* = BiggestInt
  Assertion*[E] = Preserve[E]
  Handle* = BiggestInt
  PacketKind* {.pure.} = enum
    `Turn`, `Error`
  `Packet`*[E] {.preservesOr.} = ref object
    case orKind*: PacketKind
    of PacketKind.`Turn`:
        `turn`*: Turn[E]

    of PacketKind.`Error`:
        `error`*: Error[E]

  
  EventKind* {.pure.} = enum
    `Assert`, `Retract`, `Message`, `Sync`
  `Event`*[E] {.preservesOr.} = ref object
    case orKind*: EventKind
    of EventKind.`Assert`:
        `assert`*: Assert[E]

    of EventKind.`Retract`:
        `retract`*: Retract

    of EventKind.`Message`:
        `message`*: Message[E]

    of EventKind.`Sync`:
        `sync`*: Sync[E]

  
proc `$`*[E](x: Error[E] | Turn[E] | Message[E] | Assert[E] | Sync[E] |
    TurnEvent[E] |
    Packet[E] |
    Event[E]): string =
  `$`(toPreserve(x, E))

proc encode*[E](x: Error[E] | Turn[E] | Message[E] | Assert[E] | Sync[E] |
    TurnEvent[E] |
    Packet[E] |
    Event[E]): seq[byte] =
  encode(toPreserve(x, E))

proc `$`*(x: Retract | Oid | Handle): string =
  `$`(toPreserve(x))

proc encode*(x: Retract | Oid | Handle): seq[byte] =
  encode(toPreserve(x))
