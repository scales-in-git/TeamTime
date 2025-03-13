extends Node

var _collected_items: Dictionary = {}

signal collected(category: String, data: Variant)

# I badly wanted to make these enums, but GDScript enums can only be integers.
#  I feel like having a name associated is too valuable for debugging
#  and will save headaches if we need to change the order of these consts
#  or add/remove them, as the save data will reference the string and not the
#  now out-of-order integer.
# Important and yet miscelanous
const SAVE_CATEGORY_RED_MAJOR_ITEM = "red_major_item"
const SAVE_CATEGORY_OTHER_MAJOR_ITEM = "other_major_item"
const SAVE_CATEGORY_MAX_LIVES = "max_lives"
const SAVE_CATEGORY_MAX_INVENTORY = "max_inventory"

# owo what's this? (Will probably keep for May 15th version)
const SAVE_CATEGORY_MAX_DOUBLE_JUMP_UPGRADE = "max_double_jump_upgrade"

# Health related
const SAVE_CATEGORY_MAX_HEALTH_UPGRADE = "max_health_upgrade"
const SAVE_CATEGORY_DEFENSE_UPGRADE = "defense_upgrade"

# Stamina
const SAVE_CATEGORY_MAX_STAMINA_UPGRADE = "max_stamina_upgrade"
const SAVE_CATEGORY_STAMINA_DRAIN_REDUCE = "stamina_drain_reduce"
const SAVE_CATEGORY_STAMINA_REGAIN_UPGRADE = "stamina_regain_upgrade"

# Sprint upgrades
const SAVE_CATEGORY_SPRINT_SPEED_UPGRADE = "sprint_speed_upgrade"
# (May be redundant with stamina drain reduce? Could be removed) 
const SAVE_CATEGORY_SPRINT_DRAIN_REDUCE = "sprint_drain_reduce" 

 # Fuel upgrades, if kept. Might only apply to hover/glide
const SAVE_CATEGORY_MAX_FUEL_UPGRADE = "max_fuel_upgrade"

# Battery
const SAVE_CATEGORY_MAX_BATTERY_UPGRADE = "max_battery_upgrade"
const SAVE_CATEGORY_BATTERY_DRAIN_REDUCE = "battery_drain_reduce"
const SAVE_CATEGORY_FLASHLIGHT_RANGE_UPGRADE = "flashlight_range_upgrade"
# (Again, this may be too quadratic)
const SAVE_CATEGORY_FLASHLIGHT_DRAIN_REDUCE = "flashlight_drain_reduce"
const SAVE_CATEGORY_INVISIBILITY_DRAIN_REDUCE = "invisibility_drain_reduce"
const SAVE_CATEGORY_TIME_SLOWER_DRAIN_REDUCE = "time_slower_drain_reduce"
const SAVE_CATEGORY_INFRARED_DRAIN_REDUCE = "infrared_drain_reduce"

# Keys
const SAVE_CATEGORY_KEYS_COLLECTED = "keys_collected"
const SAVE_CATEGORY_DOORS_UNLOCKED = "doors_unlocked"

# Lore
const SAVE_CATEGORY_MEMORY_WITNESSED = "memory_witnessed"
const SAVE_CATEGORY_MONSTER_LOG_COLLECTED = "monster_log_collected"

# Other
# (Meant for arbitrary level data, like if a permanent switch was flicked)
const SAVE_CATEGORY_FLAGS = "flags"

func register_collection(category: String, full_id: String, data: Variant):
	if not _collected_items.has(category):
		_collected_items[category] = {}
	
	_collected_items[category][full_id] = data

	collected.emit(category, data)
	SaveManager.save()

func item_collected(category: String, full_id: String) -> bool:
	return _collected_items.has(category) and _collected_items[category].has(full_id)

func get_category(category: String) -> Array:
	if not _collected_items.has(category):
		return []
	else:
		return _collected_items[category].values()

func _unhandled_input(event):
	if event.is_action_pressed('debug_print_current_collectibles'):
		print(_collected_items)
	
	
