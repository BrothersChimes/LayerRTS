extends Node2D

const ground_level = 162

const arbitrary_allowed_pos_left = -430
const arbitrary_allowed_pos_right = 1350


func _ready():
	position.y = ground_level
	$tent_green.visible = false
	$tent_red.visible = true

func _process(delta):
	position.x = get_global_mouse_position().x
	
	if position.x > arbitrary_allowed_pos_left and position.x < arbitrary_allowed_pos_right: 
		set_allowed()
	else: 
		set_not_allowed()

func set_allowed(): 
	$tent_green.visible = true
	$tent_red.visible = false
	
func set_not_allowed():
	$tent_green.visible = false
	$tent_red.visible = true
