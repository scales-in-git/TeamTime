extends Node

var player: Player

func set_player(our_player):
	if not player:
		player = our_player
