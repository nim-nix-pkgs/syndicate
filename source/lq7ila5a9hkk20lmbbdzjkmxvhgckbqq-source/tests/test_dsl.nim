# SPDX-FileCopyrightText: ☭ 2021 Emery Hemingway
# SPDX-License-Identifier: Unlicense

import std/asyncdispatch
import preserves
import syndicate

import ./box_and_client

syndicate testDsl:

  spawn "box":
    field(currentValue, BiggestInt, 0)
    publish prsBoxState(currentValue.get)
    stopIf currentValue.get == 10:
      echo "box: terminating"
    onMessage(prsSetBox(?newValue)) do (newValue: int):
      # The SetBox message is unpacked to `newValue: int`
      echo "box: taking on new value ", newValue
      currentValue.set(newValue)

  spawn "client":
    #stopIf retracted(observe(SetBox, _)):
    #  echo "client: box has gone"
    onAsserted(prsBoxState(?v)) do (v: BiggestInt):
      echo "client: learned that box's value is now ", v
      send(prsSetBox(v.succ))
    onRetracted(prsBoxState(?_)) do (_):
      echo "client: box state disappeared"
    onStop:
      quit(0) # Quit explicitly rather than let the dispatcher run empty.

runForever()
  # The dataspace is driven by the async dispatcher.
  # Without `runForever` this module would exit immediately.
