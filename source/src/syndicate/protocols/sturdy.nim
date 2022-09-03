
import
  std/typetraits, preserves, std/tables, std/tables

type
  CRec*[E] {.preservesRecord: "rec".} = ref object
    `label`*: Preserve[E]
    `arity`*: BiggestInt

  PCompound*[E] {.preservesRecord: "compound".} = ref object
    `ctor`*: ConstructorSpec[E]
    `members`*: PCompoundMembers[E]

  ConstructorSpecKind* {.pure.} = enum
    `CRec`, `CArr`, `CDict`
  `ConstructorSpec`*[E] {.preservesOr.} = ref object
    case orKind*: ConstructorSpecKind
    of ConstructorSpecKind.`CRec`:
        `crec`*: CRec[E]

    of ConstructorSpecKind.`CArr`:
        `carr`*: CArr

    of ConstructorSpecKind.`CDict`:
        `cdict`*: CDict

  
  PAnd*[E] {.preservesRecord: "and".} = ref object
    `patterns`*: seq[Pattern[E]]

  Rewrite*[E] {.preservesRecord: "rewrite".} = ref object
    `pattern`*: Pattern[E]
    `template`*: Template[E]

  TCompoundMembers*[E] = Table[Preserve[E], Template[E]]
  TRef* {.preservesRecord: "ref".} = object
    `binding`*: BiggestInt

  PBind*[E] {.preservesRecord: "bind".} = ref object
    `pattern`*: Pattern[E]

  Lit*[E] {.preservesRecord: "lit".} = ref object
    `value`*: Preserve[E]

  TCompound*[E] {.preservesRecord: "compound".} = ref object
    `ctor`*: ConstructorSpec[E]
    `members`*: TCompoundMembers[E]

  `PAtom`* {.preservesOr.} = enum
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

  
  CArr* {.preservesRecord: "arr".} = object
    `arity`*: BiggestInt

  PCompoundMembers*[E] = Table[Preserve[E], Pattern[E]]
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

  Oid* = BiggestInt
  Alts*[E] {.preservesRecord: "or".} = ref object
    `alternatives`*: seq[Rewrite[E]]

  CDict* {.preservesRecord: "dict".} = object
  
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

  
proc `$`*[E](x: CRec[E] | PCompound[E] | ConstructorSpec[E] | PAnd[E] |
    Rewrite[E] |
    TCompoundMembers[E] |
    PBind[E] |
    Lit[E] |
    TCompound[E] |
    Attenuation[E] |
    Template[E] |
    Caveat[E] |
    PCompoundMembers[E] |
    PNot[E] |
    SturdyRef[E] |
    WireRef[E] |
    TAttenuate[E] |
    Alts[E] |
    Pattern[E]): string =
  `$`(toPreserve(x, E))

proc encode*[E](x: CRec[E] | PCompound[E] | ConstructorSpec[E] | PAnd[E] |
    Rewrite[E] |
    TCompoundMembers[E] |
    PBind[E] |
    Lit[E] |
    TCompound[E] |
    Attenuation[E] |
    Template[E] |
    Caveat[E] |
    PCompoundMembers[E] |
    PNot[E] |
    SturdyRef[E] |
    WireRef[E] |
    TAttenuate[E] |
    Alts[E] |
    Pattern[E]): seq[byte] =
  encode(toPreserve(x, E))

proc `$`*(x: TRef | PDiscard | CArr | Oid | CDict): string =
  `$`(toPreserve(x))

proc encode*(x: TRef | PDiscard | CArr | Oid | CDict): seq[byte] =
  encode(toPreserve(x))
