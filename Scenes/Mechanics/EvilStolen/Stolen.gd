class_name Stolen extends CharacterBody2D
@export var speed:=3.0
@export var facing_right:=false

@onready var _edgedetection:RayCast2D=$%EdgeDetection
@onready var _walldetection:RayCast2D=$%WallDetection
@onready var _animation:AnimationPlayer=$%Animator


var _searching:=false

func _ready():
	speed*=-100.0
	if facing_right:
		speed*=-1


func _physics_process(delta:float)->void:
	
	if _searching:return

	move_and_slide()

	if not is_on_floor():
		velocity.y+=get_gravity().y*delta
		_animation.play("default")
		return

	if velocity.x != 0.0:
		_animation.play("Walk")
	
	if (not _edgedetection.is_colliding() or _walldetection.is_colliding())&& is_on_floor():
		print(_walldetection.is_colliding())
		flip()
	
	velocity.x= speed


func flip()->void:
	facing_right=!facing_right
	scale.x=abs(scale.x)*-1
	
	if facing_right:
			speed=abs(speed)
	else:
			speed=abs(speed)*-1

func search()->void:
	_searching=true
	_animation.play("Search")
	await _animation.animation_finished
	_searching=false

func entered_search_area(_body:Node2D):
	search()
