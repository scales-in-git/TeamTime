class_name BlockPlacer
extends Node


@onready var block_collision_detector: Area2D = $%BlockPlaceCollision
@onready var good_indicator: ColorRect = $%PlaceGoodIndicator
@onready var bad_indicator: ColorRect = $%PlaceBadIndicator

@export var max_placeable_blocks: int = 3

# Preload the block scene
var _PlacedBlock := preload("uid://bwp2sn1n0w8v7")

const TILE_SIZE = 100

var can_place_block := false
var placed_block_queue: Array[PlacedBlock] = []

# Would be of type PlacedBlock but you can't set typed vars to null (annoyingly)
var highlighted_block

func set_max_blocks(_max_blocks: int):
	max_placeable_blocks = _max_blocks
	# TODO: destroy current blocks if there's more blocks placed than allowed

# Append and pop_front
func _input(event: InputEvent):
	var blocks_changed := false

	if event.is_action_pressed("player_block_place") and can_place_block:
		var new_block := _PlacedBlock.instantiate()
		new_block.global_position = block_collision_detector.global_position
		# Can't be local to player...

		var level = Game.get_level()
		if level:
			pass
		else:
			# Debug default position
			get_tree().root.get_child(0).add_child(new_block)
		placed_block_queue.append(new_block)
		blocks_changed = true

	if event.is_action_pressed('player_block_delete') and highlighted_block:
		placed_block_queue.erase(highlighted_block)
		highlighted_block.fancy_delete()
		blocks_changed = true

	if blocks_changed:
		placed_block_queue.front().clear_highlight()

		# Don't show what will be deleted if player can only place one; they'll know it'll be removed.
		if placed_block_queue.size() == max_placeable_blocks and max_placeable_blocks > 1:
			placed_block_queue.front().highlight_as_last()

		if placed_block_queue.size() > max_placeable_blocks:
			var last_block = placed_block_queue.pop_front()
			last_block.fancy_delete()
			placed_block_queue.front().highlight_as_last()
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

	# TODO: we already have a "bad place block indicator", that might be much, much cleaner than messing with
	# animations, especially since this is a bit messy.
	if block_collision_detector.has_overlapping_bodies():
		good_indicator.visible = false
		bad_indicator.visible = true

		var get_overlapping_bodies = block_collision_detector.get_overlapping_bodies()
		if highlighted_block and highlighted_block not in get_overlapping_bodies:
			# highlighted_block.highlight_for_deletion = false
			highlighted_block = null

		for body in block_collision_detector.get_overlapping_bodies():
			if body is PlacedBlock and not highlighted_block:
				highlighted_block = body
				# highlighted_block.highlight_for_deletion = true
	elif highlighted_block:
		# highlighted_block.highlight_for_deletion = false
		highlighted_block = null

		
	else:
		good_indicator.visible = true
		bad_indicator.visible = false
	can_place_block = good_indicator.visible

	return
