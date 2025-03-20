extends Control

@export var main_menu:PackedScene


func back_to_pause_menu():
	$%PauseMenu.visible = true
	$%SettingsMenu.visible = false

func _process(_delta):
	pass
	#if Input.is_action_just_pressed('system_quit'):
		#get_tree().quit()

func _ready():
	$%QuitButton.pressed.connect(func():
		get_tree().change_scene_to_packed(main_menu)
	)
	$%SettingsButton.pressed.connect(func():
		$%PauseMenu.visible = false
		$%SettingsMenu.visible = true
	)

	$%BackFromCredits.pressed.connect(back_to_pause_menu)

func _enter_tree():
##Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	pass
