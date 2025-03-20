class_name GoalDoorExit
extends BaseExit


@export var fade_out_time := 2.0

@export var fade_colour: Color = Color.BLACK
@export var active_colour: Color = Color("#008cff")
@export var inactive_colour: Color = Color.RED

@export var state_manager: OnOffState

@onready var interact_zone = $%InteractZone
@onready var door_sprite = $%DoorSprite
@onready var door_light = $%DoorLight
@onready var fade_out = $%FadeOut

func is_active():
	return not state_manager or state_manager.on


func _on_interact_zone_interacted():
	if not is_active():
		return
	
	SceneTransition.background_load_transition(scene)

	Game.player.puppeting = true

	# Todo: emit level pause signal to game, oh no we're so late
	# Easier todo: actually make her invincible lmao (disable layer 3?)

	door_sprite.play('Open')	
	var fade_out_tween := get_tree().create_tween()
	fade_out_tween.tween_property($%FadeOut, 'color:a', 1.0, fade_out_time)
	fade_out_tween.play()
	await fade_out_tween.finished
	$%FadeOut.color.a = 1.0

	SceneTransition.transition(scene)


func turn_on():
	door_light.color = active_colour

func turn_off():
	door_light.color = inactive_colour


func _ready():
	$%FadeOut.color = fade_colour
	$%FadeOut.color.a = 0.0

	if not is_active():
		door_light.color = inactive_colour
	if state_manager:
		state_manager.turned_on.connect(turn_on)
		state_manager.turned_off.connect(turn_off)
