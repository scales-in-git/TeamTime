class_name InstantEntrance
extends BaseEntrance

func enter(player: Player):
	# Todo: @export to at least change the direction of the player
	player.position = global_position
