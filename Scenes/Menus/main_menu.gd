extends Control

@export var start:PackedScene


func back_to_main_menu():
	$%CreditsMenu.visible = false
	$%SettingsMenu.visible = false
	$%MainMenu.visible = true

func _process(_delta):
	pass
	#if Input.is_action_just_pressed('system_quit'):
		#get_tree().quit()

func _ready():
	$%PlayButton.pressed.connect(func():
		get_tree().change_scene_to_packed(start)
		pass
	#get_tree().change_scene_to_file("res://Game/Scenes/Room/laboratory.tscn")
	)
	#$%QuitButton.pressed.connect(func():
	#	get_tree().quit()
	#)

	$%CreditsButton.pressed.connect(func():
		$%MainMenu.visible = false
		$%CreditsMenu.visible = true 
	)
	$%SettingsButton.pressed.connect(func():
		$%MainMenu.visible = false
		$%SettingsMenu.visible = true
	)

	$%BackFromCredits.pressed.connect(back_to_main_menu)
	$%BackFromCredits2.pressed.connect(back_to_main_menu)

func _enter_tree():
##Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	pass
