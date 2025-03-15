extends Node2D

@export var music: AudioStream


func _enter_tree():
	GlobalMusic.play_music(music)
