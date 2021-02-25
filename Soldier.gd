extends Node2D

const cycle_speed = 100
const position_delta = 4 
# var a = 2
var hp = 0
var display_name = "display name"
var expected_x_position = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$NameLabel.text = display_name
	
func _process(delta): 
	# TODO Only do this if you are alive and idle or whatever
	if position.x - expected_x_position > position_delta: 
		position.x -= delta*cycle_speed
	elif expected_x_position - position.x > position_delta:
		position.x += delta*cycle_speed
	else: 
		position.x = expected_x_position
		
func set_hp(new_hp):
	hp = new_hp
	
func face_left(): 
	$soldier_sprite.flip_h = true
	
func face_right(): 
	$soldier_sprite.flip_h = false

func set_sprite_attack(): 
	$soldier_sprite.play("attack")

func set_sprite_idle(): 
	$soldier_sprite.play("idle")
	
func set_sprite_defend(): 
	$soldier_sprite.play("defend")

func set_sprite_dead(): 
	$soldier_sprite.play("dead")
	$NameLabel.visible = false
	
func defend_and_take_damage(damage): 
	set_sprite_defend()
	hp -= 1
	print(display_name + " HP is now: " + str(hp))
