extends Node2D

export var speed = 20

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x = position.x + delta * speed
