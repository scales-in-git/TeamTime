class_name OnOffState
extends Resource

signal state_changed(new_state: bool)
signal turned_on
signal turned_off

# Note: do not set this in code unless you're a descedant.
# TODO: _ready stuff?
@export var on: bool = false

var reset: bool

func toggle():
    if on:
        turn_off()
    else:
        turn_on()

func turn_on():
    if not on:
        on = true
        state_changed.emit(on)
        turned_on.emit()

func turn_off():
    if on:
        on = false
        state_changed.emit(on)
        turned_off.emit()

func init():
    if not reset:
        reset = on
    on = reset


