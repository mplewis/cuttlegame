#!/bin/bash

docker run -it --entrypoint bash mplewis/cuttlegame:latest -c \
  "find /usr/lib/libretro/*_libretro.so | sed 's:/usr/lib/libretro/::' | sed 's:_libretro.so::'"
