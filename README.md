# Cuttlegame

Play [RetroArch](https://www.retroarch.com/)-compatible games online with friends via VNC server.

VNC does not support sound, and its gaming latency is questionable, so you should use this for turn-based games like Pokemon rather than real-time games like Mario Kart.

# Usage

This example loads a Pokemon Emerald ROM file from the local `roms` directory using the `vbam` (VisualBoyAdvance-M) emulator core, storing saves in the local `saves` directory:

```sh
docker run -it \
    -p 8000:80 \
    -v "$(pwd)/roms:/roms" \
    -v "$(pwd)/saves:/saves" \
    -e CORE=vbam \
    -e ROM=/roms/pokemon_emerald.gba \
    mplewis/cuttlegame
```

To connect, open the browser link that appears in your terminal:

```
 a88888b.            dP     dP   dP
d8'   `88            88     88   88
88        dP    dP d8888P d8888P 88 .d8888b. .d8888b. .d8888b. 88d8b.d8b. .d8888b.
88        88    88   88     88   88 88ooood8 88'  `88 88'  `88 88'`88'`88 88ooood8
Y8.   .88 88.  .88   88     88   88 88.  ... 88.  .88 88.  .88 88  88  88 88.  ...
 Y88888P' `88888P'   dP     dP   dP `88888P' `8888P88 `88888P8 dP  dP  dP `88888P'
                                                  .88
                                              d8888P

Connect to your Cuttlegame instance in your web browser:
http://localhost:8000?scale=local&password=m43MV0J5mNZgwSoi
```

## Controls

Controls are defined in [retroarch.cfg](rootfs/root/.config/retroarch/retroarch.cfg):

Controller Button | Keyboard Binding
---|---
Up | W
Left | A
Down | S
Right | D
L | Q
R | E
A | J
B | H
X | U
Y | Y
Start | M
Select | N
*Fast-forward* | F

To customize the controls, create your own copy of [retroarch.cfg](https://retropie.org.uk/docs/RetroArch/), change the controls (`input_player1_a = "x"`, etc.) and mount it into `/config/retroarch.cfg`. Any options you specify in this file will override the default RetroArch configuration.

## Mounts

* `/saves`: When RetroArch saves your game, it will write the save files to this directory inside the container. Mount this into your local filesystem to keep the save data after the container exits. You can change this directory by setting `savefile_directory` and `savestate_directory` in a RetroArch override config.

## Environment Variables

* `CORE`: The RetroArch core to use. Run `scripts/list-cores.sh` to list all available cores.
* `ROM`: The full container path to the ROM file to load.
* `CONFIG`: Optional. The full container path to a RetroArch config. Options in this config override the defaults.
* `PASSWORD`: Optional. The VNC server password. If you do not provide one, a password will be autogenerated for you and displayed in the console.
* `RESOLUTION`: Optional. Defaults to 480x320 (2xGBA scale). The screen resolution of the server. Pick something that matches your console's render resolution for best results and to minimize bandwidth usage.
* `VERBOSE`: Optional. Set to `true` to enable verbose RetroArch and X11VNC logging. Useful for debugging why your game won't load.

# Acknowledgments

Huge thanks to [fcwu/docker-ubuntu-vnc-desktop](https://github.com/fcwu/docker-ubuntu-vnc-desktop) for helping me figure out how this all works.
