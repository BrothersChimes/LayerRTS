extends Node2D

export var speed = 20

var cur_speed

func _ready(): 
	cur_speed = speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x = position.x + delta * cur_speed

func _on_Area2D_area_entered(area2d):
	cur_speed = 0