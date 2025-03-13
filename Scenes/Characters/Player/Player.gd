class_name Player
extends CharacterBody2D

@export var speed: float = 400.0
@export var gravity: float = 1800.0
@export var jump_strength: float = 1000.0

var puppeting := false


func _physics_process(delta: float) -> void:
	var walk_magnitude = Input.get_axis("player_left", "player_right")
	velocity.x = walk_magnitude*speed
	
	velocity.y += gravity*delta
	
	if Input.is_action_just_pressed("player_jump") and is_on_floor():
		velocity.y = -jump_strength
	
	move_and_slide()
