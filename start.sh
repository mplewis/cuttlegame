#!/bin/bash

source start_vnc

set -euxo pipefail
pulseaudio --start
sudo retroarch -vf --libretro /usr/lib/libretro/vbam_libretro.so /tmp/pokemon_ruby.gba
