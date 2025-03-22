extends Node

var player: Player

signal player_started

func set_player(our_player: Player):
	if not player:
		player = our_player
