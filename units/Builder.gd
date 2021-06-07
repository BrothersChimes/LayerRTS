extends Node2D

signal start_building(builder)

var is_busy = false

var target_building

var target_x_pos = 0
var target_epsilon = 4

enum Action {IDLE, GO_TO_BUILDING, BUILD} 
var action = Action.IDLE

var walk_speed = 500

func _ready():
	action = Action.IDLE
	$AnimatedSprite.set_animation("idle")

func _process(delta): 
	if action == Action.GO_TO_BUILDING: 
		go_to_building(delta)

func go_to_building(delta): 
	if abs(position.x - target_x_pos) < target_epsilon: 
		action = Action.BUILD
		emit_signal("start_building", self)
		$AnimatedSprite.set_animation("building")
		return
		
	$AnimatedSprite.set_animation("walk")
	if position.x < target_x_pos: 
		position.x += delta*walk_speed
		$AnimatedSprite.flip_h = false
	else: 
		position.x -= delta*walk_speed
		$AnimatedSprite.flip_h = true

func is_busy(): 
	return is_busy

func get_target_building(): 
	return target_building

func set_target_building(target): 
	target_building = target
	target_x_pos = target.position.x
	action = Action.GO_TO_BUILDING
	is_busy = true 

func idle(): 
	$AnimatedSprite.set_animation("idle")
	action = Action.IDLE
	is_busy = false
