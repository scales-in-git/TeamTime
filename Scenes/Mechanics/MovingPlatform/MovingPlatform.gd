extends AnimatableBody2D

@export var direction: Vector2 = Vector2(1, 0)
@export var distance: float = 5.0
# In 100 pixels (one tile) per second
@export var speed: float = 0.5
@export var wait: float = 2.0

const TILE_SIZE: float = 100.0

enum MovementState {
	SOURCE_WAIT,
	SOURCE_MOVE_TO,
	TARGET_WAIT,
	TARGET_MOVE_TO
}

var active = true
var current_state: MovementState = MovementState.TARGET_MOVE_TO

func _physics_process(delta):
	if not active:
		return

	if current_state == MovementState.SOURCE_WAIT or current_state == MovementState.TARGET_WAIT:
		return

	var use_direction = direction if current_state == MovementState.TARGET_MOVE_TO else -direction
	var intended_displacement = use_direction*delta*speed

	var reached_destination = false
	
	if current_state == MovementState.TARGET_MOVE_TO and (position + intended_displacement).length() > distance:
		var end_position = direction*distance
		# Holy f*** linear algebra
		intended_displacement = end_position - position
		reached_destination = true
	
	if current_state == MovementState.SOURCE_MOVE_TO and (Vector2.ZERO - position).length() < intended_displacement.length():
		intended_displacement = -position #?
		reached_destination = true


	var collision := move_and_collide(intended_displacement, true)
	if collision:
		return

	if reached_destination and current_state == MovementState.TARGET_MOVE_TO:
		current_state = MovementState.TARGET_WAIT
		get_tree().create_timer(wait).timeout.connect(func ():
			current_state = MovementState.SOURCE_MOVE_TO
		)

	if reached_destination and current_state == MovementState.SOURCE_MOVE_TO:
		current_state = MovementState.SOURCE_WAIT
		get_tree().create_timer(wait).timeout.connect(func ():
			current_state = MovementState.TARGET_MOVE_TO
		)

	position += intended_displacement

func _ready():
	direction = direction.normalized()
	distance *= TILE_SIZE
	speed *= TILE_SIZE
