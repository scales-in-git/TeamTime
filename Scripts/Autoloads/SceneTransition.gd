extends Node


func background_load_transition(new_place) -> void:
	ResourceLoader.load_threaded_request(new_place)

func transition(new_place) -> void:
	var level_scene = ResourceLoader.load_threaded_get(new_place)

	if Game.player:
		Game.player.get_parent().remove_child(Game.player)
		Game.player.call_deferred("queue_free")
		Game.player = null

	# Todo: If this is called but new_place isn't ready to load, then a
	#  loading screen should appear.
	get_tree().call_deferred("change_scene_to_packed", level_scene)
	# get_tree().change_scene_to_packed(level_scene)
