extends Node2D

const camera_speed = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_pressed("ui_left") and position.x > -540:
		position.x = position.x - delta*camera_speed
	elif Input.is_action_pressed("ui_right") and position.x < 660: 
		position.x = position.x + delta*camera_speed
