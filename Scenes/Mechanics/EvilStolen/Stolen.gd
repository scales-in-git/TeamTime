class_name Stolen extends Node

@export var speed:=3.0
@export var facing_right:=false

@onready var _parent:PhysicsBody2D=get_parent()
@onready var _edgedetection:RayCast2D=$%EdgeDetection
@onready var _walldetection:RayCast2D=$%WallDetection
@onready var _animation:AnimationPlayer=$%Animator

func _ready():
	speed*=-100.0
	if facing_right:
		speed*=-1


func _physics_process(delta:float)->void:
	_parent.move_and_slide()

	if not _parent.is_on_floor():
		_parent.velocity.y+=_parent.get_gravity().y*delta
		_animation.play("default")
		return

	if _parent.velocity.x != 0.0:
		_animation.play("Walk")
	
	if (not _edgedetection.is_colliding() or _walldetection.is_colliding())&& _parent.is_on_floor():
		print(_walldetection.is_colliding())
		flip()
	
	_parent.velocity.x= speed


func flip():
	facing_right=!facing_right
	_parent.scale.x=abs(_parent.scale.x)*-1
	
	if facing_right:
			speed=abs(speed)
	else:
			speed=abs(speed)*-1

