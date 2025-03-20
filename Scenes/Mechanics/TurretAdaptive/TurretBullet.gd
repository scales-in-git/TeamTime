class_name TurretBullet
extends Area2D

@export var linear_velocity: Vector2

func _physics_process(delta):
	position += linear_velocity*delta


# TODO: Tween bullet size for maximum effect
func collide(body: Node2D):
	if body is Player:
		# Todo: set the body as puppet, force it into a death animation, fade out
		SceneTransition.reset_scene()
	
	# Spawn particle effects
	# Play a collision sound
	queue_free()

func _on_body_entered(body:Node):
	collide(body)
	pass # Replace with function body.
