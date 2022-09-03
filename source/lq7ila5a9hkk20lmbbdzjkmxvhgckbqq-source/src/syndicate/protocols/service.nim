
import
  std/typetraits, preserves

type
  StateKind* {.pure.} = enum
    `started`, `ready`, `failed`, `complete`, `userDefined`
  StateUserDefined*[E] = Preserve[E]
  `State`*[E] {.preservesOr.} = ref object
    case orKind*: StateKind
    of StateKind.`started`:
        `started`* {.preservesLiteral: "started".}: bool

    of StateKind.`ready`:
        `ready`* {.preservesLiteral: "ready".}: bool

    of StateKind.`failed`:
        `failed`* {.preservesLiteral: "failed".}: bool

    of StateKind.`complete`:
        `complete`* {.preservesLiteral: "complete".}: bool

    of StateKind.`userDefined`:
        `userdefined`*: StateUserDefined[E]

  
  ServiceObject*[E] {.preservesRecord: "service-object".} = ref object
    `serviceName`*: Preserve[E]
    `object`*: Preserve[E]

  RequireService*[E] {.preservesRecord: "require-service".} = ref object
    `serviceName`*: Preserve[E]

  RestartService*[E] {.preservesRecord: "restart-service".} = ref object
    `serviceName`*: Preserve[E]

  RunService*[E] {.preservesRecord: "run-service".} = ref object
    `serviceName`*: Preserve[E]

  ServiceState*[E] {.preservesRecord: "service-state".} = ref object
    `serviceName`*: Preserve[E]
    `state`*: State[E]

  ServiceDependency*[E] {.preservesRecord: "depends-on".} = ref object
    `depender`*: Preserve[E]
    `dependee`*: ServiceState[E]

proc `$`*[E](x: State[E] | ServiceObject[E] | RequireService[E] |
    RestartService[E] |
    RunService[E] |
    ServiceState[E] |
    ServiceDependency[E]): string =
  `$`(toPreserve(x, E))

proc encode*[E](x: State[E] | ServiceObject[E] | RequireService[E] |
    RestartService[E] |
    RunService[E] |
    ServiceState[E] |
    ServiceDependency[E]): seq[byte] =
  encode(toPreserve(x, E))
