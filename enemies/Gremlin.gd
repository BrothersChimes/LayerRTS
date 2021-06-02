extends Node2D

const walk_speed = 100
const base_anim_speed = 1

enum Action {WALK, FIGHT, IDLE} 

var action = Action.WALK
var is_player_near = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if action == Action.WALK:
		position.x -= walk_speed*delta

func is_near_player(is_player_left): 
	is_player_near = true
	action = Action.FIGHT
	$AnimatedSprite.speed_scale = 0
	
func is_not_near_player():
	is_player_near = false
	action = Action.WALK
	$AnimatedSprite.speed_scale = base_anim_speed
