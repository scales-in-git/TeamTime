class_name PlacedBlock
extends Node2D

# Maybe have functions for deleting visually?
# Either way, this script needs to exist for the class_name.



@onready var static_body := $%StaticBody

# With animations and stuff
func fancy_delete():
	static_body.set_collision_layer_value(1, false)

	# Play an audio sound first
	var tween := get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.BLACK, 1)
	tween.tween_callback(queue_free)
	tween.play()

	return tween


func set_last():
	modulate = Color.YELLOW
