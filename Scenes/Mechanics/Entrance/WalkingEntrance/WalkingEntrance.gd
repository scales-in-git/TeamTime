class_name WalkingEntrance
extends BaseEntrance

# In seconds
@export var fade_in_time := 1.0

@export var walk_towards_strength := 5.0

# Todo: Maybe support different eases?

@export var fade_colour: Color = Color.BLACK

func enter(player: Player):
	player.position = global_position
	player.puppeting = true
	player.apply_floor_snap()
	#player.velocity = walk_towards_strength*-global_transform.basis.x

	$%FadeIn.color = fade_colour
	
	var fade_in_tween := get_tree().create_tween()
	fade_in_tween.tween_property($%FadeIn, 'color:a', 0.0, fade_in_time)
	# fade_in_tween.tween_property(player, 'velocity', Vector2.ZERO, fade_in_time) \
	# 	.set_ease(Tween.EASE_IN)

	fade_in_tween.play()
	await fade_in_tween.finished
	player.puppeting = false
