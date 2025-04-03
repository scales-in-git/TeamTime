class_name PlayerAnimations
extends AnimatedSprite2D

enum CharacterAnimation{RUN,IDLE,JUMP}
var character_animation=CharacterAnimation.JUMP
var footstep_frames : Array = [1]
var footstep_frames2 : Array = [5]

@export var sfx_footsteps1 : AudioStream
@export var sfx_footsteps2 : AudioStream

func Running():
	if  character_animation!=CharacterAnimation.RUN:
		character_animation=CharacterAnimation.RUN
		play("RunStart")
		await (animation_finished)
		play("Run")
		
func _on_sprite_2d_frame_changed():
	if animation == "Run":
		if frame in footstep_frames: $%sfx_player_step1.play()
		if frame in footstep_frames2: $%sfx_player_step2.play()
		if animation == "RunEnd":
			if frame == 1: $%sfx_player_step2.play()

func Idle():
	if character_animation!=CharacterAnimation.IDLE:
		character_animation=CharacterAnimation.IDLE
		play("RunEnd")
		await (animation_finished)
		play("Idle")
		
func Jump():
	if character_animation!=CharacterAnimation.JUMP:
		character_animation=CharacterAnimation.JUMP
		play("Jump")



func _on_sprite_frames_changed() -> void:
	_on_sprite_2d_frame_changed()# Replace with function body.


func _on_frame_changed() -> void:
	_on_sprite_frames_changed()# Replace with function body.
