# silksong movement test

a tiny test demake of hollow knight: silksong's basic movement.

uses pico-8 constraints for fun: 128x128 viewport, 8x3 tile source tileset (sorta),
pico-8 palette, locked to 30fps.

the code's very messy cause i wanted to get it in a playable state asap.

## controls

- MOVE: ARROW KEYS, WASD or IJKL
- JUMP: Z or N or SPACE
- DASH: SHIFT
- ATTACK: X or M

there's various moves available, like:

- LEDGE CLIMB: you will automatically climb up ledges near you when you push against them
- UP ATTACK: up + attack
- POGO: down + attack (in the air)
- LONG JUMP: jump while dashing

debug functions:

- 1: decrease window size
- 2: increase window size
- Q: quit game (breaks web export)
- R: respawn player

## license

all code is licensed under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).