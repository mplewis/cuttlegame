#!/bin/sh

RESOLUTION="${RESOLUTION:-480x320}"

exec /usr/bin/Xvfb :1 -screen 0 "$RESOLUTION"x24
