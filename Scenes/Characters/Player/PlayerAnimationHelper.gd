class_name PlayerAnimations
extends AnimatedSprite2D

enum CharacterAnimation{RUN,IDLE,JUMP}
var character_animation=CharacterAnimation.JUMP
var footstep_frames : Array = [1,5]
var footstep_frames2 : Array = [3,7]

@export var sfx_jump : AudioStream
@export var sfx_footsteps1 : AudioStream
@export var sfx_footsteps2 : AudioStream

func Running():
	if  character_animation!=CharacterAnimation.RUN:
		character_animation=CharacterAnimation.RUN
		play("RunStart")
		await (animation_finished)
		play("Run")
		
func _on_sprite_2d_frame_changed():
	if %Sprite.animation == "Idle": return
	if %Sprite.animation == "Jump": return
	if %Sprite.animation == "RunEnd": return
	if %Sprite.animation == "RunStart": return
	if %Sprite.animation == "default": return
	load_sfx(sfx_footsteps1)
	if %Sprite.frame in footstep_frames: $%sfx_player.play()

func Idle():
	if character_animation!=CharacterAnimation.IDLE:
		character_animation=CharacterAnimation.IDLE
		play("RunEnd")
		await (animation_finished)
		play("Idle")

func Jump():
	if character_animation!=CharacterAnimation.JUMP:
		load_sfx(sfx_jump)
		$%sfx_player.play()
		character_animation=CharacterAnimation.JUMP
		play("Jump")
	
func load_sfx(sfx_to_load):
		if $%sfx_player.stream != sfx_to_load:
				$%sfx_player.stop()
				$%sfx_player.stream = sfx_to_load
