class_name PlayerAnimations
extends AnimatedSprite2D

enum CharacterAnimation{RUN,IDLE,JUMP}
var character_animation=CharacterAnimation.JUMP

func Running():
	if  character_animation!=CharacterAnimation.RUN:
		character_animation=CharacterAnimation.RUN
		play("RunStart")
		await (animation_finished)
		play("Run")

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
	
	
