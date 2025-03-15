class_name PlacedBlock
extends StaticBody2D

# Maybe have functions for deleting visually?
# Either way, this script needs to exist for the class_name.

@onready var animation_player := $%AnimationPlayer

@export var delete_time: float = 0.333

@onready var sprite := $%Sprite

var _last_survivor := false


# var highlight_for_deletion: bool = false:
# 	set(val):
# 		if val == true:
# 			animation_player.play('highlight_warn_remove')
# 		elif _last_survivor:
# 			animation_player.play('highlight_auto_remove')
# 		else:
# 			animation_player.stop()
# 			modulate = Color.WHITE
# 		highlight_for_deletion = true
# 	get():
# 		return highlight_for_deletion

# With animations and stuff
func fancy_delete():
	set_collision_layer_value(1, false)

	# Play an audio sound first
	var tween := get_tree().create_tween()
	tween.tween_property(self, "modulate", Color(Color.BLACK, 0.0), delete_time)
	tween.tween_callback(queue_free)
	tween.play()

	return tween

func clear_highlight():
	animation_player.stop()
	sprite.modulate = Color.WHITE

func highlight_as_last():
	animation_player.play("highlight_auto_remove")
	_last_survivor = true
	# modulate = Color.YELLOW
