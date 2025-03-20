extends Control

@export var main_menu:PackedScene
	
func _ready():
	$%ResumeButton.pressed.connect(func():back_to_game())
	$%QuitButton.pressed.connect(func():
		get_tree().change_scene_to_packed(main_menu)
	)
	$%SettingsButton.pressed.connect(func():
		$%MainMenu.visible = false
		$%SettingsMenu.visible = true
	)

	$%BackFromCredits.pressed.connect(back_to_main_menu)
	back_to_game()

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"): #Built-In action for ESC 
		get_tree().paused=!$%PauseMenu.visible
		back_to_main_menu()
		$%PauseMenu.visible=(!$%PauseMenu.visible)

func back_to_game():
	back_to_main_menu()
	$%PauseMenu.visible=false
	get_tree().paused=false

func back_to_main_menu():
	$%MainMenu.visible = true
	$%SettingsMenu.visible = false
