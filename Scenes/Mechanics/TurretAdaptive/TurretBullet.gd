class_name TurretBullet
extends Area2D

@export var linear_velocity: Vector2

func _physics_process(delta):
	var collision = $%RayCast.get_collider()
	if collision and collision is not Player:
		position = to_local(collision.global_position)
	else:
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

func _ready():
	$%RayCast.target_position = linear_velocity/20.0
