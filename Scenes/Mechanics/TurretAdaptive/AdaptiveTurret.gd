class_name AdaptiveTurret
extends Node2D

# In degrees
@export var rotation_limit: float = 75
# In rads per section
@export_range(0.0, 5.0) var rotation_speed: float = 0.5
# In seconds
@export var fire_rate: float = 8.0
# In 100 pixels per second
@export var bullet_speed: float = 10.0

@export var activation_zone: Area2D
@export var state_manager: OnOffState

var targetting = null

@onready var pivot: Node2D = $%BarrelPivot

func get_pointing_direction() -> Vector2:
	var barrel_rotation = pivot.rotation
	var barrel_direction = Vector2.RIGHT \
		.rotated(barrel_rotation) 
	
	return barrel_direction

# Target is in local space
func rotate_towards(target: Vector2, delta: float):
	var real_limit = deg_to_rad(rotation_limit)
	print(typeof(real_limit))

	var our_aim := get_pointing_direction()


	var angle_remaining = our_aim.angle_to(target)
	var clockwise = sign(angle_remaining)

	var rotate_strength = clampf(clockwise*rotation_speed*delta, -abs(angle_remaining), abs(angle_remaining)) 
	pivot.rotate(rotate_strength)

	pivot.rotation = clampf(pivot.rotation, Vector2.DOWN.rotated(-real_limit).angle(), Vector2.DOWN.rotated(real_limit).angle())
	


func _physics_process(delta):
	if targetting:
		rotate_towards(to_local(Game.player.global_position), delta)
	else:
		rotate_towards(Vector2.DOWN, delta)

func _ready():
	assert(abs(rotation_limit) < 90, "Turret rotation limit must be less than 90 degrees")

	activation_zone.body_entered.connect(func (player: Node2D):
		if player is Player:
			targetting = player
	)

	activation_zone.body_exited.connect(func (player: Node2D):
		if player is Player:
			targetting = null
	)

	
