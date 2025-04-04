class_name BlockPlacer
extends Node


@onready var block_collision_detector: Area2D = $%BlockPlaceCollision
@onready var good_indicator: ColorRect = $%PlaceGoodIndicator
@onready var bad_indicator: ColorRect = $%PlaceBadIndicator

@export var max_placeable_blocks: int = 3

var disabled:=false

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

func wipe_blocks(fast: bool = false):
	while placed_block_queue.size() > 0:
		var block = placed_block_queue.pop_back()
		if not fast:
			block.fancy_delete()
		else:
			block.queue_free()


# Append and pop_front
func _input(event: InputEvent):
	if disabled:return

	var blocks_changed := false

	if event.is_action_pressed("player_block_place") and can_place_block:
		var new_block := _PlacedBlock.instantiate()

		get_parent().add_sibling(new_block)
		new_block.global_position = block_collision_detector.global_position
		$sound_block.play()

		placed_block_queue.append(new_block)
		blocks_changed = true

	if event.is_action_pressed('player_block_delete') and highlighted_block:
		placed_block_queue.erase(highlighted_block)
		highlighted_block.fancy_delete()
		$sound_block_remove.play()
		blocks_changed = true

	if event.is_action_pressed('player_delete_all'):
		if placed_block_queue.size() > 1:
			$sound_block_remove.play()
		while placed_block_queue.size() > 0:
			var block = placed_block_queue.pop_back()
			block.fancy_delete()

	if blocks_changed:
		if placed_block_queue.size() > 0:
			placed_block_queue.front().clear_highlight()

		if placed_block_queue.size() > max_placeable_blocks:
			var last_block = placed_block_queue.pop_front()
			last_block.fancy_delete()
			
		# Don't show what will be deleted if player can only place one; they'll know it'll be removed.
		if placed_block_queue.size() >= max_placeable_blocks and max_placeable_blocks > 1:
			placed_block_queue.front().highlight_as_last()
	pass

func _physics_process(_delta: float) -> void:
	if disabled: return

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
