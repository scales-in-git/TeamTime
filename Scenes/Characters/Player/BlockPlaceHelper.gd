extends Node


@onready var block_collision_detector: Area2D = $%BlockPlaceCollision
@onready var good_indicator: ColorRect = $%PlaceGoodIndicator
@onready var bad_indicator: ColorRect = $%PlaceBadIndicator

const TILE_SIZE = 100

var can_place_block := false

func _physics_process(_delta: float) -> void:
	var camera = get_viewport().get_camera_2d()
	# good_indicator.global_position = floor(camera.get_global_mouse_position())
	var new_pos: Vector2 = floor(camera.get_global_mouse_position())
	new_pos.x -= TILE_SIZE if new_pos.x < 0 else 0
	new_pos.y -= TILE_SIZE if new_pos.y < 0 else 0

	new_pos.x -= new_pos.x as int % TILE_SIZE
	new_pos.y -= new_pos.y as int % TILE_SIZE


	block_collision_detector.global_position = new_pos

	if block_collision_detector.has_overlapping_bodies():
		good_indicator.visible = false
		bad_indicator.visible = true
	else:
		good_indicator.visible = true
		bad_indicator.visible = false
	can_place_block = good_indicator.visible

	return
