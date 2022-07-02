extends Node2D

## Max vertical velocity player can fall at
var terminalVelocity = 400

## When set to true, gives players GOD POWERS (keybinds visible
## from options menu [press escape in game to see])
var DEBUG_MODE : bool = true

var PHOTOSENSITIVE_MODE : bool = false

## A multiplier used to affect the intensity of background
## parallax
var PARALLAX_LEVEL : int = 30

enum SKIP_TYPE { RUN, SKIP, WORDLESS }
var SKIP_CUTSCENES : int = SKIP_TYPE.RUN
