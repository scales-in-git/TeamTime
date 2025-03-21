class_name AdaptiveTurret
extends Node2D

var _TurretBullet := preload("uid://du8sp6cb7hlgr")

# In degrees
@export var rotation_limit: float = 75
# In rads per section
@export_range(0.0, 5.0) var rotation_speed: float = 0.5
# In seconds
@export var fire_rate: float = 12.0
# In 100 pixels per second
@export var bullet_speed: float = 30.0

@export var activation_zone: Area2D
@export var state_manager: OnOffState

var targetting = null

@onready var pivot: Node2D = $%BarrelPivot
@onready var bullet_spawn_location: Marker2D = $%BulletSpawn
@onready var unfun_timer: Timer = $%UnfunTimer

func is_on():
	return not state_manager or state_manager.on

func get_pointing_direction() -> Vector2:
	var barrel_rotation = pivot.rotation
	var barrel_direction = Vector2.RIGHT \
		.rotated(barrel_rotation) 
	
	return barrel_direction

# Target is in local space
func rotate_towards(target: Vector2, delta: float):
	var real_limit = deg_to_rad(rotation_limit)

	var our_aim := get_pointing_direction()


	var angle_remaining = our_aim.angle_to(target)
	var clockwise = sign(angle_remaining)

	var rotate_strength = clampf(clockwise*rotation_speed*delta, -abs(angle_remaining), abs(angle_remaining)) 
	pivot.rotate(rotate_strength)

	pivot.rotation = clampf(pivot.rotation, Vector2.DOWN.rotated(-real_limit).angle(), Vector2.DOWN.rotated(real_limit).angle())
	

func fire_bullet():
	if not unfun_timer.is_stopped():
		return

	var bullet = _TurretBullet.instantiate() as TurretBullet

	bullet.global_position = bullet_spawn_location.global_position

	var bullet_direction = Vector2.RIGHT.rotated(pivot.rotation)
	bullet.linear_velocity = bullet_direction*bullet_speed*100

	add_sibling(bullet)
	$%ShootSound.play()
	unfun_timer.start()

func _physics_process(delta):
	if not is_on():
		return

	if targetting:
		rotate_towards(to_local(Game.player.global_position), delta)
		fire_bullet()
	else:
		rotate_towards(Vector2.DOWN, delta)

func _ready():
	assert(abs(rotation_limit) < 90, "Turret rotation limit must be less than 90 degrees")

	unfun_timer.wait_time = 1.0/fire_rate

	activation_zone.body_entered.connect(func (player: Node2D):
		if player is Player:
			targetting = player
	)

	activation_zone.body_exited.connect(func (player: Node2D):
		if player is Player:
			targetting = null
	)

	
