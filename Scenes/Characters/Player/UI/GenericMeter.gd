# Class that handles the display of meter as well as draining,
# penalty timer, regen, etc.

class_name GenericMeter
extends ProgressBar

signal drain_value_changed(naturally: bool, new_val: float, difference: float)
signal drain_depleted(naturally: bool, penalty_timer: SceneTreeTimer)
signal drain_replenished(naturally: bool)
signal drain_penalty_concluded(naturally: bool)
signal drain_began(drain_rate: float)
signal drain_ended(naturally: bool)

signal max_updated(new_max: float, old_max: float)

@export_category('Display')
@export var unit_width: float
@export var height: int = 20

@export_category('Drain')
var is_active: bool = false
var is_penalty: bool = false
var penalty_timer: SceneTreeTimer
@export var drain_rate: float
@export var penalty_wait: float
@export var regen: float

@export_category('Overdrain')
var is_overdrain_active: bool = false
var is_overdrain_penalty: bool = false
var overdrain_peanlty_timer: SceneTreeTimer
@export var overdrain_rate: float
@export var overdrain_penalty_wait: float
@export var overdrain_regen: float

var current_overdrain_value: float


func set_to(amount: float):
	# NOTE: passing in 0 drains it entirely,
	#  passing in a negative number replenishes
	#  (OR: do we want a fully deplete function?)
	#  (OR: "change by ratio"?)
	# Decide on what we'll actually need if we have
	#  "Celeste dash crystals mechanics"
	pass

func change_by(amount: float):
	pass

func toggle_drain(_drain_rate: float = -1.0):
	if not is_active:
		return begin_drain(_drain_rate)
	else:
		return end_drain()

func begin_drain(_drain_rate: float = -1.0):
	if is_penalty or is_active:
		return false
	
	# Note: don't set drain_rate if it's negative.
	# Zero can be done for "infinite meter"
	is_active = true
	if _drain_rate >= 0.0:
		drain_rate = _drain_rate
	drain_began.emit(_drain_rate)
	return true
	
func end_drain():
	if is_penalty or not is_active:
		return false
	is_active = false
	drain_ended.emit(true)

func set_max_value(new_max_value: float, replace_current: bool = true) -> void:
	custom_minimum_size = Vector2(unit_width*new_max_value, height)
	var old_max = max_value
	max_value = new_max_value
	max_updated.emit(max_value, old_max)
	
	if replace_current:
		var old_value = value
		value = new_max_value
	
		value_changed.emit(value, value - old_value)
		drain_replenished.emit(false)
		
		penalty_timer.stop()
		if is_penalty:
			is_penalty = false
			drain_penalty_concluded.emit(false)

func _on_penalty_end():
	is_penalty = false
	drain_penalty_concluded.emit(true)

# Passive restore
func _process_meter(delta):
	assert(not (is_active and is_penalty), "Meter is active despite in penalty time")
	if is_active:
		var original_value := value
		value -= drain_rate*delta
		if value <= 0.0:
			value = 0.0
			is_active = false
			is_penalty = true
			drain_ended.emit(false)
			# TODO: Begin penalty
			penalty_timer = get_tree().create_timer(penalty_wait)
			penalty_timer.timeout.connect(_on_penalty_end)
			drain_depleted.emit(true, penalty_timer)
		
		drain_value_changed.emit(true, value, value - original_value)
		
	elif not is_active and not is_penalty and not value == max_value:
		var old_value = value
		value += regen*delta
		if value > max_value:
			value = max_value
			drain_replenished.emit(true)
		drain_value_changed.emit(true, value, value - old_value)
			
			
func _process(delta):
	_process_meter(delta)
	
func _ready():
	custom_minimum_size = Vector2(unit_width*max_value, height)
	value = max_value
