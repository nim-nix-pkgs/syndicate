
import
  std/typetraits, preserves, std/tables, std/tables, std/tables

type
  CRec*[E] {.preservesRecord: "rec".} = ref object
    `label`*: Preserve[E]
    `arity`*: BiggestInt

  DLit*[E] {.preservesRecord: "lit".} = ref object
    `value`*: Preserve[E]

  DBind*[E] {.preservesRecord: "bind".} = ref object
    `pattern`*: Pattern[E]

  DDiscard* {.preservesRecord: "_".} = object
  
  CArr* {.preservesRecord: "arr".} = object
    `arity`*: BiggestInt

  DCompoundKind* {.pure.} = enum
    `rec`, `arr`, `dict`
  DCompoundRec*[E] {.preservesRecord: "compound".} = ref object
    `ctor`*: CRec[E]
    `members`*: Table[BiggestInt, Pattern[E]]

  DCompoundArr*[E] {.preservesRecord: "compound".} = ref object
    `ctor`*: CArr
    `members`*: Table[BiggestInt, Pattern[E]]

  DCompoundDict*[E] {.preservesRecord: "compound".} = ref object
    `ctor`*: CDict
    `members`*: Table[Preserve[E], Pattern[E]]

  `DCompound`*[E] {.preservesOr.} = ref object
    case orKind*: DCompoundKind
    of DCompoundKind.`rec`:
        `rec`*: DCompoundRec[E]

    of DCompoundKind.`arr`:
        `arr`*: DCompoundArr[E]

    of DCompoundKind.`dict`:
        `dict`*: DCompoundDict[E]

  
  CDict* {.preservesRecord: "dict".} = object
  
  PatternKind* {.pure.} = enum
    `DDiscard`, `DBind`, `DLit`, `DCompound`
  `Pattern`*[E] {.preservesOr.} = ref object
    case orKind*: PatternKind
    of PatternKind.`DDiscard`:
        `ddiscard`*: DDiscard

    of PatternKind.`DBind`:
        `dbind`*: DBind[E]

    of PatternKind.`DLit`:
        `dlit`*: DLit[E]

    of PatternKind.`DCompound`:
        `dcompound`*: DCompound[E]

  
proc `$`*[E](x: CRec[E] | DLit[E] | DBind[E] | DCompound[E] | Pattern[E]): string =
  `$`(toPreserve(x, E))

proc encode*[E](x: CRec[E] | DLit[E] | DBind[E] | DCompound[E] | Pattern[E]): seq[
    byte] =
  encode(toPreserve(x, E))

proc `$`*(x: DDiscard | CArr | CDict): string =
  `$`(toPreserve(x))

proc encode*(x: DDiscard | CArr | CDict): seq[byte] =
  encode(toPreserve(x))
