extends Node2D

signal place_barracks(x_pos)

const ground_level = 162

const arbitrary_allowed_pos_left = -430
const arbitrary_allowed_pos_right = 1350

const snap_size = 32
var is_allowed = false

func _ready():
	position.y = ground_level
	set_not_allowed()
	
func _process(delta):
	position.x = round(get_global_mouse_position().x/snap_size)*snap_size
	
	if position.x > arbitrary_allowed_pos_left and position.x < arbitrary_allowed_pos_right: 
		set_allowed()
	else: 
		set_not_allowed()

func _input(event):
	if (event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_LEFT):
		if is_allowed:
			emit_signal("place_barracks", position.x)

func set_allowed(): 
	is_allowed = true
	$tent_green.visible = true
	$tent_red.visible = false
	
func set_not_allowed():
	is_allowed = false
	$tent_green.visible = false
	$tent_red.visible = true