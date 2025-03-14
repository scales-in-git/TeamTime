class_name InstantExit
extends BaseExit

@export var trigger_radius := 1.5
@export var trigger_height := 2.0


func _on_warp_zone_body_entered(body: Node2D):
	if body is Player:
		SceneTransition.background_load_transition(scene)
		SceneTransition.transition(scene, entrance_id)

func _ready():
	$%Collision.shape.radius = trigger_radius
	$%Collision.shape.height = trigger_height
