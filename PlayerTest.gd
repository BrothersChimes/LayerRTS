extends Node2D
const ground_level = 162
var Barracks = preload("buildings/Barracks.tscn")

func _ready():
	pass # Replace with function body.

func _on_BarracksPlacer_place_barracks(x_pos):
	var barracks = Barracks.instance()
	barracks.position = Vector2(x_pos, ground_level)
	# barracks.z_index = 2
	add_child(barracks)
