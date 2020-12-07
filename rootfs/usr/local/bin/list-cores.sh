#!/bin/bash

find /usr/lib/libretro/*_libretro.so | sed 's:/usr/lib/libretro/::' | sed 's:_libretro.so::'
