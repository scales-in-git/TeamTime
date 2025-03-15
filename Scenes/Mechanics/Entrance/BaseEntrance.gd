class_name BaseEntrance
extends Node2D

var _Player = preload("uid://b6n4ox24glr40")

func enter(_player: Player):
	assert(false, "enter() must be implemented in child class")

func _ready():
	var player = _Player.instantiate()
	get_tree().root.get_child(0).add_child(player)
	enter(player)
