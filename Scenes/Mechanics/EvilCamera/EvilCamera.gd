class_name EvilCamera
extends Node2D

@onready var a_bajillion_ray_casts: Node2D = $%ABajillionRayCasts

func _physics_process(_delta):
	var raycasts = a_bajillion_ray_casts.get_children()
	
	for raycast in raycasts:
		var collided = raycast.get_collider()
		if collided is Player:
			print("Gotcha now")
