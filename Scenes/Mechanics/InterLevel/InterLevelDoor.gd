class_name InterLevelDoor
extends Node2D

@export var destination:InterLevelDoor
@export var active_colour: Color = Color.WHITE
@export var inactive_colour: Color = Color.RED
@export var state_manager: OnOffState

@onready var interact_zone:GenericInteractable = $%InteractZone
@onready var door_sprite = $%DoorSprite
@onready var door_light = $%DoorLight
@onready var fade_out = $%FadeOut


func _ready()->void:
	interact_zone.interacted.connect(teleport)
	interact_zone.entered.connect(func():
		if !is_active(): return
		door_sprite.play('Open')
	)
	interact_zone.left.connect(func():
		if !is_active(): return
		door_sprite.play('Closed')
	)
	
	door_light.color=active_colour
	if not is_active():
		door_light.color = inactive_colour
		
	if state_manager:
		state_manager.turned_on.connect(turn_on)
		state_manager.turned_off.connect(turn_off)
		state_manager.init()
		
		if not state_manager.on:
			turn_off()



func teleport()->void:
	if !is_active(): return

	door_sprite.play('Closed')
	destination.door_sprite.play('Open')
	Game.player.global_position=destination.global_position


func is_active():
	return not state_manager or state_manager.on
	

func turn_on():
	door_light.color = active_colour


func turn_off():
	door_light.color = inactive_colour
