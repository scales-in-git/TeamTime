extends MarginContainer

func set_volume(value):
	AudioServer.set_bus_volume_db(0, linear_to_db(value))
	$%VolumeLabel.text = "%d%%" % (value*100)


func reset():
	set_volume(.56)
	$%VolumeSlider.value = db_to_linear(AudioServer.get_bus_volume_db(0))


func _ready():
	$%VolumeSlider.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	$%VolumeLabel.text = "%d%%" % ($%VolumeSlider.value*100)
	$%VolumeSlider.value_changed.connect(set_volume)
	
	$%Reset.pressed.connect(reset)
