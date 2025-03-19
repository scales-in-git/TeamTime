extends Node2D

@export var on_off_state_manager: OnOffState

@onready var block_detector: Area2D = $%BlockDetectorZone



func _on_block_detector_zone_area_exited(_area: Node2D):
    if not on_off_state_manager.on:
        return
    on_off_state_manager.turn_off()


func _on_block_detector_zone_area_entered(_area: Node2D):
    if on_off_state_manager.on:
        return 
    on_off_state_manager.turn_on()


func _physics_process(delta):
    for detected_body in block_detector.get_overlapping_bodies():
        if detected_body is PlacedBlock:
            print("Helloy")


func _ready():
    on_off_state_manager.init()
    on_off_state_manager.turn_off()