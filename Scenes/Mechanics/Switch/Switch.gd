class_name InteractSwitch
extends Node2D


@export var state_manager: OnOffState


@export var on_colour: Color = Color('#54ffd18a')
@export var off_colour: Color = Color(Color.TOMATO,138.0/256.0)
@export var switch_sprite:Sprite2D
@export var switch_light:PointLight2D

##@onready var indicator: ColorRect = $%TempIndicator
@onready var interactor: GenericInteractable = $%Interacter


func turn_on():
	
	##indicator.color = on_colour
	switch_light.color=on_colour
	##switch_sprite.modulate=on_colour
	# Also: play sound

func turn_off():
	##indicator.color = off_colour
	#switch_sprite.modulate=off_colour
	switch_light.color=off_colour
	# Also: play sound



func _ready():
	assert(state_manager, "This class makes no sense without a state manager!")

	state_manager.init()
	state_manager.turned_on.connect(turn_on)
	state_manager.turned_off.connect(turn_off)
	interactor.interacted.connect(state_manager.toggle)

	if not state_manager.on:
		turn_off()
