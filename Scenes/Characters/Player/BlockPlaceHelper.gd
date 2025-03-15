extends Node


@onready var block_collision_detector: Area2D = $%BlockPlaceCollision
@onready var good_indicator: ColorRect = $%PlaceGoodIndicator
@onready var bad_indicator: ColorRect = $%PlaceBadIndicator

# Preload the block scene
var PlacedBlock := preload("uid://bwp2sn1n0w8v7")

const TILE_SIZE = 100

var can_place_block := false
var placed_block_queue: Array[PlacedBlock] = []

# Append and pop_front

func _input(event: InputEvent):

	if event.is_action_pressed("player_block_place"):
		var new_block := PlacedBlock.instantiate()
		new_block.global_position = block_collision_detector.global_position
		# Can't be local to player...

		var level = Game.get_level()
		if level:
			pass
		else:
			# Debug default position
			get_tree().root.get_child(0).add_child(new_block)
		placed_block_queue.append(new_block)

	pass

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
