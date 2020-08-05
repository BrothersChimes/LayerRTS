extends Node2D

export var speed = 20
export var is_flipped = false
export (PackedScene) var UnitType
export var army_size = 1

var units
var cur_speed

func _ready(): 
	cur_speed = speed
	if is_flipped: 
		cur_speed = -speed
	units = []
	
	for i in range(army_size): 
		var unit = UnitType.instance()
		units.append(unit)
		add_child(unit)
		unit.set_is_flipped(is_flipped)
		unit.begin_walk()
		var x_shift = 32*i if is_flipped else -32*i
		unit.translate(Vector2(x_shift, 0))

	get_node("Sprite").set_visible(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x = position.x + delta * cur_speed

func _on_Area2D_area_entered(_area2d):
	cur_speed = 0
	units[0].begin_attack()
	for i in range(1, units.size()): 
		units[i].begin_idle()
