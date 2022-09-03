
import
  std/typetraits, preserves

type
  ServiceStarted*[E] {.preservesRecord: "service-started".} = ref object
    `serviceName`*: Preserve[E]

  ServiceMilestone*[E] {.preservesRecord: "service-milestone".} = ref object
    `serviceName`*: Preserve[E]
    `milestone`*: Preserve[E]

  RequireService*[E] {.preservesRecord: "require-service".} = ref object
    `serviceName`*: Preserve[E]

  DependeeKind* {.pure.} = enum
    `ServiceStarted`, `ServiceRunning`
  `Dependee`*[E] {.preservesOr.} = ref object
    case orKind*: DependeeKind
    of DependeeKind.`ServiceStarted`:
        `servicestarted`*: ServiceStarted[E]

    of DependeeKind.`ServiceRunning`:
        `servicerunning`*: ServiceRunning[E]

  
  RunService*[E] {.preservesRecord: "run-service".} = ref object
    `serviceName`*: Preserve[E]

  ServiceRunning*[E] {.preservesRecord: "service-running".} = ref object
    `serviceName`*: Preserve[E]

  ServiceDependency*[E] {.preservesRecord: "depends-on".} = ref object
    `depender`*: Preserve[E]
    `dependee`*: Dependee[E]

proc `$`*[E](x: ServiceStarted[E] | ServiceMilestone[E] | RequireService[E] |
    Dependee[E] |
    RunService[E] |
    ServiceRunning[E] |
    ServiceDependency[E]): string =
  `$`(toPreserve(x, E))

proc encode*[E](x: ServiceStarted[E] | ServiceMilestone[E] | RequireService[E] |
    Dependee[E] |
    RunService[E] |
    ServiceRunning[E] |
    ServiceDependency[E]): seq[byte] =
  encode(toPreserve(x, E))
