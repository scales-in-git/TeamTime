class_name Player
extends CharacterBody2D

@export_category("Movement")

@export var speed: float = 400.0
@export var gravity: float = 1800.0
@export var jump_strength: float = 1000.0

@export_category("Other")
@export var max_blocks: int:
	set(value):
		max_blocks = 3
		block_placer.set_max_blocks(max_blocks)
	get():
		return max_blocks
@onready var block_placer: BlockPlacer = $%BlockPlaceHelper

var puppeting := false


func _physics_process(delta: float) -> void:
	var walk_magnitude = Input.get_axis("player_left", "player_right")
	velocity.x = walk_magnitude*speed
	
	velocity.y += gravity*delta
	
	if Input.is_action_just_pressed("player_jump") and is_on_floor():
		velocity.y = -jump_strength
	
	move_and_slide()
