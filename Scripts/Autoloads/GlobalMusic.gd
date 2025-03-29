extends AudioStreamPlayer



func play_music(music: AudioStream):
	if stream == music and playing:
		return
	stream = music
	play()

func _ready():
	bus = "Music"
	volume_db = -10
