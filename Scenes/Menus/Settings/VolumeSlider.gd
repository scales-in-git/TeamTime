extends HSlider

@export var bus: int = 0

func set_volume(new_value):
	AudioServer.set_bus_volume_db(bus, linear_to_db(value))
	if new_value != value:
		value = new_value

func _ready():
	value = db_to_linear(AudioServer.get_bus_volume_db(bus))
	value_changed.connect(set_volume)
