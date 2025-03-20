extends MarginContainer

func set_volume(value):
	AudioServer.set_bus_volume_db(0, linear_to_db(value))
	$%VolumeLabel.text = "%d%%" % (value*100)

func set_sensitivity(value):
	#GlobalVarsLol.mouse_sensitivity_scale = value
	$%SensitivityLabel.text = "%.2f" % value

func reset():
	set_volume(1)
	set_sensitivity(1.0)
	$%VolumeSlider.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	#$%SensitivitySlider.value = GlobalVarsLol.mouse_sensitivity_scale

func _ready():
	$%VolumeSlider.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	#$%SensitivitySlider.value = GlobalVarsLol.mouse_sensitivity_scale
	$%VolumeLabel.text = "%d%%" % ($%VolumeSlider.value*100)
	#$%SensitivityLabel.text = "%.2f" % GlobalVarsLol.mouse_sensitivity_scale
