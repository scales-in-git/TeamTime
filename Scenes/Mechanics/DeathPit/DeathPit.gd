extends Area2D

func _on_body_entered(body):
    print("Hello")
    if body is Player:
        SceneTransition.call_deferred("reset_scene")