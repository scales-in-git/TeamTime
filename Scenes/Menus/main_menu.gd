extends Control

@export var start:PackedScene
@export var start_button:Button

func back_to_main_menu():
	$%CreditsMenu.visible = false
	$%SettingsMenu.visible = false
	$%MainMenu.visible = true

func _ready():
	start_button.pressed.connect(func():
		print("pressed")
		get_tree().change_scene_to_packed(start)
		pass
	)

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
