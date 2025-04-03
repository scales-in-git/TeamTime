class_name StolenAnimations 
extends AnimatedSprite2D

enum StolenAnimation{LOOKDOWN,LOOKLEFT,WALK,DEFAULT}
var stolen_animation=StolenAnimation.DEFAULT
var stolen_footstep_frames : Array = [1]
var stolen_footstep_frames2 : Array = [5]

@export var stolen_sfx_footsteps1 : AudioStream
@export var stolen_sfx_footsteps2 : AudioStream


func _on_frame_changed() -> void:
	if  animation == "Walk":
		if frame in stolen_footstep_frames: $%sfx_stolen_footstep1.play()
		if frame in stolen_footstep_frames2: $%sfx_stolen_footstep2.play()
