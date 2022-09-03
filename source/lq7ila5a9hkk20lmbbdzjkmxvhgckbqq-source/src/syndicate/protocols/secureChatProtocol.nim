
import
  std/typetraits, preserves

type
  UserId* = int
  NickConflict* {.preservesRecord: "nickConflict".} = object
  
  NickClaimResponseKind* {.pure.} = enum
    `true`, `NickConflict`
  `NickClaimResponse`* {.preservesOr.} = object
    case orKind*: NickClaimResponseKind
    of NickClaimResponseKind.`true`:
        `true`* {.preservesLiteral: "#t".}: bool

    of NickClaimResponseKind.`NickConflict`:
        `nickconflict`*: NickConflict

  
  Join*[E] {.preservesRecord: "joinedUser".} = ref object
    `uid`*: UserId
    `handle`*: Preserve[E]

  SessionKind* {.pure.} = enum
    `observeUsers`, `observeSpeech`, `NickClaim`, `Says`
  SessionObserveUsers*[E] {.preservesRecord: "Observe".} = ref object
    `data`* {.preservesLiteral: "user".}: bool
    `observer`*: Preserve[E]

  SessionObserveSpeech*[E] {.preservesRecord: "Observe".} = ref object
    `data`* {.preservesLiteral: "says".}: bool
    `observer`*: Preserve[E]

  `Session`*[E] {.preservesOr.} = ref object
    case orKind*: SessionKind
    of SessionKind.`observeUsers`:
        `observeusers`*: SessionObserveUsers[E]

    of SessionKind.`observeSpeech`:
        `observespeech`*: SessionObserveSpeech[E]

    of SessionKind.`NickClaim`:
        `nickclaim`*: NickClaim[E]

    of SessionKind.`Says`:
        `says`*: Says

  
  UserInfo* {.preservesRecord: "user".} = object
    `uid`*: UserId
    `name`*: string

  NickClaim*[E] {.preservesRecord: "claimNick".} = ref object
    `uid`*: UserId
    `name`*: string
    `k`*: Preserve[E]

  Says* {.preservesRecord: "says".} = object
    `who`*: UserId
    `what`*: string

proc `$`*[E](x: Join[E] | Session[E] | NickClaim[E]): string =
  `$`(toPreserve(x, E))

proc encode*[E](x: Join[E] | Session[E] | NickClaim[E]): seq[byte] =
  encode(toPreserve(x, E))

proc `$`*(x: UserId | NickConflict | NickClaimResponse | UserInfo | Says): string =
  `$`(toPreserve(x))

proc encode*(x: UserId | NickConflict | NickClaimResponse | UserInfo | Says): seq[
    byte] =
  encode(toPreserve(x))
