extends Area2D

@export var camera: PhantomCamera2D
@export var camera_default_priroity := 0;
@export var camera_active_priority := 10

func _on_body_entered(body):
    if body is Player:
        camera.priority = camera_active_priority

func _on_body_exited(body):
    if body is Player:
        camera.priority = camera_default_priroity