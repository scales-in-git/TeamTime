extends Node


@onready var good_indicator: ColorRect = $%PlaceGoodIndicator
@onready var bad_indicator: ColorRect = $%PlaceBadIndicator

const TILE_SIZE = 100

func _input(event):
	pass
	# if event is InputEventMouseMotion:
	# 	var camera = get_viewport().get_camera_2d()
	# 	good_indicator.global_position = camera.get_global_mouse_position() 
	# 	print(good_indicator.global_position)
		# click.emit(camera.get_global_mouse_position())


	return


func _process(_delta: float) -> void:
	var camera = get_viewport().get_camera_2d()
	# good_indicator.global_position = floor(camera.get_global_mouse_position())
	var new_pos: Vector2 = floor(camera.get_global_mouse_position())
	new_pos.x -= TILE_SIZE if new_pos.x < 0 else 0
	new_pos.y -= TILE_SIZE if new_pos.y < 0 else 0

	new_pos.x -= new_pos.x as int % TILE_SIZE
	new_pos.y -= new_pos.y as int % TILE_SIZE

	# good_indicator.global_position.x -= TILE_SIZE if good_indicator.global_position.x

	print(new_pos)
	good_indicator.global_position = new_pos

	# good_indicator.global_position.x -= good_indicator.global_position.x as int % TILE_SIZE
	# good_indicator.global_position.y -= good_indicator.global_position.y as int % TILE_SIZE

	# good_indicator.global_position.x -= good_indicator.global_position.x % TILE_SIZE
	# good_indicator.global_position.y -= good_indicator.global_position.y % TILE_SIZE
	# good_indicator.global_position -= good_indicator.global_position % TILE_SIZE

	return
