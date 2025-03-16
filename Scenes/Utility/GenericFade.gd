class_name GenericFade
extends CanvasLayer

@export var target_colour: Color = Color.BLACK
@export var fade_in_time: float = 1.0
@export var transition_type: Tween.TransitionType = Tween.TransitionType.TRANS_LINEAR

@onready var fade: ColorRect = $ColorRect

func fade_out():
	$ColorRect.color.r = target_colour.r	
	$ColorRect.color.g = target_colour.g	
	$ColorRect.color.b = target_colour.b	
	var fade_in_tween := get_tree().create_tween()
	fade_in_tween.tween_property(fade, 'color:a', target_colour.a, fade_in_time) \
		.set_trans(transition_type)
	fade_in_tween.play()
	return fade_in_tween

func fade_omt():
	$ColorRect.color = target_colour
	var fade_in_tween := get_tree().create_tween()
	fade_in_tween.tween_property(fade, 'color:a', 0.0, fade_in_time) \
		.set_trans(transition_type)
	fade_in_tween.play()
	return fade_in_tween
