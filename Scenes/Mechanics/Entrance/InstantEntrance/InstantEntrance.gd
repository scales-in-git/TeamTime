class_name InstantEntrance
extends BaseEntrance

func enter(player: Player):
	# Todo: @export to at least change the direction of the player
	add_child(player)
	player.global_position = global_position
