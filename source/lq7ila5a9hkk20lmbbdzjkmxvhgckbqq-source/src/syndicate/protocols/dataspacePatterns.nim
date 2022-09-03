
import
  std/typetraits, preserves, std/tables

type
  AnyAtomKind* {.pure.} = enum
    `bool`, `float`, `double`, `int`, `string`, `bytes`, `symbol`, `embedded`
  AnyAtomBool* = bool
  AnyAtomFloat* = float32
  AnyAtomDouble* = float64
  AnyAtomInt* = int
  AnyAtomString* = string
  AnyAtomBytes* = seq[byte]
  AnyAtomSymbol* = Symbol
  AnyAtomEmbedded*[E] = Preserve[E]
  `AnyAtom`*[E] {.preservesOr.} = ref object
    case orKind*: AnyAtomKind
    of AnyAtomKind.`bool`:
        `bool`*: AnyAtomBool

    of AnyAtomKind.`float`:
        `float`*: AnyAtomFloat

    of AnyAtomKind.`double`:
        `double`*: AnyAtomDouble

    of AnyAtomKind.`int`:
        `int`*: AnyAtomInt

    of AnyAtomKind.`string`:
        `string`*: AnyAtomString

    of AnyAtomKind.`bytes`:
        `bytes`*: AnyAtomBytes

    of AnyAtomKind.`symbol`:
        `symbol`*: AnyAtomSymbol

    of AnyAtomKind.`embedded`:
        `embedded`*: AnyAtomEmbedded[E]

  
  DLit*[E] {.preservesRecord: "lit".} = ref object
    `value`*: AnyAtom[E]

  DBind*[E] {.preservesRecord: "bind".} = ref object
    `pattern`*: Pattern[E]

  DDiscard* {.preservesRecord: "_".} = object
  
  DCompoundKind* {.pure.} = enum
    `rec`, `arr`, `dict`
  DCompoundRec*[E] {.preservesRecord: "rec".} = ref object
    `label`*: Preserve[E]
    `fields`*: seq[Pattern[E]]

  DCompoundArr*[E] {.preservesRecord: "arr".} = ref object
    `items`*: seq[Pattern[E]]

  DCompoundDict*[E] {.preservesRecord: "dict".} = ref object
    `entries`*: Table[Preserve[E], Pattern[E]]

  `DCompound`*[E] {.preservesOr.} = ref object
    case orKind*: DCompoundKind
    of DCompoundKind.`rec`:
        `rec`*: DCompoundRec[E]

    of DCompoundKind.`arr`:
        `arr`*: DCompoundArr[E]

    of DCompoundKind.`dict`:
        `dict`*: DCompoundDict[E]

  
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

  
proc `$`*[E](x: AnyAtom[E] | DLit[E] | DBind[E] | DCompound[E] | Pattern[E]): string =
  `$`(toPreserve(x, E))

proc encode*[E](x: AnyAtom[E] | DLit[E] | DBind[E] | DCompound[E] | Pattern[E]): seq[
    byte] =
  encode(toPreserve(x, E))

proc `$`*(x: DDiscard): string =
  `$`(toPreserve(x))

proc encode*(x: DDiscard): seq[byte] =
  encode(toPreserve(x))
