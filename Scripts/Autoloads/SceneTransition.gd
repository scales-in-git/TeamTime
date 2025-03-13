extends Node

var entrance_id: int = -1

func background_load_transition(new_place) -> void:
	ResourceLoader.load_threaded_request(new_place)

func transition(new_place, new_entrance_id) -> void:
	entrance_id = new_entrance_id

	var level_scene = ResourceLoader.load_threaded_get(new_place)
	Game.player.get_parent().remove_child(Game.player)
	Game.player.puppeting = false

	# Todo: If this is called but new_place isn't ready to load, then a
	#  loading screen should appear.
	get_tree().change_scene_to_packed(level_scene)
