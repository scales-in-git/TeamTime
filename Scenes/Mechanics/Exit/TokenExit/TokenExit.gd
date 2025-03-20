class_name TokenExit
extends BaseExit

@onready var animation_player := $%AnimationPlayer

func _on_interact_zone_body_entered(body: Node2D):
	if body is not Player:
		return
	SceneTransition.background_load_transition(scene)
	body.puppeting = true
	
	animation_player.play('collect')

	await animation_player.animation_finished
	SceneTransition.transition(scene)