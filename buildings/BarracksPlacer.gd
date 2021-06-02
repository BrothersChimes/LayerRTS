extends Node2D

signal place_barracks(x_pos)

const ground_level = 162


const snap_size = 32
var is_allowed = false

var is_build_mode = true

func _ready():
	position.y = ground_level
	set_not_allowed()
	
func _process(delta):
	if is_build_mode: 
		position.x = round(get_global_mouse_position().x/snap_size)*snap_size

func _input(event):
	if (event is InputEventMouseButton and event.is_pressed() and event.button_index == BUTTON_LEFT):
		if is_allowed and is_build_mode:
			emit_signal("place_barracks", position.x)
			
func get_position_x(): 
	return position.x

func set_allowed(): 
	is_allowed = true
	$tent_green.visible = true
	$tent_red.visible = false
	
func set_not_allowed():
	is_allowed = false
	$tent_green.visible = false
	$tent_red.visible = true

func toggle_build(): 
	if is_build_mode: 
		is_build_mode = false
		visible = false
	else: 
		is_build_mode = true
		visible = true
