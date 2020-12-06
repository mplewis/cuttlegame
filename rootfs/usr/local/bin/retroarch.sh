#!/bin/bash
set -exo pipefail

V=""
if [ -n "$VERBOSE" ]; then
  V="-v"
fi
set -u

COREPATH=/usr/lib/libretro/"$CORE"_libretro.so
ROMPATH="/roms/$ROM"

retroarch -f $V --libretro "$COREPATH" "$ROMPATH"
