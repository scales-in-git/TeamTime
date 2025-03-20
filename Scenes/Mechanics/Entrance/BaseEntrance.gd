class_name BaseEntrance
extends Node2D

@export var player_max_blocks := 3

var _Player = preload("uid://b6n4ox24glr40")

func enter(_player: Player):
	assert(false, "enter() must be implemented in child class")

func _ready():
	var player = _Player.instantiate()
	enter(player)
	player.max_blocks = player_max_blocks
