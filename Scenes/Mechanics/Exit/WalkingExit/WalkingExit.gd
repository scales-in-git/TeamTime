class_name WalkingExit
extends BaseExit


# In seconds
@export var fade_out_time := 1.0
@export var walk_away_strength := 5.0

# Todo: Maybe support different eases?

@export var fade_colour: Color = Color.BLACK

func _on_warp_zone_body_entered(body: Node2D):
	if body is Player:
		SceneTransition.background_load_transition(scene)

		body.puppeting = true
		body.apply_floor_snap()
		#body.velocity = walk_away_strength*-global_transform.basis.z
		
		# Todo: emit "level pause" signal to Game
		# Todo: set player invincible

		var fade_out_tween := get_tree().create_tween()
		fade_out_tween.tween_property($%FadeOut, 'color:a', 1.0, fade_out_time)
		fade_out_tween.play()
		await fade_out_tween.finished
		$%FadeOut.color.a = 1.0

		SceneTransition.transition(scene)


func _ready():
	$%FadeOut.color = fade_colour
	$%FadeOut.color.a = 0.0
