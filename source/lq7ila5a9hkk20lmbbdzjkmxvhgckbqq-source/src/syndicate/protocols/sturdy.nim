
import
  std/typetraits, preserves, std/tables

type
  PCompoundKind* {.pure.} = enum
    `rec`, `arr`, `dict`
  PCompoundRec*[E] {.preservesRecord: "rec".} = ref object
    `label`*: Preserve[E]
    `fields`*: seq[Pattern[E]]

  PCompoundArr*[E] {.preservesRecord: "arr".} = ref object
    `items`*: seq[Pattern[E]]

  PCompoundDict*[E] {.preservesRecord: "dict".} = ref object
    `entries`*: Table[Preserve[E], Pattern[E]]

  `PCompound`*[E] {.preservesOr.} = ref object
    case orKind*: PCompoundKind
    of PCompoundKind.`rec`:
        `rec`*: PCompoundRec[E]

    of PCompoundKind.`arr`:
        `arr`*: PCompoundArr[E]

    of PCompoundKind.`dict`:
        `dict`*: PCompoundDict[E]


  PAnd*[E] {.preservesRecord: "and".} = ref object
    `patterns`*: seq[Pattern[E]]

  Rewrite*[E] {.preservesRecord: "rewrite".} = ref object
    `pattern`*: Pattern[E]
    `template`*: Template[E]

  TRef* {.preservesRecord: "ref".} = object
    `binding`*: int

  PBind*[E] {.preservesRecord: "bind".} = ref object
    `pattern`*: Pattern[E]

  Lit*[E] {.preservesRecord: "lit".} = ref object
    `value`*: Preserve[E]

  TCompoundKind* {.pure.} = enum
    `rec`, `arr`, `dict`
  TCompoundRec*[E] {.preservesRecord: "rec".} = ref object
    `label`*: Preserve[E]
    `fields`*: seq[Template[E]]

  TCompoundArr*[E] {.preservesRecord: "arr".} = ref object
    `items`*: seq[Template[E]]

  TCompoundDict*[E] {.preservesRecord: "dict".} = ref object
    `entries`*: Table[Preserve[E], Template[E]]

  `TCompound`*[E] {.preservesOr.} = ref object
    case orKind*: TCompoundKind
    of TCompoundKind.`rec`:
        `rec`*: TCompoundRec[E]

    of TCompoundKind.`arr`:
        `arr`*: TCompoundArr[E]

    of TCompoundKind.`dict`:
        `dict`*: TCompoundDict[E]


  `PAtom`* {.preservesOr, pure.} = enum
    `Boolean`, `Float`, `Double`, `SignedInteger`, `String`, `ByteString`,
    `Symbol`
  Attenuation*[E] = seq[Caveat[E]]
  PDiscard* {.preservesRecord: "_".} = object

  TemplateKind* {.pure.} = enum
    `TAttenuate`, `TRef`, `Lit`, `TCompound`
  `Template`*[E] {.preservesOr.} = ref object
    case orKind*: TemplateKind
    of TemplateKind.`TAttenuate`:
        `tattenuate`*: TAttenuate[E]

    of TemplateKind.`TRef`:
        `tref`*: TRef

    of TemplateKind.`Lit`:
        `lit`*: Lit[E]

    of TemplateKind.`TCompound`:
        `tcompound`*: TCompound[E]


  CaveatKind* {.pure.} = enum
    `Rewrite`, `Alts`
  `Caveat`*[E] {.preservesOr.} = ref object
    case orKind*: CaveatKind
    of CaveatKind.`Rewrite`:
        `rewrite`*: Rewrite[E]

    of CaveatKind.`Alts`:
        `alts`*: Alts[E]


  PNot*[E] {.preservesRecord: "not".} = ref object
    `pattern`*: Pattern[E]

  SturdyRef*[E] {.preservesRecord: "ref".} = ref object
    `oid`*: Preserve[E]
    `caveatChain`*: seq[Attenuation[E]]
    `sig`*: seq[byte]

  WireRefKind* {.pure.} = enum
    `mine`, `yours`
  WireRefMine* {.preservesTuple.} = object
    `data`* {.preservesLiteral: "0".}: bool
    `oid`*: Oid

  WireRefYours*[E] {.preservesTuple.} = ref object
    `data`* {.preservesLiteral: "1".}: bool
    `oid`*: Oid
    `attenuation`* {.preservesTupleTail.}: seq[Caveat[E]]

  `WireRef`*[E] {.preservesOr.} = ref object
    case orKind*: WireRefKind
    of WireRefKind.`mine`:
        `mine`*: WireRefMine

    of WireRefKind.`yours`:
        `yours`*: WireRefYours[E]


  TAttenuate*[E] {.preservesRecord: "attenuate".} = ref object
    `template`*: Template[E]
    `attenuation`*: Attenuation[E]

  Oid* = int
  Alts*[E] {.preservesRecord: "or".} = ref object
    `alternatives`*: seq[Rewrite[E]]

  PatternKind* {.pure.} = enum
    `PDiscard`, `PAtom`, `PEmbedded`, `PBind`, `PAnd`, `PNot`, `Lit`,
    `PCompound`
  `Pattern`*[E] {.preservesOr.} = ref object
    case orKind*: PatternKind
    of PatternKind.`PDiscard`:
        `pdiscard`*: PDiscard

    of PatternKind.`PAtom`:
        `patom`*: PAtom

    of PatternKind.`PEmbedded`:
        `pembedded`* {.preservesLiteral: "Embedded".}: bool

    of PatternKind.`PBind`:
        `pbind`*: PBind[E]

    of PatternKind.`PAnd`:
        `pand`*: PAnd[E]

    of PatternKind.`PNot`:
        `pnot`*: PNot[E]

    of PatternKind.`Lit`:
        `lit`*: Lit[E]

    of PatternKind.`PCompound`:
        `pcompound`*: PCompound[E]


proc `$`*[E](x: PCompound[E] | PAnd[E] | Rewrite[E] | PBind[E] | Lit[E] |
    TCompound[E] |
    Attenuation[E] |
    Template[E] |
    Caveat[E] |
    PNot[E] |
    SturdyRef[E] |
    WireRef[E] |
    TAttenuate[E] |
    Alts[E] |
    Pattern[E]): string =
  `$`(toPreserve(x, E))

proc encode*[E](x: PCompound[E] | PAnd[E] | Rewrite[E] | PBind[E] | Lit[E] |
    TCompound[E] |
    Attenuation[E] |
    Template[E] |
    Caveat[E] |
    PNot[E] |
    SturdyRef[E] |
    WireRef[E] |
    TAttenuate[E] |
    Alts[E] |
    Pattern[E]): seq[byte] =
  encode(toPreserve(x, E))

proc `$`*(x: TRef | PDiscard | Oid): string =
  `$`(toPreserve(x))

proc encode*(x: TRef | PDiscard | Oid): seq[byte] =
  encode(toPreserve(x))
