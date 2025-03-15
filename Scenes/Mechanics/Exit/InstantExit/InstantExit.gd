class_name InstantExit
extends BaseExit


func _on_warp_zone_body_entered(body: Node2D):
	if body is Player:
		SceneTransition.background_load_transition(scene)
		SceneTransition.transition(scene)
