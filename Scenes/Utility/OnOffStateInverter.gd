class_name OnOffStateInverter
extends OnOffState

@export var state_manager: OnOffState

# This class made my head hurt...

func turn_on():
	state_manager.turn_off()

func turn_off():
	state_manager.turn_on()

func _real_turn_on():
	on = true
	state_changed.emit(on)
	turned_on.emit()

func _real_turn_off():
	on = false
	state_changed.emit(on)
	turned_off.emit()

func toggle():
	if on:
		state_manager.turn_on()
	else:
		state_manager.turn_off()

func init():
	# Note: Godot reports this as an error, even though it shouldn't be
	state_manager.turned_on.connect(_real_turn_off)
	state_manager.turned_off.connect(_real_turn_on)