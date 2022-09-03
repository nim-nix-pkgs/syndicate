# SPDX-FileCopyrightText: ☭ 2021 Emery Hemingway
# SPDX-License-Identifier: Unlicense

import std/[asyncdispatch, hashes, macros, options, tables]
import preserves
import ../syndicate/protocols/[dataspace, dataspacePatterns]
import ./actors, ./bags

from ../syndicate/protocols/protocol import Handle

type
  Value = Preserve[Ref]
  Pattern* = dataspacePatterns.Pattern[Ref]
  Observe = dataspace.Observe[Ref]
  Turn = actors.Turn

#[
  DataspaceEntity = ref object of Entity
    assertions: Bag[Assertion]
    subscriptions: Table[Assertion, TableRef[Ref, TableRef[Assertion, Handle]]]
    handleMap: Table[Handle, Assertion] # breaks toPreserve(Observe[Ref]())

method publish(ds: DataspaceEntity; turn: var Turn; rec: Assertion; h: Handle) =
  if rec.isRecord:
    ds.handleMap[h] = rec
    if ds.assertions.change(rec, +1) == cdAbsentToPresent:
      var obs: Observe
      if fromPreserve(obs, rec):
        var seen = newTable[Assertion, Handle]()
        for prev, count in ds.assertions.pairs:
          if prev == rec.label:
            seen[prev] = publish(turn, obs.observer.unembed, prev)
        var patternSubs = ds.subscriptions.getOrDefault(rec.label)
        if patternSubs.isNil:
          patternSubs = newTable[Ref, TableRef[Value, Handle]]()
          ds.subscriptions[rec.label] = patternSubs
        patternSubs[obs.observer.unembed] = move seen
      for peer, seen in ds.subscriptions[rec.label]:
        if rec notin seen:
          seen[rec] = publish(turn, peer, rec)

method retract(ds: DataspaceEntity; turn: var Turn; upstreamHandle: Handle) =
  let rec = ds.handleMap.getOrDefault(upstreamHandle)
  if rec.isRecord:
    ds.handleMap.del upstreamHandle
    if ds.assertions.change(rec, -1) == cdPresentToAbsent:
      for peer, seen in ds.subscriptions[rec.label]:
        var h: Handle
        if pop(seen, rec, h):  retract(turn, h)
      preserveTo(rec, Observe).map do (obs: Observe):
        let peerMap = ds.subscriptions[rec.label]
        peerMap.del(obs.observer.unembed)
        if peerMap.len == 0:
          ds.subscriptions.del(rec.label)

method message(ds: DataspaceEntity; turn: var Turn; msg: Assertion) =
  if msg.isRecord:
    for peer, seen in ds.subscriptions[msg.label].pairs:
      message(turn, peer, msg)
]#

type DuringProc* = proc (turn: var Turn; a: Assertion): TurnAction {.gcsafe.}

type
  DuringActionKind = enum null, dead, act
  DuringAction = object
    case kind: DuringActionKind
    of null, dead: discard
    of act:
      action: TurnAction

type DuringEntity = ref object of Entity
  assertionMap: Table[Handle, DuringAction]
  cb: DuringProc

method publish(de: DuringEntity; turn: var Turn; a: Assertion; h: Handle) =
  let action =  de.cb(turn, a)
  # assert(not action.isNil "should have put in a no-op action")
  let g = de.assertionMap.getOrDefault h
  case g.kind
  of null:
    de.assertionMap[h] = DuringAction(kind: act, action: action)
  of dead:
    de.assertionMap.del h
    freshen(turn, action)
  of act:
    raiseAssert("during: duplicate handle in publish: " & $h)

method retract(de: DuringEntity; turn: var Turn; h: Handle) =
  let g = de.assertionMap.getOrDefault h
  case g.kind
  of null:
    de.assertionMap[h] = DuringAction(kind: dead)
  of dead:
    raiseAssert("during: duplicate handle in retract: " & $h)
  of act:
    de.assertionMap.del h
    g.action(turn)

proc during*(cb: DuringProc): DuringEntity =
  result = DuringEntity(cb: cb)

proc observe*(turn: var Turn; ds: Ref; pat: Pattern; e: Entity): Handle =
  publish(turn, ds, Observe(pattern: pat, observer: embed newRef(turn, e)))
