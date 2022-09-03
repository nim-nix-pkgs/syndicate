# SPDX-FileCopyrightText: 2021 ☭ Emery Hemingway
# SPDX-License-Identifier: Unlicense

import syndicate/assertions, syndicate/dataspaces, syndicate/events, syndicate/skeletons
import preserves, preserves/records
import asyncdispatch, tables, options

import ./box_and_client

const N = 100000

let
  `?_` = Discard().toPreserve
  `?$` = Capture().toPreserve

proc boot(facet: Facet) =

  facet.spawn("box") do (facet: Facet):
    facet.declareField(value, int, 0)

    facet.addEndpoint do (facet: Facet) -> EndpointSpec:
      # echo "recomputing published BoxState ", facet.fields.value
      result.assertion = prsBoxState(value.getPreserve)

    facet.addDataflow do (facet: Facet):
      # echo "box dataflow saw new value ", facet.fields.value
      if value.get == N:
        facet.stop do (facet: Facet):
          echo "terminated box root facet"

    facet.addEndpoint do (facet: Facet) -> EndpointSpec:
      let a = prsSetBox(`?$`)
      result.analysis = some analyzeAssertion(a)
      proc cb(facet: Facet; vs: seq[Value]) =
        facet.scheduleScript do (facet: Facet):
          value.set(vs[0])
          # echo "box updated value ", vs[0]
      result.callback = facet.wrap(messageEvent, cb)
      result.assertion = observe(prsSetBox(`?$`))

  facet.spawn("client") do (facet: Facet):

    facet.addEndpoint do (facet: Facet) -> EndpointSpec:
      let a = prsBoxState(`?$`)
      result.analysis = some analyzeAssertion(a)
      proc cb(facet: Facet; vs: seq[Value]) =
        facet.scheduleScript do (facet: Facet):
          let v = prsSetBox(vs[0].int.succ.toPreserve)
          # echo "client sending ", v
          facet.send(v)
      result.callback = facet.wrap(addedEvent, cb)
      result.assertion = observe(prsBoxState(`?$`))

    facet.addEndpoint do (facet: Facet) -> EndpointSpec:
      let a = prsBoxState(`?_`)
      result.analysis = some analyzeAssertion(a)
      proc cb(facet: Facet; vs: seq[Value]) =
        facet.scheduleScript do (facet: Facet):
          echo "box gone"
      result.callback = facet.wrap(removedEvent, cb)
      result.assertion = observe(prsBoxState(`?_`))

  facet.actor.dataspace.ground.addStopHandler do (_: Dataspace):
    echo "stopping box-and-client"

waitFor bootModule("box-and-client", boot)
