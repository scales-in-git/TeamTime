class_name GoalDoorEntrance
extends BaseEntrance


@export var fade_in_time := 2.0

@export var fade_colour: Color = Color.BLACK
@export var glow_colour: Color = Color.GHOST_WHITE

@export var enter_at: Node2D

@onready var door_sprite = $%DoorSprite
@onready var door_light = $%DoorLight
@onready var fade_in = $%FadeIn



func enter(player: Player):
	if enter_at:
		enter_at.add_child(player)
	else:
		add_child(player)

	player.puppeting = true

	fade_in.color = fade_colour
	door_sprite.play('Open')	
	var fade_in_tween := get_tree().create_tween()
	fade_in_tween.tween_property(fade_in, 'color:a', 0.0, fade_in_time)
	fade_in_tween.play()
	await fade_in_tween.finished
	door_sprite.play('Closed')	
	$door_close.play()
	fade_in.color.a = 0.0
	player.puppeting = false




func _ready():
	super._ready()
	door_light = glow_colour
