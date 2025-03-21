class_name EvilCamera
extends Node2D

@onready var a_bajillion_ray_casts: Node2D = $%ABajillionRayCasts
@onready var real_camera: AnimatedSprite2D = $"%Camera(Real)"
@onready var light: PointLight2D = $%light
@onready var fade_out := $%GenericFade
@onready var alarm: AudioStreamPlayer2D = $%Alarm

@export var state_manager: OnOffState

@export var export_light: PointLight2D
# How long the camera will stay on before it blinks. Set to zero to disable autoblinking.
@export var auto_blink_on: float = 5.0
# How long it blinks for
@export var auto_blink_off: float = 3.0


var blinking := false
var turned_off := false
var killing := false

var auto_blinking_on_state_timer: SceneTreeTimer

# !blinking and !turned_off = on, on animation
# !blinking and turned_off = off, off animation
# blinking and !turned_off = off, blink animation
# blinking and turned_off = off, off animation, blink gets ignored

func blink(how_long: float = 1.0):
	if turned_off or killing:
		return
	blinking = true
	light.enabled = false
	real_camera.animation = "blink"

	var timer := get_tree().create_timer(how_long)
	await timer.timeout
	if not turned_off:
		light.enabled = true
		blinking = false
		real_camera.animation = "on"
		if auto_blink_on > 0.0:
			auto_blinking_on_state_timer = _create_blink_timer() 

func turn_off():
	real_camera.animation = 'off'
	turned_off = true
	light.enabled = false

func turn_on():
	turned_off = false
	light.enabled = true
	real_camera.animation = 'on'


func _create_blink_timer():
	var timer = get_tree().create_timer(auto_blink_on)
	timer.timeout.connect(func ():
		blink(auto_blink_off)
	)
	return timer

func _physics_process(_delta):
	if blinking or turned_off or killing:
		return
	
	var raycasts = a_bajillion_ray_casts.get_children()
	for raycast in raycasts:
		var collided = raycast.get_collider()
		if collided is Player:
			killing = true
			light.color = Color.PALE_VIOLET_RED

			if export_light: export_light.color=Color.PALE_VIOLET_RED
			
			alarm.play()

			await fade_out.fade_out().finished
			SceneTransition.call_deferred("reset_scene")

func _ready():
	if auto_blink_on > 0.0:
		auto_blinking_on_state_timer = _create_blink_timer()
	
	if state_manager:
		state_manager.init()
		state_manager.turned_on.connect(turn_on)
		state_manager.turned_off.connect(turn_off)
	
		if not state_manager.on:
			turn_off()
