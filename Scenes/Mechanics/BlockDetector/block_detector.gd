extends Node2D

@export var on_off_state_manager: OnOffState

@onready var block_detector: Area2D = $%BlockDetectorZone



func _on_block_detector_zone_area_exited(_area: Node2D):
	if not on_off_state_manager.on:
		return
	on_off_state_manager.call_deferred("turn_off")
	$off_sound.play()

func _on_block_detector_zone_area_entered(_area: Node2D):
	if on_off_state_manager.on:
		return 
	on_off_state_manager.call_deferred("turn_on")
	$on_sound.play()

func _ready():
	if on_off_state_manager:
		on_off_state_manager.init()
		on_off_state_manager.turn_off()
