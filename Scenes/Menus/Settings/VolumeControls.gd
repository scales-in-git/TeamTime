extends Control

func _on_reset_pressed() -> void:
	$%MasterVolume.set_volume(1.0)
	$%SFXVolume.set_volume(1.0)
	$%MusicVolume.set_volume(1.0)
