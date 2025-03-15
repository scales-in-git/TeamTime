extends Node

var player: Player
var _current_level: Variant

func set_player(our_player: Player):
	if not player:
		player = our_player


func set_level(our_level: Variant):
	_current_level = our_level

func get_level():
	return _current_level