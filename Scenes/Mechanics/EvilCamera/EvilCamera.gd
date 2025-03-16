class_name EvilCamera
extends Node2D

@onready var a_bajillion_ray_casts: Node2D = $%ABajillionRayCasts
@onready var real_camera: AnimatedSprite2D = $"%Camera(Real)"
@onready var light: PointLight2D = $%light
@onready var fade_out := $%GenericFade
@onready var alarm: AudioStreamPlayer2D = $%Alarm

# How long the camera will stay on before it blinks. Set to zero to disable autoblinking.
@export var auto_blink_on: float = 5.0
# How long it blinks for
@export var auto_blink_off: float = 3.0


var blinking := false
var turned_off := false
var killing := false

# !blinking and !turned_off = on, on animation
# !blinking and turned_off = off, off animation
# blinking and !turned_off = off, blink animation
# blinking and turned_off = off, off animation, blink gets ignored

func blink(how_long: float):
	if turned_off or killing:
		return
	blinking = true
	var timer := get_tree().create_timer(how_long)
	light.enabled = false
	timer.play()
	await timer.timeout
	if not turned_off:
		light.enabled = true
		blinking = false

func turn_off():
	turned_off = true
	light.enabled = false

func turn_on():
	turned_off = false
	light.enabled = true



func _physics_process(_delta):
	if blinking or turned_off or killing:
		return
	
	var raycasts = a_bajillion_ray_casts.get_children()
	for raycast in raycasts:
		var collided = raycast.get_collider()
		if collided is Player:
			killing = true
			light.color = Color.PALE_VIOLET_RED
			alarm.play()

			await fade_out.fade_out().finished
			SceneTransition.call_deferred("reset_scene")
