class_name Player
extends CharacterBody2D

@export_category("Animation")
@export var animated_sprite:PlayerAnimations

@export_category("Movement")

@export var speed: float = 400.0
@export var gravity: float = 1800.0
@export var jump_strength: float = 1000.0

@export_category("Other")
@export var max_blocks: int:
	set(value):
		
		if value<=0: 
			block_placer.disabled=true
			value=1
		
		max_blocks = value
		block_placer.set_max_blocks(max_blocks)
	get():
		return max_blocks
@onready var block_placer: BlockPlacer = $%BlockPlaceHelper

@onready var jump_buffer_timer: Timer = $%JumpBufferTimer
@onready var coyote_timer: Timer = $%CoyoteTimer

var puppeting := false


func _physics_process(delta: float) -> void:
	if puppeting:
		return

	if Input.is_action_just_pressed('player_jump'):
		jump_buffer_timer.start()

	var walk_magnitude = Input.get_axis("player_left", "player_right")
	velocity.x = walk_magnitude*speed
	
	
	if walk_magnitude != 0.0:
		var is_left:= (animated_sprite.scale.x<0.0)
		var moving_left:bool= (walk_magnitude<0.0)
		
		if is_left and not moving_left: animated_sprite.scale.x=animated_sprite.scale.x*-1

		if moving_left and not is_left: animated_sprite.scale.x=animated_sprite.scale.x*-1
	

	if is_on_floor():
		if walk_magnitude != 0.0:
			animated_sprite.Running()

		if walk_magnitude==0.0:
			animated_sprite.Idle()
		coyote_timer.start()

	else:
		animated_sprite.Jump()

	velocity.y += gravity*delta
	
	# if Input.is_action_just_pressed("player_jump") and is_on_floor():
	if not jump_buffer_timer.is_stopped() and (is_on_floor() or not coyote_timer.is_stopped()):
		velocity.y = -jump_strength
		jump_buffer_timer.stop()
	
	move_and_slide()

func _ready():
	$%PhantomCamera.follow_mode = PhantomCamera2D.FollowMode.SIMPLE
	$%PhantomCamera.follow_target = self
	$%PhantomCamera.follow_damping = true
	$%PhantomCamera.follow_damping_value = Vector2(.2, .2)
	# $%PhantomCamera.follow_offset.y = -300

func _enter_tree():
	Game.player = self

func _exit_tree():
	block_placer.wipe_blocks(true)
