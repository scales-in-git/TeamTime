class_name GenericInteractable
extends Area2D

# NOTE: set the position of this node to where you want the icon to appear,
# than move the collision box to the correct place

signal interacted
signal entered
signal left



@export var w_instead_of_e := false

@onready var e_icon: Sprite2D = $%EIcon
@onready var w_icon: Sprite2D = $%WIcon

var overlapped := false

func _on_body_entered(body: Node2D):
	if body is Player:
		overlapped = true
		entered.emit()

		if w_instead_of_e:
			w_icon.visible = true
		else:
			e_icon.visible = true


func _on_body_exited(body: Node2D):
	if body is Player:
		overlapped = false
		left.emit()

		e_icon.visible = false
		w_icon.visible = false

func _unhandled_input(event: InputEvent):
	if not overlapped:
		return false
	if w_instead_of_e and event.is_action_pressed('player_up'):
		interacted.emit()
	elif event.is_action_pressed('player_interact'):
		print("Hello")
		interacted.emit()

