extends PanelContainer

@export var volume_slider: HSlider
@export var volume_label: Label

func _ready():
	volume_slider.value_changed.connect(func (value):
		volume_label.text = "%d%%" % (value*100)
	)
